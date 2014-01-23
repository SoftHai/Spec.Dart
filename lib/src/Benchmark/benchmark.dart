part of softhai.spec_dart;

typedef dynamic BenchFunc(BenchContext context);

abstract class Benchmark {
  
  void setUp(BenchFunc func);
  
  void bench(BenchFunc func, [String name, String unit = MILLISECONDS]);
  
  void tearDown(BenchFunc func);
  
  Future run();
  
}

class BenchResult {
  
  List<int> _times = new List<int>();
  double get avg => sum / _times.length;
  int get sum {
    var sum = 0;
    for (var time in this._times) {
      sum += time;
    }
    return sum;
  }
  String unit;
  BenchResult(this.unit);
  
  add(int timeMS) {
    this._times.add(timeMS);
  }
  
  String toString() {
    return "Avg: $avg$unit (runs '${this._times.length}' times, some values '${this._times.take(20).join(',')}')";
  }
  
}

class _BenchInfo {
  
  final BenchFunc bench;
  final String name;
  final String unit;
  
  const _BenchInfo(this.bench, this.name, this.unit);
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
  
  void bench(BenchFunc func, [String name, String unit = MILLISECONDS]) {
    if(name == null) name = "${this._benchInfos.length + 1}";
    
    this._benchInfos.add(new _BenchInfo(func, name, unit));
  }
  
  void tearDown(BenchFunc func) {
    this._tearDown = func;
  }
  
  Future run() {
    
    if(this._benchInfos.length == 0) return null;
    var context = new _BenchContextImpl();
    
    return new Future.sync(() { 
        if(this._setUp != null) return this._setUp(context); 
      }).then((_) => Future.forEach(_benchInfos, (benchinfo) {
      
      var list = new List<_BenchInfo>.filled(this.interations, benchinfo);
      var benchResult = new BenchResult(benchinfo.unit);
      
      return Future.forEach(list, (bench) { 
        
        return measure((_) => bench.bench(context), bench.unit).then((time) => 
            benchResult.add(time));
        
      }).then((_) => 
          print("${this.name} -  ${benchinfo.name} - $benchResult"));
      
    })).whenComplete(() {
      if(this._tearDown != null) return this._tearDown(context); 
    });
    
  }
  
}