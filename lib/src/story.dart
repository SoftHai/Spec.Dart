part of softhai.spec_dart;

class Story  implements Runables {
  
  _SpecContextImpl _specContext;
  List<Scenario> _scenarios = new List<Scenario>();
  
  String title;
  String asA;
  String iWant;
  String soThat;
  
  Story(this.title, {this.asA, this.iWant, this.soThat}) : this._specContext = new _SpecContextImpl();
  
  Story._fromParent(this.title, this._specContext, this.asA, this.iWant, this.soThat);
  
  Scenario scenario(String title) {
    var scenario = new Scenario._fromParent(title, new _SpecContextImpl._clone(this._specContext));
    
    this._scenarios.add(scenario);
    
    return scenario;
  }
  
  bool run([bool isSubUnit = false]) {

    if(!isSubUnit) {
      SpecContext.output.SpecStart();
      _SpecStatistics.Clear();
    }
    
    var result = 1;

    SpecContext.output.writeSpec("${SpecContext.language.story}", ": ${this.title}");
    SpecContext.output.incIntent();
    SpecContext.output.writeSpec("${SpecContext.language.asA}", " ${this.asA}");
    SpecContext.output.writeSpec("${SpecContext.language.iWant}", " ${this.iWant}");
    SpecContext.output.writeSpec("${SpecContext.language.soThat}", " ${this.soThat}");
    SpecContext.output.writeEmptyLine();
    
    for(var scenario in this._scenarios)
    {
      var scenarioResult = scenario.run(true);
      result &= scenarioResult ? 1 : 0;
    }
    
    SpecContext.output.decIntent();
    SpecContext.output.writeEmptyLine();
    
    var stat = new _SpecStatistics.current();
    stat.executedStories++;
    if(result == 0) stat.failedStories++;
    
    if(!isSubUnit) {
      SpecContext.output.writeMessage(stat.toString(), OutputFormatter.MESSAGE_TYPE_NONE);
      SpecContext.output.SpecEnd();
    }
    
    return result == 1 ? true : false;
    
  }
  
}
