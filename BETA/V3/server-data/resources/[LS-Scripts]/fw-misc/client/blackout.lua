local LSCore = exports['fw-base']:GetCoreObject()
local isLoggedIn = false

-- :: Blackout Lotus V3
RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    local PlayerData = LSCore.Functions.GetPlayerData()
    isLoggedIn = true
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

Citizen.CreateThread(function()
    local Sleep = 750
    while true do
        if isLoggedIn then
            local Entity = PlayerPedId()
            local EntityCoords = GetEntityCoords(Entity)
            if not Config.Blackout['Options']['BlackoutActive'] and IsExplosionInSphere(2, Config.Blackout['Locations']['DangerContainer']['X'], Config.Blackout['Locations']['DangerContainer']['Y'], Config.Blackout['Locations']['DangerContainer']['Z'], 20.0) then
                TriggerEvent('framework-police:client:send:blackout', EntityCoords, GetStreetLabel())
                TriggerEvent('framework-blackout:client:blackout:optional:explosions')
                TriggerServerEvent('framework-blackout:server:blackout:set:config:value', 'Options', 'BlackoutActive', true)
                TriggerServerEvent('framework-weathersync:server:toggle:blackout', true)
                print('jemoeder')
            end
            if Config.Blackout['Options']['BlackoutActive'] then
                Citizen.Wait(60000 * 15)
                if Config.Blackout['Options']['BlackoutActive'] then
                    TriggerServerEvent('framework-blackout:server:blackout:set:config:value', 'Options', 'BlackoutActive', false)
                    TriggerServerEvent('framework-weathersync:server:toggle:blackout', false)
                end
                print('jevader')
            end
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(Sleep)
    end
end)

RegisterNetEvent('framework-blackout:client:blackout:optional:explosions')
AddEventHandler('framework-blackout:client:blackout:optional:explosions', function()
    local chance = math.random(1,100)

    if chance > 0 then
        for k,v in pairs(Config.Blackout['Locations']['Explosions']) do
            AddExplosion(v['X'], v['Y'], v['Z'], 1, 15.0, true, false, 3.0)
        end
    else
    end
end)


RegisterNetEvent('framework-blackout:client:blackout:set:config:value')
AddEventHandler('framework-blackout:client:blackout:set:config:value', function(Type, Type2, Value)
    Config.Blackout[Type][Type2] = Value
end)

function GetBlackoutStatus()
    if Config.Blackout['Options']['BlackoutActive'] then
        return true
    else
        return false
    end
end


-- exports("GetBlackoutStatus", function()
--     if Config.Blackout['Options']['BlackoutActive'] then
--         return true
--     else
--         return false
--     end
-- end)

function GetStreetLabel()

    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local FirstStreetLabel = GetStreetNameFromHashKey(s1)
    local SecondStreetLabel = GetStreetNameFromHashKey(s2)
    if SecondStreetLabel ~= nil and SecondStreetLabel ~= "" then 
        FirstStreetLabel = FirstStreetLabel .. " " .. SecondStreetLabel
    end
    return FirstStreetLabel

end