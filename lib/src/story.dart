part of softhai.spec_dart;

class Story  extends SpecBase {
  
  List<Scenario> _scenarios = new List<Scenario>();
  
  String title;
  String asA;
  String iWant;
  String soThat;
  
  Story(this.title, {this.asA, this.iWant, this.soThat}) : super();
  
  Scenario scenario(String title) {
    var scenario = new Scenario(title);
    
    this._scenarios.add(scenario);
    
    return scenario;
  }
  
  bool _internalRun(_SpecContextImpl context) {
    
    var result = 1;

    SpecContext.output.writeSpec("${SpecContext.language.story}", ": ${this.title}");
    SpecContext.output.incIntent();
    SpecContext.output.writeSpec("${SpecContext.language.asA}", " ${this.asA}");
    SpecContext.output.writeSpec("${SpecContext.language.iWant}", " ${this.iWant}");
    SpecContext.output.writeSpec("${SpecContext.language.soThat}", " ${this.soThat}");
    SpecContext.output.writeEmptyLine();
    
    for(var scenario in this._scenarios)
    {
      var contextCopy = new _SpecContextImpl._clone(context);
      var scenarioResult = scenario._runFromParent(contextCopy);
      result &= scenarioResult ? 1 : 0;
    }
    
    SpecContext.output.decIntent();
    SpecContext.output.writeEmptyLine();
    
    var stat = new SpecStatistics.current();
    stat.executedStories++;
    if(result == 0) {
      stat.failedStories++;
      stat.failedStoryNames.add(this.title);
    }
    
    return result == 1 ? true : false;
    
  }
  
}
