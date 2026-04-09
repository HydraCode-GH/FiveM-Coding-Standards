# QBCore Standards

## Detection

- Prefer `exports['qb-core']:GetCoreObject()`.

## Integration Rules

- Store object at `Framework.QB`.
- Keep permission, player lookup, and notify logic behind shared wrappers.
- Avoid direct QBCore usage inside feature modules.

## Typical Access

- Player object: `Framework.QB.Functions.GetPlayer(source)`
- Permission: `Framework.QB.Functions.HasPermission(source, group)`
- Notify fallback: `QBCore:Notify`

## Notification Guidance

- Call editable or bridge notification helper first.
- Use framework-specific notify only as fallback.
