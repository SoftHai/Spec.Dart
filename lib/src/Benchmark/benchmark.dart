part of softhai.spec_dart;

typedef dynamic BenchFunc(BenchContext context);

abstract class Benchmark {
  
  void setUp(BenchFunc func);
  
  void bench(BenchFunc func, {String name, int interations, String unit: MILLISECONDS});
  
  void tearDown(BenchFunc func);
  
  Future run();
  
}

class BenchResult {
  
  List<num> _times = new List<num>();
  double get avg => sum / _times.length;
  num get sum {
    var sum = 0;
    for (var time in this._times) {
      sum += time;
    }
    return sum;
  }
  String unit;
  BenchResult(this.unit);
  
  add(num timeMS) {
    if(timeMS > 0)
    {
      this._times.add(timeMS);
    }
  }
  
  String toString() {
    return "Avg: $avg$unit (runs '${this._times.length}' times, some values '${this._times.take(20).map((time) => time.toStringAsFixed(1)).join(' , ')}')";
  }
  
}

class _BenchInfo {
  
  final BenchFunc bench;
  final String name;
  final String unit;
  final int interations;
  
  const _BenchInfo(this.bench, this.name, this.interations, this.unit);
}

class _BenchmarkImpl implements Benchmark {
  
  List<_BenchInfo> _benchInfos = new List<_BenchInfo>();
  
  int interations = 10;
  BenchFunc _setUp;
  BenchFunc _tearDown;
  
  String name;
  
  _BenchmarkImpl(this.name, this.interations);
  
  void setUp(BenchFunc func) {
    this._setUp = func;
  }
  
  void bench(BenchFunc func, {String name, int interations, String unit: MILLISECONDS}) {
    if(name == null) name = "${this._benchInfos.length + 1}";
    if(interations == null) interations = this.interations;
    
    this._benchInfos.add(new _BenchInfo(func, name, interations, unit));
  }
  
  void tearDown(BenchFunc func) {
    this._tearDown = func;
  }
  
  Future run() {
    
    BenchContext.output.startBenchmark(this.name);
    
    if(this._benchInfos.length == 0) return null;
    var context = new _BenchContextImpl();

    return new Future.sync(() { 
        if(this._setUp != null) return this._setUp(context); 
      }).then((_) => Future.forEach(_benchInfos, (benchinfo) {
      
      var list = new List<_BenchInfo>.filled(benchinfo.interations, benchinfo);
      var benchResult = new BenchResult(benchinfo.unit);
      
      return Future.forEach(list, (bench) { 
        
        return measure(() => bench.bench(context), unit: bench.unit).then((time) => 
            benchResult.add(time));
        
      }).then((_) => BenchContext.output.printBenchmarkResult(benchinfo.name, benchResult));
      
    })).whenComplete(() {
      if(this._tearDown != null) return this._tearDown(context); 
      BenchContext.output.endBenchmark();
    });
    
  }
  
}