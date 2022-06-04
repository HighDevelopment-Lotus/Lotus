function OpenMenu(MenuData)
    SendNUIMessage({
        action = 'open-context',
        menudata = MenuData,
    })
    SetNuiFocus(true, true)
    Citizen.InvokeNative(0xFC695459D4D0E219, 0.7, 0.25)
end

RegisterNUICallback('CloseContext', function(data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('TriggerContextMenu', function(data)
    if data.ShitData['Type'] == 'Client' then
        TriggerEvent(data.ShitData['Event'], data.ShitData)
    else
        TriggerServerEvent(data.ShitData['Event'], data.ShitData)
    end
end)