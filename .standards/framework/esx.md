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
