# File Naming

Use consistent file names so project structure is easy to scan.

## Rules

- Use lowercase only.
- Use hyphen-separated names (`kebab-case`).
- Keep names short and topic-focused.
- Do not use spaces.
- Do not use ambiguous files like `utils2.lua` or `new.lua`.

## Recommended Patterns

- `client-*.lua` for client-only modules.
- `server-*.lua` for server-only modules.
- `shared-*.lua` for shared modules.
- `config.lua` for static config.
- `constants.lua` for immutable constant values.

## Framework Layout

- Keep framework bridge files under `shared/`.
- Recommended names:
	- `shared/framework.lua`
	- `shared/editable.lua`
	- `server/editable.lua`
	- `client/editable.lua`
- Keep framework-specific notes/docs separated under `.standards/framework/`.

## Examples

- `client-vehicles.lua`
- `server-paychecks.lua`
- `shared-permissions.lua`
- `feature-garage.lua`
- `shared/framework.lua`
- `server/editable.lua`
