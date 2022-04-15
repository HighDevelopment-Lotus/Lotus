local Cam, Cam2 = nil, nil
local LSCore = exports['fw-base']:GetCoreObject()

RegisterNetEvent('LSCore:Client:CloseNui')
AddEventHandler('LSCore:Client:CloseNui', function()
    SetNuiFocus(false, false)
end)

-- Code

RegisterNetEvent('framework-spawn:client:choose:spawn')
AddEventHandler('framework-spawn:client:choose:spawn', function(PlayerData)
    local Player = PlayerData
    Citizen.SetTimeout(1500, function()
        LSCore.Functions.TriggerCallback("framework-spawn:server:get:houses", function(HouseData)
            local InJail = false
            if Player.metadata["jailtime"] > 0 then
                InJail = true
            end
            SetEntityVisible(PlayerPedId(), false)
            DoScreenFadeOut(250)
            Citizen.Wait(1000)
                DoScreenFadeIn(250)
                SetSkyCam(true)
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = 'OpenSpawn',
                    injail = InJail,
                    housedata = HouseData,
                })
        end, Player.citizenid)
    end)
end)

RegisterNetEvent('framework-spawn:client:choose:appartment')
AddEventHandler('framework-spawn:client:choose:appartment', function()
    SetEntityVisible(PlayerPedId(), false)
    Citizen.Wait(2000)
    SetSkyCam(true)
    SetSkyCam(false)
    TriggerEvent('LSCore:Client:OnPlayerLoaded')
    TriggerEvent('framework-appartments:client:enter:appartment', true)
end)

RegisterNUICallback('SpawnPlayer', function(data)
    Citizen.Wait(2000)
    SetNuiFocus(false, false)
    TriggerEvent('LSCore:Client:OnPlayerLoaded')
    if data.SpawnId ~= 'Appartment' then
        SpawnPlayer(data.SpawnId, data.HouseData)
    else
        DoScreenFadeOut(250)
        Citizen.Wait(1200)
        SetSkyCam(false)
        TriggerEvent('framework-appartments:client:enter:appartment', false)
    end
end)

RegisterCommand('login', function()
    TriggerEvent('LSCore:Client:OnPlayerLoaded')
end)

RegisterNUICallback('SpawnJail', function(data)
    DoScreenFadeOut(250)
    Citizen.Wait(1000)
    SetSkyCam(false)
    SetNuiFocus(false, false)
    TriggerEvent('LSCore:Client:OnPlayerLoaded')
    Citizen.Wait(100)
    SetEntityCoords(PlayerPedId(), Config.Locations['Jail']['Coords']['X'], Config.Locations['Jail']['Coords']['Y'], Config.Locations['Jail']['Coords']['Z'] - 0.9, 0, 0, 0, false)
    SetEntityHeading(PlayerPedId(), Config.Locations['Jail']['Coords']['H'])

    TriggerEvent('framework-prison:client:spawn:prison')
end)

RegisterNUICallback('Click', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

function SetSkyCam(bool)
  if bool then
        Cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -265.51, -811.01, 31.85 + 300, -85.00, 0.00, 0.00, 100.00, false, 0)
        SetCamActive(Cam, true)
        SetFocusArea(-265.51, -811.01, 31.85 + 175, 0.0, 0.0, 0.0)
        ShakeCam(Cam, "HAND_SHAKE", 0.15)
        SetEntityVisible(PlayerPedId(), false)
        RenderScriptCams(true, false, 3000, 1, 1)
  else
      if DoesCamExist(Cam) then
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(Cam, false)
        DestroyCam(Cam, true)
      end
      SetFocusEntity(PlayerPedId())
      FreezeEntityPosition(PlayerPedId(), false)
      SetEntityVisible(PlayerPedId(), true)
  end
end

