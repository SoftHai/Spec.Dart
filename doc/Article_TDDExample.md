#TDD with Spec.Dart

I want to show you, how you can create TDD (Test Driven Development) with Spec.Dart.

##The Example - Unit Converter
Let's say we want to create an Unit-Converter class. Which takes a numeric value, a source and a destination unit and converts this.

You find all Code of this article in the example-folder of this project: [Code](/example/TDD Example Code/)

###The start

The first think what you have to do, is to create tests which fails. Because you have no unit converter yet.
To reach this, you can go different ways:
* Creating an empty UnitConverter Class -> Build the tests (red) -> implement the UnitConverter until the tests are green
* Creating the tests with the power of dynamic programming language -> implement the UnitConverter class.

I will show you the first way, because than the test are runable, from start up, because the class is available but has no implementation.
I'm not a professional in TDD, so thats more my opinion how you can do that. All other styles out there also welcome.

###The Unit Converter Class (Defenition)

First, we define an empty `UnitConverter` class which has only the required functions. Addtional we implement an empty exception `UnitConverterException`.

```dart
class UnitConverter {

  void define(String srcUnit, String destUnit, num convert(num srcValue)) {

  }

  num convert(num srcValue, String srcUnit, String destUnit) {

  }

}

class UnitConvertException implements Exception {

}
```

###The Tests

First we start with writing the Tests which fails:
```dart
 // We define a feature
  var feature = new Feature("Unit Converter", "A Class which converts a numeric value from one to another unit");
  
  // now we define a story
  var storyConverting = feature.story("Converting",
                                        asA: "Developer",
                                        iWant: "to have a class to convert a value from one to another unit",
                                        soThat: "I don't need to think about factors and calculation of this");
  
  // Scenario with inline code (use this for small test code)
  storyConverting.scenario("Converting °C to °F")
              ..given(text: "is a Unit convert defenition for °C to °F", 
                      func: (context) {
                        var unitConv = new UnitConverter();
                        unitConv.define("°C", "°F", (celsiusValue) => celsiusValue * 1.8 + 32);
                        context.data["UnitConv"] = unitConv;
                      })
              ..when(text: "I convert [sourceValue]°C to °F",
                     func: (context) {
                       context.data["Result"] = context.data["UnitConv"].convert(context.data["sourceValue"], "°C", "°F");
                     })
              ..than(text: "I got [destinationValue]",
                     func: (context) => expect(context.data["Result"], equals(context.data["destinationValue"])))
              ..example([{ "sourceValue": -10, "destinationValue": 14},
                         { "sourceValue": 0, "destinationValue": 32},
                         { "sourceValue": 10, "destinationValue": 50},
                         { "sourceValue": 20, "destinationValue": 68},
                         { "sourceValue": 30, "destinationValue": 86}]);
  
// Scenario with external test code (use this for bigger test code). This holds the defenition readable
  storyConverting.scenario("Converting °F to °C")
              ..given(text: "is a Unit convert defenition for °F to °C", 
                      func: CreateUnitConverter_F_to_C)
              ..when(text: "I convert [sourceValue]°F to °C",
                     func: Convert_F_to_C)
              ..than(text: "I got [destinationValue]",
                     func: Check_F_to_C)
              ..example([{ "sourceValue": 14, "destinationValue": -10},
                         { "sourceValue": 32, "destinationValue": 0},
                         { "sourceValue": 50, "destinationValue": 10},
                         { "sourceValue": 68, "destinationValue": 20},
                         { "sourceValue": 86, "destinationValue": 30}]);
  
  // Test more supported units ...
  
  var storyException = feature.story("Exception",
                                        asA: "Developer",
                                        iWant: "that the converting fails if I try to convert apple to pear",
                                        soThat: "I can catch this and notice the user");
  
  storyException.scenario("Converting mm to °C")
              ..given(text: "is a Unit convert without a defenition for mm to °C", 
                      func: (context) {
                        var unitConv = new UnitConverter();
                        context.data["UnitConv"] = unitConv;
                      })
              ..when(text: "I convert between invalid units (e.g. mm to °C)")
              ..than(text: "A exception is thrown",
                     func: (context) => expect(() => context.data["UnitConv"].convert(200, "mm", "°C"), 
                                               throwsA(new isInstanceOf<UnitConvertException>()))); // expect a exception
  
  // Test more invalid convertings ...
  
  feature.run();
```

