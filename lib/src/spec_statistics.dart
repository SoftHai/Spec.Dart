part of softhai.spec_dart;


class _SpecStatistics {
  
  static _SpecStatistics _current;
  
  int executedFeatures = 0;
  int failedFeatures = 0;
  int executedStories = 0;
  int failedStories = 0;
  int executedScenarios = 0;
  int failedScenarios = 0;
  
  _SpecStatistics();
  
  static void Clear() {
    _current = new _SpecStatistics();
  }
  
  factory _SpecStatistics.current() {
    if(_current == null) {
      _current = new _SpecStatistics();
    }
    
    return _current;
  }
  
  String toString() {
    return "Features: ${this.failedFeatures} of ${this.executedFeatures} are failed\n"
           "Stories: ${this.failedStories} of ${this.executedStories} are failed\n"
           "Scenarios: ${this.failedScenarios} of ${this.executedScenarios} are failed";
  }
}