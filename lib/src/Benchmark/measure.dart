part of softhai.spec_dart;

const String MILLISECONDS = "ms";
const String MICROSECONDS = "µs";
const String TICKS = "ticks";

int whileCount = 0; 

Future<int> measure(dynamic func(), {String unit: "ms", int durationMS: 1000}) {
  
  whileCount = 0;
  var sw = new Stopwatch();
  
  return new Future.sync(() => sw.start())
      .then((v) => futureWhile(func, () => sw.elapsedMilliseconds < durationMS))
      .then((executionCount) {
    sw.stop();
    switch(unit) {
      case MILLISECONDS:
        return sw.elapsedMilliseconds / executionCount; 
      case MICROSECONDS:
        return sw.elapsedMicroseconds / executionCount; 
      case TICKS:
        return sw.elapsedTicks / executionCount;
      default:
        return sw.elapsedMilliseconds / executionCount; 
    }
  });
  
}

Future<int> futureWhile(dynamic func(), bool whileCondition()) {
  
  whileCount++;
  
  return new Future.sync(func).then((v) {
    if(whileCondition()) {
      return new Future.sync(() => futureWhile(func, whileCondition));
    }
    
    return whileCount;
  });
}