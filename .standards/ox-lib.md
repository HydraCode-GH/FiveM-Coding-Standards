# ox_lib Usage

Use `ox_lib` as the default utility and UI helper library when suitable.

## Rules

- Initialize `ox_lib` in `shared_scripts` via `@ox_lib/init.lua`.
- Prefer `lib` helpers over custom one-off helpers when `ox_lib` already provides the feature.
- Keep wrappers thin if you need project-specific abstractions.

## Common Usage Areas

- Context menus and input dialogs
- Notifications
- Callbacks
- Zone and point helpers
- Locale helpers

## Examples

```lua
-- Notification
lib.notify({
  title = 'Garage',
  description = 'Vehicle stored successfully.',
  type = 'success'
})
```

```lua
-- Callback
local has_access = lib.callback.await('garage:server:hasAccess', false, vehicleId)
if not has_access then
  return
end
```

## Guidance

- Keep callback names scoped (`resource:side:action`).
- Validate callback data server-side just like events.
- Do not mix multiple UI libraries for the same feature path unless required.
