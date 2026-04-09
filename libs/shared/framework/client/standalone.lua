Framework.Client.getPlayerData = function()
    return {}
end

Framework.Client.getJob = function()
    return nil
end

Framework.Client.getJobGrade = function()
    return 0
end

Framework.Client.hasJob = function(job_name, min_grade)
    return false
end

Framework.Client.notify = function(message, notify_type)
    if lib and lib.notify then
        lib.notify({ title = message, type = notify_type or 'inform' })
    end
end

return true
--- Standalone Client Bridge
--- Populates Framework.Client with no-op stubs.
--- Used when no supported framework is detected.

Framework.Client.getPlayerData = function()
    return {}
end

Framework.Client.getJob = function()
    return nil
end

Framework.Client.getJobGrade = function()
    return 0
end

Framework.Client.hasJob = function(job_name, min_grade)
    return false
end

Framework.Client.notify = function(message, type)
    if lib and lib.notify then
        lib.notify({ title = message, type = type or 'inform' })
    end
end
