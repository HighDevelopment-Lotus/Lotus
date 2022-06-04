local LSCore, LoggedIn = exports['fw-base']:GetCoreObject(), false
local ShowedInteraction, CurrentDoor, Lockpicking = false, nil, false

-- Citizen.CreateThread(function()
--     TriggerEvent('framework-doors:client:setup')
--     LoggedIn = true
-- end)

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LSCore.Functions.TriggerCallback("framework-doors:server:get:config", function(config)
			Config = config
		end)
        Citizen.Wait(1000)
        TriggerEvent('framework-doors:client:setup')
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnJobUpdate')
AddEventHandler('LSCore:Client:OnJobUpdate', function()
    exports['fw-ui']:HideDoorInteraction()
    ShowedInteraction, CurrentDoor = false, -1
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearDoor = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(Config.Doors) do
                local Distance = #(PlayerCoords - v['DoorCoords'])
                if Distance < v['LockDistance'] then
                    NearDoor = true
                    if k == CurrentDoor then
                        if v['LockState'] == 1 or v['LockState'] == 4 then
                            if not ShowedInteraction then
                                exports['fw-ui']:HideDoorInteraction()
                                Citizen.Wait(500)
                                if CanOpenDoor(v['Authorized']) then
                                    exports['fw-ui']:DoorInteraction('<img src="./img/error.png" width="32px" height="32px">', 'error')
                                else
                                    exports['fw-ui']:DoorInteraction('<img src="./img/error.png" width="32px" height="32px">', 'error')
                                end
                                ShowedInteraction = true
                            end
                        else
                            if not ShowedInteraction then
                                exports['fw-ui']:HideDoorInteraction()
                                Citizen.Wait(500)
                                if CanOpenDoor(v['Authorized']) then
                                    -- exports['fw-ui']:DoorInteraction('<img src="./img/open.png" width="32px" height="32px">', 'success')
                                else
                                    -- exports['fw-ui']:DoorInteraction('<img src="./img/open.png" width="32px" height="32px">', 'success')
                                end
                                ShowedInteraction = true
                            end
                        end
                        if IsControlJustReleased(0, 38) or IsDisabledControlJustReleased(0, 38) then
                            if CanOpenDoor(v['Authorized']) then
                                ToggleDoorLocks(k, v)
                            end
                        end
                    else
                        if ShowedInteraction then
                            ShowedInteraction = false
                        end
                    end
                    CurrentDoor = k
                    --print(CurrentDoor)
                end
            end
            if not NearDoor then
                if ShowedInteraction then
                    ShowedInteraction = false
                    exports['fw-ui']:HideDoorInteraction()
                end
                Citizen.Wait(100)
                CurrentDoor = nil
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-doors:client:sync:doors')
AddEventHandler('framework-doors:client:sync:doors', function(DoorNumber, DoorState, ConfigData)
    Config.Doors[DoorNumber] = ConfigData
    DoorSystemSetDoorState(DoorNumber, DoorState, false, true)
    DoorSystemSetAutomaticRate(DoorNumber, 1.0, false, false)
    if DoorNumber == CurrentDoor then
        if DoorState == 0 then
            if CanOpenDoor(Config.Doors[CurrentDoor]['Authorized']) then
                exports['fw-ui']:HideDoorInteraction()
                -- exports['fw-ui']:EditDoorInteraction('<img src="./img/open.png" width="32px" height="32px">', 'success')
            else
                exports['fw-ui']:HideDoorInteraction()
                -- exports['fw-ui']:EditDoorInteraction('<img src="./img/open.png" width="32px" height="32px">', 'success')
            end
        else
            if CanOpenDoor(Config.Doors[CurrentDoor]['Authorized']) then
                exports['fw-ui']:EditDoorInteraction('<img src="./img/error.png" width="32px" height="32px">', 'error')
            else
                exports['fw-ui']:EditDoorInteraction('<img src="./img/error.png" width="32px" height="32px">', 'error')
            end
        end
    end
end)

RegisterNetEvent('framework-doors:client:setup')
AddEventHandler('framework-doors:client:setup', function()
    for k, v in pairs(Config.Doors) do
        if not IsDoorRegisteredWithSystem(k) then
            AddDoorToSystem(k, GetHashKey(v['DoorName']), v['DoorCoords'], false, false, false)
        end
        if v['DoorRange'] ~= nil then
            DoorSystemSetAutomaticDistance(k, v['DoorRange'], false, true)
        end
        DoorSystemSetAutomaticRate(k, 1.0, false, false)
        DoorSystemSetDoorState(k, v['LockState'], false, true)
    end
end)

RegisterNetEvent('framework-items:client:use:lockpick')
AddEventHandler('framework-items:client:use:lockpick', function(IsAdvanced)
    if CurrentDoor ~= nil then
        if Config.Doors[CurrentDoor]['LockState'] then
            if Config.Doors[CurrentDoor]['Pickable'] then
                if IsAdvanced then
		    		exports['fw-lockpick']:OpenLockpickGame(function(Success)
		    			if Success then
                            local LockPickTime = math.random(15000, 30000)
                            LockpickDoorAnim(LockPickTime)
		    				LSCore.Functions.Progressbar("lockpick-door", "Deur lockpicken..", LockPickTime, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                Lockpicking = false
                                ClearPedTasks(PlayerPedId())
                                LSCore.Functions.Notify('Het is gelukt!', 'success', 2500)
                                TriggerServerEvent('framework-doors:server:set:door:locks', CurrentDoor, 0)
                            end, function() -- Cancel
                                Lockpicking = false
                                ClearPedTasks(PlayerPedId())
                                LSCore.Functions.Notify("Proces geannuleerd..", "error")
                            end)
		    			else
		    				if math.random(1, 100) < 15 then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'advancedlockpick', 1, false)
		    				end
		    				LSCore.Functions.Notify('Het is niet gelukt..', 'error', 2500)
		    			end
					end)
				else
					LSCore.Functions.Notify('Deze lockpick is niet sterk genoeg..', 'error', 2500)
				end 
            else
                LSCore.Functions.Notify('Deze deur heeft een te sterk slot..', 'error', 2500)
            end
        else
            LSCore.Functions.Notify('Deze deur is al open..', 'error', 2500)
        end
    end
end)

