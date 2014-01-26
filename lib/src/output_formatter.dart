part of softhai.spec_dart;


abstract class SpecOutputFormatter {
  
  static const String MESSAGE_TYPE_NONE = "N";
  static const String MESSAGE_TYPE_FAILURE = "F";
  static const String MESSAGE_TYPE_SUCCESS = "S";
  
  void incIntent();
  void decIntent();
  
  void specStart();
  void specEnd();
  
  void startFeature();
  void endFeature();
  
  void startStory();
  void endStory();
  
  void startScenario();
  void endScenario();
  
  void writeEmptyLine();
  void writeMessage(String message, [String type = MESSAGE_TYPE_NONE]);
  void writeSpec(String keyword, String message, [String type = MESSAGE_TYPE_NONE]);
  void writeExampleData(List<Map<String, Object>> data, List<Object> results);
  void writeStatistics(SpecStatistics statistics);
}

typedef void TextOutput(String object);

class TextSpecOutputFormatter implements SpecOutputFormatter {
  
  String _indent = "  ";
  String _currentIntent = "";
  TextOutput _outputFunc = print;
  
  TextSpecOutputFormatter({String intent: "  ", TextOutput printFunc: print}) : this._indent = intent, this._outputFunc = printFunc;
  
  void incIntent() {
    this._currentIntent += SpecContext.indent;
  }
  
  void decIntent() {
    this._currentIntent = this._currentIntent.replaceFirst(SpecContext.indent, "");
  }
  
  void specStart() {
    this._outputFunc("-----------------------------------------------------------------------------------------");
  }
  
  void specEnd() {
    this._outputFunc("-----------------------------------------------------------------------------------------");
  }
  
  void startFeature() {}
  void endFeature() {}
  
  void startStory() {}
  void endStory() {}
  
  void startScenario() {}
  void endScenario() {}
  
  void writeEmptyLine() => this._outputFunc("");
  void writeMessage(String message, [String type = SpecOutputFormatter.MESSAGE_TYPE_NONE]) => this._outputFunc(_currentIntent + message);
  void writeSpec(String keyword, String message, [String type = SpecOutputFormatter.MESSAGE_TYPE_NONE])  => this._outputFunc(_currentIntent + keyword + message);
  
  void writeExampleData(List<Map<String, Object>> exampleData, List<Object> results) {
    
    var header = "| ";
    for(var key in exampleData.first.keys) {
      header += "$key | ";
    }
    header += "TestResult |";
    this._outputFunc(_currentIntent + header);
    
    
    for(int i = 0; i < exampleData.length; i++) {
      var data = exampleData[i];
      var result = results[i] ? SpecContext.language.success : SpecContext.language.failed;
      var row = "| ";
      
      for(var value in data.values) {
        row += "$value | ";
      }
      row += "$result |";
      this._outputFunc(_currentIntent + row);
    }
    
  }
  
  void writeStatistics(SpecStatistics statistics) {
    this._outputFunc("Features: ${statistics.failedFeatures} of ${statistics.executedFeatures} are failed (${statistics.failedFeatureNames.join(",")})\n"
                    "Stories: ${statistics.failedStories} of ${statistics.executedStories} are failed (${statistics.failedStoryNames.join(",")})\n"
                    "Scenarios: ${statistics.failedScenarios} of ${statistics.executedScenarios} are failed (${statistics.failedScenarioNames.join(",")})");
  }
  
}

typedef void HtmlOutput(String htmlContent);

class HtmlSpecOutputFormatter implements SpecOutputFormatter {
  
  StringBuffer _content = new StringBuffer();
  HtmlOutput _outputFunc;
  int _currentIntent = 0;
  
  HtmlSpecOutputFormatter(this._outputFunc);
  
  void incIntent() {
    this._currentIntent += 1;
  }
  
  void decIntent() {
    this._currentIntent -= 1;
  }
  
  void specStart() {
    this._content.writeln("""
          <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
                                    "http://www.w3.org/TR/html4/loose.dtd">
          <html>
            <head>
              <title>Spec-Dart Test Result</title>
              <style>
                span.intent { padding: 0 40px 0 0; width: 0px; }
                span.keyword { font-weight:bold; }
                .failure { color: lightcoral;  }
                .success { color: limegreen; }
                th, td { border:thin solid black; }
                td { text-align:center;  }
              </style>
            </head>
            <body>""");
  }
  
