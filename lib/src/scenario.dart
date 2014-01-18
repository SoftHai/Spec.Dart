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
  
  Future<bool> _internalRun(_SpecContextImpl context) {
    
    SpecContext.output.writeSpec("${SpecContext.language.scenario}", ": ${this.title}");
    
    Future future = null;
    var results = new List<bool>();
    
    if(this._exampleData != null) {
      // Print steps
      if (this._givenSteps != null) this._givenSteps.printSteps(SpecContext.language.given);
      if (this._whenSteps != null) this._whenSteps.printSteps(SpecContext.language.when);
      this._thanSteps.printSteps(SpecContext.language.than);

      // Execute Example Data
      future = Future.forEach(this._exampleData, (data) {
        
        var contextCopy = new _SpecContextImpl._clone(context);
        contextCopy.data.addAll(data);
        
        return new Future.sync(() {
          if(this._exampleSetUp != null) return this._exampleSetUp(contextCopy);
        }).then((_) {
          if (this._givenSteps != null) return this._givenSteps.executeSteps(SpecContext.language.given, contextCopy, false, true);
        }).then((_) {
          if (this._whenSteps != null) return this._whenSteps.executeSteps(SpecContext.language.when, contextCopy, false, true);
        }).then((_) {
          return this._thanSteps.executeSteps(SpecContext.language.than, contextCopy, true, true)
                           .then((result) => results.add(result))
                           .catchError((_) => results.add(false));
        }).then((_) {
          if(this._exampleTearDown != null) return this._exampleTearDown(contextCopy);
        });
      }).whenComplete(() {
        SpecContext.output.incIntent();
        SpecContext.output.writeSpec(SpecContext.language.example, "");
        SpecContext.output.incIntent();
        SpecContext.output.writeExampleData(this._exampleData, results);
        SpecContext.output.decIntent();
        SpecContext.output.decIntent();
      });
    }
    else {
      future = new Future.sync(() {
        if (this._givenSteps != null) return this._givenSteps.executeSteps(SpecContext.language.given, context, false);
      }).then((_) {
        if (this._whenSteps != null) return this._whenSteps.executeSteps(SpecContext.language.when, context, false);
      }).then((_) {
        if (this._thanSteps != null) {
          return this._thanSteps.executeSteps(SpecContext.language.than, context, true).then((result) => results.add(result));
        }
        else {
          results.add(false);
        }
      });
    }
    
    return future.then((_) {
      return results.where((r) => r == false).length == 0;
    }).whenComplete(() {
      var successful = results.where((r) => r == false).length == 0;
      var stat = new SpecStatistics.current();
      stat.executedScenarios++;
      if(!successful)  {
        stat.failedScenarios++;
        stat.failedScenarioNames.add(this.title);
      }
    });
  }
  
}

