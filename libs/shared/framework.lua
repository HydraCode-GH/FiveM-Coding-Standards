--- Hydra Code Framework Bridge
--- Load with: local Framework = require 'libs.shared.framework'
---
--- This module detects the active framework and loads side-specific wrappers.
--- Supported: esx, qbcore, qbox, standalone

---@class FrameworkBridge
Framework = Framework or {
    Type = 'standalone',
    Server = {},
    Client = {},
    Resource = GetCurrentResourceName(),
}

local function detectFramework()
    if GetResourceState('es_extended') == 'started' then
        return 'esx'
    end

    if GetResourceState('qbx_core') == 'started' then
        return 'qbox'
    end

    if GetResourceState('qb-core') == 'started' then
        return 'qbcore'
    end

    return 'standalone'
end

Framework.Type = detectFramework()

if IsDuplicityVersion() then
    if Framework.Type == 'esx' then
        require 'libs.shared.framework.server.esx'
    elseif Framework.Type == 'qbcore' then
        require 'libs.shared.framework.server.qbcore'
    elseif Framework.Type == 'qbox' then
        require 'libs.shared.framework.server.qbox'
    else
        require 'libs.shared.framework.server.standalone'
    end
else
    if Framework.Type == 'esx' then
        require 'libs.shared.framework.client.esx'
    elseif Framework.Type == 'qbcore' then
        require 'libs.shared.framework.client.qbcore'
    elseif Framework.Type == 'qbox' then
        require 'libs.shared.framework.client.qbox'
    else
        require 'libs.shared.framework.client.standalone'
    end
end

return Framework
