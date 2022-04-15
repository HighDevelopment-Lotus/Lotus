local LSCore = exports['fw-base']:GetCoreObject()

RegisterNetEvent('LSCore:Client:CloseNui')
AddEventHandler('LSCore:Client:CloseNui', function()
    SetNuiFocus(false, false)
end)

-- Code

RegisterNUICallback('callback', function(data, cb)
    SetNuiFocus(false, false)
    ReturnData(data.success)
end)

function StartShapeGame(Callback)
    ReturnData = Callback
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open"
    })
end