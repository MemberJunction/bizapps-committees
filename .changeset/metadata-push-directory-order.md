---
"@mj-biz-apps/committees-entities": patch
---

`mj sync push --dir metadata` now succeeds on a fresh database.

- `metadata/.mj-sync.json` lists every metadata folder in `directoryOrder`, ending with `record-processes`, `ml-training-pipelines`, `ml-models` and `ml-model-scoring-bindings`. Folders left out of the list are pushed afterwards in alphabetical order, so `ml-model-scoring-bindings` was pushed before the model and record process it references and the push rolled back on `FK_MLModelScoringBinding_MLModel`.
- The shipped ML models no longer carry `"ArtifactFileID": null`. Push sets nulls too, so every push cleared the trained artifact link on the host that trained the models. A fresh database still gets null; a trained host keeps its value.
