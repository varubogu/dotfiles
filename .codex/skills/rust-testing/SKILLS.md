---
name: rust-testing
description: Reusable Rust testing workflow for unit/integration tests, focused execution, mock strategy, and safe parallelism settings for local development.
---

# Rust Testing

## When to use

Use for Rust test creation, failure triage, and regression prevention.

## Execution strategy

1. Run targeted tests first (specific crate/file/test name).
2. Fix root cause before widening scope.
3. Run full relevant suite after targeted tests pass.

## Test design

- Unit tests: isolate business logic and error branches.
- Integration tests: verify cross-layer behavior with realistic setup.
- Keep assertions explicit (success path + failure path).

## Reliability notes

- Use deterministic test data and avoid shared mutable state.
- Prefer controlled worker counts when local machine load is a concern (e.g. `cargo test -j 4`).