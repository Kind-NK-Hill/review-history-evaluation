# Related methods and this study's contribution

This study uses established ideas about tool feedback, proof search and process evaluation. Its empirical contribution is to connect those observations to real probability-task requirements, support-code delivery, downstream use and the comparability of recorded reviews.

| Primary source | Existing method | Connection to this study |
|---|---|---|
| [SWE-agent](https://proceedings.neurips.cc/paper_files/paper/2024/hash/5a7c947568c1b1328ccc5230172e1e7c-Abstract-Conference.html) | Examine action sequences, failed edits and recovery under different agent-computer interfaces | Define observable episodes before interpreting their outcomes; moving from a failed edit to mathematical retrieval need not mean recovery has failed |
| [COPRA](https://arxiv.org/abs/2310.04353) | Organize formal proof search around execution state, retrieval and failed attempts | Retrieving a declaration, adapting it and completing the assigned theorem are distinct observations |
| [AgentBoard](https://proceedings.neurips.cc/paper_files/paper/2024/hash/877b40688e330a0e2a3fc24084208dfa-Abstract-Datasets_and_Benchmarks_Track.html) | Measure intermediate progress and examine process-level behavior | Progress must be defined for the task; proof length or tool-call count is not a validated mathematical-progress measure |
| [SWE-Lancer](https://arxiv.org/abs/2502.12115v4) | Evaluate agents on concrete software tasks with executable assessment | Keep completed work, judgment rules and effort visible together |
| [DeepSeek-Prover-V2](https://arxiv.org/abs/2504.21801v2) | Decompose and compose formal proof obligations | A local subproof matters to completion through its actual use in the required result |

The present study does not introduce retrieval, feedback-driven repair or subgoal decomposition. It supplies domain-specific evidence about mathematical scope, equivalence-aware assessment, proof transfer and use, plus a reproducible process-measurement implementation. The parameter prototype has static checks; a model-level improvement from that intervention remains to be tested.

Original third-party papers are linked rather than redistributed in this repository.
