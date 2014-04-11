part of softhai.spec_dart;

abstract class Suite {
  
  static Suite create() {
    return new _SuiteImpl();
  }
  
  void interations(int count);
  
  Benchmark add(String name);
  
  Future run();
  
}

class _SuiteImpl implements Suite {
  
  List<Benchmark> benches = new List<Benchmark>();
  int interationCount = 3;
  
  void interations(int count) {
    this.interationCount = count;
  }
  
  Benchmark add(String name) {
    var bech = new _BenchmarkImpl(name, this.interationCount);
    benches.add(bech);
    return bech;
  }
  
  Future run() {
    
    BenchContext.output.startSuite();
    
    return Future.forEach(benches, (bench) {
      
      return bench.run();
      
    }).whenComplete(() => BenchContext.output.endSuite());
    
  }
  
}