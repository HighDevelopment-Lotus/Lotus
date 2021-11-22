local Seatbelt, CurrentVoice = false, 3

-- // Hud \\ --

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(4)
        if LoggedIn and not Restarting then
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)))
                local Rpm = GetVehicleCurrentRpm(GetVehiclePedIsIn(GetPlayerPed(-1)))
                SendNUIMessage({
                    action = "UpdateHud",
                    radio = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'radio:talking'),
                    talking = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:talking'),
                    swimming = IsPedSwimming(GetPlayerPed(-1)),
                    health = GetEntityHealth(PlayerPedId()),
                    armor = GetPedArmour(PlayerPedId()),
                    area = GetLabelText(GetNameOfZone(GetEntityCoords(GetPlayerPed(-1)))),
                    thirst = math.floor(Thirst),
                    hunger = math.floor(Hunger),
                    stress = math.floor(Stress),
                    air = math.floor(10 * GetPlayerUnderwaterTimeRemaining(PlayerId())),
                    timer = math.floor(Timer),
                    nos = exports['ls-vehicles']:HasVehicleNosActive(Plate),
                    fuel = exports['ls-fuel']:GetFuelLevel(Plate),
                    seatbelt = Seatbelt,
                    rpm = Rpm,
                    voice = CurrentVoice,
                })  
            else
                SendNUIMessage({
                    action = "UpdateHud",
                    radio = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'radio:talking'),
                    talking = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:talking'),
                    swimming = IsPedSwimming(GetPlayerPed(-1)),
                    health = GetEntityHealth(PlayerPedId()),
                    armor = GetPedArmour(PlayerPedId()),
                    thirst = math.floor(Thirst),
                    hunger = math.floor(Hunger),
                    stress = math.floor(Stress),
                    air = math.floor(10 * GetPlayerUnderwaterTimeRemaining(PlayerId())),
                    timer = math.floor(Timer),
                    voice = CurrentVoice,
                })  
            end
            SetBlipAlpha(Citizen.InvokeNative(0x3F0CF9CB7E589B88), 0)
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(4)
        if LoggedIn and not Restarting then
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                local Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1))) * 3.6
                SendNUIMessage({
                    action = "CarSpeed",
                    speed = math.floor(Speed),
                })
            else
                Citizen.Wait(1000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsControlJustReleased(0, 243) then
                CurrentVoice =  exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:mode')
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                DisplayRadar(true)
                if not InVehicle then
                  InVehicle = true
                  SendNUIMessage({
                      action = "OpenCarHud",
                  })
                end
            else
                DisplayRadar(false)
                if InVehicle then
                    InVehicle = false
                    SendNUIMessage({
                        action = "CloseCarHud",
                    })
                end
            end
            Citizen.Wait(250)
        else
            Citizen.Wait(450)
            DisplayRadar(false)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                if not IsThisModelABicycle(GetEntityModel(Vehicle)) then
                    local Plate = GetVehicleNumberPlateText(Vehicle)
                    local FuelLevel = exports['ls-fuel']:GetFuelLevel(Plate)
                    if FuelLevel > 0 and FuelLevel <= 10 then
                        LSCore.Functions.Notify('Benzine niveau laag..', 'error')
                        PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
                    end
                    Citizen.Wait(15000)
                else
                    Citizen.Wait(450)
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
            local WaitTime = 90000
            if Stress >= 15 and Stress <= 25 then
                WaitTime = 60000
            elseif Stress > 25 and Stress <= 45 then
                WaitTime = 45000
            elseif Stress > 45 and Stress <= 65 then
                WaitTime = 22500
            elseif Stress > 65 and Stress <= 85 then
                WaitTime = 11500
            elseif Stress > 85 and Stress <= 100 then
                WaitTime = 5500
            end
            if Stress >= 5 then
                TriggerScreenblurFadeIn(1000.0)
                Citizen.Wait(1100)
                TriggerScreenblurFadeOut(1000.0)
            end
            Citizen.Wait(WaitTime)
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Functions \\ --

function SetSeatbelt(Bool)
    Seatbelt = Bool
end

function HideHud(Bool)
    if Bool then
        SendNUIMessage({action = 'Hide'})
    else
        SendNUIMessage({action = 'Show'})
    end
end