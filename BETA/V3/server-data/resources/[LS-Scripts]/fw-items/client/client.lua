local HairTied, HairSyles = false, nil
local CurrentVest, CurrentVestTexture, LigherIsHot = nil, nil, false
local UsingStick, WalkstickObject, ParachuteEquiped, UsingMedKit = false, nil, false, false
local SupportedModels = {[GetHashKey('mp_f_freemode_01')] = 4, [GetHashKey('mp_m_freemode_01')] = 7}
LSCore, LoggedIn, DoingSomething = exports['fw-base']:GetCoreObject(), false, false

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
-- 	   	Citizen.Wait(250)
-- 	   	LoggedIn = true
-- 	end)
-- end)

-- Code

RegisterNetEvent('framework-items:client:drink')
AddEventHandler('framework-items:client:drink', function(ItemName, PropName)
	if not exports['fw-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
			DoingSomething = true
			TriggerEvent('framework-inv:client:set:inventory:state', false)
 			Citizen.SetTimeout(1000, function()
				exports['fw-assets']:AddProp(PropName)
    			exports['fw-assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    	 		LSCore.Functions.Progressbar("drink", "Drinken..", 10000, false, true, {
 					disableMovement = false,
 					disableCarMovement = false,
 					disableMouse = false,
 					disableCombat = true,
				 }, {}, {}, {}, function() -- Done
					DoingSomething = false
					exports['fw-assets']:RemoveProp()
					TriggerEvent('framework-inv:client:set:inventory:state', true)
					StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
						LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove)
							if DidRemove then
								TriggerServerEvent("LSCore:Server:SetMetaData", "thirst", LSCore.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
							else
								LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
							end
						end, ItemName, 1, false)
				 	end, function()
					DoingSomething = false
					exports['fw-assets']:RemoveProp()
					TriggerEvent('framework-inv:client:set:inventory:state', true)
 					LSCore.Functions.Notify("Geannuleerd..", "error")
                    StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
 				end)
 			end)
		end
	end
end)

RegisterNetEvent('framework-items:client:drink:slushy')
AddEventHandler('framework-items:client:drink:slushy', function()
	if not exports['fw-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
			DoingSomething = true
			TriggerEvent('framework-inv:client:set:inventory:state', false)
    		Citizen.SetTimeout(1000, function()
    			exports['fw-assets']:AddProp('Cup')
    			exports['fw-assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    			LSCore.Functions.Progressbar("drink", "Drinken..", 10000, false, true, {
    				disableMovement = false,
    				disableCarMovement = false,
    				disableMouse = false,
    				disableCombat = true,
    			 }, {}, {}, {}, function() -- Done
					DoingSomething = false
    				exports['fw-assets']:RemoveProp()
    				TriggerEvent('framework-inv:client:set:inventory:state', true)
    				TriggerServerEvent('framework-ui:server:remove:stress', math.random(2, 4))
    				StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
						LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove)
							if DidRemove then
								TriggerServerEvent("LSCore:Server:SetMetaData", "thirst", LSCore.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
							else
								LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
							end
						end, 'slushy', 1, false)
    			 end, function()
					DoingSomething = false
    				exports['fw-assets']:RemoveProp()
    				TriggerEvent('framework-inv:client:set:inventory:state', true)
    				LSCore.Functions.Notify("Geannuleerd..", "error")
    				StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    			end)
    		end)
		end
	end
end)

