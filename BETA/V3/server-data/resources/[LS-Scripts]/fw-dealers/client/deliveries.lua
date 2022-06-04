LSCore = exports['fw-base']:GetCoreObject()
local PlayerData            = {}
local SelectedID 			= nil
local Goons 				= {}
local JobVan

-- Blip Settings:
local DeliveryBlip
local blip
local DeliveryBlipCreated = false

-- Job Settings:
local isVehicleLockPicked = false
local JobVanPlate = ''
local DeliveryInProgress = false
local InsideJobVan = false
local vanIsDelivered = false

-- Delivery Stage:
local NearJobVehicle = false
local NearOtherVehicle = false
local drugsTaken = false
local drugBoxInHand = false
local isloaded = false

Citizen.CreateThread(function()
	while LSCore.Functions.GetPlayerData().job == nil do
		Citizen.Wait(300)
	end
	PlayerData = LSCore.Functions.GetPlayerData()
end)

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
	isloaded = true
end)

RegisterNetEvent('LSCore:Client:OnJobUpdate')
AddEventHandler('LSCore:Client:OnJobUpdate', function(job)
	PlayerData.job = job
end)

-- Usable Item Event:
RegisterNetEvent("t1ger_drugs:UsableItem")
AddEventHandler("t1ger_drugs:UsableItem",function()
	local player = PlayerPedId()
	
	TriggerEvent('framework-inv:client:set:inventory:state', false)
	if IsPedInAnyVehicle(player) then
		LSCore.Functions.Progressbar("connecting", "Ff lekker bellen", 2000, false, true, {}, {}, {}, {}, function() -- Done
		end, function() -- Cancel

		end)
		
	else
		FreezeEntityPosition(player,true)
		TaskStartScenarioInPlace(player, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
		LSCore.Functions.Progressbar("connecting", "Ff lekker bellen", 2000, false, true, {}, {}, {}, {}, function() -- Done
			TriggerEvent('framework-phone:client:notify', 'Pietje Koakloos', 'Ga naar de locatie aangewezen op je GPS', 10000)

		end, function() -- Cancel

		end)
	end
	Citizen.Wait(2000)
	
	FreezeEntityPosition(player,false)
	ClearPedTasks(player)
	ChooseDrugMenu()
	TriggerEvent('framework-inv:client:set:inventory:state', true)
end)

-- Function for Drugs Choose Menu:
function ChooseDrugMenu()
	TriggerServerEvent("t1ger_drugs:GetSelectedJob",'coke', '7000', math.random(1,10), math.random(19,39) )
end

-- Event to browse through available locations:
RegisterNetEvent("t1ger_drugs:BrowseAvailableJobs")
AddEventHandler("t1ger_drugs:BrowseAvailableJobs",function(spot,drugType,minReward,maxReward)
	local id = math.random(1,#Config.Jobs)
	local currentID = 0
	while Config.Jobs[id].InProgress and currentID < 100 do
		currentID = currentID+1
		id = math.random(1,#Config.Jobs)
	end
	if currentID == 100 then
		TriggerEvent('framework-phone:client:notify', 'Pietje Koakloos', 'Er zijn geen leveringen mogelijk probeer het later nog eens', 10000)
	else
		SelectedID = id
		TriggerEvent("t1ger_drugs:startMainEvent",id,drugType,minReward,maxReward)
		PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
	end
end)

-- Core Mission Part
RegisterNetEvent('t1ger_drugs:startMainEvent')
AddEventHandler('t1ger_drugs:startMainEvent', function(id,drugType,minReward,maxReward)
	local Goons = {}
	local selectedJob = Config.Jobs[id]
	local minRewardD = minReward
	local maxRewardD = maxReward
	local typeDrug = drugType
	selectedJob.InProgress = true
	TriggerServerEvent("t1ger_drugs:syncJobsData",Config.Jobs)
	Citizen.Wait(500)
	local playerPed = PlayerPedId()
	local JobCompleted = false
	local blip = CreateMissionBlip(selectedJob.Spot)
	
	while not JobCompleted and not StopTheJob do
		Citizen.Wait(0)
		
		if Config.Jobs[id].InProgress == true then
		
			local coords = GetEntityCoords(playerPed)
			
            -- if (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) > 60) and DeliveryInProgress == false then
			-- 	DrawMissionText("Ga naar het ~y~Busje~s~ gemarkeerd op je GPS")
			-- end
			
			if (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) < 150) and not selectedJob.VanSpawned then
				ClearAreaOfVehicles(selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, 15.0, false, false, false, false, false) 
				local jobCoords = {selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z}
				selectedJob.VanSpawned = true
				TriggerServerEvent("t1ger_drugs:syncJobsData",Config.Jobs)
				Citizen.Wait(500)
                while LSCore == nil do
                    Citizen.Wait(1)
                end
				local Plate = 'RE'..math.random(1111,9999)..'BO'
				local CoordsTable = {x = selectedJob.Spot.x, y = selectedJob.Spot.y, z = selectedJob.Spot.z, a = selectedJob.Heading}

				LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
					while not NetworkDoesEntityExistWithNetworkId(Veh) do
						Citizen.Wait(1000)
					end
					local Vehicle = NetToVeh(Veh)
					JobVan = Vehicle
					SetEntityAsMissionEntity(Vehicle, true, true)
					SetVehicleDoorsLockedForAllPlayers(Vehicle, true)
					exports['fw-vehicles']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
					LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
				end, Config.JobVan, CoordsTable, false, Plate)
			end	
			
			if (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) < 150) and not selectedJob.GoonsSpawned then
				ClearAreaOfPeds(selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, 50, 1)
				selectedJob.GoonsSpawned = true
				TriggerServerEvent("t1ger_drugs:syncJobsData",Config.Jobs)
				Citizen.Wait(500)
				SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("PLAYER"))
				AddRelationshipGroup('JobNPCs')
				local i = 0
				for k,v in pairs(selectedJob.Goons) do
					RequestModel(GetHashKey(v.ped))
					while not HasModelLoaded(GetHashKey(v.ped)) do
						Wait(1)
					end
					Goons[i] = CreatePed(4, GetHashKey(v.ped), v.x, v.y, v.z, v.h, false, true)
					NetworkRegisterEntityAsNetworked(Goons[i])
					SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(Goons[i]), true)
					SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(Goons[i]), true)
					SetPedCanSwitchWeapon(Goons[i], true)
					SetPedArmour(Goons[i], 100)
					SetPedAccuracy(Goons[i], 60)
					SetEntityInvincible(Goons[i], false)
					SetEntityVisible(Goons[i], true)
					SetEntityAsMissionEntity(Goons[i])
					RequestAnimDict(v.animDict) 
					while not HasAnimDictLoaded(v.animDict) do
						Citizen.Wait(0) 
					end 
					TaskPlayAnim(Goons[i], v.animDict, v.anim, 8.0, -8, -1, 49, 0, 0, 0, 0)
					GiveWeaponToPed(Goons[i], GetHashKey(v.weapon), 255, false, false)
					SetPedDropsWeaponsWhenDead(Goons[i], false)
					SetPedFleeAttributes(Goons[i], 0, false)	
					SetPedRelationshipGroupHash(Goons[i], GetHashKey("JobNPCs"))	
					TaskGuardCurrentPosition(Goons[i], 5.0, 5.0, 1)
					i = i +1
				end
            end
			
			if DeliveryInProgress == false and (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) < 60) and (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) > 10) then
				DrawMissionText("~r~Vermoord~s~ de bewakers rond het ~y~Busje~s~")
			end
			
			if selectedJob.VanSpawned and (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) < 60) and not selectedJob.JobPlayer then
				selectedJob.JobPlayer = true
				TriggerServerEvent("t1ger_drugs:syncJobsData",Config.Jobs)
				Citizen.Wait(500)
				SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("PLAYER"))
				AddRelationshipGroup('JobNPCs')
				local i = 0
                for k,v in pairs(selectedJob.Goons) do
                    ClearPedTasksImmediately(Goons[i])
                    i = i +1
                end
                SetRelationshipBetweenGroups(0, GetHashKey("JobNPCs"), GetHashKey("JobNPCs"))
                SetRelationshipBetweenGroups(5, GetHashKey("JobNPCs"), GetHashKey("PLAYER"))
                SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("JobNPCs"))
            end
			
			if isVehicleLockPicked == false and (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) < 10) then
				DrawMissionText("Breek de deur open van het ~y~busje~s~ en zorg dat je weg komt")
			end
			
			local VanPosition = GetEntityCoords(JobVan) 
			
			if (GetDistanceBetweenCoords(coords, VanPosition.x, VanPosition.y, VanPosition.z, true) <= 2) and isVehicleLockPicked == false then
				DrawText3Ds(VanPosition.x, VanPosition.y, VanPosition.z, "Druk ~g~[E]~s~ om ~y~open te breken~s~")
				if IsControlJustPressed(1, 38) then 
					LockpickJobVan(selectedJob)
					Citizen.Wait(500)
				end
			end
			
			if isVehicleLockPicked == true and vanIsDelivered == false then
				if not InsideJobVan then
					DrawMissionText("Geraak in het ~y~Busje~s~")
				end
			end
			
			if IsPedInAnyVehicle(PlayerPedId(), true) and isVehicleLockPicked == true then
				if GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) < 5 then
					local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
					if GetEntityModel(vehicle) == GetHashKey(Config.JobVan) then
						RemoveBlip(blip)
						for k,v in pairs(Config.DeliverySpot) do
							if DeliveryBlipCreated == false then
								PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
								DeliveryBlipCreated = true
								DeliveryBlip = AddBlipForCoord(v.x, v.y, v.z)
								SetBlipColour(DeliveryBlip,5)
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString("Delivery Location")
								EndTextCommandSetBlipName(DeliveryBlip)
								JobVanPlate = GetVehicleNumberPlateText(vehicle)
								SetBlipRoute(DeliveryBlip, true)
								SetBlipRouteColour(DeliveryBlip, 5)
							end	
						end
						
						DeliveryInProgress = true
					end
				end	
			end
						
			if DeliveryInProgress == true and isVehicleLockPicked == true and vanIsDelivered == false then
				if IsPedInAnyVehicle(PlayerPedId(), true) then
					local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
					if GetEntityModel(vehicle) == GetHashKey(Config.JobVan) then
						DrawMissionText("Lever het ~y~busje~s~ af op de GPS locatie")
					end
				end
			end
			
			if DeliveryInProgress == true then
                local coords = GetEntityCoords(PlayerPedId())
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if GetEntityModel(vehicle) == GetHashKey(Config.JobVan) then
                    InsideJobVan = true
                else
                    InsideJobVan = false
                end
				for k,v in pairs(Config.DeliverySpot) do
					if InsideJobVan then
						if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DeliveryDrawDistance) then
							DrawMarker(Config.DeliveryMarkerType, v.x, v.y, v.z-0.97, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, Config.DeliveryMarkerScale.x, Config.DeliveryMarkerScale.y, Config.DeliveryMarkerScale.z, Config.DeliveryMarkerColor.r, Config.DeliveryMarkerColor.g, Config.DeliveryMarkerColor.b, Config.DeliveryMarkerColor.a, false, true, 2, false, false, false, false)
						end
						if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 2.0) and vanIsDelivered == false then
							DrawText3Ds(v.x, v.y, v.z, "Druk ~g~[E]~s~ om ~y~af te leveren~s~")
							if IsControlJustPressed(0, 38) then 
								RemoveBlip(DeliveryBlip)
								vanIsDelivered = true
								
								SetVehicleForwardSpeed(JobVan, 0)
								SetVehicleEngineOn(JobVan, false, false, true)
								SetVehicleDoorOpen(JobVan, 2 , false, false)
								SetVehicleDoorOpen(JobVan, 3 , false, false)
								if IsPedInAnyVehicle(PlayerPedId(), true) then
									TaskLeaveVehicle(PlayerPedId(), JobVan, 4160)
									SetVehicleDoorsLockedForAllPlayers(JobVan, true)
								end
								Citizen.Wait(500)
								FreezeEntityPosition(JobVan, true)
							end
						end
					end
				end
			end
			
			if DeliveryInProgress == true and vanIsDelivered == true and not drugBoxInHand and not drugsTaken then
				DrawMissionText("Pak de ~b~drugs~s~  uit het ~y~busje~s~")
			end
			
			if DeliveryInProgress == true and vanIsDelivered == true and drugBoxInHand and not drugsTaken then
				DrawMissionText("Zet de ~b~drugs~s~ in je eigen ~y~voertuig~s~")
			end
			
			if vanIsDelivered == true then
                local coords = GetEntityCoords(PlayerPedId())
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if GetEntityModel(vehicle) == GetHashKey(Config.JobVan) then
                    InsideJobVan = true
                else
                    InsideJobVan = false
                end
				for k,v in pairs(Config.DeliverySpot) do
					if not InsideJobVan and drugsTaken == false then
						if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < ((Config.DeliveryMarkerScale.x)*4)) then
							if not IsPedInAnyVehicle(PlayerPedId(), true) then
								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 20.0, 0, 70)
								if GetEntityModel(vehicle) == GetHashKey(Config.JobVan) and not drugBoxInHand then
									local d1 = GetModelDimensions(GetEntityModel(vehicle))
									vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]+0.60,0.0)
									local Distance = GetDistanceBetweenCoords(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, coords.x, coords.y, coords.z, false);
									if Distance < 2.0 then
										DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, "Druk ~g~[E]~s~ om het ~y~pakketje~s~ te pakken")
										NearJobVehicle = true
									else
										NearJobVehicle = false
									end
								elseif GetEntityModel(vehicle) ~= GetHashKey(Config.JobVan) and drugBoxInHand then
									local d1 = GetModelDimensions(GetEntityModel(vehicle))
									vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]+0.60,0.0)
									local Distance = GetDistanceBetweenCoords(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, coords.x, coords.y, coords.z, false);
									if Distance < 2.0 then
										DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, "Druk ~g~[E]~s~ om het ~y~pakketje~s~ in je voertuig te stoppen")
										NearOtherVehicle = true
									else
										NearOtherVehicle = false
									end
								end
							end
						end
					end
				end
			end
			
			if NearJobVehicle == true and not drugBoxInHand and IsControlJustPressed(0, 38) then
				RequestAnimDict("anim@heists@box_carry@")
				while not HasAnimDictLoaded("anim@heists@box_carry@") do
					Citizen.Wait(10)
				end
				TaskPlayAnim(PlayerPedId(),"anim@heists@box_carry@","idle",1.0, -1.0, -1, 49, 0, 0, 0, 0)
				Citizen.Wait(300)
				attachModel = GetHashKey('prop_cs_cardbox_01')
				boneNumber = 28422
				SetCurrentPedWeapon(PlayerPedId(), 0xA2719263) 
				local bone = GetPedBoneIndex(PlayerPedId(), boneNumber)
				RequestModel(attachModel)
				while not HasModelLoaded(attachModel) do
					Citizen.Wait(100)
				end
				attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
				AttachEntityToEntity(attachedProp, PlayerPedId(), bone, 0.0, 0.0, 0.0, 135.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
				drugBoxInHand = true
			end
			
			if NearOtherVehicle == true and drugBoxInHand and IsControlJustPressed(0, 38) then
                -- LSCore.Functions.Notify("~g~Job completed~s~")
				TriggerEvent('framework-phone:client:notify', 'Pietje Koakloos', 'Goeie levering goos')
				PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
                ClearPedTasks(PlayerPedId())
                DeleteEntity(attachedProp)
				TriggerServerEvent("t1ger_drugs:JobReward")
				drugsTaken = true
				StopTheJob = true
			end
		
			if StopTheJob == true then
				
				Config.Jobs[id].InProgress = false
				Config.Jobs[id].VanSpawned = false
				Config.Jobs[id].GoonsSpawned = false
				Config.Jobs[id].JobPlayer = false
				TriggerServerEvent("t1ger_drugs:syncJobsData",Config.Jobs)
				Citizen.Wait(2000)
				DeleteVehicle(JobVan)
				
				if DeliveryInProgress == true then
					RemoveBlip(DeliveryBlip)
				else
					RemoveBlip(blip)
				end
				
				local i = 0
                for k,v in pairs(selectedJob.Goons) do
                    if DoesEntityExist(Goons[i]) then
                        DeleteEntity(Goons[i])
                    end
                    i = i +1
				end
				
				JobCompleted = true
				JobVanPlate = ''
				isVehicleLockPicked = false
				drugsTaken = false
				drugBoxInHand = false
				DeliveryInProgress = false
				vanIsDelivered = false
				DeliveryBlipCreated = false
				break
			end
			
		end		
	end	
end)

