# VERITAS Canonical Contract Registry

Version: 1.0.0

## Core invariants

1. Authority does not equal execution permission.
2. Capability does not equal authorization.
3. Authorization does not equal consent.
4. Consent is bound to a specific transaction version and operation.
5. Notification is not authorization.
6. Intelligence is assistive and does not independently authorize consequential execution.
7. Transaction state is canonical and versioned.
8. Evidence records preserve provenance and integrity relationships.
9. Reconciliation compares expected state against observed state.
10. Unknown state must remain unknown; VERITAS must not invent successful outcomes.
11. Institution-specific authority and policy are configuration-defined.
12. Consequential execution remains locked until all configured preconditions are satisfied.
