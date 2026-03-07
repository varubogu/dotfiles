---
name: frontend-testing-vitest
description: Generic guidance for frontend testing with Vitest and Testing Library, including single-file-first execution, stable mocking, and practical debugging flow.
---

# Frontend Testing (Vitest)

## When to use

Use for frontend unit/component/integration test implementation and debugging.

## Recommended flow

1. Run a single affected test file first.
2. Fix assertions/mocks/types with the smallest possible change.
3. Re-run the same file until stable.
4. Run broader test scope only after local stability.

## Patterns

- Prefer Arrange-Act-Assert structure.
- Keep tests independent (`beforeEach` reset/setup).
- Mock external dependencies at stable boundaries.
- For components, test user-observable behavior first.

## Common checks

- Type check and lint before concluding.
- If failures are flaky, remove timing assumptions and assert eventual state.