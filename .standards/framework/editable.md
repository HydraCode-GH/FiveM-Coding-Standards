# Editable Layer Standards

Keep custom integration points in an editable layer so updates do not require core rewrites.

## Required Pattern

- Use a global `Editable = Editable or {}`.
- Split by side:
  - `Editable.Server`
  - `Editable.Client`
- Keep defaults in shared/server/client editable files.

## Recommended File Layout

- `shared/editable.lua` for shared editable contracts.
- `server/editable.lua` for server-only editable behavior.
- `client/editable.lua` for client-only editable behavior.

## What Should Be Editable

- Notification adapters
- Dispatch integrations
- Ownership lookups and framework-specific external integrations
- UI provider swaps

## Rule

Core logic must call `Editable.*` hooks instead of hardcoding one notification or dispatch system.
