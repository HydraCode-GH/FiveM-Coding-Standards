# FiveM Coding Standards

## 2.1 - Events
* When registering an event, define the handler inline in `RegisterNetEvent`
* Event names must follow a consistent pattern: `resource:context:action`

```lua
RegisterNetEvent('inventory:server:addItem', function(item, amount)
  -- handle logic
end)
````

* Do not expose events as network events unless necessary
* Use events for **state changes or actions**, not as function replacements

---

## 2.2 - Citizen Functions

* Avoid using the `Citizen.` prefix where aliases exist

```lua
-- Don't
Citizen.CreateThread(function()
  Citizen.Wait(1000)
end)

-- Do
CreateThread(function()
  Wait(1000)
end)
```

* Allowed without prefix:

  * `CreateThread`
  * `Wait`
  * `SetTimeout`
  * `RconPrint`
 

## Citizen Function Aliases (Lua Runtime)

| Original | Alias |
|----------------------------|------------------|
| Citizen.CreateThread       | CreateThread     |
| Citizen.Wait               | Wait             |
| Citizen.SetTimeout         | SetTimeout       |
| Citizen.Trace              | separate debugPrint function |

---

## 2.3 - Exports

* Use exports to expose **clear APIs between resources**
* Prefer exports when expecting a **return value**
* Keep naming stable and descriptive

```lua
-- provider
exports('GetBalance', function(source)
  return 1000
end)

-- consumer
local balance = exports.bank:GetBalance(playerId)
```

---

## 2.4 - When to use an event vs export

**Use an export when:**

* You need a **return value**
* It behaves like a **function call**
* Logic is **synchronous**

**Use an event when:**

* You signal that **something happened**
* You need **Client ↔ Server communication**
* You want **loose coupling**

**Rule:**

> Function-like → export
> Action/event → event

---

## 2.5 - Client->Server / Server->Client Communication

**Client → Server**

```lua
TriggerServerEvent('inventory:useItem', item)

RegisterNetEvent('inventory:useItem', function(item)
  local src = source
  -- validate + handle
end)
```

**Server → Client**

```lua
TriggerClientEvent('inventory:update', playerId, data)

RegisterNetEvent('inventory:update', function(data)
  -- update UI
end)
```

**Local**

```lua
TriggerEvent('inventory:refresh')

AddEventHandler('inventory:refresh', function()
  -- local logic
end)
```

* Do not use network events for local-only logic
* Always assume events can be triggered manually by clients

---

## 2.6 - Server Validation (Protecting against cheaters)

* Never trust client input
* Clients can:

  * modify parameters
  * trigger events anytime
  * bypass UI/logic

**Always validate:**

* Types
* Entity existence
* Distance
* Ownership
* State (cooldowns, job state)

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

**Never:**

* Trust client-calculated rewards
* Execute critical logic only client-side

---

## 2.X - Deprecated / Legacy Patterns

* Avoid outdated or unclear patterns

### Player / Ped Handling

```lua
-- Don't
GetPlayerPed(-1)

-- Do
PlayerPedId()
```

```lua
-- Don't
GetPlayerPed(PlayerId())

-- Do
PlayerPedId()
```

---

### Player Iteration

```lua
-- Don't
for i = 0, 255 do
  if NetworkIsPlayerActive(i) then
    -- ...
  end
end

-- Do
for _, player in ipairs(GetActivePlayers()) do
  -- ...
end
```

---

### Event Registration

```lua
-- Don't
RegisterNetEvent('event')
AddEventHandler('event', function()
end)

-- Do
RegisterNetEvent('event', function()
end)
```

---

### Resource Manifest

```lua
-- Don't
__resource.lua

-- Do
fxmanifest.lua
```

---

### Citizen Prefix

```lua
-- Don't
Citizen.Wait(1000)

-- Do
Wait(1000)
```

---

### Vector Usage

```lua
-- Don't
local dist = Vdist(x1, y1, z1, x2, y2, z2)

-- Do
local dist = #(vec1 - vec2)
```

---

### Entity Existence Checks

```lua
-- Don't
if entity ~= 0 then

-- Do
if DoesEntityExist(entity) then
```

---

### Networked Entity Access

```lua
-- Don't
local vehicle = NetToVeh(netId) -- unclear / legacy naming

-- Do
local vehicle = NetworkGetEntityFromNetworkId(netId)
```

---

### Table Length in Loops

```lua
-- Don't
for i = 1, table.getn(tbl) do

-- Do
for i = 1, #tbl do
```

---

### Global Pollution

```lua
-- Don't
myVar = 5

-- Do
local myVar = 5
```

---

### Event Misuse as API

```lua
-- Don't
TriggerEvent('inventory:getItemCount', item)

-- Do
exports.inventory:GetItemCount(source, item)
```

---

### Key Principle

* Prefer **explicit, modern natives**
* Prefer **clear intent over legacy shortcuts**
* Code should be understandable **without FiveM-specific assumptions**
