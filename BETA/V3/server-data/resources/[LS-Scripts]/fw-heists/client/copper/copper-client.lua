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
 
RegisterNetEvent('framework-copper:client:set:plant:busy',function(PlantId, bool)
    Config.Places['palen'][PlantId]['IsBezig'] = bool
end)

RegisterNetEvent('framework-copper:client:set:picked:state',function(PlantId, bool)
    Config.Places['palen'][PlantId]['Geknipt'] = bool
end)

-- Threads

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local SpelerCoords = GetEntityCoords(PlayerPedId())
            NearAnything = false
            for k, v in pairs(Config.Places["palen"]) do
                local PlantDistance = GetDistanceBetweenCoords(SpelerCoords.x, SpelerCoords.y, SpelerCoords.z, Config.Places["palen"][k]['x'], Config.Places["palen"][k]['y'], Config.Places["palen"][k]['z'], true)
                if PlantDistance < 1.2 then
                    NearAnything = true
                    if not ShowingInteraction then
                        ShowingInteraction = true
                        exports['fw-ui']:ShowInteraction('[E] Koper Stelen', 'primary')
                    end
                    if IsControlJustReleased(0, 38) then
                    ---if IsControlJustPressed(0, Config.Keys['E']) then
                        if not Config.Places['palen'][k]['IsBezig'] then
                            if not Config.Places['palen'][k]['Geknipt'] then
                                local chance = math.random(1, 6)
                                if chance == 2 then
                                    TriggerEvent('framework-police:client:send:copper:alert', SpelerCoords)
                                end
                                PickPlant(k)
                            else
                                LSCore.Functions.Notify("Het lijkt erop of deze paal al kapot gemaakt is", "error")
                            end
                        else
                            LSCore.Functions.Notify("Al in gebruik", "error")
                        end
                    end
                end
            end

            if not NearAnything then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['fw-ui']:HideInteraction()
                end
                Citizen.Wait(2500)
            end
        end
    end
end)

-- Functions 

function PickPlant(PlantId)
    LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
        if HasItem then
            TriggerServerEvent('framework-copper:server:set:palen:busy', PlantId, true)
            LSCore.Functions.Progressbar("pick_plant", "Knippen..", math.random(3500, 6500), false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "amb@prop_human_bum_bin@idle_b",
                anim = "idle_d",
                flags = 16,
            }, {}, {}, function() -- Done
                TriggerServerEvent('framework-copper:server:set:palen:busy', PlantId, false)
                TriggerServerEvent('framework-copper:server:set:picked:state', PlantId, true)
                TriggerServerEvent('framework-copper:server:give:copper')
                StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
                LSCore.Functions.Notify("Success", "success")
            end, function() -- Cancel
                TriggerServerEvent('framework-copper:server:set:palen:busy', PlantId, false)
                StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
                LSCore.Functions.Notify("Geannuleerd", "error")
            end)
        else
            LSCore.Functions.Notify("Je mist een zware schaar", "error")
        end
    end, "heavy-scissor")
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