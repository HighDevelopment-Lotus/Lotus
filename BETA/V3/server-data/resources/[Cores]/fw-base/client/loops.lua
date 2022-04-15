Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if LoggedIn then
			TriggerServerEvent("LSCore:UpdatePlayer")
			Citizen.Wait((1000 * 60) * 8)
		else
			Citizen.Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if LoggedIn then
			Citizen.Wait((1000 * 60) * 10)
			TriggerEvent("LSCore:Player:Salary")
		else
			Citizen.Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if LoggedIn then
			local Position = LSCore.Functions.GetCoords(GetPlayerPed(-1))
			TriggerServerEvent('LSCore:UpdatePlayerPosition', Position)
			Citizen.Wait(10000)
		else
			Citizen.Wait(5000)
		end
	end
end)

-- // Food Enz \\ --
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LoggedIn then
			if LSCore.Functions.GetPlayerData().metadata["hunger"] <= 1 or LSCore.Functions.GetPlayerData().metadata["thirst"] <= 1 then
				if not LSCore.Functions.GetPlayerData().metadata["isdead"] then
					local CurrentHealth = GetEntityHealth(GetPlayerPed(-1))
					SetEntityHealth(GetPlayerPed(-1), CurrentHealth - math.random(5, 10))
				end
			end
			Citizen.Wait(math.random(4500, 5500))
		else
			Citizen.Wait(450)
		end
	end
end)