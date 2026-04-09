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
    if Framework.Client.getJob() ~= job_name then
        return false
    end

    if min_grade then
        return Framework.Client.getJobGrade() >= min_grade
    end

    return true
end

Framework.Client.notify = function(message, notify_type)
    if lib and lib.notify then
        lib.notify({ title = message, type = notify_type or 'inform' })
    else
        QBCore.Functions.Notify(message, notify_type or 'primary')
    end
end

return true
--- QBCore Client Bridge
--- Populates Framework.Client with QBCore-specific wrappers.
--- Required by libs/shared/framework.lua on the client when QBCore is detected.

local QBCore = exports['qb-core']:GetCoreObject()

--- Get the local player's data table.
---@return table
Framework.Client.getPlayerData = function()
    return QBCore.Functions.GetPlayerData()
end

--- Get the local player's job name.
---@return string|nil
Framework.Client.getJob = function()
    local data = Framework.Client.getPlayerData()
    return data and data.job and data.job.name or nil
end

--- Get the local player's job grade level.
---@return number
Framework.Client.getJobGrade = function()
    local data = Framework.Client.getPlayerData()
    return data and data.job and data.job.grade and data.job.grade.level or 0
end

--- Check if the local player has a specific job.
---@param job_name string
---@param min_grade? number
---@return boolean
Framework.Client.hasJob = function(job_name, min_grade)
    local job = Framework.Client.getJob()
    if job ~= job_name then return false end
    if min_grade then
        return Framework.Client.getJobGrade() >= min_grade
    end
    return true
end

--- Show a notification to the local player.
--- Prefer lib.notify from ox_lib for consistent styling.
---@param message string
---@param type? string  'success' | 'error' | 'info'
Framework.Client.notify = function(message, type)
    if lib and lib.notify then
        lib.notify({ title = message, type = type or 'inform' })
    else
        QBCore.Functions.Notify(message, type or 'primary')
    end
end
