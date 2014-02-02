#Bench.Dart

Bench.Dart contains 2 main elements:
* **Suite:** A Suite contains a several benchmarks which will be executed together.
* **Benchmark**: A Benchmark is a Bechnak Test Scenario and can cointains several benches.

####FAQ
*Why creating another benchmark framework?*

The default Benchmark-Lib `benchmark_harness` creates me to much overhead with implementing the benchmark class and calling each class seperate. Addtional I can benchmark async code (Futures) with it what was bad in on of my other projects. 
So I deside to implement my own benchmark Framework which fits more my requirments. And here it is!

#Defining Benchmarks

##Common

### Async Support

All Bench functions are support `Future` return data. This way you can load async data from a database, a file, a WebService and so on.

The Benchmark element will wait until the `Future` is complete and measures this time.

##Suite

A `Suite` is a set of several benchmarks.

You can create a `Suite` as below:
```dart
var suite = Suite.create();
```

A `Suite` has the following members:
* **interations**: Defines how often a benchmark should be executed (default is 3) - each interation takes at least 1 sec.
* **add**: Add a new Benchmark to the suite.


##Benchmark

A `Benchmark` defines the Benchmark you want to execute.

You can create a `Benchmark` from an `Suite` Instance:
```dart
var benchmark = suite.add("Benchmark name");
```

A `Suite` has the following members:
* **setUp**: Pass a function to the benchmark which setup / prepare the bench run.
* **bench**: Add a benchmark-function to the benchmark, which is executed between the `setUp` and the `tearDown` and is measured for the benchmark. You can add several benchmark funktions to a single `Benchmark`.
  ```dart
void bench(BenchFunc func, [String name, int interations, String unit = MILLISECONDS])
  ```
  parameters:
   * **name**: Add a costum name to each registered bench function.
   * **interations**: overwrites the global defined interations number for this benchmark. Each interation takes at least 1 sec.
   * **unit**: Defines the measured unit of the benchmark (default MILLISECONDS)

* **tearDown**: Pass a function to the benchmark which tear down the bench run (clean up resources).

###BenchContext
Each function of the benchmark `setUp`, `tearDown` and `bench` get passed the current benchmark vontext. With it you can store data / variable over the functions.
```dart
context.data["DataKey"] = data;
```

```dart
var data = context.data["DataKey"];
```


#Executing a Benchmark

You can run an benchmark by calling the `run` function of the `Suite` object.
```dart
suite.run();
```