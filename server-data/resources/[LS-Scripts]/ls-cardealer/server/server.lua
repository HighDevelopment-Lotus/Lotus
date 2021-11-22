local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback("ls-cardealer:server:get:config", function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback("ls-cardealer:server:get:cardealer:vehicles", function(source, cb, category)
    local RetrunTable = {}
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `server_cardealer` WHERE category = '"..category.."'", function(result)
        if result ~= nil and result[1] ~= nil then
            for k, v in pairs(result) do
                local SendData = {}
                SendData['Vehicle'] = v.vehicle
                SendData['Price'] = LSCore.Shared.Vehicles[v.vehicle]['Price']
                SendData['Stock'] = v.stock
                table.insert(RetrunTable, SendData)
            end
        end
    end)
    Citizen.SetTimeout(50, function()
        cb(RetrunTable)
    end)
end)

LSCore.Functions.CreateCallback("ls-cardealer:server:get:vehicle:stock", function(source, cb, vehiclename)
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `server_cardealer` WHERE `vehicle` = '"..vehiclename.."'", function(result)
        if result ~= nil and result[1] ~= nil then
            cb(result[1].stock)
        end
    end)
end)

RegisterServerEvent('ls-cardealer:server:set:vehicle')
AddEventHandler('ls-cardealer:server:set:vehicle', function(data)
    Config.CardealerSpots[data['Location']]['Vehicle'] = data['Vehicle']
    TriggerClientEvent('ls-cardealer:client:sync:data', -1, Config.CardealerSpots)
end)

RegisterServerEvent('ls-cardealer:server:sell:closest')
AddEventHandler('ls-cardealer:server:sell:closest', function(PlayerId, VehicleHash)
    local SourcePlayer = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(PlayerId)
    local VehicleData = LSCore.Shared.HashVehicles[VehicleHash]
    if TargetPlayer ~= nil and VehicleData ~= nil then
        LSCore.Functions.ExecuteSql(false, "SELECT * FROM `server_cardealer` WHERE `vehicle` = '"..VehicleData['Vehicle'].."'", function(result)
            if result ~= nil and result[1] ~= nil and result[1].stock > 0 then
                if TargetPlayer.PlayerData.money['bank'] >= VehicleData['Price'] then
                    TargetPlayer.Functions.RemoveMoney('bank', VehicleData['Price'])
                    local Plate = GeneratePlate()
                    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
                    local NewStock = (result[1].stock - 1)
                    TriggerEvent('ls-banking:server:set:business:accounts', 'Add', (VehicleData['Price'] / 100) * 10, 'CARDEALER', 'Voertuig aangekocht model: '..VehicleData['Brand']..' '..VehicleData['Name']..' kenteken: '..Plate, TargetPlayer.PlayerData.source)
                    TriggerClientEvent('ls-cardealer:client:spawn:vehicle', TargetPlayer.PlayerData.source, VehicleData['Vehicle'], Plate)
                    LSCore.Functions.ExecuteSql(false, "UPDATE `server_cardealer` SET stock = '"..NewStock.."' WHERE `vehicle` = '"..VehicleData['Vehicle'].."'")
                    LSCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..TargetPlayer.PlayerData.citizenid.."', '"..VehicleData['Vehicle'].."', '"..Plate.."', 'Blokken Parking', 'out', '{}', '"..json.encode(VehicleMeta).."')")
                else
                   TriggerClientEvent('LSCore:Notify', SourcePlayer.PlayerData.source, 'Burger heeft niet genoeg geld..', 'error')
                   TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je hebt niet genoeg geld..', 'error')
                end
            end
        end)
    end
end)

-- // Function \\ --

function GeneratePlate()
    local plate = tostring(LSCore.Shared.RandomInt(1)) .. LSCore.Shared.RandomStr(2) .. tostring(LSCore.Shared.RandomInt(3)) .. LSCore.Shared.RandomStr(2)
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = tostring(LSCore.Shared.RandomInt(1)) .. LSCore.Shared.RandomStr(2) .. tostring(LSCore.Shared.RandomInt(3)) .. LSCore.Shared.RandomStr(2)
        end
        return plate
    end)
    return plate:upper()
end

LSCore.Commands.Add("setcardealer", "Neem een cardealer medewerker aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'cardealer' then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als Cardealer medewerker! gefeliciteerd!', 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als Cardealer medewerker!', 'success')
            TargetPlayer.Functions.SetJob('cardealer')
        end
    end
end)

LSCore.Commands.Add("firecardealer", "Ontsla een cardealer medewerker", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'cardealer' then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'cardealer' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
            TargetPlayer.Functions.SetJob('unemployed')
        end
    end
end)
