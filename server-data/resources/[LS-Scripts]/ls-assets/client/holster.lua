local WeaponHolstered, DidDisable, CanFire = true, true, true
local PoliceHolsterData = {['HolsterProp'] = nil}

-- // Loops \\ --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LoggedIn then
			if CanFire then
				if DidDisable then 
					DidDisable = false
					EnableControlAction(0, 25, true)
					DisablePlayerFiring(PlayerId(), false)
				end
			else
				DisableControlAction(0, 25, true)
				DisablePlayerFiring(PlayerId(), true)
				if not DidDisable then 
					DidDisable = true
				end
			end
		end
	end
end)

-- // Events \\ --

RegisterNetEvent('ls-assets:client:do:holster:anim')
AddEventHandler('ls-assets:client:do:holster:anim', function(WeaponName)
	RequestAnimationDict("reaction@intimidation@1h")
	RequestAnimationDict("reaction@intimidation@cop@unarmed")
	RequestAnimationDict("rcmjosh4")
	RequestAnimationDict("weapons@pistol@")
	if exports['ls-weapons']:GetWeaponList(GetHashKey(WeaponName)) ~= nil then
		local PlayerRotation = GetEntityHeading(PlayerPedId())
		if WeaponHolstered then
			if IsPlayerPolice() then
				CanFire = false
				local CurrentHolster = GetPedDrawableVariation(GetPlayerPed(-1), 7)
				PoliceHolsterData['HolsterProp'] = CurrentHolster
				TaskPlayAnimAdvanced(PlayerPedId(), "reaction@intimidation@cop@unarmed", "intro", GetEntityCoords(PlayerPedId(), true), 0, 0, PlayerRotation, 3.0, 3.0, -1, 50, 0, 0, 0)
				Citizen.Wait(150)
				if GetPlayerGender() == 'Man' then
					if CurrentHolster == 153 then
						SetPedComponentVariation(GetPlayerPed(-1), 7, 155, 0, 2)
					elseif CurrentHolster == 156 then
						SetPedComponentVariation(GetPlayerPed(-1), 7, 154, 0, 2)
					end
				else
					if CurrentHolster == 122 then
						SetPedComponentVariation(GetPlayerPed(-1), 7, 124, 0, 2)
					elseif CurrentHolster == 125 then
						SetPedComponentVariation(GetPlayerPed(-1), 7, 123, 0, 2)
					end
				end
				TaskPlayAnimAdvanced(PlayerPedId(), "rcmjosh4", "josh_leadout_cop2", GetEntityCoords(PlayerPedId(), true), 0, 0, PlayerRotation, 3.0, 3.0, -1, 50, 0, 0, 0)
				Citizen.Wait(600)
				ClearPedTasks(PlayerPedId())
				WeaponHolstered = false
				CanFire = true
			else
				CanFire = false
				TaskPlayAnimAdvanced(PlayerPedId(), "reaction@intimidation@1h", "intro", GetEntityCoords(PlayerPedId(), true), 0, 0, PlayerRotation, 8.0, 3.0, -1, 50, 0, 0, 0)
				Citizen.Wait(2700)
				ClearPedTasks(PlayerPedId())
				WeaponHolstered = false
				CanFire = true
			end
		else
			if IsPlayerPolice() then
				CanFire = false
				TaskPlayAnimAdvanced(PlayerPedId(), "rcmjosh4", "josh_leadout_cop2", GetEntityCoords(PlayerPedId(), true), 0, 0, PlayerRotation, 3.0, 3.0, -1, 50, 0, 0, 0)
				Citizen.Wait(300)
				SetPedComponentVariation(GetPlayerPed(-1), 7, PoliceHolsterData['HolsterProp'], 0, 2)
				PoliceHolsterData['HolsterProp'] = nil
				ClearPedTasks(PlayerPedId())
				WeaponHolstered = true
				CanFire = true
			else
				CanFire = false
				TaskPlayAnimAdvanced(PlayerPedId(), "reaction@intimidation@1h", "outro", GetEntityCoords(PlayerPedId(), true), 0, 0, PlayerRotation, 8.0, 3.0, -1, 50, 0, 0, 0)
				Citizen.Wait(1400)
				ClearPedTasks(PlayerPedId())
				WeaponHolstered = true
				CanFire = true
			end
		end
	end
end)

RegisterNetEvent('ls-assets:client:reset:holster')
AddEventHandler('ls-assets:client:reset:holster', function()
	if not WeaponHolstered then
		CanFire, WeaponHolstered = true, true
		if IsPlayerPolice() then
			SetPedComponentVariation(GetPlayerPed(-1), 7, PoliceHolsterData['HolsterProp'], 0, 2)
			PoliceHolsterData['HolsterProp'] = nil
		end
	end
end)

-- // Functions \\ --

function IsPlayerPolice()
	local PlayerData = LSCore.Functions.GetPlayerData()
	if PlayerData.job.name == 'police' then
		return true
	else
		return false
	end
end

function GetPlayerGender()
	local PlayerData = LSCore.Functions.GetPlayerData()
	if PlayerData.charinfo.gender == 1 then
		return 'Vrouw'
	else
		return 'Man'
	end	
end