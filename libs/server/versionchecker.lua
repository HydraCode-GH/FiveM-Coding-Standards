local RESOURCE_NAME = GetCurrentResourceName()
local MANIFEST_FILE = 'fxmanifest.lua'
local VERSION_LUA_FILE = 'version.lua'
local VERSION_FILE = 'version.json'
local ORG_NAME = 'HydraCode'

local COLOR_RESET = '^7'
local COLOR_TITLE = '^5'
local COLOR_LABEL = '^3'
local COLOR_OK = '^2'
local COLOR_WARN = '^8'
local COLOR_ERROR = '^1'
local COLOR_ACCENT = '^6'

local function paint(color, text)
    return color .. tostring(text) .. COLOR_RESET
end

local function logInfo(message)
    print(('%s[%s]%s %s'):format(COLOR_LABEL, ORG_NAME, COLOR_RESET, message))
end

local function logWarn(message)
    print(('%s[%s]%s %s'):format(COLOR_WARN, ORG_NAME, COLOR_RESET, message))
end

local function logError(message)
    print(('%s[%s]%s %s'):format(COLOR_ERROR, ORG_NAME, COLOR_RESET, message))
end

local function logHeader(script_name)
    local header = ('[%s][%s] Version Checker'):format(script_name, RESOURCE_NAME)
    print(paint(COLOR_TITLE, ('='):rep(72)))
    print(paint(COLOR_TITLE, header))
    print(paint(COLOR_TITLE, ('='):rep(72)))
end

local function readManifestField(manifest, field_name)
    if type(manifest) ~= 'string' or type(field_name) ~= 'string' then
        return nil
    end

    for line in manifest:gmatch('[^\r\n]+') do
        local pattern = '^%s*' .. field_name .. "%s+['\"]([^'\"]+)['\"]"
        local value = line:match(pattern)
        if type(value) == 'string' and value ~= '' then
            return value
        end
    end

    return nil
end

local function readManifestVersion()
    local manifest = LoadResourceFile(RESOURCE_NAME, MANIFEST_FILE)
    if not manifest then
        return nil, 'missing_manifest'
    end

    local version = readManifestField(manifest, 'version')
    if not version or version == '' then
        return nil, 'missing_version_field'
    end

    local repository = readManifestField(manifest, 'repository')
    local script_name = readManifestField(manifest, 'name') or RESOURCE_NAME

    return {
        version = version,
        repository = repository,
        script_name = script_name,
    }, nil
end

local function readVersionLuaFallback()
    local raw = LoadResourceFile(RESOURCE_NAME, VERSION_LUA_FILE)
    if not raw then
        return nil, 'missing_version_lua'
    end

    local current_version = raw:match("version%s*=%s*['\"]([^'\"]+)['\"]")
    current_version = current_version or raw:match("VERSION%s*=%s*['\"]([^'\"]+)['\"]")
    if not current_version or current_version == '' then
        return nil, 'missing_version_lua_value'
    end

    local script_name = raw:match("script_name%s*=%s*['\"]([^'\"]+)['\"]")
    script_name = script_name or raw:match("SCRIPT_NAME%s*=%s*['\"]([^'\"]+)['\"]") or RESOURCE_NAME

    return {
        script_name = script_name,
        version = current_version,
    }, nil
end

local function readVersionData()
    local raw = LoadResourceFile(RESOURCE_NAME, VERSION_FILE)
    if not raw then
        return nil, 'missing_version_json'
    end

    if not json or not json.decode then
        return nil, 'json_decoder_unavailable'
    end

    local ok, parsed = pcall(json.decode, raw)
    if not ok or type(parsed) ~= 'table' then
        return nil, 'invalid_version_json'
    end

    return parsed, nil
end

local function getLatestFromStandardJson(version_data)
    if type(version_data.latest) == 'string' and version_data.latest ~= '' then
        return version_data.latest
    end

    return nil
end

