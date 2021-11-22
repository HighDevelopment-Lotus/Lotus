local LSCore = exports['ls-core']:GetCoreObject()

-- Code

RegisterServerEvent('ls-vehicles:server:register:nitrous')
AddEventHandler('ls-vehicles:server:register:nitrous', function(Plate)
	Config.NosActive[Plate] = 100
	TriggerClientEvent('ls-vehicles:client:sync:nitrous', -1, Config.NosActive)
end)

RegisterServerEvent('ls-vehicles:server:remove:amount:nitrous')
AddEventHandler('ls-vehicles:server:remove:amount:nitrous', function(Plate, RemoveAmount)
	Config.NosActive[Plate] = Config.NosActive[Plate] - RemoveAmount
	TriggerClientEvent('ls-vehicles:client:sync:nitrous', -1, Config.NosActive)
end)

RegisterServerEvent('ls-vehicles:server:remove:nitrous')
AddEventHandler('ls-vehicles:server:remove:nitrous', function(Plate)
	Config.NosActive[Plate] = nil
	TriggerClientEvent('ls-vehicles:client:sync:nitrous', -1, Config.NosActive)
end)

RegisterServerEvent('ls-vehicles:server:set:flames')
AddEventHandler('ls-vehicles:server:set:flames', function(Vehicle)
	TriggerClientEvent('ls-vehicles:client:set:flames', -1, Vehicle)
end)

RegisterServerEvent('ls-vehicles:server:remove:flames')
AddEventHandler('ls-vehicles:server:remove:flames', function(Vehicle)
	TriggerClientEvent('ls-vehicles:client:remove:flames', -1, Vehicle)
end)

RegisterServerEvent('ls-vehicles:server:recieve:papers')
AddEventHandler('ls-vehicles:server:recieve:papers', function(Plate)
	local Player = LSCore.Functions.GetPlayer(source)
	Player.Functions.AddItem('rentalpapers', 1, false, {plate = Plate}, true)
end)