RegisterNetEvent('framework-items:client:eat')
AddEventHandler('framework-items:client:eat', function(ItemName, PropName)
	if not exports['fw-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
			DoingSomething = true
			TriggerEvent('framework-inv:client:set:inventory:state', false)
 			Citizen.SetTimeout(1000, function()
				exports['fw-assets']:AddProp(PropName)
				exports['fw-assets']:RequestAnimationDict("mp_player_inteat@burger")
				TaskPlayAnim(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
 				LSCore.Functions.Progressbar("eat", "Eten..", 10000, false, true, {
 					disableMovement = false,
 					disableCarMovement = false,
 					disableMouse = false,
 					disableCombat = true,
				 }, {}, {}, {}, function() -- Done
					DoingSomething = false
					exports['fw-assets']:RemoveProp()
					TriggerEvent('framework-inv:client:set:inventory:state', true)
					StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
						LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove)
							if DidRemove then
								if ItemName == 'burger-heartstopper' then
									TriggerServerEvent("LSCore:Server:SetMetaData", "hunger", LSCore.Functions.GetPlayerData().metadata["hunger"] + math.random(40, 50))
									TriggerServerEvent("LSCore:Server:SetMetaData", "thirst", LSCore.Functions.GetPlayerData().metadata["thirst"] + math.random(40, 50))
								elseif  ItemName == 'burger-bleeder' then
									TriggerEvent('framework-hospital:client:revive')
								elseif  ItemName == 'burger-moneyshot' then
									MoneyShotEffect()
									TriggerServerEvent("LSCore:Server:SetMetaData", "hunger", LSCore.Functions.GetPlayerData().metadata["hunger"] + math.random(40, 50))
								elseif  ItemName == 'burger-torpedo' then
									TorpedoEffect()
								elseif  ItemName == 'macncheese' then
									TriggerServerEvent("LSCore:Server:SetMetaData", "hunger", LSCore.Functions.GetPlayerData().metadata["hunger"] + math.random(40, 50))
									TriggerServerEvent("LSCore:Server:SetMetaData", "thirst", LSCore.Functions.GetPlayerData().metadata["thirst"] + math.random(40, 50))
								else
									TriggerServerEvent("LSCore:Server:SetMetaData", "hunger", LSCore.Functions.GetPlayerData().metadata["hunger"] + math.random(20, 35))
								end
							else
								LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
							end
						end, ItemName, 1, false)
				 	end, function()
					DoingSomething = false
					exports['fw-assets']:RemoveProp()
					TriggerEvent('framework-inv:client:set:inventory:state', true)
 					LSCore.Functions.Notify("Geannuleerd..", "error")
					StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
 				end)
 			end)
		end
	end
end)

function MoneyShotEffect()
	local startlucky = 600
	TriggerServerEvent("LSCore:Server:SetMetaData", "lucky", true)
	while startlucky > 0 do 
		Citizen.Wait(1000)
		startlucky = startlucky - 1
	end
	startlucky = 0
	TriggerServerEvent("LSCore:Server:SetMetaData", "lucky", false)
end

