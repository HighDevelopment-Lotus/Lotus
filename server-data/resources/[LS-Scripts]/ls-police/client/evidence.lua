local ShowingInteractions, GunShotAlert, CameraActive = false, false, false
local PoliceStations = {[1] = {['Coords'] = vector3(473.78, -992.64, 26.27)}, [2] = {['Coords'] = vector3(-445.87, 6013.88, 31.71)}, [3] = {['Coords'] = vector3(-1080.35, -837.85, 13.52)}}

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LoggedIn then
			if IsPedShooting(GetPlayerPed(-1)) then
				local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
				if Weapon ~= GetHashKey("WEAPON_UNARMED") and Weapon ~= GetHashKey("WEAPON_SNOWBALL") and Weapon ~= GetHashKey("WEAPON_STUNGUN") and Weapon ~= GetHashKey("WEAPON_PETROLCAN") and Weapon ~= GetHashKey("WEAPON_FIREEXTINGUISHER") and Weapon ~= GetHashKey("WEAPON_MOLOTOV") then
					DropBulletCasing(Weapon)
				end
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
		  	if IsPedShooting(GetPlayerPed(-1)) then
		   		if PlayerJob.name ~= "police" then
		  			local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
		  			local GunCategory = GetWeaponCategory(Weapon)
		  			if not IsWeaponSilent(Weapon) then
						if not GunShotAlert then
		  					GunShotAlert = true
							TriggerServerEvent('ls-ui:server:gain:stress', math.random(1,3))
							if math.random(1, 10) == 1 then
		  						TriggerServerEvent('ls-police:server:send:alert:gunshots', GetEntityCoords(GetPlayerPed(-1)), GunCategory, LSCore.Functions.GetStreetLabel(), IsPedInAnyVehicle(GetPlayerPed(-1)))
		  						Citizen.SetTimeout(20000, function()
		  						 	GunShotAlert = false
		  		 				end)
							end
							Citizen.SetTimeout(20000, function()
								GunShotAlert = false
							end)
						end
		    		end
		  		end
			else
				Citizen.Wait(50)
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
			if PlayerJob.name == 'police' and PlayerJob.onduty then
				if IsPlayerFreeAiming(PlayerId()) and GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey("WEAPON_FLASHLIGHT") or CameraActive then
					local NearEvidence, NearSingle = false, false
					local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
					for k, v in pairs(Config.Evidence) do
						if Config.Evidence[k] ~= nil and Config.Evidence[k]['Coords'] ~= nil then
							local Distance = #(PlayerCoords - v['Coords'])
							if Distance < 10.0 then
								NearEvidence = true
								if v['Type'] == 'Blood' then
									DrawMarker(32, v['Coords'].x, v['Coords'].y, v['Coords'].z - 0.93, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.45, 0.1, 250, 0, 50, 255, false, false, false, true, false, false, false)
								elseif v['Type'] == 'Finger' then
									DrawMarker(32, v['Coords'].x, v['Coords'].y, v['Coords'].z - 0.93, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.45, 0.1, 89, 29, 138, 255, false, false, false, true, false, false, false)
								elseif v['Type'] == 'Slime' then
									DrawMarker(32, v['Coords'].x, v['Coords'].y, v['Coords'].z - 0.93, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.45, 0.1, 23, 173, 12, 255, false, false, false, true, false, false, false)
								elseif v['Type'] == 'Hair' then
									DrawMarker(32, v['Coords'].x, v['Coords'].y, v['Coords'].z - 0.93, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.45, 0.1, 247, 184, 10, 255, false, false, false, true, false, false, false)
								elseif v['Type'] == 'Bullet' then
									DrawMarker(32, v['Coords'].x, v['Coords'].y, v['Coords'].z - 0.93, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.45, 0.1, 50, 0, 250, 255, false, false, false, true, false, false, false)
								end						
								if Distance < 0.65 then
									NearSingle = true
									if not ShowingInteractions then
										exports['ls-ui']:HideInteraction()
										Citizen.Wait(350)
										ShowingInteractions = true
										exports['ls-ui']:ShowInteraction('[E] Bewijs', 'primary')
									end
									if IsControlJustReleased(0, 38) then
										if v['Weapon'] ~= nil then
											v['Ammo'] = Config.AmmoLabels[exports['ls-weapons']:GetAmmoType(v['Weapon'])]
										end
										local StreetLabel = LSCore.Functions.GetStreetLabel()
										TriggerServerEvent("ls-police:server:add:evidence", k, v, StreetLabel:gsub("%'", ""))
									end
								end
							end
						end
					end
					if not NearSingle then
						if ShowingInteractions then
							ShowingInteractions = false
							exports['ls-ui']:HideInteraction()
						end
					end
					if not NearEvidence then
						Citizen.Wait(500)
					end
				else
					if ShowingInteractions then
						ShowingInteractions = false
						exports['ls-ui']:HideInteraction()
					end
					Citizen.Wait(500)
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- // Events \\ --

RegisterNetEvent('ls-police:client:set:evidence')
AddEventHandler('ls-police:client:set:evidence', function(bool)
	CameraActive = bool
end)

RegisterNetEvent('ls-police:client:open:evidence')
AddEventHandler('ls-police:client:open:evidence', function(args)
 	local Coords = GetEntityCoords(GetPlayerPed(-1))
 	local NearPolice = false
 	for k, v in pairs(PoliceStations) do
		local Distance = #(Coords - v['Coords'])
 	  	if Distance <= 45.0 then
 	   		NearPolice = true
			if exports['ls-inventory-new']:CanOpenInventory() then
				TriggerServerEvent('ls-inventory-new:server:open:inventory:other', "evidencestash_"..args, 'Stash', 50, 2500000)
			end
 	  	end
 	end
 	if not NearPolice then
 	   LSCore.Functions.Notify("Je moet in de buurt zijn van een politie bureau..", "error")
 	end
end)

RegisterNetEvent('ls-police:client:sync:evidence')
AddEventHandler('ls-police:client:sync:evidence', function(EvidenceID, ConfigData)
	Config.Evidence[EvidenceID] = ConfigData
end)