Spec.Dart
=========

[![Build Status](https://drone.io/github.com/SoftHai/Spec.Dart/status.png)](https://drone.io/github.com/SoftHai/Spec.Dart/latest)

A BDD framework for testing dart applications

[Spec.Dart on Dart Package Manager](http://pub.dartlang.org/packages/spec_dart)

Install
=========

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


Example
=========
```dart
// Change the language of your output (default EN) (EN and DE are supported)
SpecContext.language = SpecLanguage.en;

// Change the output formatter (default is console print) (Console and HTML are supported)
SpecContext.output = new HtmlOutputFormatter((m) => print(m));

// Create Features
var feature = new Feature("UserManagement", "With this feature, user can have an account to protect here data");

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

The outpout looks like that (Console output):
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
        | Soft | Hai | true | true |
        | Hero | Man | false | true |

Features: 0 of 1 are failed ()
Stories: 0 of 1 are failed ()
Scenarios: 0 of 1 are failed ()
-----------------------------------------------------------------------------------------
```
HTML output example:
[HTMLExample](https://github.com/SoftHai/Spec.Dart/blob/master/doc/img/ExampleHtmlOutput.png)

Doc
=========

Here you can find the framework documentation:
* [Spec.Dart](https://github.com/SoftHai/Spec.Dart/blob/master/doc/SpecDart.md)
* [Translation](https://github.com/SoftHai/Spec.Dart/blob/master/doc/Translation.md)
* [OutputFormatter](https://github.com/SoftHai/Spec.Dart/blob/master/doc/OutputFormatter.md)

Changelog
=========

See [here](https://github.com/SoftHai/Spec.Dart/blob/master/CHANGELOG.md)

Roadmap
=========

* Improving
* Bugfixing

**Stable Version**

* New Feature
