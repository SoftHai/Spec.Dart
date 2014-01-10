part of softhai.spec_dart;


abstract class OutputFormatter {
  
  static const String MESSAGE_TYPE_NONE = "N";
  static const String MESSAGE_TYPE_FAILURE = "F";
  static const String MESSAGE_TYPE_SUCCESS = "S";
  
  void incIntent();
  void decIntent();
  
  void SpecStart();
  void SpecEnd();
  
  void writeEmptyLine();
  void writeMessage(String message, [String type = MESSAGE_TYPE_NONE]);
  void writeSpec(String keyword, String message, [String type = MESSAGE_TYPE_NONE]);
  void writeExampleData(List<Map<String, Object>> data, List<Object> results);
}

class ConsoleOutputFormatter implements OutputFormatter {
  
  String _indent = "  ";
  String _currentIntent = "";
  
  ConsoleOutputFormatter([this._indent = "  "]);
  
  void incIntent() {
    this._currentIntent += SpecContext.indent;
  }
  
  void decIntent() {
    this._currentIntent = this._currentIntent.replaceFirst(SpecContext.indent, "");
  }
  
  void SpecStart() {
    print("-----------------------------------------------------------------------------------------");
  }
  
  void SpecEnd() {
    print("-----------------------------------------------------------------------------------------");
  }
  
  void writeEmptyLine() => print("");
  void writeMessage(String message, [String type = OutputFormatter.MESSAGE_TYPE_NONE]) => print(_currentIntent + message);
  void writeSpec(String keyword, String message, [String type = OutputFormatter.MESSAGE_TYPE_NONE])  => print(_currentIntent + keyword + message);
  
  void writeExampleData(List<Map<String, Object>> exampleData, List<Object> results) {
    
    var header = "| ";
    for(var key in exampleData.first.keys) {
      header += "$key | ";
    }
    header += "TestResult |";
    print(_currentIntent + header);
    
    
    for(int i = 0; i < exampleData.length; i++) {
      var data = exampleData[i];
      var result = results[i];
      var row = "| ";
      
      for(var value in data.values) {
        row += "$value | ";
      }
      row += "$result |";
      print(_currentIntent + row);
    }
    
  }
  
}

typedef void HtmlOutput(String htmlContent);

class HtmlOutputFormatter implements OutputFormatter {
  
  StringBuffer _content = new StringBuffer();
  HtmlOutput _outputFunc;
  int _currentIntent = 0;
  
  HtmlOutputFormatter(this._outputFunc);
  
  void incIntent() {
    this._currentIntent += 1;
  }
  
  void decIntent() {
    this._currentIntent -= 1;
  }
  
  void SpecStart() {
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
  
  void SpecEnd() {
    this._content.writeln("""</body>
                      </html>""");
    
    if(_outputFunc != null)
    {
      _outputFunc(this._content.toString());
    }
  }
  
  void writeEmptyLine() => print("<br>");
  
  void writeMessage(String message, [String type = OutputFormatter.MESSAGE_TYPE_NONE]) {
    this._addIntents();
    this._content.writeln("<span class='message'>$message</span><br>");
  }
  void writeSpec(String keyword, String message, [String type = OutputFormatter.MESSAGE_TYPE_NONE]) {
    this._addIntents();
    this._content.write("<span class='keyword'>$keyword</span>");
    switch (type) {
      case OutputFormatter.MESSAGE_TYPE_FAILURE:
        this._content.writeln("<span class='message failure'>$message</span><br>");
        break;
      case OutputFormatter.MESSAGE_TYPE_SUCCESS:
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
    
    this._content.writeln("</tbody><table>");
    
  }
  
  void _addIntents()
  {
    for(int i = 0; i < this._currentIntent; i++)
    {
      this._content.write("<span class='intent'></span>");
    }
  }
  
}