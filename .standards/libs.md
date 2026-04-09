# Reusable Libs Standards

Use a top-level `libs` folder for shared utility code that can be reused across resources.

## Folder Structure

- `libs/server/` for reusable server libraries
- `libs/client/` for reusable client libraries

## Version Checker

- Keep version checker in `libs/server/versionchecker.lua`.
- Load it early in `server_scripts` so version info is printed during startup.
- Version checker reads:
  - `fxmanifest.lua` to detect current resource version.
  - `version.json` to compare latest version and print changelog info.

## Per-Repository Version Files

Each resource should include:

- `version.json`: machine-readable latest version and changelog entries.
- `version.md`: human-readable release history with date and summary.

## version.json Format

```json
{
  "latest": "1.1.1",
  "updated_at": "2026-04-09",
  "changelog": {
    "1.1.1": [
      "Added new alarm dispatch option",
      "Improved ESX fallback detection"
    ],
    "1.1.0": [
      "Initial framework bridge"
    ]
  }
}
```

## version.md Format

```md
## 1.1.1 - 2026-04-09
- Added new alarm dispatch option
- Improved ESX fallback detection
```

## fxmanifest Loading Example

```lua
server_scripts {
  'libs/server/versionchecker.lua',
  'libs/server/**/*.lua',
  'server/**/*.lua'
}

client_scripts {
  'libs/client/**/*.lua',
  'client/**/*.lua'
}
```