  void specEnd() {
    this._content.writeln("""</body>
                      </html>""");
    
    if(_outputFunc != null)
    {
      _outputFunc(this._content.toString());
    }
  }
  
  void startFeature() {}
  void endFeature() {}
  
  void startStory() {}
  void endStory() {}
  
  void startScenario() {}
  void endScenario() {}
  
  void writeEmptyLine() => print("<br>");
  
  void writeMessage(String message, [String type = SpecOutputFormatter.MESSAGE_TYPE_NONE]) {
    this._addIntents();
    this._content.writeln("<span class='message'>$message</span><br>");
  }
  void writeSpec(String keyword, String message, [String type = SpecOutputFormatter.MESSAGE_TYPE_NONE]) {
    this._addIntents();
    this._content.write("<span class='keyword'>$keyword</span>");
    switch (type) {
      case SpecOutputFormatter.MESSAGE_TYPE_FAILURE:
        this._content.writeln("<span class='message failure'>$message</span><br>");
        break;
      case SpecOutputFormatter.MESSAGE_TYPE_SUCCESS:
        this._content.writeln("<span class='message success'>$message</span><br>");
        break;
      default:
        this._content.writeln("<span class='message'>$message</span><br>");
        break;
    }
  }
  
  void writeExampleData(List<Map<String, Object>> exampleData, List<Object> results) {
    
    this._content.writeln("<table style='padding: 0 ${this._currentIntent * 40}px;'><thead><tr>");

    for(var key in exampleData.first.keys) {
      this._content.writeln("<th>$key</th>");
    }
    this._content.writeln("<th>Test Result</th>");
    this._content.writeln("</tr></thead>");
    
    this._content.writeln("<tbody>");
    for(int i = 0; i < exampleData.length; i++) {
      var data = exampleData[i];
      var result = results[i];
      
      this._content.writeln("<tr>");
      
      for(var value in data.values) {
        this._content.writeln("<td>$value</td>");
      }
      
      if(result) {
        this._content.writeln("<td class='success'>$result</td>");
      }
      else {
        this._content.writeln("<td class='failure'>$result</td>");
      }
      this._content.writeln("</tr>");
    }
    
    this._content.writeln("</tbody></table>");
    
  }
  
  void writeStatistics(SpecStatistics statistics) {
    
    this._content.writeln("<br><br><br>");
    this._content.writeln("<h3>Summary:</h3>");
    
    var featureClass = statistics.failedFeatures > 0 ? "failure" : "success";
    var storyClass = statistics.failedStories > 0 ? "failure" : "success";
    var scenarioClass = statistics.failedScenarios > 0 ? "failure" : "success";
    
    this._content.writeln("<div class='$featureClass'>Features: ${statistics.failedFeatures} of ${statistics.executedFeatures} are failed</div>");
    if(statistics.failedFeatures > 0) {
      this._content.writeln("<ul>");
      statistics.failedFeatureNames.forEach((name) => this._content.writeln("<li>$name</li>"));
      this._content.writeln("</ul>");
    }
    this._content.writeln("<hr>");
    this._content.writeln("<div class='$storyClass'>Stories: ${statistics.failedStories} of ${statistics.executedStories} are failed</div>");
    if(statistics.failedFeatures > 0) {
      this._content.writeln("<ul>");
      statistics.failedStoryNames.forEach((name) => this._content.writeln("<li>$name</li>"));
      this._content.writeln("</ul>");
    }
    this._content.writeln("<hr>");
    this._content.writeln("<div class='$storyClass'>Scenarios: ${statistics.failedScenarios} of ${statistics.executedScenarios} are failed</div>");
    if(statistics.failedFeatures > 0) {
      this._content.writeln("<ul>");
      statistics.failedScenarioNames.forEach((name) => this._content.writeln("<li>$name</li>"));
      this._content.writeln("</ul>");
    }
  }
  
  void _addIntents()
  {
    for(int i = 0; i < this._currentIntent; i++)
    {
      this._content.write("<span class='intent'></span>");
    }
  }
  
}