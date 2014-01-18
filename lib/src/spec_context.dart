part of softhai.spec_dart;

// Public interface
abstract class SpecContext {
  static OutputFormatter output = new TextOutputFormatter();
  static String indent = "  ";
  static SpecLanguage language = SpecLanguage.en;
  
  Map<String, dynamic> data;
}

// Hidden implementation
class _SpecContextImpl implements SpecContext {

  SpecStatistics statistics = new SpecStatistics();
  Map<String, dynamic> data = new Map<String, dynamic>();
  
  _SpecContextImpl();
  
  _SpecContextImpl._clone(_SpecContextImpl orig) {
    this.data.addAll(orig.data);
  }
  
}
