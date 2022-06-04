LSCore = exports["fw-base"]:GetCoreObject()

-- Code

local EventActive = false
local FrozenVeh = nil

RegisterNetEvent('framework-event:client:EventMovie')
AddEventHandler('framework-event:client:EventMovie', function()
    if not EventActive then
        SetNuiFocus(true, false)
        SendNUIMessage({
            action = "enable"
        })

        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            FrozenVeh = GetVehiclePedIsIn(GetPlayerPed(-1))
            FreezeEntityPosition(FrozenVeh, true)
        end
        EventActive = true
    end
end)

RegisterNUICallback('CloseEvent', function(data, cb)
    SetNuiFocus(false, false)
    EventActive = false
    FreezeEntityPosition(FrozenVeh, false)
    FrozenVeh = nil
end)