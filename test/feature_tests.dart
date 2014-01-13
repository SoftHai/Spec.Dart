import 'package:spec_dart/spec_dart.dart';
import 'package:unittest/unittest.dart';

import 'mock_output_formatter.dart';

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
             'Features: 0 of 1 are failed\n'
             'Stories: 0 of 0 are failed\n'
             'Scenarios: 0 of 0 are failed\n'
             '-----------------------------------------------------------------------------------------\n'
             '');
    });
    
    setUp(() => formatter.Clear());
    test("- Test - Feature with story", () {
      var feature = new Feature("BDD", "BDD makes tests more readable");
      var story = feature.story("Testing", asA: "Tester", iWant: "readable tests", soThat: "I easy understand what the test are doing");
      
      feature.run();
      
      expect(formatter.output, 
             '-----------------------------------------------------------------------------------------\n'
             'Feature: BDD - BDD makes tests more readable\n'
             '  Story: Testing\n'
             '    As a Tester\n'
             '    I want readable tests\n'
             '    So that I easy understand what the test are doing\n'
             '\n'
             '\n'
             '\n'
             'Features: 0 of 1 are failed\n'
             'Stories: 0 of 1 are failed\n'
             'Scenarios: 0 of 0 are failed\n'
             '-----------------------------------------------------------------------------------------\n'
             '');
    });
   
    setUp(() => formatter.Clear());
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
      feature.run();
      
      expect(formatter.output, 
             '-----------------------------------------------------------------------------------------\n'
             'Feature: BDD - BDD makes tests more readable\n'
             '  Scenario: This is readable\n'
             '    Given are some data\n'
             '    When I change some data\n'
             '    Than I check the changed data1: true\n'
             '      And I check the unchanged data2: true\n'
             '\n'
             'Features: 0 of 1 are failed\n'
             'Stories: 0 of 0 are failed\n'
             'Scenarios: 0 of 1 are failed\n'
             '-----------------------------------------------------------------------------------------\n'
             '');
    });
    
    setUp(() => formatter.Clear());
    test("- Test - Feature with sub feature", () {
      var feature = new Feature("BDD", "BDD makes tests more readable");
      var subFeature = feature.subFeature("Story", description: "A Story is a sub feature of BDD");
      
      feature.run();
      
      expect(formatter.output, 
             '-----------------------------------------------------------------------------------------\n'
             'Feature: BDD - BDD makes tests more readable\n'
             '  Feature: Story - A Story is a sub feature of BDD\n'
             '\n'
             '\n'
             'Features: 0 of 2 are failed\n'
             'Stories: 0 of 0 are failed\n'
             'Scenarios: 0 of 0 are failed\n'
             '-----------------------------------------------------------------------------------------\n'
             '');
    });
    
    setUp(() => formatter.Clear());
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
      
      feature.run();
      
      expect(formatter.output, 
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
             '    Than I check the changed data1: true\n'
             '      And I check the unchanged data2: true\n'
             '\n'
             'Features: 0 of 2 are failed\n'
             'Stories: 0 of 1 are failed\n'
             'Scenarios: 0 of 1 are failed\n'
             '-----------------------------------------------------------------------------------------\n'
             '');
    });
    
    setUp(() => formatter.Clear());
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
      feature.run();
      
      expect(formatter.output, 
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
             '      Than I check the changed data1: true\n'
             '        And I check the unchanged data2: true\n'
             '\n'
             '\n'
             'Features: 0 of 1 are failed\n'
             'Stories: 0 of 1 are failed\n'
             'Scenarios: 0 of 1 are failed\n'
             '-----------------------------------------------------------------------------------------\n'
             '');
    });
    
  });
  
  
  
  
}