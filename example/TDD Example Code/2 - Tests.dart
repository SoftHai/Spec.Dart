import 'package:unittest/unittest.dart';
import 'package:spec_dart/spec_dart.dart';

//import '1 - UnitConverter - Defenition.dart'; // Import only the empty class
import '3 - UnitConverter - Implementation.dart'; // Import the implemented class

main() {
  
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
  
}

void CreateUnitConverter_F_to_C(context) {
  var unitConv = new UnitConverter();
  unitConv.define("°F", "°C", (fahrenheitValue) => (fahrenheitValue - 32) * (5/9) );
  context.data["UnitConv"] = unitConv;
}

void Convert_F_to_C(context) {
  context.data["Result"] = context.data["UnitConv"].convert(context.data["sourceValue"], "°F", "°C");
}

bool Check_F_to_C(context) {
  expect(context.data["Result"], equals(context.data["destinationValue"]));
}

