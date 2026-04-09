# Exports And Communication

## Exports

- Use exports to expose clear APIs between resources.
- Prefer exports when a return value is expected.
- Keep export names stable and descriptive.

```lua
-- provider
exports('GetBalance', function(source)
  return 1000
end)

-- consumer
local balance = exports.bank:GetBalance(playerId)
```

## Event Vs Export

Use an export when:
- You need a return value.
- It behaves like a function call.
- Logic is synchronous.

Use an event when:
- You signal that something happened.
- You need Client ↔ Server communication.
- You want loose coupling.

Rule:
- Function-like flow -> export
- Action/event flow -> event

## Communication Patterns

### Client -> Server

```lua
TriggerServerEvent('inventory:useItem', item)

RegisterNetEvent('inventory:useItem', function(item)
  local src = source
  -- validate + handle
end)
```

### Server -> Client

```lua
TriggerClientEvent('inventory:update', playerId, data)

RegisterNetEvent('inventory:update', function(data)
  -- update UI
end)
```

### Local

```lua
TriggerEvent('inventory:refresh')

AddEventHandler('inventory:refresh', function()
  -- local logic
end)
```

- Do not use network events for local-only logic.
- Always assume events can be triggered manually by clients.
