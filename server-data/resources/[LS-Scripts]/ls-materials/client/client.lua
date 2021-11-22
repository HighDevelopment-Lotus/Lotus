LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false

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

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1250, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end)    
--         Citizen.Wait(250)
--         LoggedIn = true
--     end)
-- end)