part of softhai.spec_dart;

abstract class SpecLanguage {
  final String feature = "";
  
  final String story = "";
  final String asA = "";
  final String iWant = "";
  final String soThat = "";
  
  final String scenario = "";
  final String given = "";
  final String when = "";
  final String than = "";
  final String example = "";
  
  final String and = "";
  
  final String success = "";
  final String failed = "";
  
  static SpecLanguage get en => new _SpecLangEN();
  
  static SpecLanguage get de => new _SpecLangDE();
}

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

class _SpecLangDE implements SpecLanguage {
  final String feature = "Feature";
  
  final String story = "Story";
  final String asA = "Als ein";
  final String iWant = "Möchte ich";
  final String soThat = "So das";
  
  final String scenario = "Szenario";
  final String given = "Gegeben";
  final String when = "Wenn";
  final String than = "Dann";
  final String example = "Beispiel";
  
  final String and = "Und";
  
  final String success = "Erfolgreich";
  final String failed = "Fehler";
}