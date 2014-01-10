import 'package:spec_dart/spec_dart.dart';
import 'package:unittest/unittest.dart';

class MockOutputFormatter extends OutputFormatter {
  
  StringBuffer _output = new StringBuffer();
  String get output => this._output.toString();
  
  void Clear() { 
    this._output = new StringBuffer();
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
  
}

main() {
  
  var formatter = new MockOutputFormatter();
  SpecContext.output = formatter;
  
  group("Feature", () {
    
    setUp(() => formatter.Clear());
    test("- Test - Basiscs", () {
      var feature = new Feature("BDD", "BDD makes tests more readable");
      expect(feature.name, equals("BDD"));
      expect(feature.description, equals("BDD makes tests more readable"));
      
      feature.run();
      
      expect(formatter.output, 
        '-----------------------------------------------------------------------------------------\n'
        'Feature: BDD - BDD makes tests more readable\n'
        '\n'
        '-----------------------------------------------------------------------------------------\n'
        '');
    });
    
    setUp(() => formatter.Clear());
    test("- Test - Feature with story", () {
      var feature = new Feature("BDD", "BDD makes tests more readable");
      var story = feature.story("Testing", asA: "Tester", iWant: "readable tests", soThat: "I easy understand what the test did");
      
      feature.run();
      
      expect(formatter.output, 
         '-----------------------------------------------------------------------------------------\n'
         'Feature: BDD - BDD makes tests more readable\n'
         '  Story: Testing\n'
         '    As a Tester\n'
         '    I want readable tests\n'
         '    So that I easy understand what the test did\n'
         '\n'
         '\n'
         '\n'
         '-----------------------------------------------------------------------------------------\n'
        '');
    });
   
    setUp(() => formatter.Clear());
    test("- Test - Feature with story and senario", () {
      var feature = new Feature("BDD", "BDD makes tests more readable");
      var story = feature.story("Testing", asA: "Tester", iWant: "readable tests", soThat: "I easy understand what the test did");
      story.scenario("This is readable")
          ..given(text: "are some data", 
                  func: (context) {
                    context.data["data1"] = "data1";
                    context.data["data2"] = "data2";
                  })
          ..when(text: "I change some data", 
                 func: (context) {
                   context.data["data1"] = "data5";
                 })
          ..than(text: "I check the changed data1", 
                 func: (context) {
                   expect(context.data["data1"], "data5");
                   return true; 
                 }).and(text: "I check the data2", 
                        func: (context) {
                          expect(context.data["data2"], "data2");
                          return true;
                        });
      feature.run();
      
      expect(formatter.output, 
             '-----------------------------------------------------------------------------------------\n'
             '    Feature: BDD - BDD makes tests more readable\n'
             '      Story: Testing\n'
             '        As a Tester\n'
             '        I want readable tests\n'
             '        So that I easy understand what the test did\n'
             '\n'
             '        Scenario: This is readable\n'
             '          Given are some data\n'
             '          When I change some data\n'
             '          Than I check the changed data1: true\n'
             '            And I check the data2: true\n'
             '\n'
             '\n'
             '\n'
             '-----------------------------------------------------------------------------------------\n'
             '');
    });
    
  });
  
}