local function getLatestFromFallbackJson(version_data, script_name)
    if type(version_data) ~= 'table' or type(script_name) ~= 'string' or script_name == '' then
        return nil
    end

    local value = version_data[script_name] or version_data[RESOURCE_NAME]
    if type(value) == 'number' then
        return tostring(value)
    end
    if type(value) == 'string' and value ~= '' then
        return value
    end

    return nil
end

local function printChangelogEntry(version_data, version)
    if type(version_data.changelog) ~= 'table' then
        return
    end

    local changes = version_data.changelog[version]
    if type(changes) ~= 'table' or #changes == 0 then
        return
    end

    logInfo(('Changelog for %s:'):format(paint(COLOR_ACCENT, version)))
    for index, change in ipairs(changes) do
        print(('  %s%d.%s %s'):format(COLOR_LABEL, index, COLOR_RESET, tostring(change)))
    end
end

CreateThread(function()
    local manifest_exists = LoadResourceFile(RESOURCE_NAME, MANIFEST_FILE) ~= nil

    if manifest_exists then
        local manifest_data, manifest_err = readManifestVersion()
        if not manifest_data then
            logError(('VersionChecker: could not read %s (%s)'):format(MANIFEST_FILE, manifest_err))
            return
        end

        local manifest_version = manifest_data.version
        local repository = manifest_data.repository
        local script_name = manifest_data.script_name
        local version_data, version_err = readVersionData()

        logHeader(script_name)
        logInfo(('Current version: %s'):format(paint(COLOR_ACCENT, manifest_version)))

        if repository then
            logInfo(('Repository: %s'):format(paint(COLOR_ACCENT, repository)))
        else
            logWarn(('No repository field found in %s'):format(MANIFEST_FILE))
        end

        if not version_data then
            logWarn(('Could not read %s (%s)'):format(VERSION_FILE, version_err))
            return
        end

        local latest_version = getLatestFromStandardJson(version_data)
        local updated_at = version_data.updated_at

        if type(latest_version) == 'string' and latest_version ~= '' then
            if latest_version ~= manifest_version then
                logWarn(('Update available: %s (current: %s)')
                    :format(paint(COLOR_OK, latest_version), paint(COLOR_ACCENT, manifest_version)))
            else
                logInfo(('Status: %s')
                    :format(paint(COLOR_OK, ('up to date (%s)'):format(manifest_version))))
            end
        else
            logWarn('No latest version entry found in version.json')
        end

        if type(updated_at) == 'string' and updated_at ~= '' then
            logInfo(('Updated at: %s'):format(paint(COLOR_ACCENT, updated_at)))
        end

        printChangelogEntry(version_data, manifest_version)
        return
    end

    logWarn(('No %s found, using fallback mode (%s + %s)')
        :format(MANIFEST_FILE, VERSION_LUA_FILE, VERSION_FILE))

    local fallback_data, fallback_err = readVersionLuaFallback()
    if not fallback_data then
        logError(('VersionChecker fallback failed: could not read %s (%s)')
            :format(VERSION_LUA_FILE, fallback_err))
        return
    end

    local script_name = fallback_data.script_name
    local current_version = fallback_data.version
    local version_data, version_err = readVersionData()

    logHeader(script_name)
    logInfo(('Current version (%s): %s')
        :format(VERSION_LUA_FILE, paint(COLOR_ACCENT, current_version)))

    if not version_data then
        logWarn(('Could not read %s (%s)'):format(VERSION_FILE, version_err))
        return
    end

    local latest_version = getLatestFromFallbackJson(version_data, script_name)
    if type(latest_version) == 'string' and latest_version ~= '' then
        if latest_version ~= current_version then
            logWarn(('Update available: %s (current: %s)')
                :format(paint(COLOR_OK, latest_version), paint(COLOR_ACCENT, current_version)))
        else
            logInfo(('Status: %s')
                :format(paint(COLOR_OK, ('up to date (%s)'):format(current_version))))
        end
    else
        logWarn(('No "%s" entry found in %s for fallback lookup')
            :format(script_name, VERSION_FILE))
    end
end)
