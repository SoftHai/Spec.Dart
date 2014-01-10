Spec.Dart
=========

A BDD framework for testing dart applications

Install
=========

Coming soon

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
var story1 = feature.story("Login", asA: "user", iWant: "to login/logoff to my account", soThat: "I can get access to my data");

// Create senarios which test the story
story1.scenario("Login Test - Example Data")
    ..given(text: "is a login controller",
            func: (context) => context.data["ctrl"] =  new LoginController())

    ..when(text: "a user insert invalid login data (user: [user] / password: [pw])",
           func: (context) => context.data["ctrl"].login(context.data["user"], context.data["pw"]))

    ..than(text: "the user is not Logged in",
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
      When a user insert invalid login data (user: [user] / password: [pw])
      Than the user is not Logged in
      Example
        | user | pw | successful | TestResult |
        | Soft | Hai | true | true |
        | Hero | Man | false | true |
-----------------------------------------------------------------------------------------
```
HTML output example:
[HTMLExample](https://github.com/SoftHai/Spec.Dart/blob/master/doc/img/ExampleHtmlOutput.png)

Doc
=========

Coming soon

Changelog
=========

See [here](https://github.com/SoftHai/Spec.Dart/blob/master/CHANGELOG.md)

Roadmap
=========

Coming soon
