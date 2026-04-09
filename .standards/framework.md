# Framework Standard

Use one shared framework bridge from `libs/shared/framework.lua`.

This keeps feature code framework-agnostic and avoids framework logic spread across many files.

## Goal

- Detect framework once.
- Expose one stable API for server/client code.
- Keep ESX/QBCore/Qbox differences isolated in libs.

## File Layout (libs)

```text
libs/
  shared/
    framework.lua   ← single file, all adapters inlined
```

## Loading

Add to `shared_scripts` in `fxmanifest.lua` **before** all other shared scripts:

```lua
shared_scripts {
  '@ox_lib/init.lua',
  'libs/shared/framework.lua',
  'shared/**/*.lua',
}
```

This exposes the global `Framework` table to every shared, server, and client script. No `require` needed.

## Usage

Use unified wrappers directly:

```lua
-- server
local identifier = Framework.Server.getIdentifier(source)
local is_police = Framework.Server.getJob(source) == 'police'

-- client
if Framework.Client.hasJob('police', 2) then
  Framework.Client.notify('Access granted', 'success')
end
```

Do not call ESX/QBCore/Qbox APIs directly inside feature code.

## API Surface

### Server wrappers

- `Framework.Server.getPlayer(source)`
- `Framework.Server.getIdentifier(source)`
- `Framework.Server.getJob(source)`
- `Framework.Server.getJobGrade(source)`
- `Framework.Server.getMoney(source, account)`
- `Framework.Server.addMoney(source, account, amount)`
- `Framework.Server.removeMoney(source, account, amount)`

### Client wrappers

- `Framework.Client.getPlayerData()`
- `Framework.Client.getJob()`
- `Framework.Client.getJobGrade()`
- `Framework.Client.hasJob(job_name, min_grade?)`
- `Framework.Client.notify(message, notify_type?)`

## Detection Rules

Framework detection order:

1. `es_extended` started -> `esx`
2. `qbx_core` started -> `qbox`
3. `qb-core` started -> `qbcore`
4. fallback -> `standalone`

Resolved type is stored in `Framework.Type`.

## Rules

- All framework-specific code lives inside `libs/shared/framework.lua` only — do not split across sub-files.
- Keep wrapper names stable even if internal framework code changes.
- Validate all client input server-side, regardless of framework.
- Log framework type once on startup in debug mode if needed.
- If a resource does not need job/money integration, keep wrappers minimal but present.

## Migration Notes

Old pattern: instantiated via `require`, returned a value.

New pattern: added to `shared_scripts` in `fxmanifest.lua`. The `Framework` global is available in every script that runs after `libs/shared/framework.lua` is loaded. Remove any `require` calls.
