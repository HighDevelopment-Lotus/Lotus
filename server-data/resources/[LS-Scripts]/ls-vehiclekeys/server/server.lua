local LSCore = exports['ls-core']:GetCoreObject()

LSCore.Functions.CreateCallback("ls-vehiclekeys:server:get:config", function(source, cb)
  cb(Config)
end)

-- Code

LSCore.Commands.Add("motor", "Toggle motor aan/uit van het voertuig", {}, false, function(source, args)
    TriggerClientEvent('ls-vehiclekeys:client:toggle:engine', source)
end)

LSCore.Functions.CreateCallback("ls-vehiclekeys:server:is:vehicle:owner", function(source, cb, plate)
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        local Player = LSCore.Functions.GetPlayer(source)
        if result[1] ~= nil then
            if result[1].citizenid == Player.PlayerData.citizenid then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('ls-vehiclekeys:server:set:keys')
AddEventHandler('ls-vehiclekeys:server:set:keys', function(Plate, Bool, PlayerId)
    local Player = LSCore.Functions.GetPlayer(source)
    if not PlayerId then
        if Config.VehicleKeys[Plate] ~= nil then
            Config.VehicleKeys[Plate][Player.PlayerData.citizenid] = Bool
        else
            Config.VehicleKeys[Plate] = {[Player.PlayerData.citizenid] = Bool}
        end
    else
        local TPlayer = LSCore.Functions.GetPlayer(tonumber(PlayerId))
        if Player.PlayerData.citizenid ~= TPlayer.PlayerData.citizenid then
            if Config.VehicleKeys[Plate] ~= nil then
                Config.VehicleKeys[Plate][TPlayer.PlayerData.citizenid] = Bool
            else
                Config.VehicleKeys[Plate] = {[TPlayer.PlayerData.citizenid] = Bool}
            end
        end
    end
    TriggerClientEvent('ls-vehiclekeys:client:sync:keys', -1, Plate, Config.VehicleKeys[Plate])
end)

function GetOwnerDbName(Cid)
    local ReturnName = 'Onbekend'
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid`= '"..Cid.."'", function(result) 
        if result[1] ~= nil then
            local Charinfo = json.decode(result[1].charinfo)
            ReturnName = Charinfo.firstname..' '..Charinfo.lastname
        end
    end)
    return ReturnName
end