# File Naming

Use consistent file names so project structure is easy to scan.

## Rules

- Use lowercase only.
- Use hyphen-separated names (`kebab-case`).
- Keep names short and topic-focused.
- Do not use spaces.
- Do not use ambiguous files like `utils2.lua` or `new.lua`.

## Recommended Patterns

- `cl-*.lua` for client-only modules.
- `sv-*.lua` for server-only modules.
- `sh-*.lua` for shared modules.
- `config.lua` for static config.

## Framework Layout

- Keep framework bridge and debug lib under `libs/shared/`.
- Editable configuration goes in `server/` and `client/` directly.
- Recommended names:
	- `libs/shared/framework.lua`
	- `libs/shared/debug.lua`
	- `server/editable.lua`
	- `client/editable.lua`
- Keep framework rules in one file: `.standards/framework.md`.

## Examples

- `client-vehicles.lua`
- `server-paychecks.lua`
- `libs/shared/framework.lua`
- `server/editable.lua`
