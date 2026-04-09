# Deprecated And Legacy Patterns

Use modern, explicit patterns over outdated shortcuts.

## Player/Ped Handling

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

## Player Iteration

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

## Event Registration

```lua
-- Don't
RegisterNetEvent('event')
AddEventHandler('event', function()
end)

-- Do
RegisterNetEvent('event', function()
end)
```

## Resource Manifest

```lua
-- Don't
__resource.lua

-- Do
fxmanifest.lua
```

## Citizen Prefix

```lua
-- Don't
Citizen.Wait(1000)

-- Do
Wait(1000)
```

## Vector Usage

```lua
-- Don't
local dist = Vdist(x1, y1, z1, x2, y2, z2)

-- Do
local dist = #(vec1 - vec2)
```

## Entity Existence Checks

```lua
-- Don't
if entity ~= 0 then

-- Do
if DoesEntityExist(entity) then
```

## Networked Entity Access

```lua
-- Don't
local vehicle = NetToVeh(netId) -- unclear / legacy naming

-- Do
local vehicle = NetworkGetEntityFromNetworkId(netId)
```

## Table Length In Loops

```lua
-- Don't
for i = 1, table.getn(tbl) do

-- Do
for i = 1, #tbl do
```

## Global Pollution

```lua
-- Don't
myVar = 5

-- Do
local myVar = 5
```

## Event Misuse As API

```lua
-- Don't
TriggerEvent('inventory:getItemCount', item)

-- Do
exports.inventory:GetItemCount(source, item)
```

## Key Principle

- Prefer explicit, modern natives.
- Prefer clear intent over legacy shortcuts.
- Keep code understandable without FiveM-specific assumptions.