function TorpedoEffect()
	local startStamina = 60
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
	while startStamina > 0 do 
		Citizen.Wait(1000)
		if math.random(1, 100) < 20 then
			RestorePlayerStamina(PlayerId(), 1.0)
		end
		startStamina = startStamina - 1
		if math.random(1, 100) < 10 and IsPedRunning(PlayerPedId()) then
			SetPedToRagdoll(PlayerPedId(), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
		end
		if math.random(1, 300) < 10 then
			Citizen.Wait(math.random(3000, 6000))
		end
	end
	if IsPedRunning(PlayerPedId()) then
	  SetPedToRagdoll(PlayerPedId(), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
	end
	startStamina = 0
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

RegisterNetEvent('framework-items:client:eat:fruit')
AddEventHandler('framework-items:client:eat:fruit', function(ItemName, PropName)
	if not exports['fw-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
		TriggerEvent('framework-inv:client:set:inventory:state', false)
 			Citizen.SetTimeout(1000, function()
				exports['fw-assets']:AddProp(PropName)
				exports['fw-assets']:RequestAnimationDict("mp_player_inteat@burger")
				TaskPlayAnim(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
 				LSCore.Functions.Progressbar("eat", "Eten..", 10000, false, true, {
 					disableMovement = false,
 					disableCarMovement = false,
 					disableMouse = false,
 					disableCombat = true,
				 }, {}, {}, {}, function() -- Done
					DoingSomething = false
					exports['fw-assets']:RemoveProp()
					TriggerEvent('framework-inv:client:set:inventory:state', true)
					StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
						LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove)
							if DidRemove then
								TriggerServerEvent("LSCore:Server:SetMetaData", "hunger", LSCore.Functions.GetPlayerData().metadata["hunger"] + math.random(15, 20))
								TriggerServerEvent("LSCore:Server:SetMetaData", "thirst", LSCore.Functions.GetPlayerData().metadata["thirst"] + math.random(5, 10))
							else
								LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
							end
						end, ItemName, 1, false)
				 	end, function()
					DoingSomething = false
					exports['fw-assets']:RemoveProp()
					TriggerEvent('framework-inv:client:set:inventory:state', true)
 					LSCore.Functions.Notify("Geannuleerd..", "error")
					StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
 				end)
 			end)
		end
	end
end)

RegisterNetEvent('framework-items:client:use:armor')
AddEventHandler('framework-items:client:use:armor', function()
	if not exports['fw-progressbar']:GetTaskBarStatus() then
 		local CurrentArmor = GetPedArmour(PlayerPedId())
 		if CurrentArmor < 100 then
			local NewArmor = CurrentArmor + 50
			if CurrentArmor + 50 > 100 then NewArmor = 100 end
			TriggerEvent('framework-inv:client:set:inventory:state', false)
			LSCore.Functions.Progressbar("vest", "Vest aantrekken..", 10000, false, true, {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function() -- Done
				TriggerEvent('framework-inv:client:set:inventory:state', true)
				LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove)
					if DidRemove then
						SetPedArmour(PlayerPedId(), NewArmor)
						TriggerServerEvent('framework-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
					else
						LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
					end
				end, 'armor', 1, false)
 		    end, function()
				TriggerEvent('framework-inv:client:set:inventory:state', true)
 		    	LSCore.Functions.Notify("Geannuleerd..", "error")
 		    end)
 		else
			LSCore.Functions.Notify("Je hebt al een vest om..", "error")
 		end
	end
end)

RegisterNetEvent("framework-items:client:use:heavy")
AddEventHandler("framework-items:client:use:heavy", function()
	if not exports['fw-progressbar']:GetTaskBarStatus() then
    	LSCore.Functions.Progressbar("use_heavyarmor", "Vest aantrekken..", 5000, false, true, {
    	disableMovement = false,
    	disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove)
				if DidRemove then
					if LSCore.Functions.GetPlayerData().charinfo.gender == 0 then
						CurrentVest = GetPedDrawableVariation(PlayerPedId(), 9)
						CurrentVestTexture = GetPedTextureVariation(PlayerPedId(), 9)
						if GetPedDrawableVariation(PlayerPedId(), 9) == 68 then
							SetPedComponentVariation(PlayerPedId(), 9, 70, GetPedTextureVariation(PlayerPedId(), 9), 2)
						else
							SetPedComponentVariation(PlayerPedId(), 9, 67, 0, 2)
						end
						SetPedArmour(PlayerPedId(), 100)
					else
						CurrentVest = GetPedDrawableVariation(PlayerPedId(), 9)
						CurrentVestTexture = GetPedTextureVariation(PlayerPedId(), 9)
						if GetPedDrawableVariation(PlayerPedId(), 9) == 68 then
							SetPedComponentVariation(PlayerPedId(), 9, 69, GetPedTextureVariation(PlayerPedId(), 9), 2)
						end
						SetPedArmour(PlayerPedId(), 100)
					end
					TriggerServerEvent('framework-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
				else
					LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
				end
			end, 'heavyarmor', 1, false)
		end, function() -- Cancel
    	    LSCore.Functions.Notify("Geannuleerd..", "error")
    	end)
	end
end)

RegisterNetEvent("framework-items:client:reset:armor")
AddEventHandler("framework-items:client:reset:armor", function()
	if not exports['fw-progressbar']:GetTaskBarStatus() then
    	local ped = PlayerPedId()
    	if CurrentVest ~= nil and CurrentVestTexture ~= nil then 
    	    LSCore.Functions.Progressbar("remove-armor", "Vest uittrekken..", 2500, false, false, {
    	        disableMovement = false,
    	        disableCarMovement = false,
    	        disableMouse = false,
    	        disableCombat = true,
    	    }, {}, {}, {}, function() -- Done
    	        SetPedComponentVariation(PlayerPedId(), 9, CurrentVest, CurrentVestTexture, 2)
    	        SetPedArmour(PlayerPedId(), 0)
				TriggerServerEvent('framework-items:server:return:heavy:armor')
				TriggerServerEvent('framework-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
				CurrentVest, CurrentVestTexture = nil, nil
    	    end)
    	else
    	    LSCore.Functions.Notify("Je hebt geen vest aan..", "error")
    	end
	end
end)

RegisterNetEvent("framework-items:client:use:lighter")
AddEventHandler("framework-items:client:use:lighter", function()
	if not LigherIsHot then
		LigherIsHot = true
		local FireInts = {}
		TriggerEvent('framework-sound:client:play', 'aansteker', 0.7)
		for i = 1, 4, 1 do
			local FireCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, tonumber(((i*0.5)+ 0.5)), 0)
			local zz, GroundZ = GetGroundZFor_3dCoord(FireCoords.x, FireCoords.y, FireCoords.z, 0)
			table.insert(FireInts, StartScriptFire(FireCoords.x, FireCoords.y, GroundZ, 10, false))
			if i == 2 or 3 then
				local FireCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.5, tonumber(((i*0.5)+ 0.5)), 0)
				local zz, GroundZ = GetGroundZFor_3dCoord(FireCoords.x, FireCoords.y, FireCoords.z, 0)
				table.insert(FireInts, StartScriptFire(FireCoords.x, FireCoords.y, GroundZ, 10, false))
				local FireCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.5, tonumber(((i*0.5)+ 0.5)), 0)
				local zz, GroundZ = GetGroundZFor_3dCoord(FireCoords.x, FireCoords.y, FireCoords.z, 0)
				table.insert(FireInts, StartScriptFire(FireCoords.x, FireCoords.y, GroundZ, 10, false))
			end
		end
		Citizen.Wait(500)
		for k, v in pairs(FireInts) do
			RemoveScriptFire(v)
		end
		Citizen.Wait(1500)
		LigherIsHot = false
	else
		LSCore.Functions.Notify("Wacht eem met die aansteker..", "error")
	end
end)

