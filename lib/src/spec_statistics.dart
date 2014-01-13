part of softhai.spec_dart;


class SpecStatistics {
  
  static SpecStatistics _current;
  
  int executedFeatures = 0;
  int failedFeatures = 0;
  List<String> failedFeatureNames = new List<String>();
  
  int executedStories = 0;
  int failedStories = 0;
  List<String> failedStoryNames = new List<String>();
  
  int executedScenarios = 0;
  int failedScenarios = 0;
  List<String> failedScenarioNames = new List<String>();
  
  SpecStatistics();
  
  static void Clear() {
    _current = new SpecStatistics();
  }
  
  factory SpecStatistics.current() {
    if(_current == null) {
      _current = new SpecStatistics();
    }
    
    return _current;
  }
}