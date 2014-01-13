import 'package:spec_dart/spec_dart.dart';
import 'package:unittest/unittest.dart';

import 'mock_output_formatter.dart';

main([bool disableInit = false]) {
  
  MockOutputFormatter formatter;
  if(!disableInit) {
    var formatter = new MockOutputFormatter();
    SpecContext.output = formatter;
  }
  else {
    formatter = SpecContext.output;
  }
  
  group("Scenario", () {
    
    setUp(() => formatter.Clear());
    test("- Test - Basiscs", () {
      var scenario = new Scenario("Scenario Title");
      
      scenario.run();
      
      expect(formatter.output, 
             '-----------------------------------------------------------------------------------------\n'
             'Scenario: Scenario Title\n'
             'Features: 0 of 0 are failed ()\n'
             'Stories: 0 of 0 are failed ()\n'
             'Scenarios: 1 of 1 are failed (Scenario Title)\n'
             '-----------------------------------------------------------------------------------------\n'
             '');
    });
    
    setUp(() => formatter.Clear());
    test("- Test - SetUp / TearDown", () {
      var scenario = new Scenario("Scenario Title");
      scenario.setUp((context) => SpecContext.output.writeMessage("SETUP"));
      scenario.tearDown((context) => SpecContext.output.writeMessage("TEARDOWN"));
      
      scenario.run();
      
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
    
    setUp(() => formatter.Clear());
    test("- Test - Given with func", () {
      var scenario = new Scenario("Scenario Title");
      scenario.given(text: "is something", func: (context) => context.data["data1"] = 1);
      
      scenario.run();
      
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
    
    setUp(() => formatter.Clear());
    test("- Test - Given without func", () {
      var scenario = new Scenario("Scenario Title");
      scenario.given(text: "is nothing");
      
      scenario.run();
      
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
    
    setUp(() => formatter.Clear());
    test("- Test - Given-And", () {
      var scenario = new Scenario("Scenario Title");
      scenario.given(text: "is something", func: (context) => context.data["data1"] = 1).
                 and(text: "something else", func: (context) => context.data["data2"] = 2);
      
      scenario.run();
      
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
    
    setUp(() => formatter.Clear());
    test("- Test - Given-And-And-And", () {
      var scenario = new Scenario("Scenario Title");
      scenario.given(text: "is something").
                 and(text: "something more").
                 and(text: "more");
      
      scenario.run();
      
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
    
    setUp(() => formatter.Clear());
    test("- Test - When with func", () {
      var scenario = new Scenario("Scenario Title");
      scenario.when(text: "something happens", func: (context) => context.data["data1"] = 2);
      
      scenario.run();
      
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
    
    setUp(() => formatter.Clear());
    test("- Test - When without func", () {
      var scenario = new Scenario("Scenario Title");
      scenario.when(text: "nothing happens");
      
      scenario.run();
      
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
    
    setUp(() => formatter.Clear());
    test("- Test - When-And", () {
      var scenario = new Scenario("Scenario Title");
      scenario.when(text: "something happens", func: (context) => context.data["data1"] = 2).
                and(text: "more happens", func: (context) => context.data["data2"] = 3);
      
      scenario.run();
      
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
    
    setUp(() => formatter.Clear());
    test("- Test - When-And-And", () {
      var scenario = new Scenario("Scenario Title");
      scenario.when(text: "something happens", func: (context) => context.data["data1"] = 2).
                and(text: "more happens", func: (context) => context.data["data2"] = 3).
                and(text: "more more more", func: (context) => context.data["data3"] = 4);
      
      scenario.run();
      
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
    
    setUp(() => formatter.Clear());
    test("- Test - Than", () {
      var scenario = new Scenario("Scenario Title");
      scenario.than(text: "happens something special", func: (context) => null);
      
      scenario.run();
      
      expect(formatter.output, 
             '-----------------------------------------------------------------------------------------\n'
             'Scenario: Scenario Title\n'
             '  Than happens something special: null\n'
             'Features: 0 of 0 are failed ()\n'
             'Stories: 0 of 0 are failed ()\n'
             'Scenarios: 0 of 1 are failed ()\n'
             '-----------------------------------------------------------------------------------------\n'
             '');
    });
    
    setUp(() => formatter.Clear());
    test("- Test - Than with exception", () {
      var scenario = new Scenario("Scenario Title");
      scenario.than(text: "happens an exception", func: (context) => throw "Demo Exception");
      
      scenario.run();
      
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
    
    setUp(() => formatter.Clear());
    test("- Test - Than with TestException", () {
      var scenario = new Scenario("Scenario Title");
      scenario.than(text: "happens an exception", func: (context) =>expect(true, isFalse));
      
      scenario.run();
            
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
    
    setUp(() => formatter.Clear());
    test("- Test - Than-And", () {
      var scenario = new Scenario("Scenario Title");
      scenario.than(text: "happens something special", func: (context) => false).
                and(text: "more special", func: (context) => true);
      
      scenario.run();
      
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
    
    setUp(() => formatter.Clear());
    test("- Test - Than with example data", () {
      var scenario = new Scenario("Scenario Title");
      scenario..than(text: "happens something with examples", func: (context) => context.data["Expected"])
              ..example([{ "Data1": 1, "Data2": 2, "Expected": true},
                         { "Data1": 3, "Data2": 4, "Expected": false}]);
      
      scenario.run();
      
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
    
    setUp(() => formatter.Clear());
    test("- Test - Than example data setup / teardown", () {
      var scenario = new Scenario("Scenario Title");
      scenario..than(text: "happens something with examples", func: (context) => context.data["Expected"])
              ..example([{ "Data1": 1, "Data2": 2, "Expected": true},
                         { "Data1": 3, "Data2": 4, "Expected": false}])
              ..exampleSetUp((context) => SpecContext.output.writeMessage("SETUP"))
              ..exampleTearDown((context) => SpecContext.output.writeMessage("TEARDOWN"));
      
      scenario.run();
      
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

}