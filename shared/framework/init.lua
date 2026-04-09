--- Shared Framework Bridge
--- Entry point for framework detection and bridge loading.
---
--- Copy the full shared/framework/ folder into your resource.
--- Then load via fxmanifest:
---
---   shared_scripts {
---     '@ox_lib/init.lua',
---     'shared/framework/init.lua',
---     'shared/editable.lua',
---   }
---
--- Access anywhere after loading:
---   Framework.Type        -- 'esx' | 'qbcore' | 'qbox' | 'standalone'
---   Framework.Server.*    -- server-side wrappers (server scripts only)
---   Framework.Client.*    -- client-side wrappers (client scripts only)

---@class Framework
Framework = {
    Type   = 'standalone',
    Server = {},
    Client = {},
}

-- Detect framework from convars (set by framework resources)
local framework_convar = GetConvar('es:gamemode', ''):lower()
    or GetConvar('qb-core:gamemode', ''):lower()

if GetResourceState('es_extended') == 'started' then
    Framework.Type = 'esx'
elseif GetResourceState('qbx_core') == 'started' then
    Framework.Type = 'qbox'
elseif GetResourceState('qb-core') == 'started' then
    Framework.Type = 'qbcore'
end

-- Load the bridge file for the detected framework
-- (Server and Client wrappers are populated inside each bridge file)
if IsDuplicityVersion() then
    -- server context
    if Framework.Type == 'esx' then
        require 'shared.framework.server.esx'
    elseif Framework.Type == 'qbcore' then
        require 'shared.framework.server.qbcore'
    elseif Framework.Type == 'qbox' then
        require 'shared.framework.server.qbox'
    else
        require 'shared.framework.server.standalone'
    end
else
    -- client context
    if Framework.Type == 'esx' then
        require 'shared.framework.client.esx'
    elseif Framework.Type == 'qbcore' then
        require 'shared.framework.client.qbcore'
    elseif Framework.Type == 'qbox' then
        require 'shared.framework.client.qbox'
    else
        require 'shared.framework.client.standalone'
    end
end
