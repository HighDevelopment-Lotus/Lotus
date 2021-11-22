local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Commands.Add("fix", "Repareer een voertuig", {}, false, function(source, args)
    TriggerClientEvent('ls-vehiclefailure:client:fix:veh', source)
end, "admin")