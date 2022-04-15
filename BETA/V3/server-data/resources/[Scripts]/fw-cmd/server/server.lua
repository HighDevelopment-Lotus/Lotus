local LSCore = exports['fw-base']:GetCoreObject()

-- Code

LSCore.Commands.Add("binds", "Open commandbinding menu", {}, false, function(source, args)
	TriggerClientEvent("framework-commandbinding:client:openUI", source)
end)

RegisterServerEvent('framework-commandbinding:server:set:keys')
AddEventHandler('framework-commandbinding:server:set:keys', function(keyMeta)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.SetMetaData("commandbinds", keyMeta)
end)