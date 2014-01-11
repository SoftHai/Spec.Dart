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
             '-----------------------------------------------------------------------------------------\n'
             '\n'
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
             '-----------------------------------------------------------------------------------------\n'
             '\n'
             '');
    });
    
    setUp(() => formatter.Clear());
    test("- Test - Than with TestException", () {
      var scenario = new Scenario("Scenario Title");
      scenario.than(text: "happens an exception", func: (context) =>expect(true, isFalse));
      
      scenario.run();
      
      expect(formatter.output, 
             '-----------------------------------------------------------------------------------------\n'
             'Scenario: Scenario Title\n'
             '  Than happens an exception: Exception(Expected: false  Actual: <true>)\n'
             ' #0      SimpleConfiguration.onExpectFailure (package:unittest/src/simple_configuration.dart:137:7)\n'
             '#1      _ExpectFailureHandler.fail (package:unittest/src/simple_configuration.dart:15:28)\n'
             '#2      DefaultFailureHandler.failMatch (package:unittest/src/expect.dart:117:9)\n'
             '#3      expect (package:unittest/src/expect.dart:75:29)\n'
             '#4      main.<anonymous closure>.<anonymous closure>.<anonymous closure> (file:///C:/Projekt/Spec.Dart/test/scenario_tests.dart:199:75)\n'
             '#5      _StepChainImpl._executeStep (package:spec_dart/src/steps.dart:63:43)\n'
             '#6      _StepChainImpl.executeSteps (package:spec_dart/src/steps.dart:45:32)\n'
             '#7      Scenario.run (package:spec_dart/src/scenario.dart:87:50)\n'
             '#8      main.<anonymous closure>.<anonymous closure> (file:///C:/Projekt/Spec.Dart/test/scenario_tests.dart:201:19)\n'
             '#9      _run.<anonymous closure> (package:unittest/src/test_case.dart:109:30)\n'
             '#10     _Future._propagateToListeners.<anonymous closure> (dart:async/future_impl.dart:453)\n'
             '#11     _rootRun (dart:async/zone.dart:683)\n'
             '#12     _RootZone.run (dart:async/zone.dart:823)\n'
             '#13     _Future._propagateToListeners (dart:async/future_impl.dart:445)\n'
             '#14     _Future._complete (dart:async/future_impl.dart:303)\n'
             '#15     _Future._asyncComplete.<anonymous closure> (dart:async/future_impl.dart:354)\n'
             '#16     _asyncRunCallback (dart:async/schedule_microtask.dart:18)\n'
             '#17     _createTimer.<anonymous closure> (dart:async-patch/timer_patch.dart:11)\n'
             '#18     _Timer._createTimerHandler._handleTimeout (timer_impl.dart:151)\n'
             '#19     _Timer._createTimerHandler.<anonymous closure> (timer_impl.dart:166)\n'
             '#20     _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:93)\n'
             '\n'
             '-----------------------------------------------------------------------------------------\n'
             '\n'
             '');
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
             '-----------------------------------------------------------------------------------------\n'
             '\n'
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
             '-----------------------------------------------------------------------------------------\n'
             '');
    });
    
  });

}