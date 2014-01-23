part of softhai.spec_dart;

const String MILLISECONDS = "ms";
const String MICROSECONDS = "µs";
const String TICKS = "ticks";

Future<int> measure(dynamic func(value), [String unit = "ms"]) {
  
  var sw = new Stopwatch();
  
  return new Future.sync(() => sw.start()).then(func).then((_) {
    sw.stop();
    switch(unit) {
      case MILLISECONDS:
        return sw.elapsedMilliseconds; 
      case MICROSECONDS:
        return sw.elapsedMicroseconds; 
      case TICKS:
        return sw.elapsedTicks;
      default:
        return sw.elapsedMilliseconds; 
    }
  });
  
}