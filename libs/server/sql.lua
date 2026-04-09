--- Hydra Code SQL Library
--- Server-side OxMySQL wrapper.
---
--- Add to server_scripts in fxmanifest.lua:
---   'libs/server/sql.lua'
---
--- Exposes global: SQL
---
--- All functions are promise-based (await).
--- Use SQL.query for SELECT, SQL.single for single-row SELECT,
--- SQL.scalar for single-value SELECT, SQL.insert for INSERT,
--- SQL.update for UPDATE/DELETE, SQL.transaction for multi-query batches.

---@class SQLLib
SQL = {}

--- Execute a SELECT query. Returns all matching rows.
--- Use when you expect zero or more rows.
---@param query string
---@param params table
---@return table|nil
function SQL.query(query, params)
    return MySQL.query.await(query, params or {})
end

--- Execute a SELECT query. Returns a single row (first match).
--- Use when you expect exactly one row (LIMIT 1 recommended in query).
---@param query string
---@param params table
---@return table|nil
function SQL.single(query, params)
    return MySQL.single.await(query, params or {})
end

--- Execute a SELECT query. Returns only the first column of the first row.
--- Use when you need one scalar value (count, name, etc).
---@param query string
---@param params table
---@return string|number|boolean|nil
function SQL.scalar(query, params)
    return MySQL.scalar.await(query, params or {})
end

--- Execute an INSERT query. Returns the insert ID.
---@param query string
---@param params table
---@return number|nil
function SQL.insert(query, params)
    return MySQL.insert.await(query, params or {})
end

--- Execute an UPDATE or DELETE query. Returns the number of affected rows.
---@param query string
---@param params table
---@return number
function SQL.update(query, params)
    return MySQL.update.await(query, params or {})
end

--- Execute a batch of queries as a single transaction.
--- All queries succeed or none are committed.
--- Returns true on success, false if any query fails.
---
--- Specific format (different queries, different params):
---   SQL.transaction({
---     { query = 'INSERT INTO t (id) VALUES (?)', values = { 1 } },
---     { query = 'INSERT INTO t (id) VALUES (?)', values = { 2 } },
---   })
---
--- Shared format (named params shared across queries):
---   SQL.transaction(
---     { 'INSERT INTO t (id, name) VALUES (@id, @name)', 'UPDATE t SET name = @name WHERE id = @id' },
---     { id = 1, name = 'test' }
---   )
---@param queries table
---@param values? table
---@return boolean
function SQL.transaction(queries, values)
    return MySQL.transaction.await(queries, values)
end

--- Execute a prepared statement. Faster for frequently called queries.
--- Unlike SQL.query, SELECT always returns a column, row, or array
--- depending on the number of columns and rows selected.
--- Note: Does not support DATE → datestring, or TINYINT 1 / BIT → boolean.
---@param query string
---@param params table
---@return any
function SQL.prepare(query, params)
    return MySQL.prepare.await(query, params or {})
end
