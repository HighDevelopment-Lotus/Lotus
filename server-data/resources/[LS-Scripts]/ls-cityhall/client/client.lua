local CityProps, CanRecieve = {}, true
local LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        SpawnCityProps()
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    DeSpawnCityProps()
    LoggedIn = false
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end)    
--         Citizen.Wait(250)
--         SpawnCityProps()
--         LoggedIn = true
--     end)
-- end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearAnything = false
            for k, v in pairs(Config.MetalDetector['Coords']) do
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                if Distance < 1.2 then
                    NearAnything = true
                    if not Config.MetalDetector['Scanned'] then
                        local PlayerData = LSCore.Functions.GetPlayerData()
                        Config.MetalDetector['Scanned'] = true
                        if PlayerData.job.name == 'police' and PlayerData.job.onduty or PlayerData.job.name == 'ambulance' and PlayerData.job.onduty then
                            TriggerEvent("ls-sound:client:play", "metal-detector", 0.3)
                            Citizen.SetTimeout(10000, function()
                              Config.MetalDetector['Scanned'] = false
                            end)
                        else
                            TriggerServerEvent('ls-cityhall:server:scan:metal')
                            TriggerEvent("ls-sound:client:play", "metal-detector", 0.3)
                            Citizen.SetTimeout(10000, function()
                              Config.MetalDetector['Scanned'] = false
                            end)
                        end
                    end
                end
            end
            if not NearAnything then
                Citizen.Wait(350)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-cityhall:client:request:items')
AddEventHandler('ls-cityhall:client:request:items', function()
    if CanRecieve then
        CanRecieve = false
        TriggerServerEvent('ls-cityhall:server:recieve:metal:objects')
        Citizen.SetTimeout(7500, function()
            CanRecieve = true
        end)
    end
end)

RegisterNetEvent('ls-cityhall:client:open:menu')
AddEventHandler('ls-cityhall:client:open:menu', function(MenuType)
    local MenuItems = {}
    for k, v in pairs(Config.Menus[MenuType]) do
        local NewData = {}
        NewData['Title'] = v['Name']
        NewData['Desc'] = v['Desc']
        NewData['Data'] = {['Event'] = v['Event'], ['Type'] = v['EventType'], ['Id'] = v['Type']}
        table.insert(MenuItems, NewData)
    end
    if (#MenuItems > 0) then
        local Data = {['Title'] = 'Los Santos Stadhuis', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end
end)

-- // Functions \\ --

function SpawnCityProps()
    for k, v in pairs(Config.CityProps) do
        local Prop = GetHashKey(v['Prop'])
        exports['ls-assets']:RequestModelHash(Prop)
        local Object = CreateObject(Prop, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], false, false, false)
        SetEntityHeading(Object, v['Coords']['H'])
        FreezeEntityPosition(Object, true)
        SetEntityInvincible(Object, true)
        if not v['Visible'] then
            SetEntityVisible(Object, false)
        end
        if v['PlacePropGood'] then
            PlaceObjectOnGroundProperly(Object)
        end
        table.insert(CityProps, Object)
    end
end

function DeSpawnCityProps()
    for k, v in pairs(CityProps) do
        NetworkRequestControlOfEntity(v)
        DeleteEntity(v)
        DeleteObject(v)
    end
    CityProps = {}
end