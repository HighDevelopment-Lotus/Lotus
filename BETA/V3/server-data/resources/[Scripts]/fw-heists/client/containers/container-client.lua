local LSCore = exports['fw-base']:GetCoreObject()
LoggedIn = false
-- Events

AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    LoggedIn = true
end)
 
RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)
 
RegisterNetEvent('framework-containers:client:set:plant:busy',function(PlantId, bool)
    Config.Places['containers'][PlantId]['IsBezig'] = bool
end)

RegisterNetEvent('framework-containers:client:set:picked:state',function(PlantId, bool)
    Config.Places['containers'][PlantId]['Geknipt'] = bool
end)

-- Threads

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local SpelerCoords = GetEntityCoords(PlayerPedId())
            NearContainer = false
            for k, v in pairs(Config.Places["containers"]) do
                local ContainerDistance = GetDistanceBetweenCoords(SpelerCoords.x, SpelerCoords.y, SpelerCoords.z, Config.Places["containers"][k]['x'], Config.Places["containers"][k]['y'], Config.Places["containers"][k]['z'], true)
                if ContainerDistance < 1.2 then
                    NearContainer = true
                    if not ShowingInteractionContainer then
                        ShowingInteractionContainer = true
                        exports['fw-ui']:ShowInteraction('[E] Openbreken', 'primary')
                    end

                    if IsControlJustPressed(0, 38) then
                        if not Config.Places['containers'][k]['IsBezig'] then
                            if not Config.Places['containers'][k]['Geknipt'] then
                                local chance = math.random(1, 6)
                                if chance == 2 then
                                    TriggerEvent('framework-police:client:send:copper:alert', SpelerCoords)
                                end
                                PickPlant(k)
                            else
                                LSCore.Functions.Notify("Het lijkt erop of deze container al kapot gemaakt is en geloot", "error")
                            end
                        else
                            LSCore.Functions.Notify("Al in gebruik", "error")
                        end
                    end
                end
            end

            if not NearContainer then
                if ShowingInteractionContainer then
                    ShowingInteractionContainer = false
                    exports['fw-ui']:HideInteraction()
                end
                Citizen.Wait(1500)
            end
        end
    end
end)

-- Functions 

function PickPlant(PlantId)
    LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
        if HasItem then
            TriggerServerEvent('framework-ui:server:gain:stress', math.random(1, 6))
            exports['fw-ui']:StartSkillTest(3, 'Fast', function(Outcome)
                if Outcome then
                    TriggerServerEvent('framework-containers:server:set:containers:busy', PlantId, true)
                    LSCore.Functions.Progressbar("pick_plant", "Openbreken enne huts..", math.random(3500, 6500), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "amb@prop_human_bum_bin@idle_b",
                        anim = "idle_d",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        TriggerServerEvent('framework-containers:server:set:containers:busy', PlantId, false)
                        TriggerServerEvent('framework-containers:server:set:picked:state', PlantId, true)
                        TriggerServerEvent('framework-containers:server:give:copper')
                        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
                        LSCore.Functions.Notify("Success", "success")
                    end, function() -- Cancel
                        TriggerServerEvent('framework-containers:server:set:containers:busy', PlantId, false)
                        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
                        LSCore.Functions.Notify("Geannuleerd", "error")
                    end)
                end
            end)
        else
            LSCore.Functions.Notify("Je mist een zware schaar", "error")
        end
    end, "heavy-scissor")
end