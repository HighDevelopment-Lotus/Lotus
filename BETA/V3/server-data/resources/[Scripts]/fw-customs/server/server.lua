local LSCore = exports['fw-base']:GetCoreObject()

-- Code

RegisterServerEvent('lscustoms:server:setGarageBusy')
AddEventHandler('lscustoms:server:setGarageBusy', function(garage, busy)
	TriggerClientEvent('lscustoms:client:setGarageBusy', -1, garage, busy)
end)

RegisterServerEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button)
	local src = source
	local Player = LSCore.Functions.GetPlayer(src)
	if not button.purchased then
		if button.price then -- check if button have price
			if Player.Functions.RemoveItem("cash", button.price) then
				TriggerClientEvent("LSC:buttonSelected", source, name, button, true)
				TriggerEvent("framework-logs:server:SendLog", "vehicleupgrades", "Upgrade gekocht", "green", "**"..GetPlayerName(src).."** heeft en upgrade gekocht ("..name..") voor €" .. button.price)
			else
				TriggerClientEvent("LSC:buttonSelected", source, name, button, false)
			end
		end
	else
		TriggerClientEvent("LSC:buttonSelected", source, name, button, false)
	end
end)