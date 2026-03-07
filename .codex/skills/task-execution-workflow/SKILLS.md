---
name: task-execution-workflow
description: Reusable workflow for coding tasks: clarify scope, inspect current implementation, apply minimal changes, verify with focused tests first, and report outcomes with concrete file references.
---

# Task Execution Workflow

## When to use

Use this skill when the user asks for implementation, refactor, bug fix, or test update.

## Workflow

1. Clarify the requested behavior and constraints.
2. Inspect only relevant files first; avoid broad edits.
3. Implement minimal changes needed to satisfy the request.
4. Verify with targeted checks/tests before running wider suites.
5. Report what changed, why, and how it was verified.

## Guardrails

- Do not edit unrelated code without user approval.
- Prefer the existing architecture/style over introducing new patterns.
- If assumptions are required, state them explicitly.
- If verification could not be completed, state exactly what remains.