part of softhai.spec_dart;

typedef bool StepFunc(SpecContext context);

abstract class StepChain {
  
  StepChain and({String text, StepFunc func});
}

class _StepChainImpl implements StepChain {
  
  List<_Step> _steps = new List<_Step>();
  
  _StepChainImpl(_Step initStep) {
    this._steps.add(initStep);
  }
  
  StepChain and({String text, StepFunc func}) {
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
  
  bool executeSteps(String prefix, _SpecContextImpl context, [bool validate = false, bool silent = false]) {
        
    var result = 1;
    
    if(!silent) SpecContext.output.incIntent();
    result &= this._executeStep(prefix, this._steps.first, context, validate, silent);
    
    if(!silent) SpecContext.output.incIntent();
    for(int i = 1; i < this._steps.length; i++) {
      result &= this._executeStep(SpecContext.language.and, this._steps[i], context, validate, silent);
    }
    if(!silent) SpecContext.output.decIntent();
    if(!silent) SpecContext.output.decIntent();
    
    return result == 1 ? true : false;
  }

  int _executeStep(String keyWord, _Step currentStep, _SpecContextImpl context, bool validate, bool silent) {

    if(validate)
    {
      var vailidateResult = false;
      try {
        vailidateResult = currentStep.func(context);
      }
      on TestFailure catch(testFailure) {
        // Handle Unit Test Exceptions
        vailidateResult = "Exception(${testFailure.message.replaceAll("\n", "")})\n ${testFailure.stackTrace}";
      }
      catch (ex) {
        // Handle all other
        vailidateResult = "Exception($ex)";
      }
      
      var success = vailidateResult == true || vailidateResult == null;
      
      if(!silent) SpecContext.output.writeSpec("$keyWord", " ${currentStep.text}: $vailidateResult", 
                                                success ? OutputFormatter.MESSAGE_TYPE_SUCCESS : OutputFormatter.MESSAGE_TYPE_FAILURE); 
      
      return (success ? 1 : 0);
    }
    else
    {
      if(!silent) SpecContext.output.writeSpec("$keyWord", " ${currentStep.text}"); 
      
      if(currentStep.func != null) currentStep.func(context);
      
      return 1;
    }
  }
}

class _Step {
  
  String text; 
  StepFunc func;
  
  _Step(this.func, this.text);
  
}