-- Function for lockpicking the van door:
function LockpickJobVan(selectedJob)
				
	local playerPed = PlayerPedId()
	
	local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
	local animName = "machinic_loop_mechandplayer"
	
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(50)
	end
	
	if Config.PoliceNotfiyEnabled == true then
		TriggerServerEvent('t1ger_drugs:DrugJobInProgress',GetEntityCoords(PlayerPedId()),streetName)
	end
	
	SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"),true)
	Citizen.Wait(500)
	FreezeEntityPosition(playerPed, true)
	TaskPlayAnimAdvanced(playerPed, animDict, animName, selectedJob.LockpickPos.x, selectedJob.LockpickPos.y, selectedJob.LockpickPos.z, 0.0, 0.0, selectedJob.LockpickHeading, 3.0, 1.0, -1, 31, 0, 0, 0 )
	LSCore.Functions.Progressbar("connecting", "DEUR OPENBREKEN", 7500, false, true, {}, {}, {}, {}, function() -- Done

	end, function() -- Cancel

	end)
	Citizen.Wait(7500)
	
	ClearPedTasks(playerPed)
	FreezeEntityPosition(playerPed, false)
	isVehicleLockPicked = true
	SetVehicleDoorsLockedForAllPlayers(JobVan, false)
end

-- Function for job blip in progress:
function CreateMissionBlip(location)
	local blip = AddBlipForCoord(location.x,location.y,location.z)
	SetBlipSprite(blip, 1)
	SetBlipColour(blip, 5)
	AddTextEntry('MYBLIP', "Drug Job")
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, 0.9) -- set scale
	SetBlipAsShortRange(blip, true)
	SetBlipRoute(blip, true)
	SetBlipRouteColour(blip, 5)
	return blip
end

-- Function for Mission text:
function DrawMissionText(text)
    SetTextScale(0.5, 0.5)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(0.5,0.955)
end

-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

-- AddEventHandler('LSCore:onPlayerDeath', function(data)
-- 	StopTheJob = true
-- 	TriggerServerEvent("t1ger_drugs:syncJobsData",Config.Jobs)
-- 	Citizen.Wait(5000)
-- 	StopTheJob = false
-- end)

RegisterNetEvent("t1ger_drugs:syncJobsData")
AddEventHandler("t1ger_drugs:syncJobsData",function(data)
	Config.Jobs = data
end)
