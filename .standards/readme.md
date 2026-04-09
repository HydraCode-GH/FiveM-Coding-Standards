# README Standards

Every resource must have a `README.md` at its root. This file is the first thing anyone reads — keep it clear, accurate, and minimal.

---

## Required Sections (in order)

### 1. Title + One-Line Description

```md
# resource-name

Short one-line description of what the resource does.
```

- Use the exact resource folder name as the title.
- The description should fit in one sentence — no marketing copy.

---

### 2. Features (optional but recommended)

```md
## Features

- Players can do X
- Admins can manage Y
- Configurable via `shared/editable.lua`
```

Use a bullet list. Focus on what it does, not how it works.

---

### 3. Dependencies

```md
## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [oxmysql](https://github.com/overextended/oxmysql)
- [es_extended](https://github.com/esx-framework/esx_core) *(if using ESX bridge)*
```

List every resource that must exist for this resource to work. Link to GitHub where possible.

---

### 4. Installation

```md
## Installation

1. Download or clone the resource into your `resources/` folder.
2. Import `sql/install.sql` into your database.
3. Add `ensure resource-name` to your `server.cfg`.
4. Configure settings in `shared/editable.lua`.
```

Numbered steps only. Each step is a single action.

---

### 5. Configuration

```md
## Configuration

All user-facing settings are in `shared/editable.lua`.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `cooldown` | `number` | `30` | Seconds between uses |
| `notify_type` | `string` | `'inform'` | Notification style |
```

If the editable file is the configuration, say so and list the most important keys. Do not document private internals. or things that are not important to the readme

---

### 6. Usage (optional)

Document player commands or key binds if the resource has them.

```md
## Commands

| Command | Description | Permission |
|---------|-------------|------------|
| `/mycommand [arg]` | Does something | `group.moderator` |
```
---

## Rules

- **Write in plain English.** No abbreviations, no assumed knowledge.
- **Keep it short.** If a section would be empty, omit it.
- **Code blocks for all inline filenames, paths, commands, and keys.** Never write them as plain text.
- **Do not paste the full `fxmanifest.lua` or config into the README.** Tell users where the file is, don't duplicate it.

---

## File Header Block

Every README should open with a compact header block before the body:

```md
# my-resource

> Short one-line description

**Version:** 1.0.0 | **Framework:** ESX / QBCore / Standalone | **Author:** Hydra Code
```

---

## Minimal Example

```md
# hc-garage

Simple garage system with ox_lib UI and ESX player-owned vehicles.

**Version:** 1.2.0 | **Framework:** ESX | **Author:** Hydra Code

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [oxmysql](https://github.com/overextended/oxmysql)
- [es_extended](https://github.com/esx-framework/esx_core)

## Installation

1. Add `hc-garage` to your `resources/` folder.
2. Import `sql/install.sql`.
3. Add `ensure hc-garage` to `server.cfg`.
4. Edit `shared/editable.lua` to configure spawn points and prices.

## Configuration

See `shared/editable.lua`. Key settings:

| Key | Default | Description |
|-----|---------|-------------|
| `max_vehicles` | `5` | Maximum vehicles per player |
| `impound_price` | `500` | Cost to retrieve impounded vehicle |
```
