local HairTied, HairSyles = false, nil
local CurrentVest, CurrentVestTexture, LigherIsHot = nil, nil, false
local UsingStick, WalkstickObject, ParachuteEquiped = false, nil, false
local SupportedModels = {[GetHashKey('mp_f_freemode_01')] = 4, [GetHashKey('mp_m_freemode_01')] = 7}
LSCore, LoggedIn, DoingSomething = exports['ls-core']:GetCoreObject(), false, false

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

RegisterNetEvent('ls-items:client:drink')
AddEventHandler('ls-items:client:drink', function(ItemName, PropName)
	if not exports['ls-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
			DoingSomething = true
			TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
 			Citizen.SetTimeout(1000, function()
				exports['ls-assets']:AddProp(PropName)
    			exports['ls-assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    	 		LSCore.Functions.Progressbar("drink", "Drinken..", 10000, false, true, {
 					disableMovement = false,
 					disableCarMovement = false,
 					disableMouse = false,
 					disableCombat = true,
				 }, {}, {}, {}, function() -- Done
					DoingSomething = false
					exports['ls-assets']:RemoveProp()
					TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
					StopAnimTask(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
						LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove)
							if DidRemove then
								TriggerServerEvent("LSCore:Server:SetMetaData", "thirst", LSCore.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
							else
								LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
							end
						end, ItemName, 1, false)
				 	end, function()
					DoingSomething = false
					exports['ls-assets']:RemoveProp()
					TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
 					LSCore.Functions.Notify("Geannuleerd..", "error")
                    StopAnimTask(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
 				end)
 			end)
		end
	end
end)

RegisterNetEvent('ls-items:client:drink:slushy')
AddEventHandler('ls-items:client:drink:slushy', function()
	if not exports['ls-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
			DoingSomething = true
			TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
    		Citizen.SetTimeout(1000, function()
    			exports['ls-assets']:AddProp('Cup')
    			exports['ls-assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    			LSCore.Functions.Progressbar("drink", "Drinken..", 10000, false, true, {
    				disableMovement = false,
    				disableCarMovement = false,
    				disableMouse = false,
    				disableCombat = true,
    			 }, {}, {}, {}, function() -- Done
					DoingSomething = false
    				exports['ls-assets']:RemoveProp()
    				TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
    				TriggerServerEvent('ls-ui:server:remove:stress', math.random(12, 20))
    				StopAnimTask(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
						LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove)
							if DidRemove then
								TriggerServerEvent("LSCore:Server:SetMetaData", "thirst", LSCore.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
							else
								LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
							end
						end, 'slushy', 1, false)
    			 end, function()
					DoingSomething = false
    				exports['ls-assets']:RemoveProp()
    				TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
    				LSCore.Functions.Notify("Geannuleerd..", "error")
    				StopAnimTask(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    			end)
    		end)
		end
	end
end)

RegisterNetEvent('ls-items:client:eat')
AddEventHandler('ls-items:client:eat', function(ItemName, PropName)
	if not exports['ls-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
			DoingSomething = true
			TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
 			Citizen.SetTimeout(1000, function()
				exports['ls-assets']:AddProp(PropName)
				exports['ls-assets']:RequestAnimationDict("mp_player_inteat@burger")
				TaskPlayAnim(GetPlayerPed(-1), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
 				LSCore.Functions.Progressbar("eat", "Eten..", 10000, false, true, {
 					disableMovement = false,
 					disableCarMovement = false,
 					disableMouse = false,
 					disableCombat = true,
				 }, {}, {}, {}, function() -- Done
					DoingSomething = false
					exports['ls-assets']:RemoveProp()
					TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
					StopAnimTask(GetPlayerPed(-1), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
						LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove)
							if DidRemove then
								if ItemName == 'burger-heartstopper' or ItemName == 'macncheese' or ItemName == 'burger-bleeder' or ItemName == 'burger-moneyshot' or ItemName == 'burger-torpedo' then
									TriggerServerEvent("LSCore:Server:SetMetaData", "hunger", LSCore.Functions.GetPlayerData().metadata["hunger"] + math.random(40, 50))
								else
									TriggerServerEvent("LSCore:Server:SetMetaData", "hunger", LSCore.Functions.GetPlayerData().metadata["hunger"] + math.random(20, 35))
								end
							else
								LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
							end
						end, ItemName, 1, false)
				 	end, function()
					DoingSomething = false
					exports['ls-assets']:RemoveProp()
					TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
 					LSCore.Functions.Notify("Geannuleerd..", "error")
					StopAnimTask(GetPlayerPed(-1), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
 				end)
 			end)
		end
	end
end)

RegisterNetEvent('ls-items:client:eat:fruit')
AddEventHandler('ls-items:client:eat:fruit', function(ItemName, PropName)
	if not exports['ls-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
		TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
 			Citizen.SetTimeout(1000, function()
				exports['ls-assets']:AddProp(PropName)
				exports['ls-assets']:RequestAnimationDict("mp_player_inteat@burger")
				TaskPlayAnim(GetPlayerPed(-1), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
 				LSCore.Functions.Progressbar("eat", "Eten..", 10000, false, true, {
 					disableMovement = false,
 					disableCarMovement = false,
 					disableMouse = false,
 					disableCombat = true,
				 }, {}, {}, {}, function() -- Done
					DoingSomething = false
					exports['ls-assets']:RemoveProp()
					TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
					StopAnimTask(GetPlayerPed(-1), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
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
					exports['ls-assets']:RemoveProp()
					TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
 					LSCore.Functions.Notify("Geannuleerd..", "error")
					StopAnimTask(GetPlayerPed(-1), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
 				end)
 			end)
		end
	end
end)

RegisterNetEvent('ls-items:client:use:armor')
AddEventHandler('ls-items:client:use:armor', function()
	if not exports['ls-progressbar']:GetTaskBarStatus() then
 		local CurrentArmor = GetPedArmour(GetPlayerPed(-1))
 		if CurrentArmor < 100 then
			local NewArmor = CurrentArmor + 50
			if CurrentArmor + 50 > 100 then NewArmor = 100 end
			TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
			LSCore.Functions.Progressbar("vest", "Vest aantrekken..", 10000, false, true, {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function() -- Done
				TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
				LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove)
					if DidRemove then
						SetPedArmour(GetPlayerPed(-1), NewArmor)
						TriggerServerEvent('ls-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
					else
						LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
					end
				end, 'armor', 1, false)
 		    end, function()
				TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
 		    	LSCore.Functions.Notify("Geannuleerd..", "error")
 		    end)
 		else
			LSCore.Functions.Notify("Je hebt al een vest om..", "error")
 		end
	end
end)

RegisterNetEvent("ls-items:client:use:heavy")
AddEventHandler("ls-items:client:use:heavy", function()
	if not exports['ls-progressbar']:GetTaskBarStatus() then
    	LSCore.Functions.Progressbar("use_heavyarmor", "Vest aantrekken..", 5000, false, true, {
    	disableMovement = false,
    	disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove)
				if DidRemove then
					if LSCore.Functions.GetPlayerData().charinfo.gender == 0 then
						CurrentVest = GetPedDrawableVariation(GetPlayerPed(-1), 9)
						CurrentVestTexture = GetPedTextureVariation(GetPlayerPed(-1), 9)
						if GetPedDrawableVariation(GetPlayerPed(-1), 9) == 68 then
							SetPedComponentVariation(GetPlayerPed(-1), 9, 70, GetPedTextureVariation(GetPlayerPed(-1), 9), 2)
						else
							SetPedComponentVariation(GetPlayerPed(-1), 9, 67, 0, 2)
						end
						SetPedArmour(GetPlayerPed(-1), 100)
					else
						CurrentVest = GetPedDrawableVariation(GetPlayerPed(-1), 9)
						CurrentVestTexture = GetPedTextureVariation(GetPlayerPed(-1), 9)
						if GetPedDrawableVariation(GetPlayerPed(-1), 9) == 68 then
							SetPedComponentVariation(GetPlayerPed(-1), 9, 69, GetPedTextureVariation(GetPlayerPed(-1), 9), 2)
						end
						SetPedArmour(GetPlayerPed(-1), 100)
					end
					TriggerServerEvent('ls-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
				else
					LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
				end
			end, 'heavyarmor', 1, false)
		end, function() -- Cancel
    	    LSCore.Functions.Notify("Geannuleerd..", "error")
    	end)
	end
end)

RegisterNetEvent("ls-items:client:reset:armor")
AddEventHandler("ls-items:client:reset:armor", function()
	if not exports['ls-progressbar']:GetTaskBarStatus() then
    	local ped = GetPlayerPed(-1)
    	if CurrentVest ~= nil and CurrentVestTexture ~= nil then 
    	    LSCore.Functions.Progressbar("remove-armor", "Vest uittrekken..", 2500, false, false, {
    	        disableMovement = false,
    	        disableCarMovement = false,
    	        disableMouse = false,
    	        disableCombat = true,
    	    }, {}, {}, {}, function() -- Done
    	        SetPedComponentVariation(GetPlayerPed(-1), 9, CurrentVest, CurrentVestTexture, 2)
    	        SetPedArmour(GetPlayerPed(-1), 0)
				TriggerServerEvent('ls-items:server:return:heavy:armor')
				TriggerServerEvent('ls-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
				CurrentVest, CurrentVestTexture = nil, nil
    	    end)
    	else
    	    LSCore.Functions.Notify("Je hebt geen vest aan..", "error")
    	end
	end
end)

RegisterNetEvent("ls-items:client:use:lighter")
AddEventHandler("ls-items:client:use:lighter", function()
	if not LigherIsHot then
		LigherIsHot = true
		local FireInts = {}
		TriggerEvent('ls-sound:client:play', 'aansteker', 0.7)
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

RegisterNetEvent('ls-items:client:use:tirekit')
AddEventHandler('ls-items:client:use:tirekit', function()
	if not exports['ls-progressbar']:GetTaskBarStatus() then
		local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
		if Vehicle ~= -1 and Distance < 5.0 then
			TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
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
				TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
				StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
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
				TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
				StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
				LSCore.Functions.Notify("Mislukt!", "error")
			end)
		end
	end
end)

RegisterNetEvent('ls-items:client:use:repairkit')
AddEventHandler('ls-items:client:use:repairkit', function()
	if not exports['ls-progressbar']:GetTaskBarStatus() then
		local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
		local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
		if GetVehicleEngineHealth(Vehicle) < 1000.0 then
			NewHealth = GetVehicleEngineHealth(Vehicle) + 250.0
			if GetVehicleEngineHealth(Vehicle) + 250.0 > 1000.0 then 
				NewHealth = 1000.0 
			end
			if Distance < 4.0 and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
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
					TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
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
						StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
						TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
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
						TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
						StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
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

RegisterNetEvent('ls-items:client:walkstick')
AddEventHandler('ls-items:client:walkstick', function()
	if not UsingStick then
		UsingStick = true
		RequestAnimSet('move_heist_lester')
		while not HasAnimSetLoaded('move_heist_lester') do
		  Citizen.Wait(1)
		end
		SetPedMovementClipset(GetPlayerPed(-1), 'move_heist_lester', 1.0) 
		WalkstickObject = CreateObject(GetHashKey("prop_cs_walking_stick"), 0, 0, 0, true, true, true)
		AttachEntityToEntity(WalkstickObject, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.16, 0.06, 0.0, 335.0, 300.0, 120.0, true, true, false, true, 5, true)
	else
		UsingStick = false
		DetachEntity(WalkstickObject, 0, 0)
		DeleteEntity(WalkstickObject)
		ResetPedMovementClipset(GetPlayerPed(-1))
	end
end)

RegisterNetEvent('ls-items:client:use:wheelchair')
AddEventHandler('ls-items:client:use:wheelchair', function()
	if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
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
			local PlayerCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.75, 0) GetEntityCoords(GetPlayerPed(-1))
			local CoordTable = {x = PlayerCoords.x, y = PlayerCoords.y, z = PlayerCoords.z, a = GetEntityHeading(GetPlayerPed(-1))}
			LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
				while not NetworkDoesEntityExistWithNetworkId(Veh) do
					Citizen.Wait(1000)
				end
				local Vehicle = NetToVeh(Veh)
				exports['ls-vehiclekeys']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
				exports['ls-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
			end, 'wheelchair', CoordTable, false, false)
			LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'wheelchair', 1, false)
		end, function() -- Cancel
			LSCore.Functions.Notify("Mislukt!", "error")
		end)
	end
end)

RegisterNetEvent('ls-items:client:remove:wheelchair')
AddEventHandler('ls-items:client:remove:wheelchair', function()
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
			TriggerServerEvent('ls-items:server:return:wheelchair')
		end, function() -- Cancel
			LSCore.Functions.Notify("Mislukt!", "error")
		end)
	else
		LSCore.Functions.Notify("Jer zit nog iemand in de rolstoel joh...", "error")
	end
end)

RegisterNetEvent("ls-items:client:use:parachute")
AddEventHandler("ls-items:client:use:parachute", function()
	exports['ls-assets']:RequestAnimationDict("clothingshirt")
    TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    LSCore.Functions.Progressbar("use_parachute", "Parachute omdoen..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 1, false)
        local ParachuteData = {
            outfitData = {
                ["bag"]   = {item = 7, texture = 0},
            }
        }
        TriggerEvent('ls-clothing:client:loadOutfit', ParachuteData)
        TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
		LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'parachute', 1, false)
        ParachuteEquiped = true
    end)
end)

RegisterNetEvent("ls-items:client:reset:parachute")
AddEventHandler("ls-items:client:reset:parachute", function()
    if ParachuteEquiped then
		exports['ls-assets']:RequestAnimationDict("clothingshirt")
		TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
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
            TriggerEvent('ls-clothing:client:loadOutfit', ParachuteRemoveData)
            TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            ParachuteEquiped = false
        end)
    else
        LSCore.Functions.Notify("Je hebt geen parachute om!", "error")
    end
end)

RegisterNetEvent("ls-items:client:remove:facewear")
AddEventHandler("ls-items:client:remove:facewear", function(Type)
    if not LSCore.Functions.GetPlayerData().metadata["ishandcuffed"] then
        if Type == 'hat' then
			local HatProp = GetPedPropIndex(GetPlayerPed(-1), 0)
			local HatTexture = GetPedPropTextureIndex(GetPlayerPed(-1), 0)
            if HatProp ~= -1 then
               exports['ls-assets']:RequestAnimationDict("missheist_agency2ahelmet")
               TaskPlayAnim(GetPlayerPed(-1), "missheist_agency2ahelmet", "take_off_helmet_stand", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
               TriggerServerEvent('ls-items:server:recieve:clothing', 'hat', false, HatTexture, HatProp)
               Citizen.Wait(800)
			   local ClothingData = {outfitData = {["hat"] = {item = -1, texture = 0}}}
			   TriggerEvent('ls-clothing:client:loadOutfit', ClothingData)
            else
               LSCore.Functions.Notify('Je hebt geen pet/hoed op..', 'error')
            end
        elseif Type == 'mask' then
            local MaskProp = GetPedDrawableVariation(GetPlayerPed(-1), 1)
            local MaskPalette = GetPedPaletteVariation(GetPlayerPed(-1), 1)
			local MaskTexture = GetPedTextureVariation(GetPlayerPed(-1), 1)
            if MaskProp ~= -1 then
                exports['ls-assets']:RequestAnimationDict("missfbi4")
                TaskPlayAnim(GetPlayerPed(-1), "missfbi4", "takeoff_mask", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
                TriggerServerEvent('ls-items:server:recieve:clothing', 'mask', MaskPalette, MaskTexture, MaskProp)
                Citizen.Wait(800)
				local ClothingData = {outfitData = {["mask"] = {item = -1, texture = 0}}}
				TriggerEvent('ls-clothing:client:loadOutfit', ClothingData)
            else
                LSCore.Functions.Notify('Je hebt geen masker op..', 'error')
            end
        elseif Type == 'glasses' then
			local GlassesProp = GetPedPropIndex(GetPlayerPed(-1), 1)
			local GlassesTexture = GetPedPropTextureIndex(GetPlayerPed(-1), 1)
			if GlassesProp ~= -1 then
				exports['ls-assets']:RequestAnimationDict("clothingspecs")
                TaskPlayAnim(GetPlayerPed(-1), "clothingspecs", "take_off", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
				TriggerServerEvent('ls-items:server:recieve:clothing', 'glasses', false, GlassesTexture, GlassesProp)
				Citizen.Wait(800)
				local ClothingData = {outfitData = {["glass"] = {item = -1, texture = 0}}}
				TriggerEvent('ls-clothing:client:loadOutfit', ClothingData)
			end
        end
        ClearPedTasks(GetPlayerPed(-1))
    end
end)

RegisterNetEvent("ls-items:client:add:facewear")
AddEventHandler("ls-items:client:add:facewear", function(Type, Info, Slot)
    if Type == 'hat' then
        if Info.prop ~= -1 then
            exports['ls-assets']:RequestAnimationDict("mp_masks@on_foot")
            TaskPlayAnim(GetPlayerPed(-1), "mp_masks@on_foot", "put_on_mask", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
            LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'hat', 1, Slot)
            Citizen.Wait(800)
			local ClothingData = {outfitData = {["hat"] = {item = Info.prop, texture = Info.texture}}}
        	TriggerEvent('ls-clothing:client:loadOutfit', ClothingData)
        end
    elseif Type == 'mask' then
        if Info.prop ~= -1 then
            exports['ls-assets']:RequestAnimationDict("mp_masks@on_foot")
            TaskPlayAnim(GetPlayerPed(-1), "mp_masks@on_foot", "put_on_mask", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
			LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'mask', 1, Slot)
            Citizen.Wait(800)
			local ClothingData = {outfitData = {["mask"] = {item = Info.prop, texture = Info.texture}}}
        	TriggerEvent('ls-clothing:client:loadOutfit', ClothingData)
        end
    elseif Type == 'glasses' then
		if Info.prop ~= -1 then
			exports['ls-assets']:RequestAnimationDict("clothingspecs")
			TaskPlayAnim(GetPlayerPed(-1), "clothingspecs", "take_off", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
			LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'glasses', 1, Slot)
            Citizen.Wait(800)
			local ClothingData = {outfitData = {["glass"] = {item = Info.prop, texture = Info.texture}}}
        	TriggerEvent('ls-clothing:client:loadOutfit', ClothingData)
        end
    end
    ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent("ls-items:client:use:hairtie")
AddEventHandler("ls-items:client:use:hairtie", function()
	local HairValue = SupportedModels[GetEntityModel(PlayerPedId())]
	if HairValue ~= nil then
		exports['ls-assets']:RequestAnimationDict("amb@code_human_wander_idles@female@idle_a")
		TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_wander_idles@female@idle_a", "idle_a_hairtouch", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
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
		ClearPedTasks(GetPlayerPed(-1))
	end
end)

RegisterNetEvent("ls-items:client:show:pass:fish")
AddEventHandler("ls-items:client:show:pass:fish", function(SourceId, data)
    local SourceCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(SourceId)), false)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, SourceCoords.x, SourceCoords.y, SourceCoords.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Pas-ID:</strong> {1} <br><strong>Voornaam:</strong> {2} <br><strong>Achternaam:</strong> {3} <br><strong>BSN:</strong> {4} </div></div>',
            args = {'Advocatenpas', data.id, data.firstname, data.lastname, data.citizenid}
        })
    end
end)

RegisterNetEvent("ls-items:client:show:id")
AddEventHandler("ls-items:client:show:id", function(sourceId, citizenid, character)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        local gender = "Man"
        if character.gender == 1 then
            gender = "Vrouw"
        end
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>BSN:</strong> {1} <br><strong>Voornaam:</strong> {2} <br><strong>Achternaam:</strong> {3} <br><strong>Geboortedag:</strong> {4} <br><strong>Geslacht:</strong> {5} <br><strong>Nationaliteit:</strong> {6}</div></div>',
            args = {'ID-kaart', character.citizenid, character.firstname, character.lastname, character.birthdate, gender, character.nationality}
        })
    end
end)

RegisterNetEvent("ls-items:client:show:driver")
AddEventHandler("ls-items:client:show:driver", function(sourceId, citizenid, character)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Voornaam:</strong> {1} <br><strong>Achternaam:</strong> {2} <br><strong>Geboortedag:</strong> {3} <br><strong>Rijbewijzen:</strong> {4}</div></div>',
            args = {'Rijbewijs', character.firstname, character.lastname, character.birthdate, character.type}
        })
    end
end)

