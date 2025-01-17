LSCore, LoggedIn = exports['fw-base']:GetCoreObject(), false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1000, function()
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         LoggedIn = true
--     end)
-- end)

-- Code

RegisterNetEvent('framework-interactions:client:steal:shoes')
AddEventHandler('framework-interactions:client:steal:shoes', function()
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.0 then
        exports['fw-assets']:RequestAnimationDict("random@domestic")
        TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
        Citizen.Wait(1600)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('framework-interactions:server:steal:shoes', GetPlayerServerId(Player))
    end
end)

RegisterNetEvent('framework-interactions:client:remove:shoes')
AddEventHandler('framework-interactions:client:remove:shoes', function()
    local ClothingData = {}
    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        ClothingData.outfitData = {["shoes"] = {item = 35, texture = 0}}
    else
        ClothingData.outfitData = {["shoes"] = {item = 34, texture = 0}}
    end
    TriggerEvent('framework-clothing:client:loadOutfit', ClothingData)
end)