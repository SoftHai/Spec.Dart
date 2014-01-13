part of softhai.spec_dart;

class Scenario implements Runables {
    
  _StepChainImpl _givenSteps;
  _StepChainImpl _whenSteps;
  _StepChainImpl _thanSteps;
  List<Map<String, Object>> _exampleData;
  _SpecContextImpl _specContext;
  
  
  String title;
  
  Scenario(this.title) : this._specContext = new _SpecContextImpl();
  
  Scenario._fromParent(this.title, this._specContext);
  
  StepChain given({String text, StepFunc func}) {
    this._givenSteps = new _StepChainImpl(new _Step(func, text));
    return this._givenSteps;
  }

  StepChain when({String text, StepFunc func}) {
    this._whenSteps = new _StepChainImpl(new _Step(func, text));
    return this._whenSteps;
  }
  
  StepChain than({String text, StepFunc func}) {
    this._thanSteps = new _StepChainImpl(new _Step(func, text));
    return this._thanSteps;
  }
  
  void example(List<Map<String, Object>> data) {
    this._exampleData = data;
  }
  
  bool run([bool isSubUnit = false]) {
    
    if(!isSubUnit) {
      SpecContext.output.SpecStart();
      SpecStatistics.Clear();
    }
    
    SpecContext.output.writeSpec("${SpecContext.language.scenario}", ": ${this.title}");
    
    var runResult = false;
    if(this._exampleData != null) {
      // Given
      if (this._givenSteps != null) this._givenSteps.printSteps(SpecContext.language.given);
      // When
      if (this._whenSteps != null) this._whenSteps.printSteps(SpecContext.language.when);
      // Than
      this._thanSteps.printSteps(SpecContext.language.than);

      // Example Data
      var result = 1;
      var results = new List<bool>();
      
      for(var data in this._exampleData)
      {
        var dataContext = new _SpecContextImpl._clone(this._specContext);
        dataContext.data.addAll(data);
        
        if (this._givenSteps != null) this._givenSteps.executeSteps(SpecContext.language.given, dataContext, false, true);
        if (this._whenSteps != null) this._whenSteps.executeSteps(SpecContext.language.when, dataContext, false, true);
        var dataResult = this._thanSteps.executeSteps(SpecContext.language.than, dataContext, true, true);
        result &= dataResult ? 1 : 0;
        results.add(dataResult);
      }
      
      SpecContext.output.incIntent();
      SpecContext.output.writeSpec(SpecContext.language.example, "");
      SpecContext.output.incIntent();
      SpecContext.output.writeExampleData(this._exampleData, results);
      SpecContext.output.decIntent();
      SpecContext.output.decIntent();
      
      runResult = result == 1 ? true : false;
    }
    else {
      // Given
      if (this._givenSteps != null) this._givenSteps.executeSteps(SpecContext.language.given, this._specContext, false);
      
      // When
      if (this._whenSteps != null) this._whenSteps.executeSteps(SpecContext.language.when, this._specContext, false);
      
      // Than
      if (this._thanSteps != null) {
        runResult = this._thanSteps.executeSteps(SpecContext.language.than, this._specContext, true);
      }
     
    }
    
    var stat = new SpecStatistics.current();
    stat.executedScenarios++;
    if(!runResult)  {
      stat.failedScenarios++;
      stat.failedScenarioNames.add(this.title);
    }
    
    if(!isSubUnit) {
      SpecContext.output.writeStatistics(stat);
      SpecContext.output.SpecEnd();
    }
    
    return runResult;
  }
  
}

