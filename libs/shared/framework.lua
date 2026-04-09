--- Hydra Code Framework Bridge
--- Add to shared_scripts in fxmanifest.lua before other scripts:
---   'libs/shared/framework.lua'
---
--- Exposes global: Framework
---   Framework.Type        -- 'esx' | 'qbcore' | 'qbox' | 'standalone'
---   Framework.Server.*    -- server-side wrappers (server context only)
---   Framework.Client.*    -- client-side wrappers (client context only)

Framework = {
    Type     = 'standalone',
    Server   = {},
    Client   = {},
    Resource = GetCurrentResourceName(),
}

-- Detection

if GetResourceState('es_extended') == 'started' then
    Framework.Type = 'esx'
elseif GetResourceState('qbx_core') == 'started' then
    Framework.Type = 'qbox'
elseif GetResourceState('qb-core') == 'started' then
    Framework.Type = 'qbcore'
end

-- Server wrappers

if IsDuplicityVersion() then
    if Framework.Type == 'esx' then
        local ESX = exports['es_extended']:getSharedObject()

        Framework.Server.getPlayer = function(source)
            return ESX.GetPlayerFromId(source)
        end

        Framework.Server.getIdentifier = function(source)
            local player = Framework.Server.getPlayer(source)
            return player and player.identifier or nil
        end

        Framework.Server.getJob = function(source)
            local player = Framework.Server.getPlayer(source)
            return player and player.job and player.job.name or nil
        end

        Framework.Server.getJobGrade = function(source)
            local player = Framework.Server.getPlayer(source)
            return player and player.job and player.job.grade or 0
        end

        Framework.Server.getMoney = function(source, account)
            local player = Framework.Server.getPlayer(source)
            if not player then return 0 end
            local wallet = player.getAccount(account or 'money')
            return wallet and wallet.money or 0
        end

        Framework.Server.addMoney = function(source, account, amount)
            local player = Framework.Server.getPlayer(source)
            if not player then return end
            player.addAccountMoney(account or 'money', amount)
        end

        Framework.Server.removeMoney = function(source, account, amount)
            local player = Framework.Server.getPlayer(source)
            if not player then return end
            player.removeAccountMoney(account or 'money', amount)
        end

    elseif Framework.Type == 'qbcore' then
        local QBCore = exports['qb-core']:GetCoreObject()

        Framework.Server.getPlayer = function(source)
            return QBCore.Functions.GetPlayer(source)
        end

        Framework.Server.getIdentifier = function(source)
            local player = Framework.Server.getPlayer(source)
            return player and player.PlayerData and player.PlayerData.citizenid or nil
        end

        Framework.Server.getJob = function(source)
            local player = Framework.Server.getPlayer(source)
            return player and player.PlayerData and player.PlayerData.job and player.PlayerData.job.name or nil
        end

        Framework.Server.getJobGrade = function(source)
            local player = Framework.Server.getPlayer(source)
            return player and player.PlayerData and player.PlayerData.job and player.PlayerData.job.grade and player.PlayerData.job.grade.level or 0
        end

        Framework.Server.getMoney = function(source, account)
            local player = Framework.Server.getPlayer(source)
            if not player then return 0 end
            return player.PlayerData.money[account or 'cash'] or 0
        end

        Framework.Server.addMoney = function(source, account, amount)
            local player = Framework.Server.getPlayer(source)
            if not player then return end
            player.Functions.AddMoney(account or 'cash', amount)
        end

        Framework.Server.removeMoney = function(source, account, amount)
            local player = Framework.Server.getPlayer(source)
            if not player then return end
            player.Functions.RemoveMoney(account or 'cash', amount)
        end

    elseif Framework.Type == 'qbox' then
        local QBX = exports['qbx_core']

        Framework.Server.getPlayer = function(source)
            return QBX:GetPlayer(source)
        end

        Framework.Server.getIdentifier = function(source)
            local player = Framework.Server.getPlayer(source)
            return player and player.PlayerData and player.PlayerData.citizenid or nil
        end

        Framework.Server.getJob = function(source)
            local player = Framework.Server.getPlayer(source)
            return player and player.PlayerData and player.PlayerData.job and player.PlayerData.job.name or nil
        end

        Framework.Server.getJobGrade = function(source)
            local player = Framework.Server.getPlayer(source)
            return player and player.PlayerData and player.PlayerData.job and player.PlayerData.job.grade and player.PlayerData.job.grade.level or 0
        end

        Framework.Server.getMoney = function(source, account)
            local player = Framework.Server.getPlayer(source)
            if not player then return 0 end
            return player.PlayerData.money[account or 'cash'] or 0
        end

        Framework.Server.addMoney = function(source, account, amount)
            local player = Framework.Server.getPlayer(source)
            if not player then return end
            player.Functions.AddMoney(account or 'cash', amount)
        end

        Framework.Server.removeMoney = function(source, account, amount)
            local player = Framework.Server.getPlayer(source)
            if not player then return end
            player.Functions.RemoveMoney(account or 'cash', amount)
        end

    else -- standalone
        Framework.Server.getPlayer = function(source) return nil end

        Framework.Server.getIdentifier = function(source)
            return GetPlayerIdentifierByType(source, 'license') or nil
        end

        Framework.Server.getJob = function(source) return nil end
        Framework.Server.getJobGrade = function(source) return 0 end
        Framework.Server.getMoney = function(source, account) return 0 end
        Framework.Server.addMoney = function(source, account, amount) end
        Framework.Server.removeMoney = function(source, account, amount) end
    end

