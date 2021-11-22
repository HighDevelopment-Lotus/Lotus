local LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false
local AlertActive, MouseActive = false, false

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

RegisterNetEvent('LSCore:Client:CloseNui')
AddEventHandler('LSCore:Client:CloseNui', function()
    SetNuiFocus(false, false)
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsControlJustPressed(0, 19) then
                if AlertActive then
                    if not MouseActive then
                        if (LSCore.Functions.GetPlayerData().job.name == "police" or LSCore.Functions.GetPlayerData().job.name == "ambulance") and LSCore.Functions.GetPlayerData().job.onduty then
                            SetNuiFocus(true, true)
                            SetNuiFocusKeepInput(true, true)
                            SetCursorLocation(0.965, 0.12)
                            MouseActive = true
                        end
                    end
                end
            end
            if IsControlJustReleased(0, 19) then
                if MouseActive then
                    if (LSCore.Functions.GetPlayerData().job.name == "police" or LSCore.Functions.GetPlayerData().job.name == "ambulance") and LSCore.Functions.GetPlayerData().job.onduty then
                       MouseActive = false
                       SetNuiFocus(false, false)
                       DisablePlayerFiring(PlayerId(), false)
                       EnableControlAction(0, 24, true)
                       EnableControlAction(0, 25, true)
                       SetNuiFocusKeepInput(false, false)
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if MouseActive then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 289, true)
            DisableControlAction(0, 288, true)
            DisableControlAction(0, 346, true)
            DisablePlayerFiring(PlayerId(), true)
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Functions \\ --

function SendAlert(Data, ForBoth)
    if LoggedIn then
        local PlayerData = LSCore.Functions.GetPlayerData()
        if ForBoth then
            if (PlayerData.job.name == "police" or PlayerData.job.name == "ambulance") and PlayerData.job.onduty then
                AlertActive = true
                SendNuiMessage(json.encode({
                    action = 'SendAlert',
                    alertdata = Data,
                }))
                if Data['Type'] == 'Danger' then
                    TriggerServerEvent('ls-sound:server:play:distance', 5.0, "alert-panic-button", 0.5)
                elseif Data['Type'] == 'Almost' then
                    TriggerServerEvent("ls-sound:server:play:source", "alert-high-prio", 0.2)
                elseif Data['Type'] == 'Red' then
                    PlaySoundFrontend(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                    Citizen.Wait(100)
                    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                    Citizen.Wait(100)
                    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                    Citizen.Wait(100)
                    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                else
                    PlaySoundFrontend(-1, "Lose_1st", "GTAO_FM_Events_Soundset", true)
                end
            end
        else
            if (PlayerData.job.name == 'police') and PlayerData.job.onduty then
                AlertActive = true
                SendNuiMessage(json.encode({
                    action = 'SendAlert',
                    alertdata = Data,
                }))
                if Data['Type'] == 'Danger' then
                    TriggerServerEvent('ls-sound:server:play:distance', 5.0, "alert-panic-button", 0.5)
                elseif Data['Type'] == 'Almost' then
                    TriggerServerEvent("ls-sound:server:play:source", "alert-high-prio", 0.2)
                elseif Data['Type'] == 'Red' then
                    PlaySoundFrontend(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                    Citizen.Wait(100)
                    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                    Citizen.Wait(100)
                    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                    Citizen.Wait(100)
                    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                else
                    PlaySoundFrontend(-1, "Lose_1st", "GTAO_FM_Events_Soundset", true)
                end
            end
        end
    end
end

RegisterNUICallback('SetGps', function(data)
    SetNewWaypoint(data.Coords.x, data.Coords.y)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    LSCore.Functions.Notify("Gps ingesteld!", "success")
end)

RegisterNUICallback('CloseAlerts', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('NoActiveAlerts', function()
    SetNuiFocus(false, false)
    DisablePlayerFiring(PlayerId(), false)
    EnableControlAction(0, 24, true)
    EnableControlAction(0, 25, true)
    SetNuiFocusKeepInput(false, false)
    AlertActive = false
    MouseActive = false
end)

-- // Events \\ --

RegisterNetEvent('ls-alerts:client:open:previous:alert')
AddEventHandler('ls-alerts:client:open:previous:alert', function(JobName)
    SendNUIMessage({action = 'OpenPrevious'})
    SetCursorLocation(0.965, 0.12)
    SetNuiFocus(true, true)
end)