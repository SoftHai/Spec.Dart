part of softhai.spec_dart;

class Scenario extends SpecBase {
    
  _StepChainImpl _givenSteps;
  _StepChainImpl _whenSteps;
  _StepChainImpl _thanSteps;
  bool _thanThrows = false;
  Type _thanThrowsExceptionType = null;
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
  
  void thanThrows() {
    this._thanThrows = true;
  }
  
  void thanThrowsA(Type exceptionType) {
    this._thanThrows = true;
    this._thanThrowsExceptionType = exceptionType;
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
    
    SpecContext.output.startScenario();
    SpecContext.output.writeSpec("${SpecContext.language.scenario}", ": ${this.title}");
    
    Future future = null;
    var results = new List<bool>();
    
    if(this._exampleData != null) {
      // Print steps
      if (this._givenSteps != null) this._givenSteps.printSteps(SpecContext.language.given);
      if (this._whenSteps != null) this._whenSteps.printSteps(SpecContext.language.when);
      
      if(this._thanThrows) {
        SpecContext.output.incIntent();
        SpecContext.output.writeSpec(SpecContext.language.than, " throws an exception");
        SpecContext.output.decIntent();
      }
      else {
        this._thanSteps.printSteps(SpecContext.language.than);
      }
      
      
      // Execute Example Data
      future = Future.forEach(this._exampleData, (data) {
        
        var contextCopy = new _SpecContextImpl._clone(context);
        contextCopy.data.addAll(data);
        
        var innerFuture = new Future.sync(() {
          if(this._exampleSetUp != null) return this._exampleSetUp(contextCopy);
        }).then((_) {
          if (this._givenSteps != null) return this._givenSteps.executeSteps(SpecContext.language.given, contextCopy, validate: false, silent: true);
        }).then((_) {
          if (this._whenSteps != null) return this._whenSteps.executeSteps(SpecContext.language.when, contextCopy, validate: false, silent: true, ignoreExceptions: this._thanThrows);
        }).then((_) {
          if(this._thanThrows) {
            results.add(false);
          }
          else {
            return this._thanSteps.executeSteps(SpecContext.language.than, contextCopy, validate: true, silent: true)
                             .then((result) => results.add(result))
                             .catchError((_) => results.add(false));
          }
        }).then((_) {
          if(this._exampleTearDown != null) return this._exampleTearDown(contextCopy);
        });
        
        if(this._thanThrows) {
          innerFuture = innerFuture.catchError((ex) { 
              if(this._thanThrowsExceptionType == null || this._thanThrowsExceptionType == ex.runtimeType) {
                results.add(true); 
              }
              else {
                results.add(false); 
              }
            });
        }
        
        return innerFuture;
        
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
        if (this._givenSteps != null) return this._givenSteps.executeSteps(SpecContext.language.given, context, validate: false);
      }).then((_) {
        if (this._whenSteps != null) {
          if (this._thanThrows) this._whenSteps.printSteps(SpecContext.language.when);
          return this._whenSteps.executeSteps(SpecContext.language.when, context, validate: false, ignoreExceptions: this._thanThrows);
        }
      }).then((value) {
        if(this._thanThrows) {
          SpecContext.output.incIntent();
          SpecContext.output.writeSpec(SpecContext.language.than, " expected future to fail, but succeeded with '$value'.", SpecOutputFormatter.MESSAGE_TYPE_FAILURE);
          SpecContext.output.decIntent();
          results.add(false);
        }
        else if (this._thanSteps != null) {
          return this._thanSteps.executeSteps(SpecContext.language.than, context, validate: true).then((result) => results.add(result));
        }
        else {
          results.add(false);
        }
      });
      
      if(this._thanThrows) {
        future = future.catchError((ex) { 
          SpecContext.output.incIntent();
          if(this._thanThrowsExceptionType == null || this._thanThrowsExceptionType == ex.runtimeType) {
            SpecContext.output.writeSpec(SpecContext.language.than, " throws exception: $ex", SpecOutputFormatter.MESSAGE_TYPE_SUCCESS);
            results.add(true); 
          }
          else {
            SpecContext.output.writeSpec(SpecContext.language.than, " expect '${this._thanThrowsExceptionType}' but was '${ex.runtimeType}'", SpecOutputFormatter.MESSAGE_TYPE_FAILURE);
            results.add(false); 
          }
          SpecContext.output.decIntent();
        });
      }
    }
    
    return future.then((_) {
      return results.where((r) => r == false).length == 0;
    }).whenComplete(() {
      SpecContext.output.endScenario();
      
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

