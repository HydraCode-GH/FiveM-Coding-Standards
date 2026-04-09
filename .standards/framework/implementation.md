# Framework Implementation Guide

This is the recommended way to implement framework support in a resource.

## Goal

- Keep feature code framework-agnostic.
- Detect framework once.
- Route all framework-dependent behavior through shared wrappers.

## Suggested File Layout

- `shared/framework.lua`: Framework detection and unified bridge functions.
- `shared/editable.lua`: Shared editable contracts.
- `server/editable.lua`: Server-side editable integrations.
- `client/editable.lua`: Client-side editable integrations.

## Step 1: Define Shared Bridge

Create one shared namespace:

```lua
Framework = {}
Framework.Type = nil
Framework.ScriptName = GetCurrentResourceName()
```

Add side wrappers:

```lua
Framework.Server = Framework.Server or {}
Framework.Client = Framework.Client or {}
```

## Step 2: Detect Framework

Detection order:
1. Config override (`standalone`, `esx`, `qbcore`, `qbox`)
2. Started resources + safe export fetch via `pcall`
3. Fallback to `standalone`

Store resolved type in `Framework.Type`.

## Step 3: Implement Unified Wrappers

Expose wrappers that feature code always uses:

- `Framework.Server.Notification(...)`
- `Framework.Server.isAdmin(source)`
- `Framework.Client.Notification(...)`

Feature modules should never call ESX/QBCore/Qbox APIs directly.

## Step 4: Keep Overrides Editable

Use:

```lua
Editable = Editable or {}
Editable.Server = Editable.Server or {}
Editable.Client = Editable.Client or {}
```

Put integration-specific behavior here:

- Notify systems
- Dispatch systems
- Owner lookups / DB-specific logic

## Step 5: Framework-Specific Files

Keep framework-specific behavior isolated:

- `framework/esx.md` rules for ESX object usage.
- `framework/qbcore.md` rules for QBCore object usage.
- `framework/qbox.md` rules for Qbox usage.

## Implementation Rules

- Validate all client input server-side, regardless of framework.
- Keep wrapper method names stable across frameworks.
- Prefer shared helpers for permissions/jobs/notify.
- Log detected framework once in debug mode.
