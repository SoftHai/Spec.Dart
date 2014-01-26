part of softhai.spec_dart;

abstract class BenchOutputFormatter {
  
  void startSuite();
  void endSuite();
  
  void startBenchmark(String name);
  void endBenchmark();
  
  void printBenchmarkResult(String benchmarkName, BenchResult result);
}


class TextBenchOutputFormatter implements BenchOutputFormatter {
  
  String _indent = "  ";
  String _currentIntent = "";
  TextOutput _outputFunc = print;
  
  TextBenchOutputFormatter({String intent: "  ", TextOutput printFunc: print}) : this._indent = intent, this._outputFunc = printFunc;
  
  void _incIntent() {
    this._currentIntent += SpecContext.indent;
  }
  
  void _decIntent() {
    this._currentIntent = this._currentIntent.replaceFirst(SpecContext.indent, "");
  }
  
  void startSuite() {
    print(this._currentIntent + "Start executing suite ...");
    this._incIntent();
  }
  
  void endSuite() {
    this._decIntent();
    print(this._currentIntent + "End executing suite!");
  }
  
  void startBenchmark(String name) {
    print(this._currentIntent + "Bench '$name'");
    this._incIntent();
  }
  
  void endBenchmark() {
    this._decIntent();
  }
  
  void printBenchmarkResult(String benchmarkName, BenchResult result) {
    print(this._currentIntent + "- $benchmarkName - Result: $result");
  }
  
}