RegisterNetEvent('ls-items:client:dobbel')
AddEventHandler('ls-items:client:dobbel', function(Amount, Sides)
	local DiceResult = {}
	for i = 1, Amount do
		table.insert(DiceResult, math.random(1, Sides))
	end
	local RollText = CreateRollText(DiceResult, Sides)
	TriggerEvent('ls-items:client:dice:anim')
	Citizen.SetTimeout(1900, function()
		TriggerServerEvent('ls-sound:server:play:distance', 2.0, 'dice', 0.5)
		TriggerServerEvent('ls-assets:server:display:text', RollText)
	end)
end)

RegisterNetEvent('ls-items:client:coinflip')
AddEventHandler('ls-items:client:coinflip', function()
	local CoinFlip = {}
	local Random = math.random(1,2)
     if Random <= 1 then
		CoinFlip = 'Coinflip: ~g~Kop'
     else
		CoinFlip = 'Coinflip: ~y~Munt'
	 end
	 TriggerEvent('ls-items:client:dice:anim')
	 Citizen.SetTimeout(1900, function()
		TriggerServerEvent('ls-sound:server:play:distance', 2.0, 'coin', 0.3)
		TriggerServerEvent('ls-assets:server:display:text', CoinFlip)
	 end)
end)

RegisterNetEvent('ls-items:client:dice:anim')
AddEventHandler('ls-items:client:dice:anim', function()
	exports['ls-assets']:RequestAnimationDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(1500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('ls-items:client:use:duffel-bag')
AddEventHandler('ls-items:client:use:duffel-bag', function(BagId)
    if exports['ls-inventory-new']:CanOpenInventory() then
        TriggerServerEvent('ls-inventory-new:server:open:inventory:other', 'tas_'..BagId, 'Stash', 5, 25000, 'duffel-bag')
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