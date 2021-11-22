local LSCore = exports['ls-core']:GetCoreObject()

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- Code

LSCore.Functions.CreateCallback('ls-vehicleshop:server:get:config', function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback('ls-vehicleshop:server:can:purchase', function(source, cb, price)
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
		TriggerClientEvent('ls-vehicleshop:server:sync:config', -1, Config.StoreVehicles)
		Citizen.Wait((1000 * 60) * 5)
	end
end)

-- // Events \\ --

RegisterServerEvent('ls-vehicleshop:server:buy:vehicle')
AddEventHandler('ls-vehicleshop:server:buy:vehicle', function(VehicleModel)
	local src = source
	local Player = LSCore.Functions.GetPlayer(src)
	local VehicleData = LSCore.Shared.HashVehicles[VehicleModel]
	if VehicleData ~= nil then
		local Plate = GeneratePlate()
		local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
		Player.Functions.RemoveMoney("bank", VehicleData['Price'], "vehicle-shop")
        LSCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..Player.PlayerData.citizenid.."', '"..VehicleData['Vehicle'].."', '"..Plate.."', 'Blokken Parking', 'out', '{}', '"..json.encode(VehicleMeta).."')")
        TriggerEvent("ls-logs:server:SendLog", "vehicleshop", "Voertuig gekocht (PDM)", "green", "**"..GetPlayerName(src) .. "** heeft een " ..VehicleData['Vehicle'].. " gekocht voor €" ..VehicleData['Price'])
        TriggerClientEvent('ls-vehicleshop:client:spawn:bought:vehicle', src, VehicleData['Vehicle'], Plate)
	end
end)

RegisterServerEvent('ls-vehicleshop:server:quick:sell')
AddEventHandler('ls-vehicleshop:server:quick:sell', function(Plate, VehicleData)
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