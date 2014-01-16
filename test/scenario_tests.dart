import 'dart:async';
import 'package:spec_dart/spec_dart.dart';
import 'package:unittest/unittest.dart';

import 'mock_output_formatter.dart';

main([bool disableInit = false]) {
  
  MockOutputFormatter formatter;
  if(!disableInit) {
    formatter = new MockOutputFormatter();
    SpecContext.output = formatter;
  }
  else {
    formatter = SpecContext.output;
  }
  
  group("Scenario", () {
    
    setUp(() => formatter.Clear());
    
    test("- Test - Basiscs", () {
      var scenario = new Scenario("Scenario Title");
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    setUp(() => formatter.Clear());
    test("- Test - SetUp / TearDown", () {
      var scenario = new Scenario("Scenario Title");
      scenario.setUp((context) => SpecContext.output.writeMessage("SETUP"));
      scenario.tearDown((context) => SpecContext.output.writeMessage("TEARDOWN"));
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'SETUP\n'
               'Scenario: Scenario Title\n'
               'TEARDOWN\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - Given with func", () {
      var scenario = new Scenario("Scenario Title");
      scenario.given(text: "is something", func: (context) => context.data["data1"] = 1);
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               '  Given is something\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - Given without func", () {
      var scenario = new Scenario("Scenario Title");
      scenario.given(text: "is nothing");
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               '  Given is nothing\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - Given-And", () {
      var scenario = new Scenario("Scenario Title");
      scenario.given(text: "is something", func: (context) => context.data["data1"] = 1).
                 and(text: "something else", func: (context) => context.data["data2"] = 2);
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
            '-----------------------------------------------------------------------------------------\n'
            'Scenario: Scenario Title\n'
            '  Given is something\n'
            '    And something else\n'
            'Features: 0 of 0 are failed ()\n'
            'Stories: 0 of 0 are failed ()\n'
            'Scenarios: 1 of 1 are failed (Scenario Title)\n'
            '-----------------------------------------------------------------------------------------\n'
            '');
      });
    });
    
    test("- Test - Given-And-And-And", () {
      var scenario = new Scenario("Scenario Title");
      scenario.given(text: "is something").
                 and(text: "something more").
                 and(text: "more");
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               '  Given is something\n'
               '    And something more\n'
               '    And more\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - When with func", () {
      var scenario = new Scenario("Scenario Title");
      scenario.when(text: "something happens", func: (context) => context.data["data1"] = 2);
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               '  When something happens\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - When without func", () {
      var scenario = new Scenario("Scenario Title");
      scenario.when(text: "nothing happens");
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               '  When nothing happens\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - When-And", () {
      var scenario = new Scenario("Scenario Title");
      scenario.when(text: "something happens", func: (context) => context.data["data1"] = 2).
                and(text: "more happens", func: (context) => context.data["data2"] = 3);
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               '  When something happens\n'
               '    And more happens\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - When-And-And", () {
      var scenario = new Scenario("Scenario Title");
      scenario.when(text: "something happens", func: (context) => context.data["data1"] = 2).
                and(text: "more happens", func: (context) => context.data["data2"] = 3).
                and(text: "more more more", func: (context) => context.data["data3"] = 4);
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               '  When something happens\n'
               '    And more happens\n'
               '    And more more more\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - Than", () {
      var scenario = new Scenario("Scenario Title");
      scenario.than(text: "happens something special", func: (context) => null);
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               '  Than happens something special: true\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 0 of 1 are failed ()\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - Than with exception", () {
      var scenario = new Scenario("Scenario Title");
      scenario.than(text: "happens an exception", func: (context) => throw "Demo Exception");
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               '  Than happens an exception: Exception(Demo Exception)\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - Than with TestException", () {
      var scenario = new Scenario("Scenario Title");
      scenario.than(text: "happens an exception", func: (context) =>expect(true, isFalse));
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output.startsWith(
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               '  Than happens an exception: Exception(Expected: false  Actual: <true>)\n'), isTrue);
        
        // StackTrace is cut out because the file pathes are different local and BuildServer
        
        expect(formatter.output.endsWith(
            'Features: 0 of 0 are failed ()\n'
            'Stories: 0 of 0 are failed ()\n'
            'Scenarios: 1 of 1 are failed (Scenario Title)\n'
            '-----------------------------------------------------------------------------------------\n'
            ''), isTrue);
      });
    });
    
    test("- Test - Than-And", () {
      var scenario = new Scenario("Scenario Title");
      scenario.than(text: "happens something special", func: (context) => false).
                and(text: "more special", func: (context) => true);
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               '  Than happens something special: false\n'
               '    And more special: true\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - Than with example data", () {
      var scenario = new Scenario("Scenario Title");
      scenario..than(text: "happens something with examples", func: (context) => context.data["Expected"])
              ..example([{ "Data1": 1, "Data2": 2, "Expected": true},
                         { "Data1": 3, "Data2": 4, "Expected": false}]);
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               '  Than happens something with examples\n'
               '  Example\n'
               '    | Data1 | Data2 | Expected | TestResult |\n'
               '    | 1 | 2 | true | true |\n'
               '    | 3 | 4 | false | false |\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - Than example data setup / teardown", () {
      var scenario = new Scenario("Scenario Title");
      scenario..than(text: "happens something with examples", func: (context) => context.data["Expected"])
              ..example([{ "Data1": 1, "Data2": 2, "Expected": true},
                         { "Data1": 3, "Data2": 4, "Expected": false}])
              ..exampleSetUp((context) => SpecContext.output.writeMessage("SETUP"))
              ..exampleTearDown((context) => SpecContext.output.writeMessage("TEARDOWN"));
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'Scenario: Scenario Title\n'
               '  Than happens something with examples\n'
               'SETUP\n'
               'TEARDOWN\n'
               'SETUP\n'
               'TEARDOWN\n'
               '  Example\n'
               '    | Data1 | Data2 | Expected | TestResult |\n'
               '    | 1 | 2 | true | true |\n'
               '    | 3 | 4 | false | false |\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - Complex", () {
      var scenario = new Scenario("Scenario Title");
      scenario..setUp((context) => SpecContext.output.writeMessage("SETUP"))
              ..given(text: "is something", func: (context) => context.data["GivenData1"] = 1)
                .and(text: "something else", func: (context) => context.data["GivenData2"] = 2)
              ..when(text: "something happens", func: (context) => context.data["WhenData1"] = 2)
                .and(text: "more happens", func: (context) => context.data["WhenData2"] = 3)
              ..than(text: "check given data", func: (context) => context.data["GivenData1"] == 1 && context.data["GivenData2"] == 2)
                .and(text: "and when data", func: (context) => context.data["WhenData1"] == 2 && context.data["WhenData2"] == 3)
              ..tearDown((context) => SpecContext.output.writeMessage("TEARDOWN"));
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'SETUP\n'
               'Scenario: Scenario Title\n'
               '  Given is something\n'
               '    And something else\n'
               '  When something happens\n'
               '    And more happens\n'
               '  Than check given data: true\n'
               '    And and when data: true\n'
               'TEARDOWN\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 0 of 1 are failed ()\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - Complex with Example Data", () {
      var scenario = new Scenario("Scenario Title");
      scenario..setUp((context) => SpecContext.output.writeMessage("SETUP"))
              ..given(text: "is something", func: (context) => context.data["GivenData1"] = 1)
                .and(text: "something else", func: (context) => context.data["GivenData2"] = 2)
              ..when(text: "something happens", func: (context) => context.data["WhenData1"] = 2)
                .and(text: "more happens", func: (context) => context.data["WhenData2"] = 3)
              ..than(text: "happens something with examples", func: (context) => context.data["Expected"])
                .and(text: "and given data", func: (context) => context.data["GivenData1"] == 1 && context.data["GivenData2"] == 2)
                .and(text: "and when data", func: (context) => context.data["WhenData1"] == 2 && context.data["WhenData2"] == 3)
              ..exampleSetUp((context) => SpecContext.output.writeMessage("example SETUP"))
              ..example([{ "Data1": 1, "Data2": 2, "Expected": true},
                         { "Data1": 3, "Data2": 4, "Expected": false}])
              ..exampleTearDown((context) => SpecContext.output.writeMessage("example TEARDOWN"))
              ..tearDown((context) => SpecContext.output.writeMessage("TEARDOWN"));
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'SETUP\n'
               'Scenario: Scenario Title\n'
               '  Given is something\n'
               '    And something else\n'
               '  When something happens\n'
               '    And more happens\n'
               '  Than happens something with examples\n'
               '    And and given data\n'
               '    And and when data\n'
               'example SETUP\n'
               'example TEARDOWN\n'
               'example SETUP\n'
               'example TEARDOWN\n'
               '  Example\n'
               '    | Data1 | Data2 | Expected | TestResult |\n'
               '    | 1 | 2 | true | true |\n'
               '    | 3 | 4 | false | false |\n'
               'TEARDOWN\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
    test("- Test - Complex with Example Data (Async / Sync mixed)", () {
      var scenario = new Scenario("Scenario Title");
      scenario..setUp((context) => SpecContext.output.writeMessage("SETUP"))
              ..given(text: "is something", func: (context) => new Future.delayed(new Duration(seconds: 2), () => context.data["GivenData1"] = 1)) //Async
                .and(text: "something else", func: (context) => context.data["GivenData2"] = 2)
              ..when(text: "something happens", func: (context) => context.data["WhenData1"] = 2)
                .and(text: "more happens", func: (context) => new Future.delayed(new Duration(seconds: 2), () => context.data["WhenData2"] = 3)) //Async
              ..than(text: "happens something with examples", func: (context) => context.data["Expected"])
                .and(text: "and given data", func: (context) => new Future.delayed(new Duration(seconds: 2), () => context.data["GivenData1"] == 1 && context.data["GivenData2"] == 2)) //Async
                .and(text: "and when data", func: (context) => context.data["WhenData1"] == 2 && context.data["WhenData2"] == 3)
              ..exampleSetUp((context) => new Future.delayed(new Duration(seconds: 2), () => SpecContext.output.writeMessage("example SETUP"))) //Async
              ..example([{ "Data1": 1, "Data2": 2, "Expected": true},
                         { "Data1": 3, "Data2": 4, "Expected": false}])
              ..exampleTearDown((context) => SpecContext.output.writeMessage("example TEARDOWN"))
              ..tearDown((context) => SpecContext.output.writeMessage("TEARDOWN"));
      
      var future = scenario.run();
      
      return future.whenComplete(() {
        expect(formatter.output, 
               '-----------------------------------------------------------------------------------------\n'
               'SETUP\n'
               'Scenario: Scenario Title\n'
               '  Given is something\n'
               '    And something else\n'
               '  When something happens\n'
               '    And more happens\n'
               '  Than happens something with examples\n'
               '    And and given data\n'
               '    And and when data\n'
               'example SETUP\n'
               'example TEARDOWN\n'
               'example SETUP\n'
               'example TEARDOWN\n'
               '  Example\n'
               '    | Data1 | Data2 | Expected | TestResult |\n'
               '    | 1 | 2 | true | true |\n'
               '    | 3 | 4 | false | false |\n'
               'TEARDOWN\n'
               'Features: 0 of 0 are failed ()\n'
               'Stories: 0 of 0 are failed ()\n'
               'Scenarios: 1 of 1 are failed (Scenario Title)\n'
               '-----------------------------------------------------------------------------------------\n'
               '');
      });
    });
    
  });

}