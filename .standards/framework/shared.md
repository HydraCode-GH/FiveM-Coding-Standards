# Shared Framework Bridge

Create one shared bridge used by both client and server.

## Why

A shared bridge avoids duplicated framework checks and keeps modules portable.

## Required Pattern

- Keep a single `Framework` table in shared scope.
- Detect framework once (or lazily once) and store `Framework.Type`.
- Support at least: `esx`, `qbcore`, `qbox`, `standalone`.
- Add framework wrappers under `Framework.Server` and `Framework.Client`.

## Shared File Placement

- Prefer `shared/framework.lua` for detection and common wrappers.
- Load it through `shared_scripts` in `fxmanifest.lua`.

## Detection Guidance

- Respect explicit config override first.
- Then auto-detect by resource state and safe exports.
- Fallback to `standalone` when nothing is available.

## API Surface Guidance

Expose unified helpers such as:
- `Framework.Server.Notification(...)`
- `Framework.Server.isAdmin(...)`
- `Framework.Client.Notification(...)`

Feature code should call these wrappers, not raw ESX/QB/Qbox APIs.
