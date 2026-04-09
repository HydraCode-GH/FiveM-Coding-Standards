# Events

## Rules

- Define handlers inline when registering with `RegisterNetEvent`.
- Follow a consistent event naming scheme: `resource:context:action`.
- Do not expose local-only events as network events unless necessary.
- Use events for actions/state changes, not for function-like return flows.

## Example

```lua
RegisterNetEvent('inventory:server:addItem', function(item, amount)
  -- handle logic
end)
```
