local LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false
local ActiveParticles, UnicornProps = {}, {}
local ColorR, ColorG, ColorB = 15, 15, 15

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
       SpawnUnicornProps()
       LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    DeSpawnUnicornProps()
    LoggedIn = false
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1250, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end) 
--         Citizen.Wait(250)
--         SpawnUnicornProps()
--         LoggedIn = true
--      end)
-- end)

-- Code

-- // Loops \\ --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            ColorR, ColorG, ColorB = math.random(1,255), math.random(1,255), math.random(1,255)
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Location['StripClub']['X'], Config.Location['StripClub']['Y'], Config.Location['StripClub']['Z'], true)
            if Distance < 19.0 then
                Config.InsideUnicorn = true
                CheckEffect()
            else
                Config.InsideUnicorn = false
            end
            Citizen.Wait(750)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if Config.InsideUnicorn then
                local NearPole = false
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                for k, v in pairs(Config.Poles) do
                    local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Distance < 2.0 then
                        NearPole = true
                        if IsControlJustReleased(0, 38) then
                            CheckPoleDance(k)
                        end
                    end
                end
                if not NearPole then 
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if Config.InsideUnicorn then
                DrawLightWithRange(116.03, -1286.81, 28.88, ColorR, ColorG, ColorB, 5.0, 10.0)
                DrawLightWithRange(112.79, -1283.11, 28.87, ColorG, ColorR, ColorB, 5.0, 10.0)
                DrawLightWithRange(117.53, -1283.07, 28.87, ColorR, ColorB, ColorG, 5.0, 10.0)
                DrawLightWithRange(116.49, -1291.44, 28.87, ColorB, ColorR, ColorB, 5.0, 10.0)
                DrawLightWithRange(122.83, -1288.07, 28.87, ColorR, ColorG, ColorB, 5.0, 10.0)
                DrawLightWithRange(121.03, -1285.22, 28.87, ColorR, ColorB, ColorG, 5.0, 10.0)
                DrawLightWithRange(123.40, -1294.87, 28.87, ColorG, ColorG, ColorB, 5.0, 10.0)
                DrawLightWithRange(119.93, -1296.88, 28.88, ColorR, ColorR, ColorB, 5.0, 10.0)
                DrawLightWithRange(110.30, -1293.08, 28.87, ColorR, ColorB, ColorG, 5.0, 10.0)
                DrawLightWithRange(105.66, -1294.61, 28.87, ColorR, ColorR, ColorG, 5.0, 10.0)
                DrawLightWithRange(102.77, -1290.45, 28.87, ColorB, ColorR, ColorB, 5.0, 10.0)
                DrawLightWithRange(107.16, -1285.62, 28.87, ColorB, ColorR, ColorB, 5.0, 10.0)
                DrawLightWithRange(108.81, -1289.28, 28.88, ColorR, ColorG, ColorB, 5.0, 10.0)
                DrawLightWithRange(128.89, -1292.46, 29.26, 255, 255, 255, 5.0, 0.2)
                DrawLightWithRange(127.70, -1296.76, 29.26, 255, 255, 255, 5.0, 0.2)
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

