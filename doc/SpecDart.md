#Spec.Dart

Spec.Dart contains 3 main elements to create BDD tests:
* **Feature:** A Feature describes a part of the software (e.g. UserManagement). Features can have as child:
 * Features (as SubFeatures)
 * Stories
 * Scenarios

* **Story:** Stories describing the benefit of an part of an feature. Stories can have as child:
 * Scenarios
* **Scenario:** Scenarios are tests which checks (in different ways) a function of you software / story.

#Defining Tests

##Common

### SetUp / TearDown
All Spec elements are supporting a `setUp` and a `tearDown` function. So that you can create and destroy resources on higher level (e.g. Database connections).

```dart
var feature = new Feature("UserManagement");
feature.setUp((context) {
    // SetUp e.g. some expensive database objects
  });
feature.tearDown((context) {
    // TearDown e.g. some resources (e.g. Database connection close)
  });
```

### Async Support

All Spec functions are support `Future` return data. This way you can load async data from a database, a file, a WebService and so on.

The Spec element will wait until the `Future` is complete and will continue than the executing.

##Feature

A `Feature` is currently the top level spec object. You don't need to create features or other objects. They are optional to give you test-output a better structure (like groups in the dart unittest).

You can create a feature as below:
```dart
var feature = new Feature("name", "optional description");
```

You can create nested features as below:
```dart
var subFeature = feature.subFeature("name", "optional description");
```

##Story

A `Story` describes a benefit a named usergroup wants from that feature / part. A story contains the parts:
* **As a**: "As a developer" *(Wo needs this)*
* **I want**: "I want readable tests" *(What benefit the person expect)*
* **So that**: "So that I easy understand what the tests are doing" *(Why the person needs this function)*

You can create a `Story` direct from an object (if you don't use `Feature` objects)
```dart
var story = new Story("title",
                      asA: "developer",
                      iWant: "Readable tests",
                      soThat: "I easy understand what the tests are doing");
```
or from an feature
```dart
var story = feature.story("title",,
                          asA: "developer",
                          iWant: "Readable tests",
                          soThat: "I easy understand what the tests are doing");
```

##Scenario

The `Scenario` contains the tests of the application. A Scenario describes a use case:
* **Given**: "Given is a logged out user" *(initial situation / precondition)*
* **When**: "When a user logging in with valid login data" *(an action / event which happens)*
* **Than**: "Than the user is logged in" *(the result / situation / state after the action / event)*
* **ThenThrows**: Expect that the *When* part throws any excaption
* **ThenThrowsA**: Expect that the *When* part throws a defined exception

You can create 2 types of scenarios:
* Single Executing Scenarios
* Multi Executing Scenarios

###Single executing Scenarios
This senarios are executed one time with the given code and data.

you can create a single instance of an senario or from an feature or story by calling `scenario` on the instance.

```dart
story1.scenario("Login Test - Valid")
       ..given(text: "is a login controller",
               func: (context) => context.data["ctrl"] =  new LoginController())

       ..when(text: "a user insert valid login data (user: Soft / password: Hai)",
              func: (context) => context.data["ctrl"].login("Soft", "Hai"))

       ..than(text: "the user is Logged in",
              func: (context) => context.data["ctrl"].isLogin);
      // OR
      ..thanThrows();
      // OR
      ..thanThrowsA(TestException);
```
This tests will login with the valid data (user: "Soft" / pw: "Hai").

You can shared data across the 3 function by saving and loading from the `context.data`object.

The func-parameter in the `given` and `when` part are optional.

###Multi executing Scenarios (Example Data)
This scenarios are executing several times by different given data.

The upper example shows you how to test an login. But you don't want to create 2 or more blocks of this code to test the login with different conndions (e.g. valid, invalid, only username, ...).

For that you can use an data-driven-test with example data:
```dart
  story1.scenario("Login Test - Example Data")
         ..given(text: "is a login controller",
                 func: (context) => context.data["ctrl"] =  new LoginController())

         ..when(text: "a user insert login data (user: [user] / password: [pw])",
               func: (context) => context.data["ctrl"].login(context.data["user"], context.data["pw"]))

         ..than(text: "the user is perhaps Logged in",
                func: (context) => expect(context.data["ctrl"].isLogin, context.data["successful"]))

         ..example([{ "user": "Soft", "pw": "Hai", "successful": true},
                    { "user": "Hero", "pw": "Man", "successful": false}]);
```

You can see the addional function call `example`. It takes a list of maps of string/object. This way you can define a table of input data.

Additional you can see in the `than` function that it don't inputs the login data hard coded. It takes the login data from the `context.data` object.

All example data in an map are added to the `context.data` object. And you can access this by the name defined in the map.

The test will be executed for each item in the example list.

####Example SetUp / TearDown

Additional to the normal `setUp` and a `tearDown` functions, Scenario support 2 additional functions `exampleSetUp` and `exampleTearDown`. The difference between this functions is, that the normal SetUp / TearDown are called one time per Scenario. The example SetUp / TearDown functions are call for each row of the example.

```dart
  story1.scenario("Login Test - Example Data")
         ..given(text: "is a login controller",
                 func: (context) => context.data["ctrl"] =  new LoginController())

         ..when(text: "a user insert login data (user: [user] / password: [pw])",
               func: (context) => context.data["ctrl"].login(context.data["user"], context.data["pw"]))

         ..than(text: "the user is perhaps Logged in",
                func: (context) => expect(context.data["ctrl"].isLogin, context.data["successful"]))

         ..example([{ "user": "Soft", "pw": "Hai", "successful": true},
                    { "user": "Hero", "pw": "Man", "successful": false}])
         ..exampleSetUp((context) {
         	// Example SetUp code here
         })
         ..exampleTearDown((context) {
         	// Example TearDown code here
         });
```

###Expecting an Exception during the When executing

Alterbative to the `Then` part you can define that the `When` throws an exception. You can do that with the methods `ThenThrows()` or `ThenThrowsA(Type)`:

```dart
story1.scenario("Login Test - Valid")
       ..given(text: "is a login controller",
               func: (context) => context.data["ctrl"] =  new LoginController())

       ..when(text: "a user insert invalid login data (user: ABC / password: XYZ)",
              func: (context) => context.data["ctrl"].login("ABC", "XYZ"))

      ..thenThrows();
      // OR
      ..thenThrowsA(LoginException); // Throws an LoginException
```

#Executing Tests

You can run an test by calling the `run` function of you top level spec object. It will call all sub object automatically in the order you have defined.
```dart
feature.run();
```