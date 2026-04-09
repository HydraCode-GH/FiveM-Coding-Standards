# Exports Standards

Use exports to expose stable function-like APIs between resources.

## Core Rules

- Prefer exports when you need a return value.
- Keep export names stable and descriptive.
- Define exports in code (recommended), not in `fxmanifest.lua`.
- Keep export registration in a dedicated file, for example `shared/exports.lua`.
- Exports can be registered on both server and client.
- Use exports from the same side context (server->server, client->client).

## Export Vs Event

Use an export when:
- You need a return value.
- It behaves like a function call.
- Logic is synchronous.

Use an event when:
- You signal that something happened.
- You need Client <-> Server communication.
- You want loose coupling.

Rule:
- Function-like flow -> export
- Action/event flow -> event

## Why Code-Based Exports

- Easier to read and maintain next to implementation.
- Works cleanly with wrappers and shared modules.
- Avoids spreading API definition across multiple places.

## Note About fxmanifest Exports

- Declaring exports in `fxmanifest.lua` is possible.
- Team standard: do not use manifest export declarations in new resources.
- Prefer `exports('Name', function(...) ... end)` in Lua files.

## Recommended Layout

- `shared/sh-exports.lua` for shared exports.
- `server/sv-exports.lua` for server-only exports.
- `client/cl-exports.lua` for client-only exports when needed.

## Server And Client Usage

- Server scripts can call exports from other server-side resources.
- Client scripts can call exports from other client-side resources.
- Keep side-specific APIs clearly named and documented.

## Provider Example

```lua
-- server/exports.lua
---@param source number
---@return number balance
exports('GetBalance', function(source)
    return 1000
end)
```

## Consumer Example

```lua
local balance = exports.bank:GetBalance(playerId)
if balance <= 0 then
    return
end
```

## Dot Vs Colon

- Use `:` when calling an exported function.
- Use `.` when reading a value/field from a returned table or object.

Examples:

```lua
-- Function export call
local balance = exports.bank:GetBalance(playerId)

-- Export returns a table/object
local profile = exports.identity:GetProfile(playerId)
local first_name = profile.first_name -- field access uses .
```

## Naming

- Use `PascalCase` for export names.
- Use verb-first action names where possible.

Examples:
- `GetBalance`
- `HasPermission`
- `GetOwnedVehicles`
