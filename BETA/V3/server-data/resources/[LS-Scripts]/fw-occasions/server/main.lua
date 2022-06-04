local LSCore = exports["fw-base"]:GetCoreObject()
-- Code

LSCore.Functions.CreateCallback('framework-occasions:server:getVehicles', function(source, cb)
    LSCore.Functions.ExecuteSql(true, 'SELECT * FROM `occasion_vehicles`', function(result)
        if result ~= nil then
            cb(result)
        else
            cb(nil)
        end
        -- print(result)
    end)
end)

-- LSCore.Functions.CreateCallback("framework-garage:server:checkVehicleOwner", function(source, cb, plate)
--     local src = source
--     local pData = LSCore.Functions.GetPlayer(src)

--     exports['oxmysql']:execute('SELECT * FROM player_vehicles WHERE plate = @plate AND citizenid = @citizenid', {['@plate'] = plate, ['@citizenid'] = pData.PlayerData.citizenid}, function(result)
--         if result[1] ~= nil then
--             cb(true)
--         else
--             cb(false)
--         end
--     end)
-- end)

LSCore.Functions.CreateCallback("framework-occasions:server:getSellerInformation", function(source, cb, citizenid)
    local src = source

    exports['oxmysql']:execute('SELECT * FROM players WHERE citizenid = @citizenid', {['@citizenid'] = citizenid}, function(result)
        if result[1] ~= nil then
            cb(result[1])
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('framework-occasions:server:ReturnVehicle')
AddEventHandler('framework-occasions:server:ReturnVehicle', function(vehicleData)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local GarageData = "Blokken Parking"
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    exports['oxmysql']:execute("SELECT * FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData['plate'].."'", function(result)
        if result ~= nil then 
            print('oja joh')
            if result[1].seller == Player.PlayerData.citizenid then
                -- LSCore.Functions.InsertSql(false, "INSERT INTO `player_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES (@citizenid, @vehicle, @plate, @garage, @state, @mods, @metadata)", {
                --     ['@citizenid'] = Player.PlayerData.citizenid,
                --     ['@vehicle'] = vehicleData["model"],
                --     ['@plate'] = vehicleData["plate"],
                --     ['@garage'] = GarageData,
                --     ['@state'] = 'out',
                --     ['@mods'] = '{}',
                --     ['@metadata'] = json.encode(VehicleMeta),
                -- })
                exports['oxmysql']:execute("UPDATE `player_vehicles` SET `citizenid` = '"..Player.PlayerData.citizenid.."' WHERE `plate` = '"..vehicleData["plate"].."'")
                exports['oxmysql']:execute("DELETE FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData['plate'].."'")
                TriggerClientEvent("framework-occasions:client:ReturnOwnedVehicle", src, result[1].mods)
                TriggerClientEvent('framework-occasion:client:refreshVehicles', -1)
            else
                TriggerClientEvent('LSCore:Notify', src, 'Dit is niet jouw voertuig...', 'error', 3500)
            end
        else
            TriggerClientEvent('LSCore:Notify', src, 'Voertuig bestaat niet...', 'error', 3500)
        end
    end)
end)

RegisterServerEvent('framework-occasions:server:sellVehicle')
AddEventHandler('framework-occasions:server:sellVehicle', function(vehiclePrice, vehicleData)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    LSCore.Functions.InsertSql(true, "INSERT INTO `occasion_vehicles` (`seller`, `price`, `description`, `plate`, `model`, `mods`, `occasionId`) VALUES ('"..Player.PlayerData.citizenid.."', '"..vehiclePrice.."', '"..escapeSqli(vehicleData.desc).."', '"..vehicleData.plate.."', '"..vehicleData.model.."', '"..json.encode(vehicleData.mods).."', '"..generateOID().."')")
    TriggerEvent("framework-log:server:CreateLog", "vehicleshop", "Voertuig te koop", "red", "**"..GetPlayerName(src) .. "** heeft een " .. vehicleData.model .. " te koop gezet voor "..vehiclePrice)
    TriggerClientEvent('framework-occasion:client:refreshVehicles', -1)
end)

RegisterServerEvent('framework-occasions:server:buyVehicle')
AddEventHandler('framework-occasions:server:buyVehicle', function(vehicleData)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local GarageData = "Blokken Parking"
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    local ownerCid = vehicleData['owner']
    local vehprice = vehicleData['price']
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData['plate'].."'", function(result)
        local bankAmount = Player.PlayerData.money["bank"]
        if result then 
            if bankAmount >= vehprice then
                Player.Functions.RemoveMoney('bank', vehprice, "occasions-bought-vehicle")
                exports['oxmysql']:execute("UPDATE `player_vehicles` SET `citizenid` = '"..Player.PlayerData.citizenid.."' WHERE `plate` = '"..vehicleData["plate"].."'")
                TriggerClientEvent('framework-occasions:client:BuyFinished', src, vehicleData["model"], vehicleData["plate"], result[1].mods)
                local recieverSteam = LSCore.Functions.GetPlayerByCitizenId(ownerCid)
                    if recieverSteam ~= nil then
                        recieverSteam.Functions.AddMoney('bank', math.ceil((vehprice / 100) * 77))
                        TriggerClientEvent('framework-phone:client:newMailNotify', recieverSteam.PlayerData.source, {
                            sender = "Autoscout Melding",
                            subject = "Uw voertuig is verkocht!",
                            message = "Je "..LSCore.Shared.Vehicles[vehicleData["model"]]["Name"].." is verkocht voor €"..vehprice..",-!"
                        })
                    else
                        local moneyInfo = json.decode(player[1].money)
                        moneyInfo.bank = math.ceil((moneyInfo.bank + (vehprice / 100) * 77))
                        exports['oxmysql']:execute("UPDATE `players` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..ownerCid.."'")
                    end
                    TriggerEvent('framework-phone:server:sendNewMailToOffline', ownerCid, {
                        sender = "Autoscout Melding",
                        subject = "U heeft een voertuig verkocht!",
                        message = "Je "..LSCore.Shared.Vehicles[vehicleData["model"]]["Name"].." is verkocht voor €"..vehprice..",-!"
                    })
                    
                    LSCore.Functions.ExecuteSql(false, "DELETE FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData["plate"].."'")
                    -- TriggerEvent("framework-log:server:CreateLog", "vehicleshop", "Occasion gekocht", "green", "**"..GetPlayerName(src) .. "** heeft een occasian gekocht voor "..result[1].price .. " (" .. result[1].plate .. ") van **"..player[1].citizenid.."**")
                    TriggerClientEvent('framework-occasion:client:refreshVehicles', -1)
            else
                TriggerClientEvent('LSCore:Notify', src, 'Je hebt niet voldoende geld...', 'error', 3500)
            end
        else
            TriggerClientEvent('LSCore:Notify', src, 'Voertuig bestaat niet...', 'error', 3500)
        end
    end)
end)

function generateOID()
    local num = math.random(1, 10)..math.random(111, 999)

    return "QK"..num
end

function round(number)
    return number - (number % 1)
end

function escapeSqli(str)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return str:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end