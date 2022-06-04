local LSCore, LoggedIn, onRadio, RadioChannel, CurrentVolume = exports['fw-base']:GetCoreObject(), false, false, 0, 100

-- Threads

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if isLoggedIn and onRadio then
            LSCore.Functions.TriggerCallback('framework-radio:server:GetItem', function(hasItem)
                if not hasItem then
                    if RadioChannel ~= 0 then
                        LeaveRadio(true)
                    end
                end
            end, "radio")
            Citizen.Wait(5000)
        else
            Citizen.Wait(1000)  
        end
    end
end)

-- Events

RegisterNetEvent('LSCore:Client:OnPlayerLoaded', function()
    LoggedIn = true
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload', function()
    LeaveRadio{true}
    LoggedIn = false
end)

RegisterNetEvent('LSCore:Client:CloseNui', function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent('framework-radio:use', function()
    OpenRadio()
end)

RegisterNetEvent('framework-radio:drop:radio', function()
    LSCore.Functions.TriggerCallback('framework-radio:server:HasItem', function(HasItem)
        if not HasItem then
           LeaveRadio()
        end
    end, "radio")
end)

-- Key Mapping

RegisterKeyMapping('PortoVolUp', 'Radio Volume Up', 'keyboard', '')
RegisterKeyMapping('PortoVolDown', 'Radio Volume Down', 'keyboard', '')
RegisterKeyMapping('PortoUp', 'Radio Channel Up', 'keyboard', '')
RegisterKeyMapping('PortoDown', 'Radio Channel Down', 'keyboard', '')

RegisterCommand('PortoVolUp', function(source, args)
    local Player = LSCore.Functions.GetPlayerData()
    if not Player.metadata['ishandcuffed'] then
        Volume('Up')
    end
end, false)

RegisterCommand('PortoVolDown', function(source, args)
    local Player = LSCore.Functions.GetPlayerData()
    if not Player.metadata['ishandcuffed'] then
        Volume('Down')
    end
end, false)

RegisterCommand('PortoUp', function(source, args)
    local Player = LSCore.Functions.GetPlayerData()
    if not Player.metadata['ishandcuffed'] then
        ChangeRadio('Up')
    end
end, false)

RegisterCommand('PortoDown', function(source, args)
    local Player = LSCore.Functions.GetPlayerData()
    if not Player.metadata['ishandcuffed'] then
        ChangeRadio('Down')
    end
end, false)

-- Functions

function ConnectRadio(channel)
    RadioChannel = channel
    if onRadio then
        exports["fw-voice"]:setRadioChannel(0)
    else
        onRadio = true
        exports["fw-voice"]:setVoiceProperty("radioEnabled", true)
    end

    exports["fw-voice"]:setRadioChannel(channel)

    if SplitStr(tostring(channel), ".")[2] ~= nil and SplitStr(tostring(channel), ".")[2] ~= "" then
        LSCore.Functions.Notify('Verbonden met '..channel.. ' MHz', 'success')
    else
        LSCore.Functions.Notify('Verbonden met '..channel.. '.00 MHz', 'success')
    end
end

function JoinRadio(Channel)
    local rchannel = tonumber(Channel)
    if rchannel ~= nil then
        if rchannel <= Config.MaxFrequency and rchannel ~= 0 then
            if rchannel ~= RadioChannel then
                if Config.RestrictedChannels[rchannel] ~= nil then
                    local Player = LSCore.Functions.GetPlayerData()
                    if Config.RestrictedChannels[rchannel][Player.job.name] and Player.job.onduty then
                        ConnectRadio(rchannel)
                    else
                        LSCore.Functions.Notify('Dit kanaal is beveiligd', 'error')
                    end
                else
                    ConnectRadio(rchannel)
                end
            else
                LSCore.Functions.Notify("Je zit al op deze frequentie", 'error')
            end
        else
            LSCore.Functions.Notify("De verbinding van de radio is slecht", 'error')
        end
    else
        LSCore.Functions.Notify('Je radio is uit', 'error')
    end
end

function Volume(Type)
    if Type == 'Up'  then
        if CurrentVolume < 100 then
            CurrentVolume = CurrentVolume + 10
            exports['fw-voice']:setRadioVolume(CurrentVolume)
            LSCore.Functions.Notify('Volume: '..CurrentVolume, 'success', 2500)
        else
            LSCore.Functions.Notify('Volume Maximaal', 'error', 2500)
        end
    elseif Type == 'Down' then
        if CurrentVolume > 10 then
            CurrentVolume = CurrentVolume - 10
            exports['fw-voice']:setRadioVolume(CurrentVolume)
            LSCore.Functions.Notify('Volume: '..CurrentVolume, 'success')
        else
            LSCore.Functions.Notify('Kan niet zachter', 'error', 2500)
        end
    end
end

function ChangeRadio(Type)
    if Type == 'Up' then
        local NewChannel = RadioChannel + 1
        if NewChannel > 500 then
            NewChannel = 500
        end
        JoinRadio(NewChannel, tostring(NewChannel):len())
        SendNUIMessage({type = 'setchannel', channel = tostring(NewChannel)})
    elseif Type == 'Down' then
        local NewChannel = RadioChannel - 1
        if NewChannel < 1 then
            NewChannel = 1
        end
        JoinRadio(NewChannel, tostring(NewChannel):len())
        SendNUIMessage({type = 'setchannel', channel = tostring(NewChannel)})
    end
end

function LeaveRadio(Forced)
    if onRadio or Forced then
        RadioChannel = 0
        TriggerEvent("framework-sound:client:play", "radio-click", 0.25)
        exports["fw-voice"]:removePlayerFromRadio()
        exports["fw-voice"]:SetRadioChannel(0)
        exports["fw-voice"]:setVoiceProperty("radioEnabled", false)
        LSCore.Functions.Notify('Je bent uit het radio kanaal verwijderd', 'error')
    else
        LSCore.Functions.Notify('Je radio is uit', 'error')
    end
end

function OpenRadio()
    SetNuiFocus(true, true)
    PhonePlayIn()
    if not onRadio then
        SendNUIMessage({type = "setchannel", channel = 'OFF'})
    end
    SendNUIMessage({
        type = "open",
    })
end

function SplitStr(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function SetRadioState(bool)
    RadioOn = bool
end

function IsRadioOn()
    return onRadio    
end

exports("IsRadioOn", IsRadioOn)

-- NUI

RegisterNUICallback('JoinRadio', function(data)
    JoinRadio(data.channel, data.channel:len())
end)

RegisterNUICallback('LeaveRadio', function(data, cb)
    if RadioChannel == 0 then
        LSCore.Functions.Notify('Je bent niet verbonden met een kanaal', 'error')
    else
        LeaveRadio()
    end
end)

RegisterNUICallback('Escape', function(data, cb)
    SetNuiFocus(false, false)
    PhonePlayOut()
end)

RegisterNUICallback('SetVolume', function(data)
    if data.Type == 'Up'  then
        if CurrentVolume < 100 then
            CurrentVolume = CurrentVolume + 10
            exports['fw-voice']:setRadioVolume(CurrentVolume)
            LSCore.Functions.Notify('Volume: '..CurrentVolume, 'success', 2500)
        else
            LSCore.Functions.Notify('Volume Maximaal', 'error', 2500)
        end
    elseif data.Type == 'Down' then
        if CurrentVolume > 10 then
            CurrentVolume = CurrentVolume - 10
            exports['fw-voice']:setRadioVolume(CurrentVolume)
            LSCore.Functions.Notify('Volume: '..CurrentVolume, 'success')
        else
            LSCore.Functions.Notify('Kan niet zachter', 'error', 2500)
        end
    end
end)

RegisterNUICallback('ToggleOnOff', function()
    Citizen.SetTimeout(150, function()
        if not onRadio then
            onRadio = true
            if RadioChannel ~= 0 then
                SendNUIMessage({type = 'setchannel', channel = RadioChannel})
                exports["fw-voice"]:addPlayerToRadio(RadioChannel, "Radio", "radio")
                exports["fw-voice"]:SetRadioChannel(RadioChannel)
            else
                SendNUIMessage({type = "setchannel", channel = 0})
            end
            exports["fw-voice"]:setVoiceProperty("radioEnabled", true)
            exports['fw-voice']:setRadioVolume(CurrentVolume)
            SendNUIMessage({type = "enableinput"})
            TriggerEvent("framework-sound:client:play", "radio-on", 0.25)
            LSCore.Functions.Notify('Radio Aan.', 'success')
        else
            onRadio = false
            exports['fw-voice']:removePlayerFromRadio()
            exports["fw-voice"]:setVoiceProperty("radioEnabled", false)
            SendNUIMessage({type = "setchannel", channel = 'OFF'})
            SendNUIMessage({type = "disableinput"})
            TriggerEvent("framework-sound:client:play", "radio-click", 0.25)
            LSCore.Functions.Notify('Radio Uit.', 'error')
        end
    end)
end)

RegisterNUICallback('OnClick', function()
    PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end)

RegisterNUICallback('NotEnabled', function()
    LSCore.Functions.Notify('Je radio staat niet aan..', 'error', 2500)
    PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end)