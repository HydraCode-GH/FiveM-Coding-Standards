# fxmanifest Standards

Every resource must use `fxmanifest.lua` and keep it minimal, explicit, and organized.

## Rules

- Use `fxmanifest.lua` (never `__resource.lua`).
- Keep metadata at the top (`fx_version`, `game`, `lua54`).
- Group script lists by side (`shared_scripts`, `client_scripts`, `server_scripts`).
- Keep dependency declarations explicit.

## Example

```lua
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'my-resource'
author 'Hydra Code'
description 'Short resource description'
version '1.0.0'

shared_scripts {
  '@ox_lib/init.lua',
  'shared/*.lua'
}

client_scripts {
  'client/*.lua'
}

server_scripts {
  'server/*.lua'
}

dependencies {
  'ox_lib'
}
```

## Guidance

- Avoid duplicate entries across script blocks.
- Keep wildcard usage predictable.
- Add new files in side-correct blocks only.
