#SpecOutputFormatter

You can change the output formatter for the Spec.Dart run-output.
By default Spec.Dart outputs to the console. Which is great for IDE testing and the most build-servers.

But if you want to work with the results (e.g. setting a build to successful or fail, or to include the result to a buildserver mail, ...) you will perhaps need an different format (e.g. XML)
 
##Switching the SpecOutputFormatter

You can switch the output formatter by assigning a different formatter to the property `SpecContext.output`.

The following output formatter are supported:
* **TextOutputFormatter**: This is the default output formatter and logs, by default, all outputs to the console.
* **HtmlOutputFormatter**: This is an output formatter which creates a HTML document.

###HtmlOutputFormatter

You can switch to the HtmlOutputFormatter by assigning an istance to the `SpecContext.output` property:
```dart
SpecContext.output = new HtmlOutputFormatter((m) => print(m));
```

As parameter in the constructor you have to insert an function. This function will be called at the end of the spec run and gives to the content (string) of the HTML file.

I did this this way to have no dependancy to the IO framework. You can do in the function what ever you need:
* Save to an file
* Display in an HTML file
* Send to somewhere by mail
* ...

In the upper example I output the content to the console.

##Creating own SpecOutputFormatter

You can create own output formatter by inherit from the class `SpecOutputFormatter`.

```dart
class ExampleOutputFormatter implements SpecOutputFormatter {

  void incIntent();
  void decIntent();

  void SpecStart();
  void SpecEnd();

  void writeEmptyLine();
  void writeMessage(String message, [String type = MESSAGE_TYPE_NONE]);
  void writeSpec(String keyword, String message, [String type = MESSAGE_TYPE_NONE]);
  void writeExampleData(List<Map<String, Object>> data, List<Object> results);
  void writeStatistics(SpecStatistics statistics);
}
```

##Contribute

If you create new output formatter which could be interesting for other users, too. Than it would be greate if you would return your code to the project.
