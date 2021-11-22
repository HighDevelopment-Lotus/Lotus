local LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LSCore.Functions.TriggerCallback("ls-emergencylights:server:get:config", function(ConfigData)
            Config = ConfigData
        end)
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) == 18 then
                    if IsControlJustPressed(0, 36) then
                        if not Config.UiOpend then
                            local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)))
                            if Config.ButtonData[Plate] ~= nil then
                                Config.UiOpend = true
                                SendNUIMessage({
                                    action = 'open',
                                    buttondata = Config.ButtonData[Plate],
                                })
                                SetNuiFocus(true, true)
                                SetNuiFocusKeepInput(true, true)
                                Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.95)
                                TriggerServerEvent('ls-emergencylights:server:set:sounds:disabled')
                                SetVehicleAutoRepairDisabled(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
                            end
                        end
                    end
                    DisableControlAction(0, 38, true)
                    DisableControlAction(0, 86, true)
                end
            else
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if Config.UiOpend then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 289, true)
            DisableControlAction(0, 288, true)
            DisableControlAction(0, 346, true)
        else
            Citizen.Wait(250)
        end
    end
end)

-- Events --

RegisterNetEvent('ls-emergencylights:client:set:lights')
AddEventHandler('ls-emergencylights:client:set:lights', function(Vehicle, Plate, Data)
    local Count = 0
    local Veh = NetToVeh(Vehicle)
    local VehicleModel = GetEntityModel(Veh)
    if Data.State == 1 then
        if Config.SirenData[VehicleModel] ~= nil then
            for k, v in pairs(Config.SirenData[VehicleModel]['LightSettings'][Data.Type]) do
                SetVehicleExtra(Veh, v, 1)
            end
            for i = 1, 12 do
                if IsVehicleExtraTurnedOn(Veh, i) then
                    Count = Count + 1
                end
            end
            if Count <= 0 then
                SetVehicleSiren(Veh, false)
            end
        end
    else
        if Config.SirenData[VehicleModel] ~= nil then
            for k, v in pairs(Config.SirenData[VehicleModel]['LightSettings'][Data.Type]) do
                SetVehicleExtra(Veh, v, 0)
            end
            SetVehicleSiren(Veh, true)
        end
    end
end)

RegisterNetEvent('ls-emergencylights:client:sync')
AddEventHandler('ls-emergencylights:client:sync', function(ConfigData)
    Config.ButtonData = ConfigData
end)

RegisterNetEvent('ls-emergencylights:client:update:button')
AddEventHandler('ls-emergencylights:client:update:button', function(Data, Plate)
    Config.ButtonData[Plate][Data.Type] = Data.State
end)

RegisterNetEvent('ls-emergencylights:client:toggle:sounds')
AddEventHandler('ls-emergencylights:client:toggle:sounds', function(Sender, State)
    local SelfPed = GetPlayerPed(GetPlayerFromServerId(Sender))
    local Vehicle = GetVehiclePedIsIn(SelfPed)
    local ModelName = GetEntityModel(Vehicle)
    ToggleVehicleSirens(Vehicle, ModelName, GetVehicleNumberPlateText(Vehicle), State)
    ToggleMuteDefaultSiren(Vehicle, true)
end)

RegisterNetEvent('ls-emergencylights:client:set:sounds:disabled')
AddEventHandler('ls-emergencylights:client:set:sounds:disabled', function(Sender)
    local SelfPed = GetPlayerPed(GetPlayerFromServerId(Sender))
    local Vehicle = GetVehiclePedIsIn(SelfPed)
    ToggleMuteDefaultSiren(Vehicle, true)
end)

-- Functions --

function ToggleMuteDefaultSiren(Vehicle, Toggle)
	if DoesEntityExist(Vehicle) and not IsEntityDead(Vehicle) then
		DisableVehicleImpactExplosionActivation(Vehicle, Toggle)
	end
end

function ToggleVehicleSirens(Vehicle, Model, Plate, State)
    if Config.SirenData[Model] ~= nil then
        if State then
           Config.EmergencyData[Plate] = {['SoundId'] = GetSoundId()}
           PlaySoundFromEntity(Config.EmergencyData[Plate]['SoundId'], Config.SirenData[Model]['SirenSound'], Vehicle, 0, 0, 0)
        else
            if Config.EmergencyData[Plate] ~= nil then
                StopSound(Config.EmergencyData[Plate]['SoundId'])
                ReleaseSoundId(Config.EmergencyData[Plate]['SoundId'])
                Config.EmergencyData[Plate]['SoundId'] = nil
            end
        end
    end
end

RegisterNUICallback('CloseUi', function()
    Config.UiOpend = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false, false)
    TriggerServerEvent('ls-emergencylights:server:set:sounds:disabled')
end)

RegisterNUICallback('Click', function()
    PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end)

RegisterNUICallback('RegisterButton', function(data)
    local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
    local Plate = GetVehicleNumberPlateText(Vehicle)
    TriggerServerEvent('ls-emergencylights:server:update:button', data, Plate)
end)

RegisterNUICallback('SetLights', function(data)
    local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
    TriggerServerEvent('ls-emergencylights:server:set:lights', VehToNet(Vehicle), GetVehicleNumberPlateText(Vehicle),data )
end)

RegisterNUICallback('SetSirens', function(data)
   TriggerServerEvent('ls-emergencylights:server:toggle:sounds', data.Bool)
end)

function SetupEmergencyVehicle(Vehicle, Plate)
    Config.EmergencyData[Plate] = {['SirenState'] = false, ['SoundId'] = nil}
    TriggerServerEvent('ls-emergencylights:server:setup:first:time', Plate)
    TriggerServerEvent('ls-emergencylights:server:set:sounds:disabled')
    for i = 1, 15 do
        SetVehicleExtra(Vehicle, i, 1)
    end
end