-- // Functions \\ --

function ToggleDoorLocks(DoorNumber, DoorData)
    if DoorData['IsAGate'] then   
        LSCore.Functions.TriggerCallback("LSCore:HasItem", function(HasItem)
            if HasItem then
                OpenDoorAnimation(DoorData)
                if DoorData['LockState'] == 1 or DoorData['LockState'] == 4 then
                    TriggerServerEvent('framework-doors:server:set:door:locks', DoorNumber, 0)
                else
                    TriggerServerEvent('framework-doors:server:set:door:locks', DoorNumber, 1)
                end
            else
                LSCore.Functions.Notify('Je hebt geen garage afstandsbediening..', 'error', 2500)
            end
	    end, 'keyfob')
    else
        OpenDoorAnimation(DoorData)
        if DoorData['LockState'] == 1 or DoorData['LockState'] == 4 then
            TriggerServerEvent('framework-doors:server:set:door:locks', DoorNumber, 0)
        else
            TriggerServerEvent('framework-doors:server:set:door:locks', DoorNumber, 1)
        end
    end
end

function OpenDoorAnimation(Data)
    if Data['IsAGate'] then
        PlaySoundFromEntity(-1, "Keycard_Success", PlayerPedId(), "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 1, 5.0)
    else
        TriggerEvent('framework-sound:client:play', 'doorlock-keys', 0.4)
        exports['fw-assets']:RequestAnimationDict("anim@heists@keycard@")
        TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 48, 0, 0, 0, 0)
        Citizen.Wait(500)
        ClearPedTasks(PlayerPedId())
    end
end

function LockpickDoorAnim(Time)
    local Time = Time / 1000
    exports['fw-assets']:RequestAnimationDict("veh@break_in@0h@p_m_one@")
    TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
    Lockpicking = true
    Citizen.CreateThread(function()
        while Lockpicking do
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
            Time = Time - 1
            if Time <= 0 then
                Lockpicking = false
                StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
            end
        end
    end)
end

function CanOpenDoor(Authorized)
    local PlayerData = LSCore.Functions.GetPlayerData()
	for k, v in pairs(Authorized) do
		if v == PlayerData.job.name or v == PlayerData.gang.name then
			return true
		end
	end
	return false
end