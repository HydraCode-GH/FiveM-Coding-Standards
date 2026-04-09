# Module Loading

FiveM / ox_lib provides three ways to load external Lua code at runtime. Use the right one for the right job.

---

## Quick Reference

| Method | Cached | Cross-resource | JSON | Use when |
|--------|--------|----------------|------|----------|
| `require` | Yes | Yes (`@resource`) | No | Shared modules loaded multiple times |
| `lib.load` | No | No | No | One-off file loads, hot-reload patterns |
| `lib.loadJson` | No | No | Yes | Config / data files in JSON format |

---

## `require`

> Built into FiveM. Always available — no ox_lib needed.

Loads a Lua file and **caches** the return value. Subsequent calls to `require` with the same path return the cached value without re-executing the file.

### Syntax

```lua
local module = require 'path.to.file'
```

- Path is relative to the current resource root.
- Use `.` to separate directories (maps to `/`).
- The `.lua` extension is omitted.

### Hydra Code Path Rule

Always use the full module path from resource root.

```lua
-- bad (ambiguous in this standard)
local Framework = require 'framework'

-- good
local Framework = require 'libs.shared.framework'

-- good
local Debug = require 'libs.shared.debug'
```

For shared libraries, start paths with `libs.shared.`.
For server libraries, start paths with `libs.server.`.
For client libraries, start paths with `libs.client.`.

### Cross-resource require

```lua
local module = require '@other-resource.path.to.file'
```

Prefix the resource name with `@`.

### fxmanifest requirement

For **client** scripts, every file loaded via `require` must be declared in the `files {}` block:

```lua
-- fxmanifest.lua
files {
  'libs/shared/debug.lua',
  'data/config.lua',
}
```

Server scripts do not need this.

### Example — define a module

```lua
-- myresource/data/events.lua
return {
  disconnect = 'onPlayerDropped',
  spawn      = 'playerSpawned',
}
```

```lua
-- myresource/server.lua
local events = require 'data.events'
local Framework = require 'libs.shared.framework'
print(events.disconnect) -- onPlayerDropped
```

### Example — cross-resource

```lua
-- myresource/server.lua
local mylib = require '@mylib.import'
print(mylib.events.disconnect)
```

### When to use `require`

- Shared modules used by multiple files (debug, SQL wrapper, framework bridge).
- Code that should only execute once and be cached (heavy initial setup).
- Any reusable lib under `libs/`.

---

## `lib.load`

> Requires `ox_lib`.

Loads and executes a Lua file **without caching**. Every call re-executes the file.

### Syntax

```lua
local result = lib.load('path.to.file')
```

Same path rules as `require`.

### Optional environment

```lua
local result = lib.load('data.events', { myGlobal = true })
```

Pass a table as the second argument to use as the global environment (`_ENV`) for the loaded chunk.

### Example

```lua
-- myresource/import.lua
local events = lib.load('data.events')
print('Loaded events module')
```

### When to use `lib.load`

- Files that change at runtime and need fresh data each time.
- Development hot-reload workflows.
- Rare cases where caching from `require` is undesirable.

> **Default to `require`.** Only reach for `lib.load` when caching is explicitly a problem.

---

## `lib.loadJson`

> Requires `ox_lib`.

Loads a JSON file and returns it as a decoded Lua table.

### Syntax

```lua
local data = lib.loadJson('path.to.file')
```

The path omits the `.json` extension.

### Example

```lua
-- myresource/data/events.json
{
  "disconnect": "onPlayerDropped"
}
```

```lua
-- myresource/import.lua
local events = lib.loadJson('data.events')
print(events.disconnect) -- onPlayerDropped
```

### When to use `lib.loadJson`

- Config or data authoring in JSON (designers, external tools).
- Per-locale data files (`locales/en.json`).
- Any structured data that doesn't need Lua logic.

> Prefer Lua tables over JSON for config unless the file is edited outside of Lua tooling.

---

## Decision Guide

```
Does the file need to run once and be shared across multiple scripts?
  └─ Yes → require

Does the file need to re-execute on every call?
  └─ Yes → lib.load (rare)

Is the file JSON and not Lua?
  └─ Yes → lib.loadJson
  └─ No  → require / lib.load depending on caching need
```

---

## Module File Layout

```
resources/
  mylib/
    import.lua          ← public surface (require '@mylib.import')
    data/
      events.lua
      config.lua
  myresource/
    server.lua
    libs/
      shared/
        debug.lua       ← require 'libs.shared.debug'
      server/
        sql.lua         ← require 'libs.server.sql'
```

---

## Rules

- **Modules must return a value.** A `require`d file with no `return` will cache `true`. Always end module files with `return ModuleName`.
- **Do not side-effect at module load time.** No `CreateThread`, no network calls, no `RegisterNetEvent` inside a module file. Modules define data and functions — the calling script controls execution.
- **Client modules must be in `files {}`.** Forgetting this causes a silent nil require on the client.
- **Never `require` inside a loop or hot path.** The first call incurs file I/O; subsequent calls are cached but the lookup still has overhead. Assign the result to a local at the top of the file.
- **Use full module paths for libs.** Do not use legacy shorthand like `shared.framework`; use `libs.shared.framework`.

```lua
-- bad
CreateThread(function()
    while true do
        local SQL = require 'libs.server.sql'  -- don't do this
        ...
    end
end)

-- good
local SQL = require 'libs.server.sql'

CreateThread(function()
    while true do
        ...
    end
end)
```
