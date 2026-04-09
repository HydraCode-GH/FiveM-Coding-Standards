# Communication Standards

Use events for signaling actions and state changes between contexts.

## Core Rules

- Use events for client-server communication.
- Use local events only for local resource flow.
- Never trust incoming event data from clients.
- Keep event names clear and scoped (`resource:context:action`).

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

## Guidance

- Do not use network events for local-only logic.
- Validate types, ownership, and state on the server.
- For function-like return flows, use exports instead of events.