RegisterNetEvent('framework-items:client:use:tirekit')
AddEventHandler('framework-items:client:use:tirekit', function()
	if not exports['fw-progressbar']:GetTaskBarStatus() then
		local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
		if Vehicle ~= -1 and Distance < 5.0 then
			TriggerEvent('framework-inv:client:set:inventory:state', false)
			LSCore.Functions.Progressbar("repair_vehicle", "Banden verwisselen..", math.random(10000, 15000), false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {
				animDict = "mini@repair",
				anim = "fixing_a_player",
				flags = 16,
			}, {}, {}, function() -- Done
				TriggerEvent('framework-inv:client:set:inventory:state', true)
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
				if math.random(1, 50) < 10 then
					LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove)
						if DidRemove then
							NetworkRequestControlOfEntity(Vehicle)
							local Wheels = {0,1,4,5}
							for k, v in pairs(Wheels) do
								SetTyreHealth(Vehicle, v, 1000.0)
								SetVehicleTyreFixed(Vehicle, v)
							end
						else
							LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
						end
					end, 'tirekit', 1, false)
				else
					NetworkRequestControlOfEntity(Vehicle)
					local Wheels = {0,1,4,5}
					for k, v in pairs(Wheels) do
						SetTyreHealth(Vehicle, v, 1000.0)
						SetVehicleTyreFixed(Vehicle, v)
					end
				end
			end, function() -- Cancel
				TriggerEvent('framework-inv:client:set:inventory:state', true)
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
				LSCore.Functions.Notify("Mislukt!", "error")
			end)
		end
	end
end)

