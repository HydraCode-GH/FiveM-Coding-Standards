Framework.Server.getPlayer = function(source)
    return nil
end

Framework.Server.getIdentifier = function(source)
    return GetPlayerIdentifierByType(source, 'license') or nil
end

Framework.Server.getJob = function(source)
    return nil
end

Framework.Server.getJobGrade = function(source)
    return 0
end

Framework.Server.getMoney = function(source, account)
    return 0
end

Framework.Server.addMoney = function(source, account, amount) end

Framework.Server.removeMoney = function(source, account, amount) end

return true
--- Standalone Server Bridge
--- Populates Framework.Server with no-op stubs.
--- Used when no supported framework is detected.
--- Replace stubs with your own logic as needed.

Framework.Server.getPlayer = function(source)
    return nil
end

Framework.Server.getIdentifier = function(source)
    return GetPlayerIdentifierByType(source, 'license') or nil
end

Framework.Server.getJob = function(source)
    return nil
end

Framework.Server.getJobGrade = function(source)
    return 0
end

Framework.Server.getMoney = function(source, account)
    return 0
end

Framework.Server.addMoney = function(source, account, amount) end

Framework.Server.removeMoney = function(source, account, amount) end
