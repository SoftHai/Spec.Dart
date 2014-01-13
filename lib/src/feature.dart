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
  
  bool _runFromParent(_SpecContextImpl context) {
    this._specContext = context;
    return this._runImpl(true);
  }
  
  bool run() {
    return this._runImpl(false);
  }
  
  bool _runImpl([bool isSubUnit = false]) {
    
    if(!isSubUnit) {
      SpecContext.output.SpecStart();
      SpecStatistics.Clear();
    }
    
    if(this._setUp != null) {
      this._setUp(_specContext);
    }
    
    var result = this._internalRun(_specContext);
    
    if(this._tearDown != null) {
      this._tearDown(_specContext);
    }
    
    var stat = new SpecStatistics.current();
    if(!isSubUnit) {
      SpecContext.output.writeStatistics(stat);
      SpecContext.output.SpecEnd();
    }
    
    return result;
  }
  
  bool _internalRun(_SpecContextImpl context);
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
  
  bool _internalRun(_SpecContextImpl context) {
    
    var result = 1;

    SpecContext.output.writeSpec("${SpecContext.language.feature}",": ${this.name} - ${this.description}");
    SpecContext.output.incIntent();
    
    for(var child in this._childSpecs)
    {
      var contextCopy = new _SpecContextImpl._clone(context);
      var childResult = child._runFromParent(contextCopy);
      result &= childResult ? 1 : 0;
    }
        
    SpecContext.output.decIntent();
    SpecContext.output.writeEmptyLine();
    
    var stat = new SpecStatistics.current();
    stat.executedFeatures++;
    if(result == 0)  { 
      stat.failedFeatures++;
      stat.failedFeatureNames.add(this.name);
    }
    
    return result == 1 ? true : false;
  }
}