function SpawnPlayer(SpawnId, HouseData)
    print(SpawnId)
    if SpawnId == 'LastLocation' then
        LSCore.Functions.GetPlayerData(function(PlayerData)
          SetEntityCoords(PlayerPedId(), PlayerData.position.x, PlayerData.position.y, PlayerData.position.z - 0.9, 0, 0, 0, false)
        --   SetFocusArea(PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + 300, 0.0, 0.0, 0.0)
        --   SetCamParams(Cam, PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + 300, -85.0, 0.00, 0.00, 100.0, 7200, 0, 0, 2)
        --   Citizen.Wait(6500)
        --   SetFocusArea(PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + 10, 0.0, 0.0, 0.0)
        --   SetCamParams(Cam, PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + 10, -40.0, 0.00, 0.00, 100.0, 5000, 0, 0, 2)
        --   Citizen.Wait(4500)
          Citizen.SetTimeout(1000, function()
             SetSkyCam(false)
             Citizen.Wait(100)
             DoScreenFadeOut(250)
             Citizen.Wait(150)
             SetSkyCam(false)
             Citizen.Wait(1000)
             DoScreenFadeIn(1000)
          end)
        end)
    elseif SpawnId == 'House' then
        SetEntityCoords(PlayerPedId(), HouseData['Coords']['X'], HouseData['Coords']['Y'], HouseData['Coords']['Z'] - 0.9, 0, 0, 0, false)
        -- SetFocusArea(HouseData['Coords']['X'], HouseData['Coords']['Y'], HouseData['Coords']['Z'] + 300, 0.0, 0.0, 0.0)
        -- SetCamParams(Cam, HouseData['Coords']['X'], HouseData['Coords']['Y'], HouseData['Coords']['Z'] + 300, -85.0, 0.00, 0.00, 100.0, 7200, 0, 0, 2)
        -- Citizen.Wait(6500)
        -- SetFocusArea(HouseData['Coords']['X'], HouseData['Coords']['Y'], HouseData['Coords']['Z'] + 10, 0.0, 0.0, 0.0)
        -- SetCamParams(Cam, HouseData['Coords']['X'], HouseData['Coords']['Y'], HouseData['Coords']['Z'] + 10, -40.0, 0.00, 0.00, 100.0, 5000, 0, 0, 2)
        -- Citizen.Wait(4500)
        Citizen.SetTimeout(1000, function()
           SetSkyCam(false)
           Citizen.Wait(100)
           DoScreenFadeOut(250)
           Citizen.Wait(150)
           SetSkyCam(false)
           Citizen.Wait(1000)
           DoScreenFadeIn(1000)
        end)
    else
        -- print(Config.Locations[SpawnId])
        -- SetFocusArea(Config.Locations[SpawnId]['Coords']['X'], Config.Locations[SpawnId]['Coords']['Y'], Config.Locations[SpawnId]['Coords']['Z'] + 300, 0.0, 0.0, 0.0)
        -- SetCamParams(Cam, Config.Locations[SpawnId]['Coords']['X'], Config.Locations[SpawnId]['Coords']['Y'], Config.Locations[SpawnId]['Coords']['Z'] + 300, -85.0, 0.00, 0.00, 100.0, 7200, 0, 0, 2)
        SetEntityCoords(PlayerPedId(), Config.Locations[SpawnId]['Coords']['X'], Config.Locations[SpawnId]['Coords']['Y'], Config.Locations[SpawnId]['Coords']['Z'] - 0.9, 0, 0, 0, false)
        -- SetEntityHeading(PlayerPedId(), Config.Locations[SpawnId]['Coords']['H'])
        -- Citizen.Wait(6500)
        -- SetFocusArea(Config.Locations[SpawnId]['Coords']['X'], Config.Locations[SpawnId]['Coords']['Y'], Config.Locations[SpawnId]['Coords']['Z'] + 10, 0.0, 0.0, 0.0)
        -- SetCamParams(Cam, Config.Locations[SpawnId]['Coords']['X'], Config.Locations[SpawnId]['Coords']['Y'], Config.Locations[SpawnId]['Coords']['Z'] + 10, Config.Locations[SpawnId]['Coords']['XR'], 0.00, 0.00, 100.0, 5000, 0, 0, 2)
        -- Citizen.Wait(2500)
        Citizen.SetTimeout(1000, function()
           SetSkyCam(false)
           Citizen.Wait(100)
           DoScreenFadeOut(250)
           Citizen.Wait(1500)
           SetSkyCam(false)
           Citizen.Wait(1000)
           DoScreenFadeIn(1000)
        end)
    end
end