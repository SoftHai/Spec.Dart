part of softhai.spec_dart;

// Public interface
abstract class SpecContext {
  static OutputFormatter output = new ConsoleOutputFormatter();
  static String indent = "  ";
  static SpecLanguage language = SpecLanguage.en;
  
  Map<String, dynamic> data;
}

// Hidden implementation
class _SpecContextImpl implements SpecContext {

  _SpecStatistics statistics = new _SpecStatistics();
  Map<String, dynamic> data = new Map<String, dynamic>();
  
  _SpecContextImpl();
  
  _SpecContextImpl._clone(_SpecContextImpl orig) {
    this.data.addAll(orig.data);
  }
  
}
