local LSCore = nil

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end) 
    end)
end)

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