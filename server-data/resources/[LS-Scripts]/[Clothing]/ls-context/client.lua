local server = false

RegisterNUICallback("dataPost", function(data, cb)
    SetNuiFocus(false)
    if server then
        TriggerServerEvent(data.event, data.args)
    else
        TriggerEvent(data.event, data.args)
    end
    cb('ok')
end)

RegisterNUICallback("cancel", function()
    SetNuiFocus(false)
end)


RegisterNetEvent('ls-context:sendMenu', function(data, toServer)
    if not data then return end
    if toServer then server = true end    
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "OPEN_MENU",
        data = data
    })
end)