-- Client wrappers

else
    if Framework.Type == 'esx' then
        local ESX = exports['es_extended']:getSharedObject()

        Framework.Client.getPlayerData = function()
            return ESX.GetPlayerData()
        end

        Framework.Client.getJob = function()
            local data = Framework.Client.getPlayerData()
            return data and data.job and data.job.name or nil
        end

        Framework.Client.getJobGrade = function()
            local data = Framework.Client.getPlayerData()
            return data and data.job and data.job.grade or 0
        end

        Framework.Client.hasJob = function(job_name, min_grade)
            if Framework.Client.getJob() ~= job_name then return false end
            if min_grade then return Framework.Client.getJobGrade() >= min_grade end
            return true
        end

        Framework.Client.notify = function(message, notify_type)
            if lib and lib.notify then
                lib.notify({ title = message, type = notify_type or 'inform' })
            else
                ESX.ShowNotification(message)
            end
        end

    elseif Framework.Type == 'qbcore' then
        local QBCore = exports['qb-core']:GetCoreObject()

        Framework.Client.getPlayerData = function()
            return QBCore.Functions.GetPlayerData()
        end

        Framework.Client.getJob = function()
            local data = Framework.Client.getPlayerData()
            return data and data.job and data.job.name or nil
        end

        Framework.Client.getJobGrade = function()
            local data = Framework.Client.getPlayerData()
            return data and data.job and data.job.grade and data.job.grade.level or 0
        end

        Framework.Client.hasJob = function(job_name, min_grade)
            if Framework.Client.getJob() ~= job_name then return false end
            if min_grade then return Framework.Client.getJobGrade() >= min_grade end
            return true
        end

        Framework.Client.notify = function(message, notify_type)
            if lib and lib.notify then
                lib.notify({ title = message, type = notify_type or 'inform' })
            else
                QBCore.Functions.Notify(message, notify_type or 'primary')
            end
        end

    elseif Framework.Type == 'qbox' then
        local QBX = exports['qbx_core']

        Framework.Client.getPlayerData = function()
            return QBX:GetPlayerData()
        end

        Framework.Client.getJob = function()
            local data = Framework.Client.getPlayerData()
            return data and data.job and data.job.name or nil
        end

        Framework.Client.getJobGrade = function()
            local data = Framework.Client.getPlayerData()
            return data and data.job and data.job.grade and data.job.grade.level or 0
        end

        Framework.Client.hasJob = function(job_name, min_grade)
            if Framework.Client.getJob() ~= job_name then return false end
            if min_grade then return Framework.Client.getJobGrade() >= min_grade end
            return true
        end

        Framework.Client.notify = function(message, notify_type)
            if lib and lib.notify then
                lib.notify({ title = message, type = notify_type or 'inform' })
            else
                BeginTextCommandThefeedPost('STRING')
                AddTextComponentSubstringPlayerName(tostring(message))
                EndTextCommandThefeedPostTicker(false, false)
            end
        end

    else -- standalone
        Framework.Client.getPlayerData = function() return {} end
        Framework.Client.getJob = function() return nil end
        Framework.Client.getJobGrade = function() return 0 end
        Framework.Client.hasJob = function(job_name, min_grade) return false end

        Framework.Client.notify = function(message, notify_type)
            if lib and lib.notify then
                lib.notify({ title = message, type = notify_type or 'inform' })
            end
        end
    end
end