If you now executing the test, you will see that all test fail:
```
-----------------------------------------------------------------------------------------
Feature: Unit Converter - A Class which converts a numeric value from one to another unit
  Story: Converting
    As a Developer
    I want to have a class to convert a value from one to another unit
    So that I don't need to think about factors and calculation of this

    Scenario: Converting °C to °F
      Given is a Unit convert defenition for °C to °F
      When I convert [sourceValue]°C to °F
      Than I got [destinationValue]
      Example
        | sourceValue | destinationValue | TestResult |
        | -10 | 14 | FAILED |
        | 0 | 32 | FAILED |
        | 10 | 50 | FAILED |
        | 20 | 68 | FAILED |
        | 30 | 86 | FAILED |

    Scenario: Converting °F to °C
      Given is a Unit convert defenition for °C to °F
      When I convert [sourceValue]°F to °C
      Than I got [destinationValue]
      Example
        | sourceValue | destinationValue | TestResult |
        | 14 | -10 | FAILED |
        | 32 | 0 | FAILED |
        | 50 | 10 | FAILED |
        | 68 | 20 | FAILED |
        | 86 | 30 | FAILED |

  Story: Exception
    As a Developer
    I want that the converting fails if I try to convert apple to pear
    So that I can catch this and notice the user

    Scenario: Converting mm to °C
      Given is a Unit convert without a defenition for mm to °C
      When I convert between invalid units (e.g. mm to °C)
      Than A exception is thrown: Exception(Expected: throws an instance of specified type  Actual: <Closure: () => dynamic>   Which: did not throw)
 #0     ...StackTrace was removed!

Features: 1 of 1 are failed (Unit Converter)
Stories: 2 of 2 are failed (Converting,Exception)
Scenarios: 3 of 3 are failed (Converting °C to °F,Converting °F to °C,Converting mm to °C)
-----------------------------------------------------------------------------------------
```
But you have a great defenition/documentation, what your code should do in the future.

###The Unit Converter Class (Implementation) 

Now we implementing the `UnitConverter` logic.
```dart
typedef num ConvertUnit(num srcValue); 

class UnitConverter {
  
  Map<String, ConvertUnit> _defenitions = new Map<String, ConvertUnit>();
  
  void define(String srcUnit, String destUnit, ConvertUnit convert) {
    this._defenitions["$srcUnit->$destUnit"] = convert;
  }
  
  num convert(num srcValue, String srcUnit, String destUnit) {
    
    if(this._defenitions.containsKey("$srcUnit->$destUnit")) {
      return this._defenitions["$srcUnit->$destUnit"](srcValue);
    }
    else {
      throw new UnitConvertException();
    }
    
  }
  
}

class UnitConvertException implements Exception {
  
}
```

Now you can run the tests again and you will see that all tests are green. We made it correct:
```
-----------------------------------------------------------------------------------------
Feature: Unit Converter - A Class which converts a numeric value from one to another unit
  Story: Converting
    As a Developer
    I want to have a class to convert a value from one to another unit
    So that I don't need to think about factors and calculation of this

    Scenario: Converting °C to °F
      Given is a Unit convert defenition for °C to °F
      When I convert [sourceValue]°C to °F
      Than I got [destinationValue]
      Example
        | sourceValue | destinationValue | TestResult |
        | -10 | 14 | SUCCESS |
        | 0 | 32 | SUCCESS |
        | 10 | 50 | SUCCESS |
        | 20 | 68 | SUCCESS |
        | 30 | 86 | SUCCESS |
    Scenario: Converting °F to °C
      Given is a Unit convert defenition for °F to °C
      When I convert [sourceValue]°F to °C
      Than I got [destinationValue]
      Example
        | sourceValue | destinationValue | TestResult |
        | 14 | -10 | SUCCESS |
        | 32 | 0 | SUCCESS |
        | 50 | 10 | SUCCESS |
        | 68 | 20 | SUCCESS |
        | 86 | 30 | SUCCESS |

  Story: Exception
    As a Developer
    I want that the converting fails if I try to convert apple to pear
    So that I can catch this and notice the user

    Scenario: Converting mm to °C
      Given is a Unit convert without a defenition for mm to °C
      When I convert between invalid units (e.g. mm to °C)
      Than A exception is thrown: SUCCESS


Features: 0 of 1 are failed ()
Stories: 0 of 2 are failed ()
Scenarios: 0 of 3 are failed ()
-----------------------------------------------------------------------------------------
```