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

## Shared Detection Snippet

```lua
local function getEsxSharedObject()
	if not isResourceStarted('es_extended') then
		return nil
	end

	local ok, result = pcall(function()
		return exports['es_extended']:getSharedObject()
	end)

	if ok and result then
		return result
	end

	local sharedObject = nil
	TriggerEvent('esx:getSharedObject', function(obj)
		sharedObject = obj
	end)

	return sharedObject
end

---@return table|nil
local function getQbCoreObject()
	if not isResourceStarted('qb-core') then
		return nil
	end

	local ok, result = pcall(function()
		return exports['qb-core']:GetCoreObject()
	end)

	if ok and result then
		return result
	end

	return nil
end
```