RegisterNetEvent('framework-items:client:use:repairkit')
AddEventHandler('framework-items:client:use:repairkit', function()
	if not exports['fw-progressbar']:GetTaskBarStatus() then
		local PlayerCoords = GetEntityCoords(PlayerPedId())
		local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
		if GetVehicleEngineHealth(Vehicle) < 1000.0 then
			NewHealth = GetVehicleEngineHealth(Vehicle) + 250.0
			if GetVehicleEngineHealth(Vehicle) + 250.0 > 1000.0 then 
				NewHealth = 1000.0 
			end
			if Distance < 4.0 and not IsPedInAnyVehicle(PlayerPedId()) then
				local EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, 2.5, 0)
				if IsBackEngine(GetEntityModel(Vehicle)) then
					EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -2.5, 0)
				end
				if GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, EnginePos) < 4.0 then
					local VehicleDoor = nil
					if IsBackEngine(GetEntityModel(Vehicle)) then
						VehicleDoor = 5
					else
						VehicleDoor = 4
					end
					SetVehicleDoorOpen(Vehicle, VehicleDoor, false, false)
					TriggerEvent('framework-inv:client:set:inventory:state', false)
					Citizen.Wait(450)
					LSCore.Functions.Progressbar("repair_vehicle", "Bezig met sleutelen..", math.random(10000, 20000), false, true, {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}, {
						animDict = "mini@repair",
						anim = "fixing_a_player",
						flags = 16,
					}, {}, {}, function() -- Done
						SetVehicleDoorShut(Vehicle, VehicleDoor, false)
						StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
						TriggerEvent('framework-inv:client:set:inventory:state', true)
						if math.random(1,50) < 10 then
							LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove)
								if DidRemove then
									NetworkRequestControlOfEntity(Vehicle)
									SetVehicleEngineHealth(Vehicle, NewHealth) 
								else
									LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
								end
							end, 'repairkit', 1, false)
						else
							NetworkRequestControlOfEntity(Vehicle)
							SetVehicleEngineHealth(Vehicle, NewHealth) 
						end
					end, function() -- Cancel
						TriggerEvent('framework-inv:client:set:inventory:state', true)
						StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
						LSCore.Functions.Notify("Mislukt!", "error")
						SetVehicleDoorShut(Vehicle, VehicleDoor, false)
					end)
				end
			else
				LSCore.Functions.Notify("Geen voertuig?!?", "error")
			end
		end	
	end
end)

RegisterNetEvent('framework-items:client:walkstick')
AddEventHandler('framework-items:client:walkstick', function()
	if not UsingStick then
		UsingStick = true
		RequestAnimSet('move_heist_lester')
		while not HasAnimSetLoaded('move_heist_lester') do
		  Citizen.Wait(1)
		end
		SetPedMovementClipset(PlayerPedId(), 'move_heist_lester', 1.0) 
		WalkstickObject = CreateObject(GetHashKey("prop_cs_walking_stick"), 0, 0, 0, true, true, true)
		AttachEntityToEntity(WalkstickObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.16, 0.06, 0.0, 335.0, 300.0, 120.0, true, true, false, true, 5, true)
	else
		UsingStick = false
		DetachEntity(WalkstickObject, 0, 0)
		DeleteEntity(WalkstickObject)
		ResetPedMovementClipset(PlayerPedId())
	end
end)

RegisterNetEvent('framework-items:client:showmedkit')
AddEventHandler('framework-items:client:showmedkit', function()
	if not UsingMedKit then
		UsingMedKit = true
		CaseObject = CreateObject(GetHashKey("prop_cs_shopping_bag"), 0, 0, 0, true, true, true)
		AttachEntityToEntity(WalkstickObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.16, 0.06, 0.0, 335.0, 300.0, 120.0, true, true, false, true, 5, true)
	else
		UsingMedKit = false
		DetachEntity(CaseObject, 0, 0)
		DeleteEntity(CaseObject)
	end
end)

RegisterNetEvent('framework-items:client:use:wheelchair')
AddEventHandler('framework-items:client:use:wheelchair', function()
	if not IsPedInAnyVehicle(PlayerPedId()) then
		LSCore.Functions.Progressbar("remove-armor", "Rolstoel plaatsen..", 1500, false, false, {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}, {
			animDict = "mp_common",
			anim = "givetake1_a",
			flags = 8,
		}, {}, {}, function() -- Done
			local PlayerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.75, 0) GetEntityCoords(PlayerPedId())
			local CoordTable = {x = PlayerCoords.x, y = PlayerCoords.y, z = PlayerCoords.z, a = GetEntityHeading(PlayerPedId())}
			LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
				while not NetworkDoesEntityExistWithNetworkId(Veh) do
					Citizen.Wait(1000)
				end
				local Vehicle = NetToVeh(Veh)
				exports['fw-vehicles']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
				exports['fw-vehicles']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
			end, 'wheelchair', CoordTable, false, false)
			LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'wheelchair', 1, false)
		end, function() -- Cancel
			LSCore.Functions.Notify("Mislukt!", "error")
		end)
	end
end)

