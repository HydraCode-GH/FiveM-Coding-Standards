# Debug Library

`libs/shared/debug.lua` — Shared structured logging module for Hydra Code resources.

---

## Overview

The debug library provides five log levels with consistent formatting:

| Level | Visible | Use for |
|-------|---------|---------|
| `info` | Always | Normal startup messages, state changes |
| `warn` | Always | Missing optional config, degraded function |
| `error` | Always | Failures that affect features |
| `debug` | Opt-in | Verbose internals, raw data dumps |
| `sensitive` | Separate opt-in | IDs, payloads, or private diagnostics (dev-only) |

All output follows the format:

```
[Hydra Code][resource-name][LEVEL] message
```

---

## Loading

Add to `shared_scripts` in `fxmanifest.lua` **before** all other shared scripts:

```lua
shared_scripts {
  '@ox_lib/init.lua',
  'libs/shared/debug.lua',
  'shared/**/*.lua',
}
```

This exposes the global `Debug` table to every shared, server, and client script in the resource. No `require` needed.

---

## Enabling Debug Mode

`Debug.debug` and `Debug.sensitive` can be toggled independently.

Toggle resolution priority:

1. `Config.Debug` values (if defined)
2. convars
3. fallback defaults

### Standard Debug Toggle

Accepted config keys:

- `Config.Debug = true/false`
- `Config.Debug.enabled = true/false`
- `Config.Debug.default = true/false`
- `Config.Debug.debug = true/false`

Convar fallback:

```cfg
# server.cfg
set debug_my-resource 1
```

The convar name is `debug_` + the resource folder name.

### Sensitive Debug Toggle

Accepted config keys:

- `Config.Debug.sensitive = true/false`
- `Config.Debug.sensitive_information = true/false`

Convar fallback:

```cfg
# server.cfg
set debug_sensitive_my-resource 1
```

If the sensitive convar is missing, it falls back to `debug_my-resource`.

This is read at startup. Changing it at runtime requires a resource restart.
If config is loaded later, call `Debug.refresh()`.

---

## Functions

### `Debug.info(message, ...)`

Always-visible informational log. Use for startup confirmations and notable state changes.

```lua
Debug.info('Player %s joined the garage', player_name)
```

---

### `Debug.warn(message, ...)`

Always-visible warning. Use when something unexpected happened but the feature still works.

```lua
Debug.warn('Config key "spawn_point" missing, using default')
```

---

### `Debug.error(message, ...)`

Always-visible error. Use when a feature fails or data cannot be loaded.

```lua
Debug.error('Could not load vehicle for player %s: %s', source, err)
```

---

### `Debug.debug(message, ...)`

Debug-only output. Use for tracing, raw values, and internals.

```lua
Debug.debug('oxmysql response: %s', json.encode(row))
```

Nothing is printed unless `debug_<resourcename>` convar is set to `1`.

---

### `Debug.dump(label, value)`

Debug-only table/value inspector. Pretty-prints tables using `json.encode`.

```lua
Debug.dump('vehicle data', vehicle_table)
```

---

### `Debug.sensitive(message, ...)`

Sensitive debug-only output. Use when data is useful for diagnosis but should stay behind a stricter toggle.

```lua
Debug.sensitive('Identifier: %s | Job: %s', identifier, job_name)
```

Nothing is printed unless sensitive debug is enabled by `Config.Debug.sensitive` or `debug_sensitive_<resourcename>`.

---

### `Debug.refresh()`

Recomputes `Debug.enabled` and `Debug.sensitiveEnabled` from Config/convars.

Call after your `Config` table is populated if it loads after `libs/shared/debug.lua`:

```lua
-- in shared/editable.lua or shared/config.lua
Debug.refresh()
```

---

## Usage Pattern

At the top of every server or client file that needs logging:

```lua
-- Always prints
Debug.info('Resource started')

-- Only prints when debug convar enabled
Debug.debug('Framework detected: %s', Framework.Type)

-- Only prints when sensitive toggle enabled
Debug.sensitive('Player identifier: %s', identifier)
```

---

## Rules

- **Never use `print()` directly in feature code.** Use `Debug.info` at minimum.
- **`Debug.debug` is for development.** Gate all verbose internal output behind it.
- **Never log passwords, tokens, API keys, or secrets** even in `Debug.sensitive`.
- **`Debug.sensitive` is for controlled diagnostics only** (identifiers/payload snapshots) in development or incident response.
- **One message per event.** Do not chain multiple prints to construct a single logical message.
- **Use format args instead of concatenation:**

```lua
-- bad
Debug.info('Player ' .. name .. ' loaded')

-- good
Debug.info('Player %s loaded', name)
```
