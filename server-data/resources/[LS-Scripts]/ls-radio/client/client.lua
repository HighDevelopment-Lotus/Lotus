local LSCore, LoggedIn, RadioOn = exports['ls-core']:GetCoreObject(), false, false
local LastRadioChannel, CurrentVolume = -1, 5

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        exports['tokovoip_script']:setRadioVolume(Config.VolumeSettings[CurrentVolume])
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    CurrentVolume = 5
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
        Citizen.Wait(0)
        if LoggedIn then
            LSCore.Functions.TriggerCallback('ls-radio:server:HasItem', function(HasItem)
                if not HasItem then
                    if exports.tokovoip_script:getPlayerData(GetPlayerName(PlayerId()), "radio:channel") ~= 'nil' then
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

-- // Events \\ --

RegisterNetEvent('ls-radio:drop:radio')
AddEventHandler('ls-radio:drop:radio', function()
    LSCore.Functions.TriggerCallback('ls-radio:server:HasItem', function(HasItem)
        if not HasItem then
           LeaveRadio()
        end
    end, "radio")
end)

RegisterNetEvent('ls-radio:use:radio')
AddEventHandler('ls-radio:use:radio', function()
    Citizen.SetTimeout(1000, function()
        OpenRadio()
    end)
end)

-- // Keybinds Porto \\ --
RegisterKeyMapping('PortoUp', 'Radio kanaal omhoog', 'keyboard', '')
RegisterKeyMapping('PortoDown', 'Radio kanaal omlaag', 'keyboard', '')

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

-- // Functions \\ --

RegisterNUICallback('JoinRadio', function(data)
    JoinRadio(data.channel, data.channel:len())
end)

RegisterNUICallback('LeaveRadio', function(data, cb)
    LeaveRadio()
end)

RegisterNUICallback('Escape', function(data, cb)
    SetNuiFocus(false, false)
    PhonePlayOut()
end)

RegisterNUICallback('SetVolume', function(data)
    if data.Type == 'Up' then
        if CurrentVolume < 5 then
          CurrentVolume = CurrentVolume + 1
          exports['tokovoip_script']:setRadioVolume(Config.VolumeSettings[CurrentVolume])
          LSCore.Functions.Notify('Geluids Instelling: '..CurrentVolume, 'success')
        else
          LSCore.Functions.Notify('Volume kan niet hoger dan instelling 5', 'error')
        end
    elseif data.Type == 'Down' then
        if CurrentVolume > 1 then
          CurrentVolume = CurrentVolume - 1
          exports['tokovoip_script']:setRadioVolume(Config.VolumeSettings[CurrentVolume])
          LSCore.Functions.Notify('Geluids Instelling: '..CurrentVolume, 'success')
        else
            LSCore.Functions.Notify('Volume kan niet lager dan instelling 1.', 'error')
        end
    end
end)

RegisterNUICallback('ToggleOnOff', function()
    local CurrentRadioChannel = exports.tokovoip_script:getPlayerData(GetPlayerName(PlayerId()), "radio:channel")
    Citizen.SetTimeout(150, function()
        if not RadioOn then
            RadioOn = true
            if LastRadioChannel ~= -1 then
               SendNUIMessage({type = 'setchannel', channel = LastRadioChannel})
               exports.tokovoip_script:addPlayerToRadio(LastRadioChannel, "Radio", "radio")
               exports.tokovoip_script:setPlayerData(GetPlayerName(PlayerId()), "radio:channel", LastRadioChannel, true);
             else
               SendNUIMessage({type = "setchannel", channel = 0})
            end
            TriggerEvent("ls-sound:client:play", "radio-on", 0.25)
            LSCore.Functions.Notify('Radio Aan..', 'success')
        else
            RadioOn = false
            if CurrentRadioChannel ~= nil and CurrentRadioChannel ~= 'nil' and CurrentRadioChannel ~= false then
              exports.tokovoip_script:removePlayerFromRadio(CurrentRadioChannel)
              exports.tokovoip_script:setPlayerData(GetPlayerName(PlayerId()), "radio:channel", 'nil', true);
            end
            SendNUIMessage({type = "setchannel", channel = 'Uit'})
            TriggerEvent("ls-sound:client:play", "radio-click", 0.25)
            LSCore.Functions.Notify('Radio Uit..', 'error')
        end
    end)
end)

RegisterNUICallback('OnClick', function()
    PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end)

function JoinRadio(Channel, StringLenght)
    local JoinChannel = tonumber(Channel)
    local PlayerData = LSCore.Functions.GetPlayerData()
    if RadioOn then
        if JoinChannel <= Config.MaxFrequency then
            if JoinChannel ~= exports.tokovoip_script:getPlayerData(GetPlayerName(PlayerId()), "radio:channel") then
                if JoinChannel <= Config.RestrictedChannels then 
                    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
                        LastRadioChannel = JoinChannel 
                        exports.tokovoip_script:removePlayerFromRadio(exports.tokovoip_script:getPlayerData(GetPlayerName(PlayerId()), "radio:channel"))
                        exports.tokovoip_script:setPlayerData(GetPlayerName(PlayerId()), "radio:channel", JoinChannel, true);
                        exports.tokovoip_script:addPlayerToRadio(JoinChannel, "Radio", "radio")
                        if StringLenght >= 4 then
                            LSCore.Functions.Notify('Verbonden met '..JoinChannel..' Mhz', 'success')
                        else
                            LSCore.Functions.Notify('Verbonden met '..JoinChannel..'.00 Mhz', 'success')
                        end
                    else
                        LSCore.Functions.Notify('Deze kanalen zijn gecodeerd..', 'error')
                    end
                elseif JoinChannel > Config.RestrictedChannels then
                    LastRadioChannel = JoinChannel
                    exports.tokovoip_script:removePlayerFromRadio(exports.tokovoip_script:getPlayerData(GetPlayerName(PlayerId()), "radio:channel"))
                    exports.tokovoip_script:setPlayerData(GetPlayerName(PlayerId()), "radio:channel", JoinChannel, true);
                    exports.tokovoip_script:addPlayerToRadio(JoinChannel, "Radio", "radio")
                    if StringLenght >= 4 then
                        LSCore.Functions.Notify('Verbonden met '..JoinChannel..'Mhz', 'success')
                    else
                        LSCore.Functions.Notify('Verbonden met '..JoinChannel..'.00 Mhz', 'success')
                    end
                end
            else
                LSCore.Functions.Notify('Je zit al op deze frequentie..', 'error')
            end
        else
           LSCore.Functions.Notify('Deze frequentie kan je niet joinen..', 'success')
        end
    else
        LSCore.Functions.Notify('Je radio staat niet aan..', 'error')
    end
end

function LeaveRadio(Forced)
    if RadioOn or Forced then
        LastRadioChannel = -1
        TriggerEvent("ls-sound:client:play", "radio-click", 0.25)
        exports.tokovoip_script:removePlayerFromRadio(exports.tokovoip_script:getPlayerData(GetPlayerName(PlayerId()), "radio:channel"))
        exports.tokovoip_script:setPlayerData(GetPlayerName(PlayerId()), "radio:channel", 'nil', true);
        TriggerServerEvent("TokoVoip:removePlayerFromAllRadio", GetPlayerServerId(PlayerId()))
        LSCore.Functions.Notify('Je bent verwijderd van je huidige frequentie!', 'error')
    else
        LSCore.Functions.Notify('Je radio staat niet aan..', 'error')
    end
end

function ChangeRadio(Type)
    if Type == 'Up' then
        local NewChannel = LastRadioChannel + 1
        if NewChannel > 500 then
            NewChannel = 500
        end
        JoinRadio(NewChannel, tostring(NewChannel):len())
        SendNUIMessage({type = 'setchannel', channel = tostring(NewChannel)})
    elseif Type == 'Down' then
        local NewChannel = LastRadioChannel - 1
        if NewChannel < 1 then
            NewChannel = 1
        end
        JoinRadio(NewChannel, tostring(NewChannel):len())
        SendNUIMessage({type = 'setchannel', channel = tostring(NewChannel)})
    end
end

function SetRadioState(bool)
   RadioOn = bool
end

function OpenRadio()
    PhonePlayIn()
    SetNuiFocus(true, true)
    SendNUIMessage({
      type = "open",
    })
end