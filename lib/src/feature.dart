part of softhai.spec_dart;

abstract class SpecBase {
  
  _SpecContextImpl _specContext;
  
  SpecFunc _setUp;
  SpecFunc _tearDown;
  
  SpecBase() : this._specContext = new _SpecContextImpl();
  
  void setUp(SpecFunc func) {
    this._setUp = func;
  }
  
  void tearDown(SpecFunc func) {
    this._tearDown = func;
  }
  
  Future<bool> _runFromParent(_SpecContextImpl context) {
    this._specContext = context;
    return this._runImpl(true);
  }
  
  Future<bool> run() {
    return this._runImpl(false);
  }
  
  Future<bool> _runImpl([bool isSubUnit = false]) {
    
    if(!isSubUnit) {
      SpecContext.output.specStart();
      SpecStatistics.Clear();
    }
    
    return new Future.sync(() {
      if(this._setUp != null) return this._setUp(_specContext);
    }).then((_) { 
      return this._internalRun(_specContext); 
    }).whenComplete(() {
      if(this._tearDown != null) return this._tearDown(_specContext); 
    }).whenComplete(() {
      var stat = new SpecStatistics.current();
      if(!isSubUnit) {
        SpecContext.output.writeStatistics(stat);
        SpecContext.output.specEnd();
      }
    }).catchError((testFailure) {
        SpecContext.output.writeMessage("Exception(${testFailure.message.replaceAll("\n", "")})\n ${testFailure.stackTrace}", SpecOutputFormatter.MESSAGE_TYPE_FAILURE);
    }, test: (ex) => ex is TestFailure)
    
      .catchError((ex) {
        SpecContext.output.writeMessage("Exception($ex)", SpecOutputFormatter.MESSAGE_TYPE_FAILURE);
    }, test: (ex) => !(ex is TestFailure));

  }
  
  Future<bool> _internalRun(_SpecContextImpl context);
}

class Feature extends SpecBase {

  List<SpecBase> _childSpecs = new List<SpecBase>();
  
  String name;
  String description;
  
  Feature(this.name, [this.description = ""]) : super();
  
  Feature subFeature(String name, {String description}) {
    var feature = new Feature(name, description);
    
    this._childSpecs.add(feature);
    
    return feature;
  }
  
  Scenario scenario(String title) {
    var scenario = new Scenario(title);
    
    this._childSpecs.add(scenario);
    
    return scenario;
  }
  
  Story story(String title, {String asA, String iWant, String soThat}) {
    var story = new Story(title, asA: asA, iWant: iWant, soThat: soThat);
    
    this._childSpecs.add(story);
    
    return story;
  }
  
  Future<bool> _internalRun(_SpecContextImpl context) {
    
    var results = new List<bool>();

    SpecContext.output.startFeature();
    SpecContext.output.writeSpec("${SpecContext.language.feature}",": ${this.name} - ${this.description}");
    SpecContext.output.incIntent();
    
    return Future.forEach(this._childSpecs, (child) {
      var contextCopy = new _SpecContextImpl._clone(context);
      return child._runFromParent(contextCopy)
                  .then((v) => results.add(v));
    }).then((_) => results.where((r) => r == false).length == 0)
      .whenComplete(() {
      SpecContext.output.decIntent();
      SpecContext.output.writeEmptyLine();
      SpecContext.output.endFeature();
      
      var successful = results.where((r) => r == false).length == 0;
      var stat = new SpecStatistics.current();
      stat.executedFeatures++;
      if(!successful)  { 
        stat.failedFeatures++;
        stat.failedFeatureNames.add(this.name);
      }
    });
  }
}