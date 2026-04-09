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
    framework.lua
    framework/
      server/
        esx.lua
        qbcore.lua
        qbox.lua
        standalone.lua
      client/
        esx.lua
        qbcore.lua
        qbox.lua
        standalone.lua
```

## Usage

Load at top of script:

```lua
local Framework = require 'libs.shared.framework'
```

Then use unified wrappers only:

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

- Keep framework-specific code in `libs/shared/framework/server/*.lua` and `libs/shared/framework/client/*.lua` only.
- Keep wrapper names stable even if internal framework code changes.
- Validate all client input server-side, regardless of framework.
- Log framework type once on startup in debug mode if needed.
- If a resource does not need job/money integration, keep wrappers minimal but present.

## Migration Notes

Legacy path pattern:

- shared-root framework module path

New path:

- `libs/shared/framework.lua`

Update all imports:

```lua
-- old
-- local Framework = require '<legacy-shared-root-path>'

-- new
local Framework = require 'libs.shared.framework'
```
