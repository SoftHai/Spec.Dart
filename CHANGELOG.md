#Changelog
```
DateFormat: DD.MM.YYYY
Legend: (NEW) New Feature - (IMP) Improvement - (FIX) Bugfix - (!!!) Attantion (e.g. Breaking Changes)

```

##Version 0.3.2-beta
**Release date: *02.02.2014* **

- **(FIX)** Bench.Dart: Benchmark result was not comparable and not correct

##Version 0.3.1-beta
**Release date: *29.01.2014* **

--------------------------------------------------------------
- **(!!!) Bench.Dart: Changed optional parameter of function `Bench` from positional to named**

--------------------------------------------------------------

- **(IMP)** Bench.Dart: Changed postional to named parameter in function `Bench` of object `Benchmark`
- **(IMP)** Bench.Dart: Removed zeros measuring values from the result calculation
- **(IMP)** Bench.Dart: Changed the output text of the results

##Version 0.3.0-beta
**Release date: *26.01.2014* **

--------------------------------------------------------------
- **(!!!) Renamed `OutputFormatter` to `SpecOutputFormatter`**
- **(!!!) Renamed `ConsoleOutputFormatter`to `TextSpecOutputFormatter`**
- **(!!!) Renamed `HtmlOutputFormatter`to `HtmlSpecOutputFormatter`**
- **(!!!) Add `success` and `failed` to the `SpecLanguage` interface**
- **(!!!) Add some functions to the `SpecOutputFormatter` interface**

--------------------------------------------------------------

- **(NEW)** Add [Bench.Dart](/doc/BenchDart.md). A lib for Benchmarks
- **(IMP)** Add a output function to the construtor of the class `TextOutputFormatter`, to change the default output from console to what ever you need
- **(IMP)** Changed Senario Than result test from `true`/`false` to `SUCCESS`/`FAILED` and made than translatable
- **(IMP)** (#7): Add `ThanThrows` and `ThanThrowsA` method to 'Scenario`

##Version 0.2.0-beta
**Release date: *16.01.2014* **

- **(NEW)** Add Statistics (How many executed, how many failed)
- **(IMP)** (#4): Add `setUp`/`tearDown` functions to each Spec-Object (`Feature`, `Story`, `Scenario`)
- **(IMP)** (#4): Add `exampleSetUp`/`exampleTearDown` functions to `Scenario`
- **(IMP)** (#6): Add support for async (`Future`) to all Spec-Functions (`given`, `when`, `then`, `setUp`, `tearDown`, `exampleSetUp`, `exampleTearDown`)

##Version 0.1.0-beta
**Release date: *11.01.2014* **

- **(NEW)** Feature
- **(NEW)** Story
- **(NEW)** Scenario
- **(NEW)** Scenario - Example Data (Data Driven Tests)
- **(NEW)** Translation Support (DE and EN)
- **(NEW)** OutputFormatter
