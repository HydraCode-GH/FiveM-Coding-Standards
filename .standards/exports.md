# Exports Standards

Use exports to expose stable function-like APIs between resources.

## Core Rules

- Prefer exports when you need a return value.
- Keep export names stable and descriptive.
- Define exports in code (recommended), not in `fxmanifest.lua`.
- Keep export registration in a dedicated file, for example `shared/exports.lua`.

## Why Code-Based Exports

- Easier to read and maintain next to implementation.
- Works cleanly with wrappers and shared modules.
- Avoids spreading API definition across multiple places.

## Note About fxmanifest Exports

- Declaring exports in `fxmanifest.lua` is possible.
- Team standard: do not use manifest export declarations in new resources.
- Prefer `exports('Name', function(...) ... end)` in Lua files.

## Recommended Layout

- `shared/exports.lua` for shared exports.
- `server/exports.lua` for server-only exports.
- `client/exports.lua` for client-only exports when needed.

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

## Naming

- Use `PascalCase` for export names.
- Use verb-first action names where possible.

Examples:
- `GetBalance`
- `HasPermission`
- `GetOwnedVehicles`
