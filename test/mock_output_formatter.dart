import 'package:spec_dart/spec_dart.dart';

class MockOutputFormatter extends OutputFormatter {
  
  StringBuffer _output = new StringBuffer();
  String get output => this._output.toString();
  
  void Clear() { 
    this._output = new StringBuffer();
    this._currentIntent = "";
  }
  
  String _indent = "  ";
  String _currentIntent = "";
  
  MockOutputFormatter();
  
  void incIntent() {
    this._currentIntent += SpecContext.indent;
  }
  
  void decIntent() {
    this._currentIntent = this._currentIntent.replaceFirst(SpecContext.indent, "");
  }
  
  void SpecStart() {
    this._output.writeln("-----------------------------------------------------------------------------------------");
  }
  
  void SpecEnd() {
    this._output.writeln("-----------------------------------------------------------------------------------------");
  }
  
  void writeEmptyLine() => this._output.writeln("");
  void writeMessage(String message, [String type = OutputFormatter.MESSAGE_TYPE_NONE]) => this._output.writeln(_currentIntent + message);
  void writeSpec(String keyword, String message, [String type = OutputFormatter.MESSAGE_TYPE_NONE])  => this._output.writeln(_currentIntent + keyword + message);
  
  void writeExampleData(List<Map<String, Object>> exampleData, List<Object> results) {
    
    var header = "| ";
    for(var key in exampleData.first.keys) {
      header += "$key | ";
    }
    header += "TestResult |";
    this._output.writeln(_currentIntent + header);
    
    
    for(int i = 0; i < exampleData.length; i++) {
      var data = exampleData[i];
      var result = results[i];
      var row = "| ";
      
      for(var value in data.values) {
        row += "$value | ";
      }
      row += "$result |";
      this._output.writeln(_currentIntent + row);
    }
    
  }
  
  void writeStatistics(SpecStatistics statistics) {
    this._output.writeln("Features: ${statistics.failedFeatures} of ${statistics.executedFeatures} are failed (${statistics.failedFeatureNames.join(",")})\n"
          "Stories: ${statistics.failedStories} of ${statistics.executedStories} are failed (${statistics.failedStoryNames.join(",")})\n"
          "Scenarios: ${statistics.failedScenarios} of ${statistics.executedScenarios} are failed (${statistics.failedScenarioNames.join(",")})");
  }
  
}