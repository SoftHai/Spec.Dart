part of softhai.spec_dart;

abstract class Runables {
  bool run([bool isSubUnit = false]);
}

class Feature implements Runables {
  _SpecContextImpl _specContext;
  List<Runables> _childSpecs = new List<Runables>();
  
  String name;
  String description;
  
  Feature(this.name, [this.description = ""]) : this._specContext = new _SpecContextImpl();
 
  Feature._fromParent(this.name, this.description, this._specContext);
  
  Feature subFeature(String name, {String description}) {
    var feature = new Feature._fromParent(name, description, new _SpecContextImpl._clone(this._specContext));
    
    this._childSpecs.add(feature);
    
    return feature;
  }
  
  Scenario scenario(String title) {
    var scenario = new Scenario._fromParent(title, new _SpecContextImpl._clone(this._specContext));
    
    this._childSpecs.add(scenario);
    
    return scenario;
  }
  
  Story story(String title, {String asA, String iWant, String soThat}) {
    var story = new Story._fromParent(title, new _SpecContextImpl._clone(this._specContext), asA, iWant, soThat);
    
    this._childSpecs.add(story);
    
    return story;
  }
  
  bool run([bool isSubUnit = false]) {
    
    if(!isSubUnit) {
      SpecContext.output.SpecStart();
      SpecStatistics.Clear();
    }
    
    var result = 1;

    SpecContext.output.writeSpec("${SpecContext.language.feature}",": ${this.name} - ${this.description}");
    SpecContext.output.incIntent();
    
    for(var child in this._childSpecs)
    {
      var childResult = child.run(true);
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
    
    if(!isSubUnit) {
      SpecContext.output.writeStatistics(stat);
      SpecContext.output.SpecEnd();
    }
    
    return result == 1 ? true : false;
  }
}