#Changelog
```
Legend: (NEW) New Feature - (IMP) Improvement - (FIX) Bugfix
```

##Version 0.1.0-beta
**Release date: *11.01.2014*

- **(NEW)** Feature
- **(NEW)** Story
- **(NEW)** Scenario
- **(NEW)** Scenario - Example Data (Data Driven Tests)
- **(NEW)** Translation Support (DE and EN)
- **(NEW)** OutputFormatter

##Version 0.2.0-beta
**Release date: *16.01.2014*

- **(NEW)** Add Statistics (How many executed, how many failed)
- **(IMP)** (#4): Add `setUp`/`tearDown` functions to each Spec-Object (`Feature`, `Story`, `Scenario`)
- **(IMP)** (#4): Add `exampleSetUp`/`exampleTearDown` functions to 'Scenario'
- **(IMP)** (#6): Add support for async (`Future`) to all Spec-Functions (* `given`, `when`, `then`, `setUp`, `tearDown`, `exampleSetUp`, `exampleTearDown`, `example`)