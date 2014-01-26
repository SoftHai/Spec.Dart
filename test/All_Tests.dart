import 'feature_tests.dart' as featureTests;
import 'story_tests.dart' as storyTests;
import 'scenario_tests.dart' as scenarioTests;
import 'package:spec_dart/spec_dart.dart';

main() {
  
  StringBuffer outputString = new StringBuffer();
  SpecContext.output = new TextSpecOutputFormatter(printFunc: (o) => outputString.writeln(o));
  
  featureTests.tests(outputString);
  storyTests.tests(outputString);
  scenarioTests.tests(outputString);
  
}