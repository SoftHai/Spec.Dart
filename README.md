Spec.Dart
=========

[![Build Status](https://drone.io/github.com/SoftHai/Spec.Dart/status.png)](https://drone.io/github.com/SoftHai/Spec.Dart/latest)

**Spec.Dart** ins an BDD framework for Dart. It's offers an fluent Gherkin API to descripe the Tests.
Additional: Spec.Dart contains an Benchmark libary (called **Bench.Dart**) to benchmark your code.

Install
=========
[Spec.Dart on Dart Package Manager](http://pub.dartlang.org/packages/spec_dart)

You can get Spec.Dart from the Dart Package Manager.<br/>
**Get the Package**
* Add the dependancy 'spec_dart' to your pubspec.yaml
 * Via the DartEditor dialog
 * By adding the following to the file:
   ```
   dependencies:
       spec_dart: any
   ```
* Update your depandancies by running `pub install`

**Use the Package**
```dart
import 'package:spec_dart/spec_dart.dart
```


##Examples

### TDD with Spec.Dart

Here you can find an article about TDD / BDD with Spec.Dart: [Article](/doc/Article_TDDExample.md)


###Spec.Dart

```dart
// Change the language of your output (default EN) (EN and DE are supported)
SpecContext.language = SpecLanguage.en;

// Change the output formatter (default is console print) (Console and HTML are supported)
SpecContext.output = new HtmlOutputFormatter((m) => print(m));

// Create Features
var feature = new Feature("UserManagement", "With this feature, user can have an account to protect here data");
feature.setUp((context) {
    // SetUp e.g. some expensive database objects
  });
feature.tearDown((context) {
    // TearDown e.g. some resources (e.g. Database connection close)
  });

// Create Stories of features
var story1 = feature.story("Login",
                         asA: "user",
                         iWant: "to login/logoff to my account",
                         soThat: "I can get access to my data");

// Create senarios which test the story
story1.scenario("Login Test - Example Data")
    ..given(text: "is a login controller",
            func: (context) => context.data["ctrl"] =  new LoginController())

    ..when(text: "a user insert login data (user: [user] / password: [pw])",
           func: (context) => context.data["ctrl"].login(context.data["user"], context.data["pw"]))

    ..than(text: "the user is perhaps Logged in",
           func: (context) => expect(context.data["ctrl"].isLogin, context.data["successful"]))

    // Use Example data as Data-Driven-Tests
    ..example([{ "user": "Soft", "pw": "Hai", "successful": true},
               { "user": "Hero", "pw": "Man", "successful": false}]);

// Execute the test
feature.run();
```

The outpout looks like that (default console output. You can custumize the output by implementing an own `SpecOutputFormatter`):
```
-----------------------------------------------------------------------------------------
Feature: UserManagement - With this feature, user can have an account to protect here data
  Story: Login
    As a user
    I want to login/logoff to my account
    So that I can get access to my data

    Scenario: Login Test - Example Data
      Given is a login controller
      When a user insert login data (user: [user] / password: [pw])
      Than the user is perhaps Logged in
      Example
        | user | pw | successful | TestResult |
        | Soft | Hai | true | SUCCESS |
        | Hero | Man | false | SUCCESS |

Features: 0 of 1 are failed ()
Stories: 0 of 1 are failed ()
Scenarios: 0 of 1 are failed ()
-----------------------------------------------------------------------------------------
```
HTML output example:
[HTMLExample](/doc/img/ExampleHtmlOutput.png)

###Bench.Dart

```dart
// Change the output formatter (default is console print)
SpecContext.output = new TextBenchOutputFormatter();

// Create a Benchmark test Suite
var suite = Suite.create();
// You can set the number of interations per benchmark global or at each benchmark
suite.interations(10);
// Add an benchmark
suite.add("Login / logoff")
		..setUp((context) { context.data["ctrl"] = new LoginController(); }) // Setup the benchmark
		..bench((context) {
            return new Future.delayed(new Duration(milliseconds: 500)).then((_) { // Simulate a constant 500ms run
              context.data["ctrl"].login("Soft", "Hai");
              context.data["ctrl"].logoff();
            });
        }, "Delay")
		..bench((context) {
          var rnd = new Random();
          return new Future.delayed(new Duration(milliseconds: rnd.nextInt(1000))).then((_) { // Simulate a run which need between 0 and 1000ms
            context.data["ctrl"].login("Soft", "Hai");
            context.data["ctrl"].logoff();
          });
         }, "Random", 20); // executing this bench 20 times instead of global 10

// Execute the Benchmark
suite.run();
```
The outpout looks like that (default console output. You can custumize the output by implementing an own `BenchOutputFormatter`):
```
Start executing suite ...
  Bench 'Login / logoff'
    - Delay - Result: Avg: 521.6ms (runs '10' times, some values '513,501,501,501,501,501,504,541,613,540')
    - Random - Result: Avg: 543.15ms (runs '20' times, some values '602,507,5,388,15,740,662,122,441,769,589,1028,610,693,895,521,641,678,583,374')
End executing suite!
```


Doc
=========

Here you can find the framework documentation:
* [Spec.Dart](/doc/SpecDart.md)
 * [Translation](/doc/Translation.md)
 * [SpecOutputFormatter](/doc/OutputFormatter.md)

* [Bench.Dart](/doc/BenchDart.md)
 * BenchOutputFormatter

Changelog
=========

See [here](/CHANGELOG.md)

Roadmap
=========

* Improving
* Bugfixing

**Stable Version**

* New Feature
