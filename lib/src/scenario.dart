part of softhai.spec_dart;

class Scenario extends SpecBase {
    
  _StepChainImpl _givenSteps;
  _StepChainImpl _whenSteps;
  _StepChainImpl _thanSteps;
  List<Map<String, Object>> _exampleData;
  SpecFunc _exampleSetUp;
  SpecFunc _exampleTearDown;
  
  String title;
  
  Scenario(this.title) : super();
  
  StepChain given({String text, SpecFunc func}) {
    this._givenSteps = new _StepChainImpl(new _Step(func, text));
    return this._givenSteps;
  }

  StepChain when({String text, SpecFunc func}) {
    this._whenSteps = new _StepChainImpl(new _Step(func, text));
    return this._whenSteps;
  }
  
  StepChain than({String text, SpecFunc func}) {
    this._thanSteps = new _StepChainImpl(new _Step(func, text));
    return this._thanSteps;
  }
  
  void example(List<Map<String, Object>> data) {
    this._exampleData = data;
  }
  
  void exampleSetUp(SpecFunc func) {
    this._exampleSetUp = func;
  }
  
  void exampleTearDown(SpecFunc func) {
    this._exampleTearDown = func;
  }
  
  bool _internalRun(_SpecContextImpl context) {
    
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
        var contextCopy = new _SpecContextImpl._clone(context);
        
        if(this._exampleSetUp != null) {
          this._exampleSetUp(contextCopy);
        }

        contextCopy.data.addAll(data);
        
        if (this._givenSteps != null) this._givenSteps.executeSteps(SpecContext.language.given, contextCopy, false, true);
        if (this._whenSteps != null) this._whenSteps.executeSteps(SpecContext.language.when, contextCopy, false, true);
        var dataResult = this._thanSteps.executeSteps(SpecContext.language.than, contextCopy, true, true);
        result &= dataResult ? 1 : 0;
        results.add(dataResult);
        
        if(this._exampleTearDown != null) {
          this._exampleTearDown(contextCopy);
        }
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
      if (this._givenSteps != null) this._givenSteps.executeSteps(SpecContext.language.given, context, false);
      
      // When
      if (this._whenSteps != null) this._whenSteps.executeSteps(SpecContext.language.when, context, false);
      
      // Than
      if (this._thanSteps != null) {
        runResult = this._thanSteps.executeSteps(SpecContext.language.than, context, true);
      }
     
    }
    
    var stat = new SpecStatistics.current();
    stat.executedScenarios++;
    if(!runResult)  {
      stat.failedScenarios++;
      stat.failedScenarioNames.add(this.title);
    }
    
    return runResult;
  }
  
}