-- // Events \\ --
RegisterNetEvent('ls-unicorn:client:open:effect:panel')
AddEventHandler('ls-unicorn:client:open:effect:panel', function()
    local MenuItems = {}
    for k, v in pairs(Config.EffectsMenu) do
      local NewData = {}
      NewData['Title'] = v['Name']
      NewData['Desc'] = v['Desc']
      NewData['Data'] = {['Event'] = v['Event'], ['Type'] = 'Server', ['Dict'] = v['Dict'], ['Effect'] = v['Effect']}
      table.insert(MenuItems, NewData)
    end
    local ExtraData = {['Title'] = 'Effecten Stoppen', ['Desc'] = 'Zet alle effecten uit.', ['Data'] = {['Event'] = 'ls-stripclub:server:close:effect', ['Type'] = 'Server'}}
    table.insert(MenuItems, ExtraData)
    Citizen.SetTimeout(100, function()
        local Data = {['Title'] = 'Stripclub Effecten', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end)
end)

RegisterNetEvent('ls-unicorn:client:stop:effects')
AddEventHandler('ls-unicorn:client:stop:effects', function()
    for k, v in pairs(ActiveParticles) do
        StopParticleFxLooped(v, 0)
        RemoveParticleFx(v, 0)
    end
    ActiveParticles = {}
end)

RegisterNetEvent('ls-unicorn:client:sync:config')
AddEventHandler('ls-unicorn:client:sync:config', function(ConfigData)
    Config = ConfigData
end)

RegisterNetEvent('ls-unicorn:client:open:storage')
AddEventHandler('ls-unicorn:client:open:storage', function()
    if exports['ls-inventory-new']:CanOpenInventory() then
        TriggerServerEvent('ls-inventory-new:server:open:inventory:other', "stripclub", 'Stash', 20, 10000000)
    end
end)

RegisterNetEvent('ls-unicorn:client:open:tray')
AddEventHandler('ls-unicorn:client:open:tray', function()
    if exports['ls-inventory-new']:CanOpenInventory() then
        TriggerServerEvent('ls-inventory-new:server:open:inventory:other', "stripclubtray", 'Stash', 5, 100000)
    end
end)

-- // Functions \\ --
function CheckEffect()
    if Config.CurrentEffect['Effect'] ~= nil then
        local Data = Config.Effects[Config.CurrentEffect['Effect']]
        for k, v in pairs(Data) do
            RequestNamedPtfxAsset(Config.CurrentEffect['Dict'])
            UseParticleFxAssetNextCall(Config.CurrentEffect['Dict'])
            while not HasNamedPtfxAssetLoaded(Config.CurrentEffect['Dict']) do
                Wait(100)
            end
            Particle = StartParticleFxLoopedAtCoord(Config.CurrentEffect['Effect'], v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 0.0, 0.0, 0.0, 0.5, 0, 0, 0)
            table.insert(ActiveParticles, Particle)
        end
    end
end

function CheckPoleDance(CurrentPole)
    if not DoingDance then
        DoingDance = true
        local RandomDance = Config.Dances[math.random(1,#Config.Dances)]
        exports['ls-assets']:RequestAnimationDict(RandomDance['Dict'])
        local DanceScene = NetworkCreateSynchronisedScene(Config.Poles[CurrentPole]['X'], Config.Poles[CurrentPole]['Y'], Config.Poles[CurrentPole]['Z'], 0.0, 0.0, 0.0, 2, false, true, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(PlayerPedId(), DanceScene, RandomDance['Dict'], RandomDance['Anim'], 1.5, -4.0, 1, 1, 1148846080, 0)
        NetworkStartSynchronisedScene(DanceScene)
    else
        DoingDance = false
        ClearPedTasksImmediately(PlayerPedId())
    end
end

function SpawnUnicornProps()
    for k, v in pairs(Config.UnicornProps) do
        local Prop = GetHashKey(v['Prop'])
        exports['ls-assets']:RequestModelHash(Prop)
        local Object = CreateObject(Prop, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], false, false, false)
        SetEntityHeading(Object, 123.46)
        FreezeEntityPosition(Object, true)
        SetEntityInvincible(Object, true)
        if not v['Visible'] then
            SetEntityVisible(Object, false)
        end
        table.insert(UnicornProps, Object)
    end
end

function DeSpawnUnicornProps()
    for k, v in pairs(UnicornProps) do
        DeleteEntity(v)
        DeleteObject(v)
    end
    UnicornProps = {}
end

--UseParticleFxAssetNextCall("scr_ba_club")
--StartParticleFxLoopedAtCoord("scr_ba_club_smoke_machine", emitter.pos.x, emitter.pos.y, emitter.pos.z, emitter.rot.x, emitter.rot.y, emitter.rot.z, AfterHoursNightclubs.Interior.DryIce.scale, false, false, false, true)