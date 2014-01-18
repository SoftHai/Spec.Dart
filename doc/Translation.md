#Translation

Default language of Spec.Dart is english but you can change or create your own language.

The object `SpecContext`contains the language configuration.

##Changing the Language

You can change the language by setting a new language to the `SpecContext.language`property:

```dart
SpecContext.language = SpecLanguage.de; // set to german
```

following languages are currently supported:
* **en**: english (default)
* **de**: german


##Creating own translations

You can create own languages by inherit from the class `SpecLanguage`. You have to implement the following properties:

```dart
class _SpecLangEN implements SpecLanguage {
  final String feature = "Feature";

  final String story = "Story";
  final String asA = "As a";
  final String iWant = "I want";
  final String soThat = "So that";

  final String scenario = "Scenario";
  final String given = "Given";
  final String when = "When";
  final String than = "Than";
  final String example = "Example";

  final String and = "And";

  final String success = "SUCCESS";
  final String failed = "FAILED";

}
```
Change the strings to the your language and assign an istance of the class to the `SpecContext.language` property.

###Contribute

If you create own languages, than it would be greate when you return your language to the Spec.Dart project. So that other user can use the language, too.

Here the rules:
* create a class with the name `SpecLangXX`, where XX the uppercase shortcut of your language is (e.g. DE for German)
* create a getter in the class `SpecLanguage` with the lowercase shortcut of your language (e.g. `static SpecLanguage get xx => new _SpecLangXX();`)
* Create a pull request to return your code to the project