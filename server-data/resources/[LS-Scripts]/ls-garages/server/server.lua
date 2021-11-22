local LSCore = exports['ls-core']:GetCoreObject()

-- Code

-- // Callbacks \\ --

LSCore.Functions.CreateCallback("ls-garages:server:get:config", function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback("ls-garages:server:get:vehicle:mods", function(source, cb, Plate)
    LSCore.Functions.ExecuteSql(true, "SELECT `mods` FROM `player_vehicles` WHERE `plate` = '"..Plate.."'", function(result)
        if result ~= nil and result[1] ~= nil then
            local VehicleMods = json.decode(result[1].mods)
            cb(VehicleMods)
        else
            cb({})
        end
    end)
end)

LSCore.Functions.CreateCallback("ls-garage:server:is:vehicle:owner", function(source, cb, Plate)
    if Plate ~= nil and Plate ~= false then
        LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..Plate.."'", function(result)
            local Player = LSCore.Functions.GetPlayer(source)
            if result ~= nil and result[1] ~= nil then
                if result[1].citizenid == Player.PlayerData.citizenid then
                    cb(true)
                else
                    cb(false)
                end
            else
                cb(false)
            end
        end)
    else
        cb(false)
    end
end)

LSCore.Functions.CreateCallback('ls-garage:server:get:my:vehicles', function(source, cb)
    local ReturnData = {}
    local Player = LSCore.Functions.GetPlayer(source)
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result ~= nil and result[1] ~= nil then
            for k, v in pairs(result) do
                local GarageVehicle = {}
                GarageVehicle['VehicleName'] = v.vehicle
                GarageVehicle['VehicleLabel'] = LSCore.Shared.Vehicles[v.vehicle] ~= nil and LSCore.Shared.Vehicles[v.vehicle]['Brand']..' '..LSCore.Shared.Vehicles[v.vehicle]['Name'] or v.vehicle
                GarageVehicle['VehiclePlate'] = v.plate
                GarageVehicle['VehicleGarage'] = v.garage
                GarageVehicle['VehicleGarageState'] = v.state
                GarageVehicle['VehiclePrice'] = v.depotprice
                GarageVehicle['VehicleImage'] = LSCore.Shared.Vehicles[v.vehicle] ~= nil and LSCore.Shared.Vehicles[v.vehicle]['Image'] or false
                GarageVehicle['VehicleStatus'] = json.decode(v.metadata)
                table.insert(ReturnData, GarageVehicle)
            end
            cb(ReturnData)
        else
            cb({})
        end
    end)
end)

LSCore.Functions.CreateCallback('ls-garage:server:get:house:vehicles', function(source, cb, HouseName)
    local ReturnData = {}
    local Player = LSCore.Functions.GetPlayer(source)
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `garage` = '"..HouseName.."'", function(result)
        if result ~= nil and result[1] ~= nil then
            for k, v in pairs(result) do
                local GarageVehicle = {}
                GarageVehicle['VehicleName'] = v.vehicle
                GarageVehicle['VehicleLabel'] = LSCore.Shared.Vehicles[v.vehicle] ~= nil and LSCore.Shared.Vehicles[v.vehicle]['Brand']..' '..LSCore.Shared.Vehicles[v.vehicle]['Name'] or v.vehicle
                GarageVehicle['VehiclePlate'] = v.plate
                GarageVehicle['VehicleGarage'] = v.garage
                GarageVehicle['VehicleGarageState'] = v.state
                GarageVehicle['VehicleImage'] = LSCore.Shared.Vehicles[v.vehicle] ~= nil and LSCore.Shared.Vehicles[v.vehicle]['Image'] or false
                GarageVehicle['VehicleStatus'] = json.decode(v.metadata)
                table.insert(ReturnData, GarageVehicle)
            end
            cb(ReturnData)
        else
            cb({})
        end
    end)
end)

LSCore.Functions.CreateCallback('ls-garage:server:all:vehicles', function(source, cb)
    local ReturnData = {}
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles`", function(result)
        if result ~= nil and result[1] ~= nil then
            for k, v in pairs(result) do
                local GarageVehicle = {}
                GarageVehicle['VehicleName'] = v.vehicle
                GarageVehicle['VehicleLabel'] = LSCore.Shared.Vehicles[v.vehicle] ~= nil and LSCore.Shared.Vehicles[v.vehicle]['Brand']..' '..LSCore.Shared.Vehicles[v.vehicle]['Name'] or v.vehicle
                GarageVehicle['VehiclePlate'] = v.plate
                GarageVehicle['VehicleGarageState'] = v.state
                GarageVehicle['VehicleReason'] = v.impoundreason
                GarageVehicle['VehiclePrice'] = v.depotprice
                GarageVehicle['VehicleImage'] = LSCore.Shared.Vehicles[v.vehicle] ~= nil and LSCore.Shared.Vehicles[v.vehicle]['Image'] or false
                GarageVehicle['VehicleStatus'] = json.decode(v.metadata)
                table.insert(ReturnData, GarageVehicle)
            end
            cb(ReturnData)
        else
            cb({})
        end
    end)
end)

-- // Events \\ --

RegisterServerEvent('ls-garages:server:set:vehicle:state')
AddEventHandler('ls-garages:server:set:vehicle:state', function(Plate, State, VehicleData, Veh)
    if State == 'in' then
        if VehicleData ~= nil then
            LSCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET garage = '" ..VehicleData['Garage'].. "', state = 'in', metadata = '"..json.encode(VehicleData['MetaData']).."' WHERE `plate` = '"..Plate.."'")
        else
            LSCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET state = 'in' WHERE `plate` = '"..Plate.."'")
        end
        Config.OutsideVehicles[Plate] = nil
        TriggerClientEvent('ls-garages:client:sync:outside:vehicles', -1, Plate, Config.OutsideVehicles[Plate])
    elseif State == 'out' then
        LSCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET state = 'out', depotprice = 0 WHERE `plate` = '"..Plate.."'")
        Config.OutsideVehicles[Plate] = Veh
        TriggerClientEvent('ls-garages:client:sync:outside:vehicles', -1, Plate, Config.OutsideVehicles[Plate])
    elseif State == 'impounded' then
        LSCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET state = 'impounded', impoundreason = '"..VehicleData.."' WHERE `plate` = '"..Plate.."'")
    elseif State == 'depotprice' then
        LSCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET depotprice = '"..tonumber(VehicleData).."' WHERE `plate` = '"..Plate.."'")
    end
end)

RegisterServerEvent("ls-garage:server:save:vehicle:mods")
AddEventHandler("ls-garage:server:save:vehicle:mods", function(Plate, VehicleProps)
    LSCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `mods` = '"..json.encode(VehicleProps).."' WHERE `plate` = '"..Plate.."'")
end)