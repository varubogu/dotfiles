---
name: tauri-ipc-patterns
description: General implementation patterns for Tauri frontend-backend communication, including invoke usage, parameter naming, DTO conversion, and error handling consistency.
---

# Tauri IPC Patterns

## When to use

Use when adding or modifying Tauri commands and frontend invoke calls.

## Core conventions

- Frontend uses `camelCase` parameter names.
- Rust command handlers use `snake_case`.
- Keep IPC DTOs separate from domain models when complexity grows.

## Frontend side

- Import invoke from `@tauri-apps/api/core`.
- Handle command errors consistently and return typed results.

## Rust side

- Validate/convert IDs at command boundary.
- Keep command handlers thin; delegate business logic to services/facades.
- Return predictable shapes for success/failure to simplify frontend handling.