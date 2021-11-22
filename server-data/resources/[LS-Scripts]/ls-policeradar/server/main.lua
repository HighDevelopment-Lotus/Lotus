local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Commands.Add("radar", "Toggle snelheidsradar :)", {}, false, function(source, args)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("wk:toggleRadar", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)