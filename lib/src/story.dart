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
  
  Future<bool> _internalRun(_SpecContextImpl context) {
    
    var results = new List<bool>();

    SpecContext.output.startStory();
    SpecContext.output.writeSpec("${SpecContext.language.story}", ": ${this.title}");
    SpecContext.output.incIntent();
    SpecContext.output.writeSpec("${SpecContext.language.asA}", " ${this.asA}");
    SpecContext.output.writeSpec("${SpecContext.language.iWant}", " ${this.iWant}");
    SpecContext.output.writeSpec("${SpecContext.language.soThat}", " ${this.soThat}");
    SpecContext.output.writeEmptyLine();
    
    return Future.forEach(this._scenarios, (scenario) {
      var contextCopy = new _SpecContextImpl._clone(context);
      return scenario._runFromParent(contextCopy)
                     .then((v) => results.add(v));
    }).then((_) => results.where((r) => r == false).length == 0)
      .whenComplete(() {
        SpecContext.output.decIntent();
        SpecContext.output.writeEmptyLine();
        SpecContext.output.endStory();
        
        var successful = results.where((r) => r == false).length == 0;
        var stat = new SpecStatistics.current();
        stat.executedStories++;
        if(!successful) {
          stat.failedStories++;
          stat.failedStoryNames.add(this.title);
        }
      });
    
  }
  
}
