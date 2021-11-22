local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Commands.Add("binds", "Open commandbinding menu", {}, false, function(source, args)
	TriggerClientEvent("ls-commandbinding:client:openUI", source)
end)

RegisterServerEvent('ls-commandbinding:server:set:keys')
AddEventHandler('ls-commandbinding:server:set:keys', function(keyMeta)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.SetMetaData("commandbinds", keyMeta)
end)