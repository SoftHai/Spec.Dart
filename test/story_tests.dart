import 'package:spec_dart/spec_dart.dart';
import 'package:unittest/unittest.dart';

import 'mock_output_formatter.dart';

main([disableInit = false]) {
  
  MockOutputFormatter formatter;
  if(!disableInit) {
    var formatter = new MockOutputFormatter();
    SpecContext.output = formatter;
  }
  else {
    formatter = SpecContext.output;
  }
  
  group("Story", () {
    
    setUp(() => formatter.Clear());
    test("- Test - Basiscs", () {
      var story = new Story("Story of tests", asA: "Tester", iWant: "Readable tests", soThat: "I fast understand what they doing");
      expect(story.title, equals("Story of tests"));
      expect(story.asA, equals("Tester"));
      expect(story.iWant, equals("Readable tests"));
      expect(story.soThat, equals("I fast understand what they doing"));
      
      story.run();
      
      expect(formatter.output, 
             '-----------------------------------------------------------------------------------------\n'
             'Story: Story of tests\n'
             '  As a Tester\n'
             '  I want Readable tests\n'
             '  So that I fast understand what they doing\n'
             '\n'
             '\n'
             '-----------------------------------------------------------------------------------------\n'
             '');
    });
    
    setUp(() => formatter.Clear());
    test("- Test - Story with senario", () {
      var story = new Story("Story of tests", asA: "Tester", iWant: "Readable tests", soThat: "I fast understand what they doing");
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
                 }).and(text: "I check the unchanged data2", 
                        func: (context) {
                          expect(context.data["data2"], "data2");
                          return true;
                        });
      story.run();
      
      expect(formatter.output, 
             '-----------------------------------------------------------------------------------------\n'
             'Story: Story of tests\n'
             '  As a Tester\n'
             '  I want Readable tests\n'
             '  So that I fast understand what they doing\n'
             '\n'
             '  Scenario: This is readable\n'
             '    Given are some data\n'
             '    When I change some data\n'
             '    Than I check the changed data1: true\n'
             '      And I check the unchanged data2: true\n'
             '\n'
             '\n'
             '-----------------------------------------------------------------------------------------\n'
             '');
    });
    
  });
  
  
  
  
}