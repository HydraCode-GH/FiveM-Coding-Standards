--- ESX Server Bridge
--- Populates Framework.Server with ESX-specific wrappers.
--- Required by shared/framework/init.lua on the server when ESX is detected.

local ESX = nil

local function getESX()
    if ESX then return ESX end
    ESX = exports['es_extended']:getSharedObject()
    return ESX
end

--- Get the ESX player object for a source.
---@param source number
---@return table|nil
Framework.Server.getPlayer = function(source)
    return getESX().GetPlayerFromId(source)
end

--- Get a player's identifier string.
---@param source number
---@return string|nil
Framework.Server.getIdentifier = function(source)
    local player = Framework.Server.getPlayer(source)
    return player and player.identifier or nil
end

--- Get a player's job name.
---@param source number
---@return string|nil
Framework.Server.getJob = function(source)
    local player = Framework.Server.getPlayer(source)
    return player and player.job and player.job.name or nil
end

--- Get a player's job grade.
---@param source number
---@return number
Framework.Server.getJobGrade = function(source)
    local player = Framework.Server.getPlayer(source)
    return player and player.job and player.job.grade or 0
end

--- Get a player's money (account balance).
---@param source number
---@param account string  e.g. 'money', 'bank', 'black_money'
---@return number
Framework.Server.getMoney = function(source, account)
    local player = Framework.Server.getPlayer(source)
    if not player then return 0 end
    local acc = player.getAccount(account or 'money')
    return acc and acc.money or 0
end

--- Add money to a player account.
---@param source number
---@param account string
---@param amount number
Framework.Server.addMoney = function(source, account, amount)
    local player = Framework.Server.getPlayer(source)
    if not player then return end
    player.addAccountMoney(account or 'money', amount)
end

--- Remove money from a player account.
---@param source number
---@param account string
---@param amount number
Framework.Server.removeMoney = function(source, account, amount)
    local player = Framework.Server.getPlayer(source)
    if not player then return end
    player.removeAccountMoney(account or 'money', amount)
end
