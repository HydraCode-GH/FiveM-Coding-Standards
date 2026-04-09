# Events

An event is a fire-and-handle signal that says something happened.

Events are not function calls. They are one-way messages used to trigger behavior.

## When To Use Events

Use events when:

- You are broadcasting an action or state change.
- You need client <-> server communication.
- You want decoupled modules (producer does not need to know consumer internals).
- You do not need a direct return value.

Examples:

- Player used an item.
- Vehicle was stored.
- Job changed.
- UI should refresh after data change.

## When Not To Use Events

Do not use events when:

- You need a return value right now.
- You are doing function-like request/response logic.
- The call is local and tightly coupled.

In these cases, use exports.

Rule:

- Function-like API with return value -> export
- Action/state signal -> event

## Internal Events

Use events internally inside your own resource to separate features.

This keeps modules independent and easier to test:

- One module triggers event.
- Another module handles event.
- Both can change independently as long as event name/payload stays stable.

Internal events should stay local by default.
Only use network events if the event must cross client/server.

## Naming

Follow: `resource:context:action`

Examples:

- `garage:server:vehicleStored`
- `garage:client:openMenu`
- `inventory:internal:itemAdded`

Use `internal` context for local, in-resource events.

## Rules

- Define handlers inline when registering with `RegisterNetEvent`.
- Use `RegisterNetEvent` for networked handlers.
- Use `AddEventHandler` for local/internal handlers.
- Do not expose local-only events as network events unless required.
- Keep payloads minimal and explicit.
- Validate client-triggered payloads on server.

## Examples

### Server Network Event (client -> server)

```lua
RegisterNetEvent('inventory:server:addItem', function(item_name, amount)
    local source = source
    if type(item_name) ~= 'string' or type(amount) ~= 'number' then return end

    -- handle logic
    TriggerEvent('inventory:internal:itemAdded', source, item_name, amount)
end)
```

### Internal Event (same resource, server)

```lua
AddEventHandler('inventory:internal:itemAdded', function(player_source, item_name, amount)
    -- logging, achievements, analytics, etc.
end)
```

### Client Network Event (server -> client)

```lua
RegisterNetEvent('inventory:client:itemAdded', function(item_name, amount)
    -- update UI or notify player
end)
```

### Use Export Instead (return value required)

```lua
-- Use export for function-like flow
local has_space = exports.inventory:HasSpace(player_source, item_name, amount)
if not has_space then
    return
end
```
