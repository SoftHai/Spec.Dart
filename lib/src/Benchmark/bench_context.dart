part of softhai.spec_dart;

abstract class BenchContext {
  
  Map<String, dynamic> data;
  
}

class _BenchContextImpl implements BenchContext {
  
  Map<String, dynamic> data = new Map<String, dynamic>();
  
}