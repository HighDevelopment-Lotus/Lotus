-- // Register Player Data in client \\ --
RegisterNetEvent('LSCore:Player:SetPlayerData')
AddEventHandler('LSCore:Player:SetPlayerData', function(val)
	LSCore.PlayerData = val
end)

RegisterNetEvent('LSCore:Player:UpdatePlayerData')
AddEventHandler('LSCore:Player:UpdatePlayerData', function()
	local Coords = LSCore.Functions.GetCoords(GetPlayerPed(-1))
	TriggerServerEvent('LSCore:UpdatePlayerPosition', Coords)
end)

RegisterNetEvent('LSCore:Player:Salary')
AddEventHandler('LSCore:Player:Salary', function()
	TriggerServerEvent('LSCore:Salary')
end)

-- // LSCore Command Events \\ --

RegisterNetEvent('LSCore:Command:TeleportToPlayer')
AddEventHandler('LSCore:Command:TeleportToPlayer', function(othersource)
	local coords = LSCore.Functions.GetCoords(GetPlayerPed(GetPlayerFromServerId(othersource)))
	local entity = GetPlayerPed(-1)
	if IsPedInAnyVehicle(entity, false) then
		entity = GetVehiclePedIsUsing(entity)
	end
	SetEntityCoords(entity, coords.x, coords.y, coords.z)
	SetEntityHeading(entity, coords.a)
end)

RegisterNetEvent('LSCore:Command:TeleportToCoords')
AddEventHandler('LSCore:Command:TeleportToCoords', function(x, y, z)
	local entity = GetPlayerPed(-1)
	if IsPedInAnyVehicle(entity, false) then
		entity = GetVehiclePedIsUsing(entity)
	end
	SetEntityCoords(entity, x, y, z)
end)

RegisterNetEvent('LSCore:client:spawn:vehicle')
AddEventHandler('LSCore:client:spawn:vehicle', function(Veh, Model)
	if IsModelValid(Model) then
		DoScreenFadeOut(250)
		Citizen.Wait(250)
		while not NetworkDoesEntityExistWithNetworkId(Veh) do
			Citizen.Wait(300)
		end
		Citizen.SetTimeout(100, function()
			local Vehicle = NetToVeh(Veh)
			exports['ls-vehiclekeys']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vehicle, -1)
			exports['ls-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, true)
			SetVehicleHasBeenOwnedByPlayer(Vehicle,  true)
			SetNetworkIdCanMigrate(Veh, true)
			SetVehicleNeedsToBeHotwired(Vehicle, false)
			SetVehRadioStation(Vehicle, "OFF")
			SetVehicleOnGroundProperly(Vehicle)
			DoScreenFadeIn(250)
			LSCore.Functions.Notify(Model..' ingespawned!', 'success')
		end)
	else
		LSCore.Functions.Notify('Model bestaat niet..', 'error')
	end
end)

RegisterNetEvent('LSCore:client:add:vehicle:properties')
AddEventHandler('LSCore:client:add:vehicle:properties', function(Veh)
	while not NetworkDoesEntityExistWithNetworkId(Veh) do
		Citizen.Wait(300)
	end
	local Vehicle = NetToVeh(Veh)
	while not DoesEntityExist(Vehicle) do
		Citizen.Wait(100)
	end
	SetVehicleHasBeenOwnedByPlayer(Vehicle,  true)
	SetNetworkIdCanMigrate(Veh, true)
	SetVehicleNeedsToBeHotwired(Vehicle, false)
	SetVehRadioStation(Vehicle, "OFF")
	SetVehicleOnGroundProperly(Vehicle)
	NetworkRegisterEntityAsNetworked(Vehicle)
end)

