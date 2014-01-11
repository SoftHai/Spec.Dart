import 'feature_tests.dart' as featureTests;
import 'story_tests.dart' as storyTests;
import 'scenario_tests.dart' as scenarioTests;

main() {
  
  featureTests.main();
  storyTests.main(true);
  scenarioTests.main(true);
  
}