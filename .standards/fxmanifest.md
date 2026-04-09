# fxmanifest Standards

Every resource must use `fxmanifest.lua` and keep it minimal, explicit, and organized.

## Rules

- Use `fxmanifest.lua` (never `__resource.lua`).
- Keep metadata at the top (`fx_version`, `game`).
- Do not add `lua54 'yes'`; Lua 5.4 is default since October 2025.
- Add `repository 'https://github.com/<owner>/<repo>'` so tooling can reference source and updates.
- Group script lists by side (`shared_scripts`, `client_scripts`, `server_scripts`).
- Use recursive globs for folders: `**/*.lua`.
- Keep dependency declarations explicit and limited to actual resource dependencies only.
- Load shared framework bridge files through `shared_scripts`.
- Prefer code-defined exports in `*exports.lua` files; do not declare exports in `fxmanifest.lua` for new resources.
- Include locale files in `files` when using `ox_lib` locale.
- Load reusable libs from `libs/server` and `libs/client` when present.
- Load `libs/server/versionchecker.lua` early in `server_scripts`.
- Use `provide` only when you intentionally mimic/replace another resource.
- Control load order by listing required bootstrap files before glob entries.

## Example

```lua
fx_version 'cerulean'
game 'gta5'

name 'my-resource'
author 'HydraCode'
description 'Short resource description'
version '1.0.0'
repository 'https://github.com/HydraCode-GH/my-resource'

ui_page 'html/index.html'

files {
  'html/**/*'
  'locales/**/*.json'
}

shared_scripts {
  '@ox_lib/init.lua',
  'libs/shared/debug.lua',       -- exposes Debug global
  'libs/shared/framework.lua',  -- exposes Framework global
  'shared/editable.lua',
  'shared/**/*.lua'
}

client_scripts {
  'client/editable.lua',
  'client/**/*.lua'
}

server_scripts {
  'libs/server/versionchecker.lua',
  'libs/server/sql.lua',         -- exposes SQL global
  'libs/server/**/*.lua',
  'server/editable.lua',
  'server/**/*.lua'
}

dependencies {
  'ox_lib'
}

-- Optional: use only when replacing a known resource name.
provide 'my-resource-compat'
```

## Guidance

- Avoid duplicate entries across script blocks.
- Keep wildcard usage predictable.
- Add new files in side-correct blocks only.
- Keep shared framework detection loaded before modules that use `Framework`.
- If load order matters, use filename ordering (for example `00-init.lua`, `10-core.lua`) and keep explicit bootstrap entries above globs.
- Only list real resource names in `dependencies` (for example `ox_lib`); do not include files, exports, convars, or metadata values.
