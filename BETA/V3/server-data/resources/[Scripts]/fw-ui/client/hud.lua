local Seatbelt, CurrentVoice, usingRadio = false, 0, false
AddEventHandler("framework-voice:radioActive", function(radioTalking) usingRadio = radioTalking end)
AddEventHandler('framework-voice:setTalkingMode', function(newTalkingRange) CurrentVoice = newTalkingRange end)
-- // Hud \\ --

local weaponFireRate = 0
local showWeaponFireRate = false

RegisterNetEvent('framework-weapons:client:setWeaponFireRate')
AddEventHandler('framework-weapons:client:setWeaponFireRate', function (pAmount)
    weaponFireRate = pAmount
    -- setHudValue("weaponFireRate", weaponFireRate)
end)

RegisterNetEvent('framework-weapons:client:showWeaponFireRate')
AddEventHandler('framework-weapons:client:showWeaponFireRate', function (pToggle)
    showWeaponFireRate = pToggle
    -- setHudValue("showWeaponFireRate", pToggle)
end)

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(4)
        if LoggedIn and not Restarting then
            if IsPedInAnyVehicle(PlayerPedId()) then
                local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId()))
                local Rpm = GetVehicleCurrentRpm(GetVehiclePedIsIn(PlayerPedId()))
                local voertuigbenzine = exports['fw-vehicles']:GetFuelLevel(Plate)
                
                SendNUIMessage({
                    action = "UpdateHud",
                    radio = usingRadio,
                    talking = NetworkIsPlayerTalking(PlayerId()),
                    swimming = IsPedSwimming(PlayerPedId()),
                    health = GetEntityHealth(PlayerPedId()),
                    armor = GetPedArmour(PlayerPedId()),
                    area = GetLabelText(GetNameOfZone(GetEntityCoords(PlayerPedId()))),
                    thirst = math.floor(Thirst),
                    hunger = math.floor(Hunger),
                    stress = math.floor(Stress),
                    air = math.floor(10 * GetPlayerUnderwaterTimeRemaining(PlayerId())),
                    timer = math.floor(Timer),
                    nos = exports['fw-vehicles']:HasVehicleNosActive(Plate),
                    fuel = math.floor(voertuigbenzine),
                    seatbelt = Seatbelt,
                    rpm = Rpm,
                    voice = CurrentVoice,
                    -- cornerselling = exports['fw-illegal']:getCornersellingInfo(),
                })  
            else
                SendNUIMessage({
                    action = "UpdateHud",
                    radio = usingRadio,
                    talking = NetworkIsPlayerTalking(PlayerId()),
                    swimming = IsPedSwimming(PlayerPedId()),
                    health = GetEntityHealth(PlayerPedId()),
                    armor = GetPedArmour(PlayerPedId()),
                    thirst = math.floor(Thirst),
                    hunger = math.floor(Hunger),
                    stress = math.floor(Stress),
                    air = math.floor(10 * GetPlayerUnderwaterTimeRemaining(PlayerId())),
                    timer = math.floor(Timer),
                    voice = CurrentVoice,
                    -- cornerselling = exports['fw-illegal']:getCornersellingInfo(),
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
            if IsPedInAnyVehicle(PlayerPedId()) then
                local Speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) * 3.6
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
            if IsPedInAnyVehicle(PlayerPedId()) then
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
            if IsPedInAnyVehicle(PlayerPedId()) then
                local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                if not IsThisModelABicycle(GetEntityModel(Vehicle)) then
                    local Plate = GetVehicleNumberPlateText(Vehicle)
                    local FuelLevel = exports['fw-vehicles']:GetFuelLevel(Plate)
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
            if Stress >= 55 then
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