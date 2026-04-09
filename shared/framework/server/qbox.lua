--- Qbox Server Bridge
--- Populates Framework.Server with Qbox-specific wrappers.
--- Required by shared/framework/init.lua on the server when Qbox is detected.
--- Qbox uses the same player object shape as QBCore.

local QBX = exports['qbx_core']

--- Get the Qbox player object for a source.
---@param source number
---@return table|nil
Framework.Server.getPlayer = function(source)
    return QBX:GetPlayer(source)
end

--- Get a player's identifier (citizenid).
---@param source number
---@return string|nil
Framework.Server.getIdentifier = function(source)
    local player = Framework.Server.getPlayer(source)
    return player and player.PlayerData and player.PlayerData.citizenid or nil
end

--- Get a player's job name.
---@param source number
---@return string|nil
Framework.Server.getJob = function(source)
    local player = Framework.Server.getPlayer(source)
    return player and player.PlayerData.job and player.PlayerData.job.name or nil
end

--- Get a player's job grade.
---@param source number
---@return number
Framework.Server.getJobGrade = function(source)
    local player = Framework.Server.getPlayer(source)
    return player and player.PlayerData.job and player.PlayerData.job.grade.level or 0
end

--- Get a player's cash or bank balance.
---@param source number
---@param account string  'cash' | 'bank'
---@return number
Framework.Server.getMoney = function(source, account)
    local player = Framework.Server.getPlayer(source)
    if not player then return 0 end
    return player.PlayerData.money[account or 'cash'] or 0
end

--- Add money to a player account.
---@param source number
---@param account string
---@param amount number
Framework.Server.addMoney = function(source, account, amount)
    local player = Framework.Server.getPlayer(source)
    if not player then return end
    player.Functions.AddMoney(account or 'cash', amount)
end

--- Remove money from a player account.
---@param source number
---@param account string
---@param amount number
Framework.Server.removeMoney = function(source, account, amount)
    local player = Framework.Server.getPlayer(source)
    if not player then return end
    player.Functions.RemoveMoney(account or 'cash', amount)
end