RegisterNetEvent('framework-items:client:remove:wheelchair')
AddEventHandler('framework-items:client:remove:wheelchair', function()
	local Vehicle = LSCore.Functions.GetClosestVehicle()
	if IsVehicleSeatFree(Vehicle, -1) then
		LSCore.Functions.Progressbar("remove-armor", "Rolstoel Oppakken..", 1500, false, false, {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}, {
			animDict = "mp_common",
			anim = "givetake1_a",
			flags = 8,
		}, {}, {}, function() -- Done
			LSCore.Functions.DeleteVehicle(Vehicle)
			TriggerServerEvent('framework-items:server:return:wheelchair')
		end, function() -- Cancel
			LSCore.Functions.Notify("Mislukt!", "error")
		end)
	else
		LSCore.Functions.Notify("Jer zit nog iemand in de rolstoel joh...", "error")
	end
end)

RegisterNetEvent("framework-items:client:use:parachute")
AddEventHandler("framework-items:client:use:parachute", function()
	exports['fw-assets']:RequestAnimationDict("clothingshirt")
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    LSCore.Functions.Progressbar("use_parachute", "Parachute omdoen..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 1, false)
        local ParachuteData = {
            outfitData = {
                ["bag"]   = {item = 7, texture = 0},
            }
        }
        TriggerEvent('framework-clothing:client:loadOutfit', ParachuteData)
        TaskPlayAnim(PlayerPedId(), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
		LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'parachute', 1, false)
        ParachuteEquiped = true
    end)
end)

