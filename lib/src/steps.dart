part of softhai.spec_dart;

typedef dynamic SpecFunc(SpecContext context);

abstract class StepChain {
  
  StepChain and({String text, SpecFunc func});
}

class _StepChainImpl implements StepChain {
  
  List<_Step> _steps = new List<_Step>();
  
  _StepChainImpl(_Step initStep) {
    this._steps.add(initStep);
  }
  
  StepChain and({String text, SpecFunc func}) {
    this._steps.add(new _Step(func, text));
    return this;
  }
  
  void printSteps(String prefix) {
    
    SpecContext.output.incIntent();
    this._printStep(prefix, this._steps.first);
    
    SpecContext.output.incIntent();
    for(int i = 1; i < this._steps.length; i++) {
      this._printStep(SpecContext.language.and, this._steps[i]);
    }
    SpecContext.output.decIntent();
    SpecContext.output.decIntent();
  }
  
  void _printStep(String keyWord, _Step currentStep) {
    SpecContext.output.writeSpec("$keyWord", " ${currentStep.text}"); 
  }
  
  Future<bool> executeSteps(String prefix, _SpecContextImpl context, [bool validate = false, bool silent = false]) {
        
    var results = new List<bool>();

    var future = new Future.sync(() {
      if(!silent) SpecContext.output.incIntent();
      return this._executeStep(prefix, this._steps.first, context, validate, silent)
                 .then((r) => results.add(r));
    }).then((_) {
        if(!silent) SpecContext.output.incIntent();
        return Future.forEach(this._steps.skip(1), (step) {
          return this._executeStep(SpecContext.language.and, step, context, validate, silent)
                     .then((r) => results.add(r));
        });
    }).then((_) => results.where((r) => r != true).length == 0)
      .whenComplete(() {
        if(!silent) SpecContext.output.decIntent();
        if(!silent) SpecContext.output.decIntent();
      });
    
    return future;
  }

  Future<bool> _executeStep(String keyWord, _Step currentStep, _SpecContextImpl context, bool validate, bool silent) {

    return new Future.sync(() { if(currentStep.func != null) return currentStep.func(context); })
      .then((r) {
      var success = r != false;
      if(validate)
      {        
        if(!silent) {
          var successText = success ? SpecContext.language.success : SpecContext.language.failed;
          SpecContext.output.writeSpec("$keyWord", " ${currentStep.text}: $successText", 
              success ? SpecOutputFormatter.MESSAGE_TYPE_SUCCESS : SpecOutputFormatter.MESSAGE_TYPE_FAILURE); 
        }
      }
      else
      {
        if(!silent) SpecContext.output.writeSpec("$keyWord", " ${currentStep.text}"); 
      }
      
      return success;
    })
      .catchError((testFailure) {
      if(!silent) {
        var errorMessage = "Exception(${testFailure.message.replaceAll("\n", "")})\n ${testFailure.stackTrace}";
        SpecContext.output.writeSpec("$keyWord", " ${currentStep.text}: $errorMessage", SpecOutputFormatter.MESSAGE_TYPE_FAILURE);
      }
    }, test: (ex) => ex is TestFailure)
    
      .catchError((ex) {
      if(!silent) {
        var errorMessage = "Exception($ex)";
        SpecContext.output.writeSpec("$keyWord", " ${currentStep.text}: $errorMessage", SpecOutputFormatter.MESSAGE_TYPE_FAILURE);
      }
    }, test: (ex) => !(ex is TestFailure));

  }
}

class _Step {
  
  String text; 
  SpecFunc func;
  
  _Step(this.func, this.text);
  
}