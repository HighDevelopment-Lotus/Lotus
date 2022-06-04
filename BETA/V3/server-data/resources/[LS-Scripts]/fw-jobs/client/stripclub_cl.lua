local LSCore, LoggedIn = exports['fw-base']:GetCoreObject(), false
local ActiveParticles, UnicornProps = {}, {}
local ColorR, ColorG, ColorB = 15, 15, 15
local currentZone = nil

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
       LoggedIn = true
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

-- // Loops \\ --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
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
                local PlayerCoords = GetEntityCoords(PlayerPedId())
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
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 127.82, -1296.91, 29.56, true)
            InRange = false
            if Distance < 35.0 then
                InRange = true
                if not AddedProps then
                    AddedProps = true
                end
            end
            if not InRange then
                if AddedProps then
                    AddedProps = false                    
                end
                Citizen.Wait(1500)
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
RegisterNetEvent('framework-unicorn:client:open:effect:panel')
AddEventHandler('framework-unicorn:client:open:effect:panel', function()
    local MenuItems = {}
    for k, v in pairs(Config.EffectsMenu) do
      local NewData = {}
      NewData['Title'] = v['Name']
      NewData['Desc'] = v['Desc']
      NewData['Data'] = {['Event'] = v['Event'], ['Type'] = 'Server', ['Dict'] = v['Dict'], ['Effect'] = v['Effect']}
      table.insert(MenuItems, NewData)
    end
    local ExtraData = {['Title'] = 'Stoppen', ['Desc'] = 'Stop alle effecten.', ['Data'] = {['Event'] = 'framework-unicorn:server:close:effect', ['Type'] = 'Server'}}
    table.insert(MenuItems, ExtraData)
    Citizen.SetTimeout(100, function()
        local Data = {['Title'] = 'Stripclub Effects', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end)
end)

RegisterNetEvent('framework-unicorn:client:stop:effects')
AddEventHandler('framework-unicorn:client:stop:effects', function()
    for k, v in pairs(ActiveParticles) do
        StopParticleFxLooped(v, 0)
        RemoveParticleFx(v, 0)
    end
    ActiveParticles = {}
end)

RegisterNetEvent('framework-unicorn:client:sync:config')
AddEventHandler('framework-unicorn:client:sync:config', function(ConfigData)
    Config = ConfigData
end)

RegisterNetEvent('framework-unicorn:client:open:storage')
AddEventHandler('framework-unicorn:client:open:storage', function()
    if exports['fw-inv']:CanOpenInventory() then
        TriggerServerEvent('framework-inv:server:open:inventory:other', "stripclub", 'Stash', 20, 10000000)
    end
end)

RegisterNetEvent('framework-unicorn:client:open:tray')
AddEventHandler('framework-unicorn:client:open:tray', function()
    if exports['fw-inv']:CanOpenInventory() then
        TriggerServerEvent('framework-inv:server:open:inventory:other', "stripclubtray", 'Stash', 5, 100000)
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
        exports['fw-assets']:RequestAnimationDict(RandomDance['Dict'])
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
        exports['fw-assets']:RequestModelHash(Prop)
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

-- // Dafke \\ --

-- // Shops \\ --
RegisterNetEvent("framework-unicorn:client:shop")
AddEventHandler("framework-unicorn:client:shop", function()
    TriggerServerEvent("framework-inv:server:OpenInventory", "shop", "stripclub", Config.Items)
end)

RegisterNetEvent('framework-unicorn:client:open:cigarettes')
AddEventHandler('framework-unicorn:client:open:cigarettes', function(Numbers)    
    TriggerServerEvent("framework-inv:server:OpenInventory", "shop", "cigarettes", Config.ItemsSigaretten)
end)

RegisterNUICallback('Click', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
  end)
  
  RegisterNUICallback('ErrorClick', function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
  end)
  
  RegisterNUICallback('AddPrice', function(data)
    TriggerServerEvent('framework-unicorn:server:add:to:register', data.Price, data.Note)
  end)
  
  RegisterNUICallback('PayReceipt', function(data)
    TriggerServerEvent('framework-unicorn:server:pay:receipt', data.Price, data.Note, data.Id)
  end)
  
  RegisterNUICallback('CloseNui', function()
    SetNuiFocus(false, false)
  end)

-- // Register \\ --
RegisterNetEvent('framework-unicorn:client:open:payment')
AddEventHandler('framework-unicorn:client:open:payment', function()
    local MenuItems = {}
    for k, v in pairs(Config.ActivePayments) do
        if Config.ActivePayments[k] ~= nil then
          local NewData = {}
          NewData['Title'] = 'Bestelling: #'..k
          NewData['Desc'] = 'Prijs: $'..v['Price']..' <br>Notitie: '..v['Note']
          NewData['Data'] = {['Event'] = 'framework-unicorn:server:pay:receipt', ['Type'] = 'Server', ['BillId'] = k, ['Price'] = v['Price'], ['Note'] = v['Note']}
          table.insert(MenuItems, NewData)
        end
    end
    if #MenuItems > 0 then
        local Data = {['Title'] = 'Open Orders', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    else
        LSCore.Functions.Notify("Er zijn geen orders", "error")
    end
end)

RegisterNetEvent('framework-unicorn:client:open:register')
AddEventHandler('framework-unicorn:client:open:register', function()
  local PrData = {['Title'] = 'Prijs?', ['Type'] = 'number', ['Logo'] = '<i class="fas fa-coins"></i>'}
  local TxData = {['Title'] = 'Order?', ['Type'] = 'text', ['Logo'] = '<i class="fa-martini-glass"></i>'}
  LSCore.Functions.OpenInput(PrData, function(PriceData)
      if PriceData ~= false then
        Citizen.Wait(250)
        LSCore.Functions.OpenInput(TxData, function(NoteData)
          if NoteData ~= false then
            TriggerServerEvent('framework-unicorn:server:add:to:register', PriceData, NoteData)
          end
        end)
      end
  end)
end)

RegisterNetEvent('framework-unicorn:client:sync:register')
AddEventHandler('framework-unicorn:client:sync:register', function(RegisterConfig)
    Config.ActivePayments = RegisterConfig
end)


-- // Slushy \\ --
RegisterNetEvent("framework-unicorn:client:maken")
AddEventHandler("framework-unicorn:client:maken", function()

    TriggerEvent('framework-inv:client:set:busy', true)
    TriggerEvent("framework-sound:client:play", "pour-drink", 0.4)
    exports['fw-assets']:RequestAnimationDict("amb@world_human_hang_out_street@female_hold_arm@idle_a")
    TaskPlayAnim(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a" ,3.0, 3.0, -1, 8, 0, false, false, false)
    LSCore.Functions.Progressbar("open-brick", "Slushy Maken", 6500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('framework-prison:server:find:reward', 'slushy')
        TriggerEvent('framework-inv:client:set:busy', false)
        StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
    end, function()
        TriggerEvent('framework-inv:client:set:busy', false)
        LSCore.Functions.Notify("Geannuleerd..", "error")
        StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
    end)
end)

-- // Ice Cubes \\ --
RegisterNetEvent("framework-unicorn:client:ijsblokjes")
AddEventHandler("framework-unicorn:client:ijsblokjes", function()

    TriggerEvent('framework-inv:client:set:busy', true)
    TriggerEvent("framework-sound:client:play", "ice", 0.4)
    exports['fw-assets']:RequestAnimationDict("amb@world_human_hang_out_street@female_hold_arm@idle_a")
    TaskPlayAnim(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a" ,3.0, 3.0, -1, 8, 0, false, false, false)
    LSCore.Functions.Progressbar("open-brick", "Ijsblokjes hakken", 4500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('framework-stripclub:server:find:reward', 'ijsblokjes')
        TriggerEvent('framework-inv:client:set:busy', false)
        StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
    end, function()
        TriggerEvent('framework-inv:client:set:busy', false)
        LSCore.Functions.Notify("Geannuleerd..", "error")
        StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
    end)
end)

-- // Cocktails \\ --
RegisterNetEvent('framework-unicorn:client:open:craft')
AddEventHandler('framework-unicorn:client:open:craft', function()
    if exports['fw-inv']:CanOpenInventory() then
        local CraftingData = {['Type'] = 'Crafting', ['InvName'] = 'Cocktails', ['Items'] = Config.CocktailsItems}
		TriggerServerEvent('framework-inv:server:open:inventory:other', CraftingData, 'Crafting')
    end
end)