RegisterNetEvent('LSCore:client:set:vehicle:plate')
AddEventHandler('LSCore:client:set:vehicle:plate', function(Veh, Plate)
	while not NetworkDoesEntityExistWithNetworkId(Veh) do
		Citizen.Wait(300)
	end
	local Vehicle = NetToVeh(Veh)
	while not DoesEntityExist(Vehicle) do
		Citizen.Wait(100)
	end
	NetworkRequestControlOfEntity(Vehicle)
	SetVehicleNumberPlateText(Vehicle, Plate)
end)

RegisterNetEvent('LSCore:Command:DeleteVehicle')
AddEventHandler('LSCore:Command:DeleteVehicle', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
		LSCore.Functions.DeleteVehicle(Vehicle)
	else
		local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
		if Vehicle ~= -1 and Distance < 7.0 then
			LSCore.Functions.DeleteVehicle(Vehicle)
		end
	end
	LSCore.Functions.Notify('Succesvol voertuig verwijderd!', 'error')
end)

RegisterNetEvent('LSCore:Command:Revive')
AddEventHandler('LSCore:Command:Revive', function()
	local coords = LSCore.Functions.GetCoords(GetPlayerPed(-1))
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z+0.2, coords.a, true, false)
	SetPlayerInvincible(GetPlayerPed(-1), false)
	ClearPedBloodDamage(GetPlayerPed(-1))
end)

RegisterNetEvent('LSCore:Command:GoToMarker')
AddEventHandler('LSCore:Command:GoToMarker', function()
	Citizen.CreateThread(function()
		local entity = PlayerPedId()
		if IsPedInAnyVehicle(entity, false) then
			entity = GetVehiclePedIsUsing(entity)
		end
		local success = false
		local blipFound = false
		local blipIterator = GetBlipInfoIdIterator()
		local blip = GetFirstBlipInfoId(8)

		while DoesBlipExist(blip) do
			if GetBlipInfoIdType(blip) == 4 then
				cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector())) --GetBlipInfoIdCoord(blip)
				blipFound = true
				break
			end
			blip = GetNextBlipInfoId(blipIterator)
		end

		if blipFound then
			DoScreenFadeOut(250)
			while IsScreenFadedOut() do
				Citizen.Wait(250)
			end
			local groundFound = false
			local yaw = GetEntityHeading(entity)
			
			for i = 0, 1000, 1 do
				SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
				SetEntityRotation(entity, 0, 0, 0, 0 ,0)
				SetEntityHeading(entity, yaw)
				SetGameplayCamRelativeHeading(0)
				Citizen.Wait(0)
				--groundFound = true
				if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then --GetGroundZFor3dCoord(cx, cy, i, 0, 0) GetGroundZFor_3dCoord(cx, cy, i)
					cz = ToFloat(i)
					groundFound = true
					break
				end
			end
			if not groundFound then
				cz = -300.0
			end
			success = true
		end

		if success then
			SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
			SetGameplayCamRelativeHeading(0)
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
					SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
				end
			end
			DoScreenFadeIn(250)
		end
	end)
end)

-- Other stuff
RegisterNetEvent('LSCore:Client:LocalOutOfCharacter')
AddEventHandler('LSCore:Client:LocalOutOfCharacter', function(playerId, playerName, message)
	local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 20.0) then
		TriggerEvent("chatMessage", "OOC | "..playerName.." ["..playerId.."]", "normal", message)
    end
end)

RegisterNetEvent('LSCore:Notify')
AddEventHandler('LSCore:Notify', function(text, type, length)
	LSCore.Functions.Notify(text, type, length)
end)

RegisterNetEvent('LSCore:Client:CloseNui')
AddEventHandler('LSCore:Client:CloseNui', function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent('ls-core:client:opennui')
AddEventHandler('ls-core:client:opennui', function()
	SetNuiFocus(true, true)
end)

RegisterNetEvent('LSCore:Client:TriggerCallback')
AddEventHandler('LSCore:Client:TriggerCallback', function(name, ...)
	if LSCore.ServerCallbacks[name] ~= nil then
		LSCore.ServerCallbacks[name](...)
		LSCore.ServerCallbacks[name] = nil
	end
end)