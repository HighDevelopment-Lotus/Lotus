local LSCore = exports['fw-base']:GetCoreObject()

-- Code

LSCore.Commands.Add("dispatch", "Open dispatch log", {}, false, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) or (Player.PlayerData.job.name == "ambulance" and Player.PlayerData.job.onduty) then
        TriggerClientEvent('framework-alerts:client:open:previous:alert', source, Player.PlayerData.job.name)
    end
end)