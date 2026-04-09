local RESOURCE_NAME = GetCurrentResourceName()
local MANIFEST_FILE = 'fxmanifest.lua'
local VERSION_FILE = 'version.json'
local ORG_NAME = 'Hydra Code'

local function readManifestField(manifest, fieldName)
    if type(manifest) ~= 'string' or type(fieldName) ~= 'string' then
        return nil
    end

    local pattern = fieldName .. "%s+['\"]([^'\"]+)['\"]"
    local value = manifest:match(pattern)
    if type(value) ~= 'string' or value == '' then
        return nil
    end

    return value
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
    local scriptName = readManifestField(manifest, 'name') or RESOURCE_NAME

    return {
        version = version,
        repository = repository,
        scriptName = scriptName
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

local function printChangelogEntry(scriptName, versionData, version)
    if type(versionData.changelog) ~= 'table' then
        return
    end

    local changes = versionData.changelog[version]
    if type(changes) ~= 'table' or #changes == 0 then
        return
    end

    print(('[%s][%s][%s] VersionChecker changelog for %s:'):format(ORG_NAME, scriptName, RESOURCE_NAME, version))
    for index, change in ipairs(changes) do
        print(('  %d. %s'):format(index, tostring(change)))
    end
end

CreateThread(function()
    local manifestData, manifestErr = readManifestVersion()
    if not manifestData then
        print(('[%s][%s] VersionChecker: could not read %s (%s)'):format(ORG_NAME, RESOURCE_NAME, MANIFEST_FILE, manifestErr))
        return
    end

    local manifestVersion = manifestData.version
    local repository = manifestData.repository
    local scriptName = manifestData.scriptName

    local versionData, versionErr = readVersionData()
    print(('[%s][%s][%s] VersionChecker: current manifest version is %s'):format(ORG_NAME, scriptName, RESOURCE_NAME, manifestVersion))

    if repository then
        print(('[%s][%s][%s] VersionChecker: repository %s'):format(ORG_NAME, scriptName, RESOURCE_NAME, repository))
    else
        print(('[%s][%s][%s] VersionChecker: no repository field found in %s'):format(ORG_NAME, scriptName, RESOURCE_NAME, MANIFEST_FILE))
    end

    if not versionData then
        print(('[%s][%s][%s] VersionChecker: could not read %s (%s)'):format(ORG_NAME, scriptName, RESOURCE_NAME, VERSION_FILE, versionErr))
        return
    end

    local latestVersion = versionData.latest
    local updatedAt = versionData.updated_at

    if type(latestVersion) == 'string' and latestVersion ~= '' then
        if latestVersion ~= manifestVersion then
            print(('[%s][%s][%s] VersionChecker: update available -> %s (current: %s)'):format(ORG_NAME, scriptName, RESOURCE_NAME, latestVersion, manifestVersion))
        else
            print(('[%s][%s][%s] VersionChecker: resource is up to date (%s)'):format(ORG_NAME, scriptName, RESOURCE_NAME, manifestVersion))
        end
    end

    if type(updatedAt) == 'string' and updatedAt ~= '' then
        print(('[%s][%s][%s] VersionChecker: latest update date %s'):format(ORG_NAME, scriptName, RESOURCE_NAME, updatedAt))
    end

    printChangelogEntry(scriptName, versionData, manifestVersion)
end)
