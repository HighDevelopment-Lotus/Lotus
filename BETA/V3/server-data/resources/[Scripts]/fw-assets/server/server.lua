local LSCore = exports['fw-base']:GetCoreObject()

-- Code

-- LSCore.Functions.CreateCallback('framework-assets:server:get:dui:data', function(source, cb)
--     cb(Config.SavedDuiData)
-- end)

RegisterServerEvent('framework-assets:server:tackle:player')
AddEventHandler('framework-assets:server:tackle:player', function(playerId)
    TriggerClientEvent("framework-assets:client:get:tackeled", playerId)
end)

RegisterServerEvent('framework-assets:server:display:text')
AddEventHandler('framework-assets:server:display:text', function(Text)
	TriggerClientEvent('framework-assets:client:me:show', -1, Text, source)
end)

RegisterServerEvent('framework-assets:server:drop')
AddEventHandler('framework-assets:server:drop', function()
	if not LSCore.Functions.HasPermission(source, 'admin') then
        local BanId = 'BAN-'..math.random(11111,99999)
        LSCore.Functions.InsertSql(false, "INSERT INTO `server_bans` (`banid`, `name`, `steam`, `license`, `reason`, `bannedby`) VALUES ('"..BanId.."', '"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', 'NUI Devtools zijn niet nodig om te roleplayen..', 'Server PC')")
        TriggerEvent("framework-logs:server:SendLog", "bans", "Verbannen", "green", "**Speler:** "..GetPlayerName(source).." \n**Reden:** NUI Devtools zijn niet nodig om te roleplayen..\n **Ban ID:** "..BanId.."\n**Door:** Server PC")
        DropPlayer(source, "\n🔰 Je bent verbannen van de server. \n🛑 Reden: NUI Devtools zijn niet nodig om te roleplayen..\n🛑 Ban ID: "..BanId.."\n🛑 Verbannen Door: Auto-Ban\n\n Voor een unban kan je een ticket openen op het forum")
	end
end)

LSCore.Commands.Add("shuff", "Van stoel schuiven", {}, false, function(source, args)
 TriggerClientEvent('framework-assets:client:seat:shuffle', source)
end)

LSCore.Commands.Add("me", "Karakter expresie", {}, false, function(source, args)
  local Text = table.concat(args, ' ')
  TriggerClientEvent('framework-assets:client:me:show', -1, Text, source)
end)

RegisterServerEvent('framework-assets:server:setup:trunk:data')
AddEventHandler('framework-assets:server:setup:trunk:data', function(Plate)
    Config.TrunkData[Plate] = {['Busy'] = false}
    TriggerClientEvent('framework-assets:client:sync:trunk:data', -1, Plate, Config.TrunkData[Plate])
end)

RegisterServerEvent('framework-assets:server:set:trunk:data')
AddEventHandler('framework-assets:server:set:trunk:data', function(Plate, Bool)
    Config.TrunkData[Plate]['Busy'] = Bool
    TriggerClientEvent('framework-assets:client:sync:trunk:data', -1, Plate, Config.TrunkData[Plate])
end)

RegisterServerEvent('framework-assets:server:set:dui:url')
AddEventHandler('framework-assets:server:set:dui:url', function(DuiId, URL)
    TriggerClientEvent('framework-assets:client:set:dui:url', -1, DuiId, URL)
end)

RegisterServerEvent('framework-assets:server:set:dui:data')
AddEventHandler('framework-assets:server:set:dui:data', function(DuiId, DuiData)
    Config.SavedDuiData[DuiId] = DuiData
    TriggerClientEvent('framework-assets:client:set:dui:data', -1, DuiId, Config.SavedDuiData[DuiId])
end)


local oArray = {}
local oPlayerUse = {}

AddEventHandler('playerDropped', function()
    local oSource = source
    if oPlayerUse[oSource] ~= nil then
        oArray[oPlayerUse[oSource]] = nil
        oPlayerUse[oSource] = nil
    end
end)

RegisterServerEvent('framework-assets:Server:Enter')
AddEventHandler('framework-assets:Server:Enter', function(object, objectcoords)
    local oSource = source
    if oArray[objectcoords] == nil then
        oPlayerUse[oSource] = objectcoords
        oArray[objectcoords] = true
        TriggerClientEvent('framework-assets:Client:Animation', oSource, object, objectcoords)
    end
end)

RegisterServerEvent('framework-assets:Server:Leave')
AddEventHandler('framework-assets:Server:Leave', function(objectcoords)
    local oSource = source

    oPlayerUse[oSource] = nil
    oArray[objectcoords] = nil
end)
-- Items

LSCore.Functions.CreateUseableItem("nightvision", function(source)
    local player = LSCore.Functions.GetPlayer(source)
    if player ~= nil then
        TriggerClientEvent("framework-nightvision:client:toggle", source)
    end
end)