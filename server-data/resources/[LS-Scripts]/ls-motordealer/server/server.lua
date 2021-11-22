local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback("ls-motordealer:server:get:config", function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback("ls-motordealer:server:get:motordealer:vehicles", function(source, cb, category)
    local RetrunTable = {}
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `server_motordealer` WHERE category = '"..category.."'", function(result)
        if result ~= nil and result[1] ~= nil then
            for k, v in pairs(result) do
                local SendData = {}
                SendData['Vehicle'] = v.vehicle
                SendData['Price'] = LSCore.Shared.Vehicles[v.vehicle]['Price']
                table.insert(RetrunTable, SendData)
            end
        end
    end)
    Citizen.SetTimeout(50, function()
        cb(RetrunTable)
    end)
end)

RegisterServerEvent('ls-motordealer:server:set:vehicle')
AddEventHandler('ls-motordealer:server:set:vehicle', function(data)
    Config.MotorShopSpots[data['Location']]['Vehicle'] = data['Vehicle']
    TriggerClientEvent('ls-motordealer:client:sync:data', -1, Config.MotorShopSpots)
end)

RegisterServerEvent('ls-motordealer:server:sell:closest')
AddEventHandler('ls-motordealer:server:sell:closest', function(PlayerId, VehicleHash)
    local SourcePlayer = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(PlayerId)
    local VehicleData = LSCore.Shared.HashVehicles[VehicleHash]
    if TargetPlayer ~= nil and VehicleData ~= nil then
        LSCore.Functions.ExecuteSql(false, "SELECT * FROM `server_motordealer` WHERE `vehicle` = '"..VehicleData['Vehicle'].."'", function(result)
            if result ~= nil and result[1] ~= nil then
                if TargetPlayer.PlayerData.money['bank'] >= VehicleData['Price'] then
                    TargetPlayer.Functions.RemoveMoney('bank', VehicleData['Price'])
                    local Plate = GeneratePlate()
                    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
                    TriggerEvent('ls-banking:server:set:business:accounts', 'Add', (VehicleData['Price'] / 100) * 30, 'motordealer', 'Voertuig aangekocht model: '..VehicleData['Brand']..' '..VehicleData['Name']..' kenteken: '..Plate, TargetPlayer.PlayerData.source)
                    TriggerClientEvent('ls-motordealer:client:spawn:vehicle', TargetPlayer.PlayerData.source, VehicleData['Vehicle'], Plate)
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

LSCore.Commands.Add("setmotor", "Neem een motordealer medewerker aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'motordealer' then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als motordealer medewerker! gefeliciteerd!', 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als motordealer medewerker!', 'success')
            TargetPlayer.Functions.SetJob('motordealer')
        end
    end
end)

LSCore.Commands.Add("firemotor", "Ontsla een motordealer medewerker", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'motordealer' then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'motordealer' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
            TargetPlayer.Functions.SetJob('unemployed')
        end
    end
end)