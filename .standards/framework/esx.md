# ESX Standards

## Detection

- Prefer `exports['es_extended']:getSharedObject()`.
- Optional fallback: `esx:getSharedObject` event when needed for compatibility.

## Integration Rules

- Store object at `Framework.ESX`.
- Use bridge wrappers for job/group/admin checks.
- Avoid calling ESX directly from feature modules.

## Typical Access

- Player object: `Framework.ESX.GetPlayerFromId(source)`
- Group: `xPlayer.getGroup()`
- Job: `xPlayer.getJob().name`

## Notification Guidance

- Use bridge/editable hook first.
- ESX fallback can use `esx:showNotification` if no custom notifier is configured.

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
