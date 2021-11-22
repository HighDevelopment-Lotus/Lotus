local LSCore = exports['ls-core']:GetCoreObject()

-- Code

RegisterServerEvent('ls-appartments:server:set:appartment:data')
AddEventHandler('ls-appartments:server:set:appartment:data', function(AppartmentName)
local Player = LSCore.Functions.GetPlayer(source)
local NewAppartmentData = {Id = Player.PlayerData.metadata['appartment-data'].Id, Name = AppartmentName}
    Player.Functions.SetMetaData("appartment-data", NewAppartmentData)
    TriggerClientEvent('ls-appartments:client:enter:appartment', source, true, AppartmentName)
end)

RegisterServerEvent('ls-appartments:server:logout')
AddEventHandler('ls-appartments:server:logout', function()
 local src = source
 local Player = LSCore.Functions.GetPlayer(src)
 local PlayerItems = Player.PlayerData.inventory
 TriggerClientEvent('ls-radio:onRadioDrop', src)
 if PlayerItems ~= nil then
    LSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `inventory` = '"..LSCore.EscapeSqli(json.encode(PlayerItems)).."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
 else
    LSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `inventory` = '{}' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
 end
 LSCore.Player.Logout(src)
 Citizen.Wait(450)
 TriggerClientEvent('ls-multichar:client:open:select', src)
end)

function GetAppartmentName(AppartmentId)
    if Config.Locations[AppartmentId] ~= nil then
        return Config.Locations[AppartmentId]['Label']
    else
        return 'Onbekent..'
    end
end

LSCore.Commands.Add("searchappartment", "Open een appartement stash", {{name="id", help="Appartement ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local AppartementID = args[1]
    if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'judge' and Player.PlayerData.metadata['ishighcommand'] then
        TriggerClientEvent('ls-appartments:client:open:appartment:stash', source, AppartementID)
    end
end)