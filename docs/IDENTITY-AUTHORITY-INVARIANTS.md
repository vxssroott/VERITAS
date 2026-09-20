# VERITAS Identity & Authority Invariants

## Identity

VERITAS must establish the identity of the current operator from
an authoritative identity mechanism.

A locally supplied username is not sufficient proof of identity.

## Role

An operator may declare an intended role.

That declaration is informational.

It is never itself an authority source.

## Authority

Authority must be resolved from an authoritative institutional source.

Examples:

- Active Directory
- institutional identity provider
- role registry
- signed authority record
- institution-controlled API
- certificate attributes

## Capability

Authority is not equivalent to capability.

A resolved authority profile may contain multiple capabilities,
scopes and constraints.

## Execution

Identity verification does not authorize execution.

Authority verification does not authorize execution.

Capability resolution does not authorize execution.

Policy evaluation does not by itself constitute operator consent.

Execution remains a separate controlled boundary.

## Anti-Spoofing

VERITAS must never trust:

- a locally edited role
- a command-line role parameter
- a configuration file claiming authority
- a client-side UI selection
- an unverified external assertion

as the sole authority source.

## Failure Behavior

Unknown identity:
DENY RESOLUTION

Unknown authority:
DENY AUTHORITY RESOLUTION

Conflicting authority:
DENY AUTHORITY RESOLUTION

Expired authority:
DENY AUTHORITY RESOLUTION

Revoked authority:
DENY AUTHORITY RESOLUTION

Missing institutional source:
UNRESOLVED

No component may silently convert an unresolved state into an
authorized state.
