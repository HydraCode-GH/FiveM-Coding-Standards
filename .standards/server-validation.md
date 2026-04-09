# Server Validation

## Core Principle

- Never trust client input.

Clients can:
- Modify parameters.
- Trigger events at any time.
- Bypass UI/flow.

## Always Validate

- Type checks
- Entity existence
- Distance checks
- Ownership
- State (cooldowns, job state)

## Example

```lua
RegisterNetEvent('vehicles:sell', function(vehicleNetId)
  local src = source

  if type(vehicleNetId) ~= 'number' then return end

  local ped = GetPlayerPed(src)
  if ped == 0 then return end

  local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
  if vehicle == 0 then return end

  if #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > 10.0 then return end

  local price = CalculatePrice(vehicle)
  AddMoney(src, price)
end)
```

## Never

- Trust client-calculated rewards.
- Run critical logic only client-side.
