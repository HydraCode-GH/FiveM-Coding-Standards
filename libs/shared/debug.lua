--- Hydra Code Debug Library
--- Shared module for structured, toggleable log output.
---
--- Load via require:
---   local Debug = require 'libs.shared.debug'
---
--- Enable debug output per-resource via convar:
---   set debug_<resourcename> 1
---
--- Usage:
---   Debug.info('Player %s connected', player_name)
---   Debug.warn('Missing config key: %s', key)
---   Debug.error('Failed to load data: %s', err)
---   Debug.debug('Raw response: %s', json.encode(data))  -- only prints when debug enabled

local RESOURCE_NAME = GetCurrentResourceName()
local ORG_NAME = 'Hydra Code'

local COLOR_RESET = '^7'
local COLOR_INFO  = '^5'
local COLOR_WARN  = '^8'
local COLOR_ERROR = '^1'
local COLOR_DEBUG = '^6'
local COLOR_SENSITIVE = '^9'

---@class DebugLib
local Debug = {}

local function toBoolean(value)
    if type(value) == 'boolean' then return value end
    if type(value) == 'number' then return value ~= 0 end
    if type(value) ~= 'string' then return nil end

    local normalized = value:lower()
    if normalized == '1' or normalized == 'true' or normalized == 'yes' or normalized == 'on' then
        return true
    end
    if normalized == '0' or normalized == 'false' or normalized == 'no' or normalized == 'off' then
        return false
    end

    return nil
end

local function resolveDebugToggle(default_value)
    local cfg = rawget(_G, 'Config')
    if type(cfg) == 'table' and type(cfg.Debug) == 'table' then
        local resolved = toBoolean(cfg.Debug.enabled)
            or toBoolean(cfg.Debug.default)
            or toBoolean(cfg.Debug.debug)
        if resolved ~= nil then
            return resolved
        end
    elseif type(cfg) == 'table' then
        local resolved = toBoolean(cfg.Debug)
        if resolved ~= nil then
            return resolved
        end
    end

    local convar = toBoolean(GetConvar(('debug_%s'):format(RESOURCE_NAME), ''))
    if convar ~= nil then
        return convar
    end

    if default_value ~= nil then
        return default_value
    end

    return false
end

local function resolveSensitiveToggle(default_value)
    local cfg = rawget(_G, 'Config')
    if type(cfg) == 'table' and type(cfg.Debug) == 'table' then
        local resolved = toBoolean(cfg.Debug.sensitive)
            or toBoolean(cfg.Debug.sensitive_information)
        if resolved ~= nil then
            return resolved
        end
    end

    local convar = toBoolean(GetConvar(('debug_sensitive_%s'):format(RESOURCE_NAME), ''))
    if convar ~= nil then
        return convar
    end

    local fallback_debug = toBoolean(GetConvar(('debug_%s'):format(RESOURCE_NAME), ''))
    if fallback_debug ~= nil then
        return fallback_debug
    end

    if default_value ~= nil then
        return default_value
    end

    return false
end

--- Whether debug-level output is enabled.
--- Resolution order:
--- 1) Config.Debug.enabled / Config.Debug.default / Config.Debug.debug
--- 2) convar debug_<resourcename>
--- 3) false
Debug.enabled = resolveDebugToggle(false)

--- Whether sensitive debug output is enabled.
--- Resolution order:
--- 1) Config.Debug.sensitive / Config.Debug.sensitive_information
--- 2) convar debug_sensitive_<resourcename>
--- 3) convar debug_<resourcename>
--- 4) false
Debug.sensitiveEnabled = resolveSensitiveToggle(false)

local function prefix(level, color)
    return ('%s[%s][%s][%s]%s'):format(color, ORG_NAME, RESOURCE_NAME, level, COLOR_RESET)
end

--- Print an info-level message. Always visible.
---@param message string
---@param ... any  Format arguments
function Debug.info(message, ...)
    if select('#', ...) > 0 then
        message = message:format(...)
    end
    print(prefix('INFO', COLOR_INFO) .. ' ' .. tostring(message))
end

--- Print a warning-level message. Always visible.
---@param message string
---@param ... any  Format arguments
function Debug.warn(message, ...)
    if select('#', ...) > 0 then
        message = message:format(...)
    end
    print(prefix('WARN', COLOR_WARN) .. ' ' .. tostring(message))
end

--- Print an error-level message. Always visible.
---@param message string
---@param ... any  Format arguments
function Debug.error(message, ...)
    if select('#', ...) > 0 then
        message = message:format(...)
    end
    print(prefix('ERROR', COLOR_ERROR) .. ' ' .. tostring(message))
end

--- Print a debug-level message. Only visible when debug is enabled.
--- Enable with: set debug_<resourcename> 1
---@param message string
---@param ... any  Format arguments
function Debug.debug(message, ...)
    if not Debug.enabled then return end
    if select('#', ...) > 0 then
        message = message:format(...)
    end
    print(prefix('DEBUG', COLOR_DEBUG) .. ' ' .. tostring(message))
end

--- Print a table or value for inspection (debug-only).
---@param label string
---@param value any
function Debug.dump(label, value)
    if not Debug.enabled then return end
    local encoded = (type(value) == 'table' and json and json.encode)
        and json.encode(value, { indent = true })
        or tostring(value)
    print(prefix('DUMP', COLOR_DEBUG) .. ' ' .. tostring(label) .. ' = ' .. encoded)
end

--- Print sensitive debug output.
--- Only visible when sensitive debug is enabled.
---
--- Do not use for secrets in production unless explicitly enabled.
---@param message string
---@param ... any  Format arguments
function Debug.sensitive(message, ...)
    if not Debug.sensitiveEnabled then return end
    if select('#', ...) > 0 then
        message = message:format(...)
    end
    print(prefix('SENSITIVE', COLOR_SENSITIVE) .. ' ' .. tostring(message))
end

--- Re-evaluate toggle values at runtime.
--- Useful if Config.Debug is loaded after this module.
function Debug.refresh()
    Debug.enabled = resolveDebugToggle(false)
    Debug.sensitiveEnabled = resolveSensitiveToggle(Debug.enabled)
end

return Debug
