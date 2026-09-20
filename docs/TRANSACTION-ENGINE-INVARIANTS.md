# VERITAS Phase 4 — Canonical Transaction Invariants

1. Every transaction has a unique transaction identifier.
2. Every transaction has an explicit institution identity.
3. Every transaction has an explicit environment.
4. Every transaction has a monotonically increasing version.
5. Transaction versions are immutable once persisted.
6. Transaction state is explicit.
7. State transitions must be configured.
8. Unconfigured state transitions are denied.
9. Transaction integrity is verified before state transition.
10. Optimistic version conflicts block state transitions.
11. Canonical transaction state is the shared transaction object.
12. Maker/checker semantics are not hard-coded into the transaction object.
13. Institution-specific workflow remains configuration-driven.
14. Authority is not execution permission.
15. Execution eligibility is not execution.
16. Execution consent remains a separate boundary.
17. Transaction state must not imply transmission.
18. Transmission must not be inferred from local state alone.
19. ACK must never be fabricated.
20. Settlement must never be fabricated.
21. Unknown remains unknown.
22. Failed verification blocks consequential progression.
23. Every state transition produces a transaction event.
24. Transaction integrity is represented by a cryptographic digest.
25. Phase 4 does not transmit SWIFT messages.
26. Phase 4 does not simulate successful SWIFT transmission.
27. Phase 4 does not manufacture external acknowledgements.
28. Phase 4 establishes the canonical state substrate required by later execution systems.
