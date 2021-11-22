local IsLockPicking = false
local LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
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

AddEventHandler('ls-lockpick:client:openLockpick', function(callback)
    lockpickCallback = callback
    openLockpick(true)
end)

function OpenLockpickGame(callback)
 lockpickCallback = callback
 openLockpick(true)
end

RegisterNUICallback('callback', function(data, cb)
    openLockpick(false)
	lockpickCallback(data.success)
    if data.success then
        TriggerServerEvent('ls-lockpick:server:add:skill:lockpick', math.random(1,2))
    else
        if math.random(1, 20) <= 9 then
            TriggerServerEvent('ls-lockpick:server:remove:skill:lockpick', 1)
        end
    end
    cb('ok')
end)

RegisterNUICallback('exit', function(data)
    lockpickCallback(data.success)
    if data.success then
        TriggerServerEvent('ls-lockpick:server:add:skill:lockpick', math.random(1,2))
    else
        if math.random(1, 20) <= 9 then
            TriggerServerEvent('ls-lockpick:server:remove:skill:lockpick', 1)
        end
    end
    openLockpick(false)
end)

 function openLockpick(bool)
 SetNuiFocus(bool, bool)
 SendNUIMessage({
     action = "ui",
     toggle = bool,
 })
 SetCursorLocation(0.5, 0.2)
 IsLockPicking = bool
end

function GetLockPickStatus()
    return IsLockPicking
end