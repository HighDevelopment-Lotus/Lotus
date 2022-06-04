local LSCore = exports['fw-base']:GetCoreObject()

LSCore.Functions.CreateCallback("framework-fuel:server:get:fuel:config", function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback("framework-vehiclekeys:server:get:config", function(source, cb)
    cb(Config)
  end)
  
-- Code

LSCore.Commands.Add("motor", "Toggle motor aan/uit van het voertuig", {}, false, function(source, args)
    TriggerClientEvent('framework-vehiclekeys:client:toggle:engine', source)
end)


LSCore.Commands.Add("fix", "Repareer een voertuig", {}, false, function(source, args)
    TriggerClientEvent('framework-vehiclefailure:client:fix:veh', source)
end, "admin")

RegisterServerEvent('framework-fuel:server:set:fuel')
AddEventHandler('framework-fuel:server:set:fuel', function(Plate, Vehicle, Amount)
    Config.VehicleFuel[Plate] = Amount
    TriggerClientEvent('framework-fuel:client:sync:vehicle:fuel', -1, Plate, Config.VehicleFuel[Plate])
end)

RegisterServerEvent('framework-vehicles:server:register:nitrous')
AddEventHandler('framework-vehicles:server:register:nitrous', function(Plate)
	Config.NosActive[Plate] = 100
	TriggerClientEvent('framework-vehicles:client:sync:nitrous', -1, Config.NosActive)
end)

RegisterServerEvent('framework-vehicles:server:remove:amount:nitrous')
AddEventHandler('framework-vehicles:server:remove:amount:nitrous', function(Plate, RemoveAmount)
	Config.NosActive[Plate] = Config.NosActive[Plate] - RemoveAmount
	TriggerClientEvent('framework-vehicles:client:sync:nitrous', -1, Config.NosActive)
end)

RegisterServerEvent('framework-vehicles:server:remove:nitrous')
AddEventHandler('framework-vehicles:server:remove:nitrous', function(Plate)
	Config.NosActive[Plate] = nil
	TriggerClientEvent('framework-vehicles:client:sync:nitrous', -1, Config.NosActive)
end)

RegisterServerEvent('framework-vehicles:server:set:flames')
AddEventHandler('framework-vehicles:server:set:flames', function(Vehicle)
	TriggerClientEvent('framework-vehicles:client:set:flames', -1, Vehicle)
end)

RegisterServerEvent('framework-vehicles:server:remove:flames')
AddEventHandler('framework-vehicles:server:remove:flames', function(Vehicle)
	TriggerClientEvent('framework-vehicles:client:remove:flames', -1, Vehicle)
end)

RegisterServerEvent('framework-vehicles:server:recieve:papers')
AddEventHandler('framework-vehicles:server:recieve:papers', function(Plate)
	local Player = LSCore.Functions.GetPlayer(source)
	Player.Functions.AddItem('rentalpapers', 1, false, {plate = Plate}, true)
end)

-- Carwash

LSCore.Functions.CreateCallback('framework-carwash:server:can:wash', function(source, cb, price)
    local CanWash = false
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("bank", price) then
        CanWash = true
    else 
        CanWash = false
    end
    cb(CanWash)
end)

LSCore.Functions.CreateCallback("framework-vehiclekeys:server:is:vehicle:owner", function(source, cb, plate)
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

RegisterServerEvent('framework-vehiclekeys:server:set:keys')
AddEventHandler('framework-vehiclekeys:server:set:keys', function(Plate, Bool, PlayerId)
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
    TriggerClientEvent('framework-vehiclekeys:client:sync:keys', -1, Plate, Config.VehicleKeys[Plate])
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

RegisterServerEvent('framework-carwash:server:set:busy')
AddEventHandler('framework-carwash:server:set:busy', function(CarWashId, bool)
 Config.CarWashLocations[CarWashId]['Busy'] = bool
 TriggerClientEvent('framework-carwash:client:set:busy', -1, CarWashId, bool)
end)

RegisterServerEvent('framework-carwash:server:sync:wash')
AddEventHandler('framework-carwash:server:sync:wash', function(Vehicle)
 TriggerClientEvent('framework-carwash:client:sync:wash', -1, Vehicle)
end)

RegisterServerEvent('framework-carwash:server:sync:water')
AddEventHandler('framework-carwash:server:sync:water', function(WaterId)
 TriggerClientEvent('framework-carwash:client:sync:water', -1, WaterId)
end)

RegisterServerEvent('framework-carwash:server:stop:water')
AddEventHandler('framework-carwash:server:stop:water', function(WaterId)
 TriggerClientEvent('framework-carwash:client:stop:water', -1, WaterId)
end)
