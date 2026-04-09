# Naming Conventions

Use predictable names so code is readable across all resources.

## General

- Use `snake_case` for local variables and file-level module state.
- Use `camelCase` for function names.
- Use `UPPER_SNAKE_CASE` for constants.
- Avoid short unclear names like `x`, `tmp`, or `data2` unless scope is very small.

## Events

- Event names should follow `resource:context:action`.
- Include side when it helps clarity (`server`, `client`, `shared`).

Examples:
- `inventory:server:addItem`
- `garage:client:openMenu`
- `jobs:shared:updateState`

## Exports

- Export names should be verb-first and descriptive.
- Prefer `PascalCase` for exported APIs to stand out from locals.

Examples:
- `GetBalance`
- `HasPermission`
- `GetOwnedVehicles`

## Booleans

- Prefix booleans with `is`, `has`, `can`, or `should`.

Examples:
- `is_player_dead`
- `has_license`
- `can_spawn_vehicle`
