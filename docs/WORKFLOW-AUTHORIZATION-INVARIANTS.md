# VERITAS Phase 5 — Workflow & Authorization Invariants

1. Workflow is institution-specific.
2. Workflow is configuration-driven.
3. VERITAS does not invent universal Maker/Checker rules.
4. Workflow actions are explicitly configured.
5. Actions are state-bound.
6. Unconfigured actions are denied.
7. Ambiguous workflow resolution is not silently resolved.
8. Authority must be resolved before workflow authorization.
9. Authority status must be active.
10. Required capabilities must be explicitly configured.
11. Workflow authorization does not equal execution.
12. AUTHORIZED does not equal execution consent.
13. EXECUTION_ELIGIBLE does not equal execution consent.
14. CONSENT_REQUIRED is an explicit execution boundary.
15. Workflow actions cannot bypass transaction integrity.
16. Workflow actions cannot bypass optimistic concurrency.
17. Workflow actions cannot fabricate external results.
18. Workflow actions cannot transmit SWIFT messages.
19. Workflow actions cannot manufacture ACKs.
20. Unknown authorization state remains unresolved.
21. Transaction remains the canonical shared object.
22. Every workflow action is attributable to an operator identity.
23. Every workflow action produces structured evidence/event data.
24. Institution-specific authority remains authoritative over generic defaults.
25. Execution remains separately governed by the execution-consent fabric.
