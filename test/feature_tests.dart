import 'dart:async';
import 'package:spec_dart/spec_dart.dart';
import 'package:unittest/unittest.dart';

main() { 
  StringBuffer outputString = new StringBuffer();
  SpecContext.output = new TextSpecOutputFormatter(printFunc: (o) => outputString.writeln(o));
  
  tests(outputString);
}

tests(StringBuffer outputString) {
  
  group("Feature", () {
    
    setUp(() => outputString.clear());
    
    test("- Test - Basiscs", () {     
      var feature = new Feature("BDD", "BDD makes tests more readable");
      expect(feature.name, equals("BDD"));
      expect(feature.description, equals("BDD makes tests more readable"));
      
      var future = feature.run();
      
      return future.whenComplete(() {
        expect(outputString.toString(), 
            '-----------------------------------------------------------------------------------------\n'
            'Feature: BDD - BDD makes tests more readable\n'
            '\n'
            'Features: 0 of 1 are failed ()\n'
            'Stories: 0 of 0 are failed ()\n'
            'Scenarios: 0 of 0 are failed ()\n'
            '-----------------------------------------------------------------------------------------\n'
        '');
      });
    });
      
    test("- Test - SetUp / TearDown", () {
      var feature = new Feature("BDD", "BDD makes tests more readable");
      feature.setUp((context) => SpecContext.output.writeMessage("SETUP"));
      feature.tearDown((context) => SpecContext.output.writeMessage("TEARDOWN"));
      
      var future = feature.run();
      
      return future.whenComplete(() {
        expect(outputString.toString(), 
            '-----------------------------------------------------------------------------------------\n'
            'SETUP\n'
            'Feature: BDD - BDD makes tests more readable\n'
            '\n'
            'TEARDOWN\n'
            'Features: 0 of 1 are failed ()\n'
            'Stories: 0 of 0 are failed ()\n'
            'Scenarios: 0 of 0 are failed ()\n'
            '-----------------------------------------------------------------------------------------\n'
        '');
      });
    });
    
    test("- Test - SetUp / TearDown (Async)", () {
      var feature = new Feature("BDD", "BDD makes tests more readable");
      feature.setUp((context) => new Future.delayed(new Duration(seconds: 2), () => SpecContext.output.writeMessage("SETUP")));
      feature.tearDown((context) => new Future.delayed(new Duration(seconds: 2), () => SpecContext.output.writeMessage("TEARDOWN")));
      
      var future = feature.run();
      
      return future.whenComplete(() {
        expect(outputString.toString(), 
            '-----------------------------------------------------------------------------------------\n'
            'SETUP\n'
            'Feature: BDD - BDD makes tests more readable\n'
            '\n'
            'TEARDOWN\n'
            'Features: 0 of 1 are failed ()\n'
            'Stories: 0 of 0 are failed ()\n'
            'Scenarios: 0 of 0 are failed ()\n'
            '-----------------------------------------------------------------------------------------\n'
        '');
      });
    });
    
    test("- Test - Feature with story", () {
      var feature = new Feature("BDD", "BDD makes tests more readable");
      var story = feature.story("Testing", asA: "Tester", iWant: "readable tests", soThat: "I easy understand what the test are doing");
      
      var future = feature.run();
      
      return future.whenComplete(() {
        expect(outputString.toString(), 
               '-----------------------------------------------------------------------------------------\n'
               'Feature: BDD - BDD makes tests more readable\n'
               '  Story: Testing\n'
               '    As a Tester\n'
               '    I want readable tests\n'
               '    So that I easy understand what the test are doing\n'
               '\n'
               '\n'
               '\n'
               'Features: 0 of 1 are failed ()\n'
               'Stories: 0 of 1 are failed ()\n'
               'Scenarios: 0 of 0 are failed ()\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
   
    test("- Test - Feature with scenario", () {
      var feature = new Feature("BDD", "BDD makes tests more readable");
      var scenario = feature.scenario("This is readable")
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
      
      var future = feature.run();
      
      return future.whenComplete(() {
       expect(outputString.toString(), 
             '-----------------------------------------------------------------------------------------\n'
             'Feature: BDD - BDD makes tests more readable\n'
             '  Scenario: This is readable\n'
             '    Given are some data\n'
             '    When I change some data\n'
             '    Than I check the changed data1: SUCCESS\n'
             '      And I check the unchanged data2: SUCCESS\n'
             '\n'
             'Features: 0 of 1 are failed ()\n'
             'Stories: 0 of 0 are failed ()\n'
             'Scenarios: 0 of 1 are failed ()\n'
             '-----------------------------------------------------------------------------------------\n'
             '');
      });
    });
    
    test("- Test - Feature with sub feature", () {
      var feature = new Feature("BDD", "BDD makes tests more readable");
      var subFeature = feature.subFeature("Story", description: "A Story is a sub feature of BDD");
      
      var future = feature.run();
      
      return future.whenComplete(() {
        expect(outputString.toString(), 
               '-----------------------------------------------------------------------------------------\n'
               'Feature: BDD - BDD makes tests more readable\n'
               '  Feature: Story - A Story is a sub feature of BDD\n'
               '\n'
               '\n'
               'Features: 0 of 2 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 0 of 0 are failed ()\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - Feature with story, subfeature, scenario", () {
      var feature = new Feature("BDD", "BDD makes tests more readable");
      var story = feature.story("Testing", asA: "Tester", iWant: "readable tests", soThat: "I easy understand what the test are doing");
      var subFeature = feature.subFeature("Story", description: "A Story is a sub feature of BDD");
      var scenario = feature.scenario("This is readable")
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
      
      var future = feature.run();
      
      return future.whenComplete(() {
        expect(outputString.toString(), 
               '-----------------------------------------------------------------------------------------\n'
               'Feature: BDD - BDD makes tests more readable\n'
               '  Story: Testing\n'
               '    As a Tester\n'
               '    I want readable tests\n'
               '    So that I easy understand what the test are doing\n'
               '\n'
               '\n'
               '  Feature: Story - A Story is a sub feature of BDD\n'
               '\n'
               '  Scenario: This is readable\n'
               '    Given are some data\n'
               '    When I change some data\n'
               '    Than I check the changed data1: SUCCESS\n'
               '      And I check the unchanged data2: SUCCESS\n'
               '\n'
               'Features: 0 of 2 are failed ()\n'
               'Stories: 0 of 1 are failed ()\n'
               'Scenarios: 0 of 1 are failed ()\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - Feature with story with senario", () {
      var feature = new Feature("BDD", "BDD makes tests more readable");
      var story = feature.story("Testing", asA: "Tester", iWant: "readable tests", soThat: "I easy understand what the test are doing");
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
      var future = feature.run();
      
      return future.whenComplete(() {
        expect(outputString.toString(), 
               '-----------------------------------------------------------------------------------------\n'
               'Feature: BDD - BDD makes tests more readable\n'
               '  Story: Testing\n'
               '    As a Tester\n'
               '    I want readable tests\n'
               '    So that I easy understand what the test are doing\n'
               '\n'
               '    Scenario: This is readable\n'
               '      Given are some data\n'
               '      When I change some data\n'
               '      Than I check the changed data1: SUCCESS\n'
               '        And I check the unchanged data2: SUCCESS\n'
               '\n'
               '\n'
               'Features: 0 of 1 are failed ()\n'
               'Stories: 0 of 1 are failed ()\n'
               'Scenarios: 0 of 1 are failed ()\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
        });
    });
    
  });
  
  
  
  
}