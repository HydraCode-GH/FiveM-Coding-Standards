# SQL — OxMySQL

Standard for database access in Hydra Code resources. All database calls go through `libs/server/sql.lua` which wraps OxMySQL.

---

## Setup

Add to `server_scripts` in `fxmanifest.lua` **before** other server scripts:

```lua
server_scripts {
  'libs/server/versionchecker.lua',
  'libs/server/sql.lua',
  'libs/server/**/*.lua',
  'server/editable.lua',
  'server/**/*.lua',
}
```

This exposes the global `SQL` table to every server script in the resource. No `require` needed.

---

## Function Reference

### `SQL.query(query, params)` → `table|nil`

Returns **all matching rows** as an array of tables.

Use when you expect **zero or more rows**.

```lua
local rows = SQL.query('SELECT `firstname`, `lastname` FROM `users` WHERE `job` = ?', { 'police' })

if rows then
    for i = 1, #rows do
        print(rows[i].firstname, rows[i].lastname)
    end
end
```

---

### `SQL.single(query, params)` → `table|nil`

Returns the **first matching row** as a table, or `nil` if no match.

Use when you expect **exactly one row**. Always add `LIMIT 1` to the query.

```lua
local row = SQL.single('SELECT `firstname`, `lastname` FROM `users` WHERE `identifier` = ? LIMIT 1', { identifier })

if not row then return end

print(row.firstname, row.lastname)
```

---

### `SQL.scalar(query, params)` → `string|number|boolean|nil`

Returns the **first column of the first row** as a raw value.

Use when you need **one value** (count, name, balance, flag).

```lua
local count = SQL.scalar('SELECT COUNT(*) FROM `vehicles` WHERE `owner` = ?', { identifier })
print(count) -- e.g. 3
```

```lua
local first_name = SQL.scalar('SELECT `firstname` FROM `users` WHERE `identifier` = ? LIMIT 1', { identifier })
```

---

### `SQL.insert(query, params)` → `number|nil`

Executes an `INSERT` and returns the **auto-increment insert ID**.

```lua
local id = SQL.insert(
    'INSERT INTO `vehicles` (`owner`, `plate`, `model`) VALUES (?, ?, ?)',
    { identifier, plate, model }
)

print('Created vehicle with id:', id)
```

---

### `SQL.update(query, params)` → `number`

Executes an `UPDATE` or `DELETE` and returns the **number of affected rows**.

```lua
local affected = SQL.update(
    'UPDATE `users` SET `firstname` = ? WHERE `identifier` = ?',
    { new_name, identifier }
)

if affected == 0 then
    Debug.warn('No rows updated for identifier %s', identifier)
end
```

---

### `SQL.transaction(queries, values?)` → `boolean`

Executes multiple queries atomically. **Either all succeed, or none are committed.**

Returns `true` on success, `false` if any query fails.

#### Specific format (each query has its own params)

```lua
local ok = SQL.transaction({
    { query = 'INSERT INTO `t` (id) VALUES (?)',        values = { 1 } },
    { query = 'INSERT INTO `t` (id, name) VALUES (?, ?)', values = { 2, 'bob' } },
})
```

#### Shared format (named params shared across queries)

```lua
local ok = SQL.transaction(
    {
        'INSERT INTO `inventory` (owner, item) VALUES (@owner, @item)',
        'UPDATE `users` SET last_action = NOW() WHERE identifier = @owner',
    },
    { owner = identifier, item = 'phone' }
)
```

---

### `SQL.prepare(query, params)` → `any`

Faster execution for **frequently called queries**. The query is compiled once and reused.

Unlike `SQL.query`, the SELECT return value depends on the number of columns/rows:
- 1 column, 1 row → scalar value
- multiple columns, 1 row → single table
- multiple rows → array of tables

> **Caveats:** DATE does not return a datestring. TINYINT 1 and BIT do not return a boolean. Only `?` placeholders — no `??` or named.

```lua
local result = SQL.prepare(
    'SELECT `firstname`, `lastname` FROM `users` WHERE `identifier` = ?',
    { identifier }
)
```

Use `SQL.prepare` for queries called on every player action (e.g. inventory loads, vehicle checks).

---

## Decision Guide

```
What shape of result do you need?
  │
  ├─ All matching rows → SQL.query
  ├─ One row           → SQL.single  (+ LIMIT 1 in query)
  ├─ One value         → SQL.scalar  (+ LIMIT 1 in query)
  ├─ Insert ID         → SQL.insert
  ├─ Affected rows     → SQL.update
  ├─ Atomic multi-step → SQL.transaction
  └─ High-frequency    → SQL.prepare
```

---

## Rules

- **Server only.** Never call SQL functions from client scripts.
- **All calls are await (promise-based).** The calling thread yields until the query completes. Never nest SQL calls inside event handlers that run on the main game thread without a `CreateThread`.
- **Always use `?` placeholders.** Never interpolate values directly into query strings.
- **Check for `nil` before iterating.** `SQL.query` returns `nil` if no rows matched or on error.
- **Add `LIMIT 1`** to any `SELECT` passed to `SQL.single` or `SQL.scalar`.
- **Use transactions for multi-step writes.** Any sequence of inserts/updates that must be atomic belongs in `SQL.transaction`.
- **Use `SQL.prepare` for hot paths.** Login, inventory load, vehicle spawn, and similar per-player calls should use prepared statements.

---

## Anti-patterns

```lua
-- bad: string interpolation (SQL injection risk)
SQL.query('SELECT * FROM users WHERE identifier = "' .. identifier .. '"', {})

-- good: parameterised
SQL.query('SELECT * FROM users WHERE identifier = ?', { identifier })
```

```lua
-- bad: unchecked nil
local row = SQL.single('SELECT firstname FROM users WHERE identifier = ? LIMIT 1', { id })
print(row.firstname) -- crashes if row is nil

-- good: guard first
local row = SQL.single('SELECT firstname FROM users WHERE identifier = ? LIMIT 1', { id })
if not row then return end
print(row.firstname)
```

```lua
-- bad: sequential independent queries (slower)
SQL.update('UPDATE users SET firstname = ? WHERE identifier = ?', { name, id })
SQL.update('UPDATE users SET lastname = ? WHERE identifier = ?',  { last, id })

-- good: one query
SQL.update('UPDATE users SET firstname = ?, lastname = ? WHERE identifier = ?', { name, last, id })
```
