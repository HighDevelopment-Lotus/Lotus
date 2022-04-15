local LSCore = exports['fw-base']:GetCoreObject()

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- Code

LSCore.Functions.CreateCallback("framework-cardealer:server:get:config", function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback('framework-vehicleshop:server:get:config', function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback('framework-vehicleshop:server:can:purchase', function(source, cb, price)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.PlayerData.money['bank'] >= price then
		cb(true)
	else
		cb(false)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		Config.StoreVehicles[1]['Vehicle'] = GetRandomDealerVehicle('Sport')
		Config.StoreVehicles[2]['Vehicle'] = GetRandomDealerVehicle('Sedan')
		Config.StoreVehicles[3]['Vehicle'] = GetRandomDealerVehicle('Vans')
		Config.StoreVehicles[4]['Vehicle'] = GetRandomDealerVehicle('Muscle')
		Config.StoreVehicles[5]['Vehicle'] = GetRandomDealerVehicle('Coupe')
		Config.StoreVehicles[6]['Vehicle'] = GetRandomDealerVehicle('Addon')
		TriggerClientEvent('framework-vehicleshop:server:sync:config', -1, Config.StoreVehicles)
		Citizen.Wait((1000 * 60) * 5)
	end
end)

-- // Events \\ --

RegisterServerEvent('framework-vehicleshop:server:buy:vehicle')
AddEventHandler('framework-vehicleshop:server:buy:vehicle', function(VehicleModel)
	local src = source
	local Player = LSCore.Functions.GetPlayer(src)
	local VehicleData = LSCore.Shared.HashVehicles[VehicleModel]
	if VehicleData ~= nil then
		local Plate = GeneratePlate()
		local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
		Player.Functions.RemoveMoney("bank", VehicleData['Price'], "vehicle-shop")
        LSCore.Functions.InsertSql(false, "INSERT INTO `player_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..Player.PlayerData.citizenid.."', '"..VehicleData['Vehicle'].."', '"..Plate.."', 'Blokken Parking', 'out', '{}', '"..json.encode(VehicleMeta).."')")
        TriggerEvent("framework-logs:server:SendLog", "vehicleshop", "Voertuig gekocht (PDM)", "green", "**"..GetPlayerName(src) .. "** heeft een " ..VehicleData['Vehicle'].. " gekocht voor €" ..VehicleData['Price'])
        TriggerClientEvent('framework-vehicleshop:client:spawn:bought:vehicle', src, VehicleData['Vehicle'], Plate)
	end
end)

RegisterServerEvent('framework-vehicleshop:server:quick:sell')
AddEventHandler('framework-vehicleshop:server:quick:sell', function(Plate, VehicleData)
	local Player = LSCore.Functions.GetPlayer(source)
	local ReturnMoney = math.floor(VehicleData['Price'] / 2)
	Player.Functions.AddMoney('bank', ReturnMoney)
	TriggerClientEvent('LSCore:Notify', source, "Je verkocht je voertuig voor €"..ReturnMoney..',-')
	LSCore.Functions.ExecuteSql(false, "DELETE FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..Plate.."'")
end)

-- // Functions \\ --

function GetRandomDealerVehicle(Type)
	return Config.RandomVehicles[Type][math.random(1, #Config.RandomVehicles[Type])]
end

function GeneratePlate()
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
        end
        return plate
    end)
    return plate:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

-- PDM

LSCore.Functions.CreateCallback("framework-cardealer:server:get:cardealer:vehicles", function(source, cb, category)
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

LSCore.Functions.CreateCallback("framework-cardealer:server:get:vehicle:stock", function(source, cb, vehiclename)
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `server_cardealer` WHERE `vehicle` = '"..vehiclename.."'", function(result)
        if result ~= nil and result[1] ~= nil then
            cb(result[1].stock)
        end
    end)
end)

RegisterServerEvent('framework-cardealer:server:set:vehicle')
AddEventHandler('framework-cardealer:server:set:vehicle', function(data)
    Config.CardealerSpots[data['Location']]['Vehicle'] = data['Vehicle']
    TriggerClientEvent('framework-cardealer:client:sync:data', -1, Config.CardealerSpots)
end)

RegisterServerEvent('framework-cardealer:server:sell:closest')
AddEventHandler('framework-cardealer:server:sell:closest', function(PlayerId, VehicleHash)
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
                    TriggerEvent('framework-banking:server:set:business:accounts', 'Add', (VehicleData['Price'] / 100) * 10, 'CARDEALER', 'Voertuig aangekocht model: '..VehicleData['Brand']..' '..VehicleData['Name']..' kenteken: '..Plate, TargetPlayer.PlayerData.source)
                    TriggerClientEvent('framework-cardealer:client:spawn:vehicle', TargetPlayer.PlayerData.source, VehicleData['Vehicle'], Plate)
                    LSCore.Functions.ExecuteSql(false, "UPDATE `server_cardealer` SET stock = '"..NewStock.."' WHERE `vehicle` = '"..VehicleData['Vehicle'].."'")
                    LSCore.Functions.InsertSql(false, "INSERT INTO `player_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..TargetPlayer.PlayerData.citizenid.."', '"..VehicleData['Vehicle'].."', '"..Plate.."', 'Blokken Parking', 'out', '{}', '"..json.encode(VehicleMeta).."')")
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
            TargetPlayer.Functions.SetJob('cardealer', 1)
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
            TargetPlayer.Functions.SetJob('unemployed', 1)
        end
    end
end)
