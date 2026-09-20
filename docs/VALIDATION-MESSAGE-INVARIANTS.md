# VERITAS Phase 6 — Transaction Validation + Message Construction Invariants

1. Every transaction must resolve an institution-specific message profile.
2. Missing message profile remains UNRESOLVED.
3. Required fields must be explicitly configured.
4. Missing required fields make structural validation INVALID.
5. Field type validation is configuration-driven.
6. Unknown field validation rules remain unresolved.
7. Structural validity does not prove real-world existence.
8. BIC format validity does not prove BIC existence.
9. Account format validity does not prove account existence.
10. Reference verification remains a separate authoritative boundary.
11. Business rules are not invented by the validation engine.
12. Unknown business state remains UNRESOLVED.
13. Structural invalidity blocks message construction.
14. Semantic invalidity blocks message construction.
15. UNRESOLVED authoritative state blocks message construction.
16. Canonical messages are bound to transaction ID.
17. Canonical messages are bound to transaction version.
18. Canonical messages are bound to message profile.
19. Canonical message integrity is cryptographically represented.
20. Message construction does not transmit.
21. Message construction does not imply delivery.
22. Message construction does not imply acknowledgement.
23. Message construction does not imply settlement.
24. External results must come from observed authoritative systems.
25. Unknown remains unknown.
