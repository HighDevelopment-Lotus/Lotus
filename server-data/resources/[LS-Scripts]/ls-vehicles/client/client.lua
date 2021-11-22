LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false
local Carrying, AttatchedEntity = false, nil

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
 	Citizen.SetTimeout(1250, function()
		LoggedIn = true
 	end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Citizen.CreateThread(function()
-- 	Citizen.SetTimeout(1, function()
-- 		TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end)    
-- 	   Citizen.Wait(250)
-- 	   LoggedIn = true
-- 	end)
-- end)

-- Code

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LoggedIn then
			if Carrying then
				if IsControlJustReleased(0, 38) then
					DetachEntity(AttatchedEntity, nil, nil)
					SetVehicleOnGroundProperly(AttatchedEntity)
					Carrying, AttatchedEntity = false, nil
					Citizen.Wait(150)
					ClearPedTasks(GetPlayerPed(-1))
					exports['ls-ui']:HideInteraction()
				end
				if IsEntityDead(PlayerPedId()) then
					DetachEntity(AttatchedEntity, nil, nil)
					SetVehicleOnGroundProperly(AttatchedEntity)
					Carrying, AttatchedEntity = false, nil
					Citizen.Wait(150)
					ClearPedTasks(GetPlayerPed(-1))
					exports['ls-ui']:HideInteraction()
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LoggedIn then
			if Carrying then
				if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
					exports['ls-assets']:RequestAnimationDict("anim@heists@box_carry@")
					TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@box_carry@', 'idle', 2.0, 2.0, -1, 51, 0, false, false, false)
				else
					Citizen.Wait(50)
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('ls-vehicles:client:carry:bicycle')
AddEventHandler('ls-vehicles:client:carry:bicycle', function(Nothing, Entity)
	if not Carrying then
		local PlayerBone = GetPedBoneIndex(PlayerPedId(), 0xE5F3)
		NetworkRequestControlOfEntity(Entity['Entity'])
		exports['ls-ui']:ShowInteraction('[E] Fiets Droppen', 'primary')
		AttachEntityToEntity(Entity['Entity'], PlayerPedId(), PlayerBone, 0.0, 0.24, 0.10, 340.0, 330.0, 330.0, true, true, false, true, 1, true)
		exports['ls-assets']:RequestAnimationDict("anim@heists@box_carry@")
		TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@box_carry@', 'idle', 2.0, 2.0, -1, 51, 0, false, false, false)
		AttatchedEntity = Entity['Entity']
		Carrying = true
	else
		LSCore.Functions.Notify('Je hebt al wat in je handen..', 'error', 5500)
	end
end)