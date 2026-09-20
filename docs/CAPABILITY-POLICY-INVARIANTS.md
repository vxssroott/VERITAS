# VERITAS Capability & Policy Invariants

## Capability

A capability is an explicit grant describing what an authority
profile may perform within a configured scope.

Capabilities are:

- institution-specific
- configuration-defined
- scoped
- revocable
- auditable
- environment-aware
- operation-aware
- resource-aware

## Policy

Policy determines whether a requested operation is permitted
under the institution's configured rules and current context.

Policy must never be invented by the intelligence layer.

## No Implicit Authority

VERITAS must not infer:

- transaction limits
- approval requirements
- segregation-of-duties rules
- role powers
- institutional restrictions

unless the institution has configured or exposed them through
an authoritative source.

## Execution Eligibility

Eligibility means:

"All configured prerequisites for requesting execution have
been satisfied."

Eligibility does NOT mean:

"Execute immediately."

## Consent

Even an ALLOW policy decision does not constitute operator consent.

The execution-consent fabric remains a separate boundary.

## Unknown State

If capability resolution or policy evaluation cannot establish
a trustworthy answer, the state remains unresolved.

VERITAS must not convert UNKNOWN into ALLOW.