RegisterNetEvent("framework-items:client:reset:parachute")
AddEventHandler("framework-items:client:reset:parachute", function()
    if ParachuteEquiped then
		exports['fw-assets']:RequestAnimationDict("clothingshirt")
		TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        LSCore.Functions.Progressbar("reset_parachute", "Parachute inpakken..", 20000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            local ParachuteRemoveData = {
                outfitData = {
                    ["bag"] = { item = 0, texture = 0},
                }
            }
            TriggerEvent('framework-clothing:client:loadOutfit', ParachuteRemoveData)
            TaskPlayAnim(PlayerPedId(), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            ParachuteEquiped = false
        end)
    else
        LSCore.Functions.Notify("Je hebt geen parachute om!", "error")
    end
end)

RegisterNetEvent("framework-items:client:remove:facewear")
AddEventHandler("framework-items:client:remove:facewear", function(Type)
    if not LSCore.Functions.GetPlayerData().metadata["ishandcuffed"] then
        if Type == 'hat' then
			local HatProp = GetPedPropIndex(PlayerPedId(), 0)
			local HatTexture = GetPedPropTextureIndex(PlayerPedId(), 0)
            if HatProp ~= -1 then
               exports['fw-assets']:RequestAnimationDict("missheist_agency2ahelmet")
               TaskPlayAnim(PlayerPedId(), "missheist_agency2ahelmet", "take_off_helmet_stand", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
               TriggerServerEvent('framework-items:server:recieve:clothing', 'hat', false, HatTexture, HatProp)
               Citizen.Wait(800)
			   local ClothingData = {outfitData = {["hat"] = {item = -1, texture = 0}}}
			   TriggerEvent('framework-clothing:client:loadOutfit', ClothingData)
            else
               LSCore.Functions.Notify('Je hebt geen pet/hoed op..', 'error')
            end
        elseif Type == 'mask' then
            local MaskProp = GetPedDrawableVariation(PlayerPedId(), 1)
            local MaskPalette = GetPedPaletteVariation(PlayerPedId(), 1)
			local MaskTexture = GetPedTextureVariation(PlayerPedId(), 1)
            if MaskProp ~= -1 then
                exports['fw-assets']:RequestAnimationDict("missfbi4")
                TaskPlayAnim(PlayerPedId(), "missfbi4", "takeoff_mask", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
                TriggerServerEvent('framework-items:server:recieve:clothing', 'mask', MaskPalette, MaskTexture, MaskProp)
                Citizen.Wait(800)
				local ClothingData = {outfitData = {["mask"] = {item = -1, texture = 0}}}
				TriggerEvent('framework-clothing:client:loadOutfit', ClothingData)
            else
                LSCore.Functions.Notify('Je hebt geen masker op..', 'error')
            end
        elseif Type == 'glasses' then
			local GlassesProp = GetPedPropIndex(PlayerPedId(), 1)
			local GlassesTexture = GetPedPropTextureIndex(PlayerPedId(), 1)
			if GlassesProp ~= -1 then
				exports['fw-assets']:RequestAnimationDict("clothingspecs")
                TaskPlayAnim(PlayerPedId(), "clothingspecs", "take_off", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
				TriggerServerEvent('framework-items:server:recieve:clothing', 'glasses', false, GlassesTexture, GlassesProp)
				Citizen.Wait(800)
				local ClothingData = {outfitData = {["glass"] = {item = -1, texture = 0}}}
				TriggerEvent('framework-clothing:client:loadOutfit', ClothingData)
			end
        end
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("framework-items:client:add:facewear")
AddEventHandler("framework-items:client:add:facewear", function(Type, Info, Slot)
    if Type == 'hat' then
        if Info.prop ~= -1 then
            exports['fw-assets']:RequestAnimationDict("mp_masks@on_foot")
            TaskPlayAnim(PlayerPedId(), "mp_masks@on_foot", "put_on_mask", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
            LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'hat', 1, Slot)
            Citizen.Wait(800)
			local ClothingData = {outfitData = {["hat"] = {item = Info.prop, texture = Info.texture}}}
        	TriggerEvent('framework-clothing:client:loadOutfit', ClothingData)
        end
    elseif Type == 'mask' then
        if Info.prop ~= -1 then
            exports['fw-assets']:RequestAnimationDict("mp_masks@on_foot")
            TaskPlayAnim(PlayerPedId(), "mp_masks@on_foot", "put_on_mask", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
			LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'mask', 1, Slot)
            Citizen.Wait(800)
			local ClothingData = {outfitData = {["mask"] = {item = Info.prop, texture = Info.texture}}}
        	TriggerEvent('framework-clothing:client:loadOutfit', ClothingData)
        end
    elseif Type == 'glasses' then
		if Info.prop ~= -1 then
			exports['fw-assets']:RequestAnimationDict("clothingspecs")
			TaskPlayAnim(PlayerPedId(), "clothingspecs", "take_off", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
			LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'glasses', 1, Slot)
            Citizen.Wait(800)
			local ClothingData = {outfitData = {["glass"] = {item = Info.prop, texture = Info.texture}}}
        	TriggerEvent('framework-clothing:client:loadOutfit', ClothingData)
        end
    end
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("framework-items:client:use:hairtie")
AddEventHandler("framework-items:client:use:hairtie", function()
	local HairValue = SupportedModels[GetEntityModel(PlayerPedId())]
	if HairValue ~= nil then
		exports['fw-assets']:RequestAnimationDict("amb@code_human_wander_idles@female@idle_a")
		TaskPlayAnim(PlayerPedId(), "amb@code_human_wander_idles@female@idle_a", "idle_a_hairtouch", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
		Citizen.Wait(1000)
		if not HairTied then
			local HairDraw = GetPedDrawableVariation(PlayerPedId(), 2)
			local HairTexture = GetPedTextureVariation(PlayerPedId(), 2)
			local HairPallete = GetPedPaletteVariation(PlayerPedId(), 2)
			HairSyles = {HairDraw, HairTexture, HairPallete}
			SetPedComponentVariation(PlayerPedId(), 2, HairValue, HairTexture, HairPallete)
			HairTied = true
		else
			SetPedComponentVariation(PlayerPedId(), 2, HairSyles[1], HairSyles[2], HairSyles[3])
			HairTied, HairSyles = false, nil
		end
		ClearPedTasks(PlayerPedId())
	end
end)

RegisterNetEvent("framework-items:client:show:pass:fish")
AddEventHandler("framework-items:client:show:pass:fish", function(SourceId, data)
    local SourceCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(SourceId)), false)
    local PlayerCoords = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, SourceCoords.x, SourceCoords.y, SourceCoords.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Pas-ID:</strong> {1} <br><strong>Voornaam:</strong> {2} <br><strong>Achternaam:</strong> {3} <br><strong>BSN:</strong> {4} </div></div>',
            args = {'Advocatenpas', data.id, data.firstname, data.lastname, data.citizenid}
        })
    end
end)

local gender = ""
RegisterNetEvent("framework-items:client:show:id")
AddEventHandler("framework-items:client:show:id", function(sourceId, citizenid, character)
    if LSCore ~= nil then
        local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
        local pos = GetEntityCoords(PlayerPedId(), false)
        if (#(pos - sourcePos) < 2.0) then
                local geslacht = "man"
                if character.gender == 1 then
                    geslacht = "vrouw"
                end
                local pic = "images/"..geslacht..".png"
                
                TriggerEvent('chat:addMessage', {
                    template = '<div id="id-card"><img src="{7}" /><p id="bsn">{1}</p><p id="lastname">{3}</p><p id="name">{2}</p> <div id="inline"><p id="dob">{4}</p><p id="sex">{5}</p><p id="nationality">{6}</p></div><div id="licenses"></div><p id="signature">{2} {3}</p></div>',
                    args = {'ID-kaart', character.citizenid, character.firstname, character.lastname, character.birthdate, geslacht, character.nationality, pic}
                })
        end
    end
end)

RegisterNetEvent("framework-items:client:show:driver")
AddEventHandler("framework-items:client:show:driver", function(sourceId, citizenid, character)
    if LSCore ~= nil then
        local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
        local pos = GetEntityCoords(PlayerPedId(), false)
        if (#(pos - sourcePos) < 2.0) then
                local geslacht = "man"
                if character.gender == 1 then
                    geslacht = "vrouw"
                end
                local pic = "images/"..geslacht..".png"
                TriggerEvent('chat:addMessage', {
                    template = '<div id="license-card"><img src="{7}" /><p id="bsn2"></p><p id="lastname2">{3}</p><p id="name2">{2}</p><p id="dob2">{6}</p><div id="licenses">{5}</div><p id="signature2">{2} {3}</p></div>',
                    args = {'rijbwijs', character.citizenid, character.firstname, character.lastname, geslacht, character.type, character.birthdate, pic}
                })
        end
    end
end)

RegisterNetEvent('framework-items:client:dobbel')
AddEventHandler('framework-items:client:dobbel', function(Amount, Sides)
	local DiceResult = {}
	for i = 1, Amount do
		table.insert(DiceResult, math.random(1, Sides))
	end
	local RollText = CreateRollText(DiceResult, Sides)
	TriggerEvent('framework-items:client:dice:anim')
	Citizen.SetTimeout(1900, function()
		TriggerServerEvent('framework-sound:server:play:distance', 2.0, 'dice', 0.5)
		TriggerServerEvent('framework-assets:server:display:text', RollText)
	end)
end)

RegisterNetEvent('framework-items:client:coinflip')
AddEventHandler('framework-items:client:coinflip', function()
	local CoinFlip = {}
	local Random = math.random(1,2)
     if Random <= 1 then
		CoinFlip = 'Coinflip: ~g~Kop'
     else
		CoinFlip = 'Coinflip: ~y~Munt'
	 end
	 TriggerEvent('framework-items:client:dice:anim')
	 Citizen.SetTimeout(1900, function()
		TriggerServerEvent('framework-sound:server:play:distance', 2.0, 'coin', 0.3)
		TriggerServerEvent('framework-assets:server:display:text', CoinFlip)
	 end)
end)

RegisterNetEvent('framework-items:client:dice:anim')
AddEventHandler('framework-items:client:dice:anim', function()
	exports['fw-assets']:RequestAnimationDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(1500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('framework-items:client:use:duffel-bag')
AddEventHandler('framework-items:client:use:duffel-bag', function(BagId)
    if exports['fw-inv']:CanOpenInventory() then
        TriggerServerEvent('framework-inv:server:open:inventory:other', 'tas_'..BagId, 'Stash', 5, 25000, 'duffel-bag')
    end
end)

--  // Functions \\ --

function IsBackEngine(Vehicle)
    for _, model in pairs(Config.BackEngineVehicles) do
        if GetHashKey(model) == Vehicle then
            return true
        end
    end
    return false
end

function CreateRollText(Table, Sides)
    local String = "~g~Gedobbled~s~: "
    local Total = 0
    for k, v in pairs(Table) do
        Total = Total + v
        if k == 1 then
            String = String .. v .. "/" .. Sides
        else
            String = String .. " | " .. v .. "/" .. Sides
        end
    end
    String = String .. " | (Totaal: ~g~"..Total.."~s~)"
    return String
end