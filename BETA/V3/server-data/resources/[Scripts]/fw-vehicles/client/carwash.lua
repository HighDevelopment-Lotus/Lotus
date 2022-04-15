local LSCore, LoggedIn, ActiveParticles = exports['fw-base']:GetCoreObject(), false, {}

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

RegisterNetEvent('framework-carwash:client:sync:water')
AddEventHandler('framework-carwash:client:sync:water', function(WaterId)
    StartWashParticle(WaterId)
end)

RegisterNetEvent('framework-carwash:client:stop:water')
AddEventHandler('framework-carwash:client:stop:water', function(WaterId)
    StopWashParticle(WaterId)
end)

-- Code

-- // Event \\ --

RegisterNetEvent('framework-carwash:client:set:busy')
AddEventHandler('framework-carwash:client:set:busy', function(CarWashId, bool)
 Config.CarWashLocations[CarWashId]['Busy'] = bool
end)

RegisterNetEvent('framework-carwash:client:sync:wash')
AddEventHandler('framework-carwash:client:sync:wash', function(Vehicle)
    SetVehicleDirtLevel(Vehicle, 0.0)
end)


RegisterNetEvent('framework-carwash:client:start:wasj')
AddEventHandler('framework-carwash:client:start:wasj', function()
    for k, v in pairs(Config.CarWashLocations) do
        local Positie = GetEntityCoords(PlayerPedId())
        local Gebied = #(vector3(Positie.x, Positie.y, Positie.z) - vector3(Config.CarWashLocations[k]['Coords']['Marker']['X'], Config.CarWashLocations[k]['Coords']['Marker']['Y'], Config.CarWashLocations[k]['Coords']['Marker']['Z']))
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            if Gebied <= 2.5 then 

                if not Config.CarWashLocations[k]['Busy'] then
                    LSCore.Functions.TriggerCallback("framework-carwash:server:can:wash", function(CanWash)
                    if CanWash then
                        StartCarWashing(k, GetVehiclePedIsIn(PlayerPedId(), false))
                    else
                        LSCore.Functions.Notify('Je hebt niet genoeg contant op zak..', 'error')
                    end
                end, Config.CarWashLocations[k]['Price'])
                else
                    LSCore.Functions.Notify('De wasstraat is al in gebruik..', 'error')
                end
            end
        end
    end
end)

-- // Functions \\ --

function StartCarWashing(CarWashId, Vehicle)
 SetVehicleDirtLevel(Vehicle, 10.0)
 TriggerServerEvent('framework-carwash:server:set:busy', CarWashId, true) 
 SetEveryoneIgnorePlayer(PlayerPedId(), true)
 SetPlayerControl(PlayerPedId(), false)
 Wait(250)
 TriggerServerEvent('framework-carwash:server:sync:water', Config.CarWashLocations[CarWashId]['Particle'])
 TaskVehicleDriveToCoord(PlayerPedId(), Vehicle, Config.CarWashLocations[CarWashId]['Coords']['GoTo']['X'], Config.CarWashLocations[CarWashId]['Coords']['GoTo']['Y'], Config.CarWashLocations[CarWashId]['Coords']['GoTo']['Z'], 5.0, 0.0, GetEntityModel(Vehicle), 262144, 1.0, 1000.0)
 Citizen.Wait(Config.CarWashLocations[CarWashId]['Wait'] / 2)
 TriggerServerEvent('framework-carwash:server:sync:wash', Vehicle)
 Citizen.Wait(Config.CarWashLocations[CarWashId]['Wait'] / 2)
 TriggerServerEvent('framework-carwash:server:stop:water', Config.CarWashLocations[CarWashId]['Particle'])
 SetPlayerControl(PlayerPedId(), true)
 TriggerServerEvent('framework-carwash:server:set:busy', CarWashId, false) 
end

function StartWashParticle(ParticleName)
 if Config.Particles[ParticleName] ~= nil then
     for k, v in pairs(Config.Particles[ParticleName]) do
      RequestNamedPtfxAsset("scr_carwash")
      UseParticleFxAssetNextCall("scr_carwash")
      while not HasNamedPtfxAssetLoaded("scr_carwash") do
          Wait(100)
      end
      local CarWashParticle = StartParticleFxLoopedAtCoord(Config.Particles[ParticleName][k]['particle'], Config.Particles[ParticleName][k]['X'], Config.Particles[ParticleName][k]['Y'], Config.Particles[ParticleName][k]['Z'], Config.Particles[ParticleName][k]['rotation'], 0.0, 0.0, 1.0, 0, 0, 0)
      table.insert(ActiveParticles, CarWashParticle)
     end
 end
end

function StopWashParticle(ParticleName)
 for k, v in ipairs(ActiveParticles) do
    StopParticleFxLooped(v, 0)
    RemoveParticleFx(v, 0)
    Citizen.Wait(150)
 end
end

function DrawText3D(x, y, z, text)
 SetTextScale(0.35, 0.35)
 SetTextFont(4)
 SetTextProportional(1)
 SetTextColour(255, 255, 255, 215)
 SetTextEntry("STRING")
 SetTextCentre(true)
 AddTextComponentString(text)
 SetDrawOrigin(x,y,z, 0)
 DrawText(0.0, 0.0)
 ClearDrawOrigin()
end