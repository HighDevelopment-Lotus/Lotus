local LSCore = exports['ls-core']:GetCoreObject()

-- Code

-- LSCore.Functions.CreateCallback('ls-assets:server:get:dui:data', function(source, cb)
--     cb(Config.SavedDuiData)
-- end)

RegisterServerEvent('ls-assets:server:tackle:player')
AddEventHandler('ls-assets:server:tackle:player', function(playerId)
    TriggerClientEvent("ls-assets:client:get:tackeled", playerId)
end)

RegisterServerEvent('ls-assets:server:display:text')
AddEventHandler('ls-assets:server:display:text', function(Text)
	TriggerClientEvent('ls-assets:client:me:show', -1, Text, source)
end)

RegisterServerEvent('ls-assets:server:drop')
AddEventHandler('ls-assets:server:drop', function()
	if not LSCore.Functions.HasPermission(source, 'admin') then
        local BanId = 'BAN-'..math.random(11111,99999)
        LSCore.Functions.ExecuteSql(false, "INSERT INTO `server_bans` (`banid`, `name`, `steam`, `license`, `reason`, `bannedby`) VALUES ('"..BanId.."', '"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', 'NUI Devtools zijn niet nodig om te roleplayen..', 'Server PC')")
        TriggerEvent("ls-logs:server:SendLog", "bans", "Verbannen", "green", "**Speler:** "..GetPlayerName(source).." \n**Reden:** NUI Devtools zijn niet nodig om te roleplayen..\n **Ban ID:** "..BanId.."\n**Door:** Server PC")
        DropPlayer(source, "\n🔰 Je bent verbannen van de server. \n🛑 Reden: NUI Devtools zijn niet nodig om te roleplayen..\n🛑 Ban ID: "..BanId.."\n🛑 Verbannen Door: Auto-Ban\n\n Voor een unban kan je een ticket openen op het forum")
	end
end)

LSCore.Commands.Add("shuff", "Van stoel schuiven", {}, false, function(source, args)
 TriggerClientEvent('ls-assets:client:seat:shuffle', source)
end)

LSCore.Commands.Add("me", "Karakter expresie", {}, false, function(source, args)
  local Text = table.concat(args, ' ')
  TriggerClientEvent('ls-assets:client:me:show', -1, Text, source)
end)

RegisterServerEvent('ls-assets:server:setup:trunk:data')
AddEventHandler('ls-assets:server:setup:trunk:data', function(Plate)
    Config.TrunkData[Plate] = {['Busy'] = false}
    TriggerClientEvent('ls-assets:client:sync:trunk:data', -1, Plate, Config.TrunkData[Plate])
end)

RegisterServerEvent('ls-assets:server:set:trunk:data')
AddEventHandler('ls-assets:server:set:trunk:data', function(Plate, Bool)
    Config.TrunkData[Plate]['Busy'] = Bool
    TriggerClientEvent('ls-assets:client:sync:trunk:data', -1, Plate, Config.TrunkData[Plate])
end)

RegisterServerEvent('ls-assets:server:set:dui:url')
AddEventHandler('ls-assets:server:set:dui:url', function(DuiId, URL)
    TriggerClientEvent('ls-assets:client:set:dui:url', -1, DuiId, URL)
end)

RegisterServerEvent('ls-assets:server:set:dui:data')
AddEventHandler('ls-assets:server:set:dui:data', function(DuiId, DuiData)
    Config.SavedDuiData[DuiId] = DuiData
    TriggerClientEvent('ls-assets:client:set:dui:data', -1, DuiId, Config.SavedDuiData[DuiId])
end)