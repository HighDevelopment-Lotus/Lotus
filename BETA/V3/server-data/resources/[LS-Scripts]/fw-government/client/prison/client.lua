local LSCore, LoggedIn = exports['fw-base']:GetCoreObject(), false
local JailTime, InJail, ShowingInteraction, currentJob, IsInHouse = 0, false, false, "electrician", false
local CallActive = false
RegisterNetEvent("LSCore:Client:OnPlayerLoaded")
AddEventHandler("LSCore:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(1250, function()
        LoggedIn = true
        PlayerJob = LSCore.Functions.GetPlayerData().job
        JailTime = LSCore.Functions.GetPlayerData().metadata["jailtime"]
    end) 
end)

RegisterNetEvent('LSCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    InJail, JailTime, currentJob = false, 0, nil
	RemoveBlip(currentBlip)
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if LoggedIn then
            if InJail then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Prison"]['Coords']['X'], Config.Locations["Prison"]['Coords']['Y'], Config.Locations["Prison"]['Coords']['Z'], false) > 220.0 and InJail) then
                    JailTime, InJail = 0, false
                    TriggerServerEvent("framework-prison:server:set:jail:leave")
                    TriggerServerEvent('framework-prison:server:set:alarm', true)
                    TriggerServerEvent("LSCore:Server:SetMetaData", "jailitems", nil)
                    TriggerServerEvent('framework-police:server:alert:prison', GetEntityCoords(PlayerPedId()))
                    LSCore.Functions.Notify("Je bent de gevangenis ontsnapt.. Maak dat je weg komt!", "error")
                else
                    Citizen.Wait(5000)
                end

                -- if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 1830.4757, 2586.2946, 46.007766, false) < 10.0) then
                --     IsInHouse = true
                -- else
                --     Citizen.Wait(5000)
                -- end
            else
                Citizen.Wait(5000)
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        if LoggedIn then
            -- print(CallActive)
            local NearAnything = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            if CallActive then
                local Distance = #(PlayerCoords - vector3(1831.2248, 2587.363, 46.014369))
                if Distance < 3.5 then
                    NearAnything = true
                    if not ShowingInteraction then
                        ShowingInteraction = true
                        -- print('set')
                        exports['fw-ui']:ShowInteraction('Gevangenis Telefoon', 'primary')
                    end
                end
            end 
            if not NearAnything then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['fw-ui']:HideInteraction()
                    exports["framework-voice"]:removePlayerFromCall(878914)
                end
                Citizen.Wait(5000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if InJail then
                InRange = false
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                for k, v in pairs(Config.Locations['Search']) do
                    local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                    if Distance < 2.5 then 
                        InRange = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['fw-ui']:ShowInteraction('[E] ??', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            SearchPlace(v['Reward'], v['Chance'])
                        end
                    end
                end
                if not InRange then
                    if ShowingInteraction then
                        ShowingInteraction = false
                        exports['fw-ui']:HideInteraction()
                    end
                    Citizen.Wait(450)
                end
            else
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-prison:client:spawn:prison')
AddEventHandler('framework-prison:client:spawn:prison', function()
    Citizen.SetTimeout(550, function()
        LSCore.Functions.GetPlayerData(function(PlayerData)
            local RandomStartPosition = Config.Locations['Spawns'][math.random(1, #Config.Locations['Spawns'])]
            TriggerEvent('framework-sound:client:play', 'jail-door', 0.5)
            Citizen.Wait(450)
            SetEntityCoords(PlayerPedId(), RandomStartPosition['Coords']['X'], RandomStartPosition['Coords']['Y'], RandomStartPosition['Coords']['Z'] - 0.9, 0, 0, 0, false)
            SetEntityHeading(PlayerPedId(), RandomStartPosition['Coords']['H'])
            Citizen.Wait(1000)
            TriggerEvent('animations:client:EmoteCommandStart', {RandomStartPosition['Animation']})
            Citizen.Wait(2000)
            InJail = true
            JailTime = PlayerData.metadata["jailtime"]
            LSCore.Functions.Notify("Je zit in de gevangenis voor "..JailTime.." maand(en)..", "error", 6500)
            DoScreenFadeIn(1000)
            LSCore.Functions.Notify("Doe werk voor strafvermindering fix wat kastjes", "error", 6500)
        end)
    end)
end)

RegisterNetEvent('framework-prison:client:enter:prison')
AddEventHandler('framework-prison:client:enter:prison', function(Time, bool)
    JailTime, InJail = Time, bool
end)

RegisterNetEvent('framework-prison:client:setbooth')
AddEventHandler('framework-prison:client:setbooth', function()
    -- local PlayerCoords = GetEntityCoords(PlayerPedId())
        CallActive = true
        exports["framework-voice"]:addPlayerToCall(94678)
        -- exports["framework-voice"]:addPlayerToCall(94678)
end)

RegisterNetEvent('framework-prison::client:set:time')
AddEventHandler('framework-prison::client:set:time', function(Time)
    JailTime = Time
end)

RegisterNetEvent('framework-prison:client:set:alarm')
AddEventHandler('framework-prison:client:set:alarm', function(bool)
    if bool then
        while not PrepareAlarm("PRISON_ALARMS") do
            Citizen.Wait(10)
        end
        StartAlarm("PRISON_ALARMS", true)
        Citizen.Wait(60 * 1000)
        StopAllAlarms(true)
    else
        StopAllAlarms(true)
    end
end)

RegisterNetEvent('framework-prison:client:leave:prison')
AddEventHandler('framework-prison:client:leave:prison', function()
    local RandomSeat = Config.Locations['Leave-Spawn'][math.random(1, #Config.Locations['Leave-Spawn'])]
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    TriggerEvent('framework-sound:client:play', 'jail-cell', 0.2)
    SetEntityCoords(PlayerPedId(), RandomSeat['Coords']['X'], RandomSeat['Coords']['Y'], RandomSeat['Coords']['Z'] - 0.9, 0, 0, 0, false)
    SetEntityHeading(PlayerPedId(), RandomSeat['Coords']['H'])
    Citizen.Wait(250)
    TriggerEvent('animations:client:EmoteCommandStart', {RandomSeat['Animation']})
    Citizen.Wait(2000)
    DoScreenFadeIn(1000)
end)

RegisterNetEvent('framework-prison:client:check:time')
AddEventHandler('framework-prison:client:check:time', function()
    if InJail then
        if JailTime <= 0 then
            JailTime, InJail = 0, false
            TriggerServerEvent("framework-prison:server:get:items:back")
            TriggerServerEvent("framework-prison:server:set:jail:leave")
            TriggerEvent('framework-prison:client:leave:prison')
            LSCore.Functions.Notify("Je bent vrij!", "success")
        else
            LSCore.Functions.Notify("Je moet nog "..JailTime.." maand(en) zitten.", "error")
        end
    else
        LSCore.Functions.Notify("Je zit niet in de gevangenis..", "error")
    end
end)

-- // Functions \\ --

function SearchPlace(Reward, Chance)
    local Label = 'Zoeken..'
    if Reward == 'slushy' then
      Label = 'Slushy maken..'
    end
    LSCore.Functions.Progressbar("search-jail", Label, math.random(5000, 6500), false, true, {
        disableMovement = false,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        if math.random(1,100) < Chance then
            -- GiveItem Reward
            TriggerServerEvent('framework-prison:server:find:reward', Reward)
            LSCore.Functions.Notify("Noice!", "success")
        else
            LSCore.Functions.Notify("Helemaal niks..", "error") 
        end
    end, function() -- Cancel
        LSCore.Functions.Notify("Geannuleerd..", "error") 
    end)
end

-- Threads
CreateThread(function()
    exports['fw-polyzone']:AddTargetModel(`prop_elecbox_10`, {
        options = {
            {
                icon = 'fas fa-coins',
                label = 'Werk uitvoeren',
                targeticon = 'fas fa-briefcase',
                action = function(entity)
                    if IsPedAPlayer(entity) then return false end
                    isWorking = true
                exports['fw-ui']:StartSkillTest(1, 'Normal', function(Outcome)
                    if Outcome then
                            LSCore.Functions.Progressbar("work_electric", "Werken aan electriciteit", math.random(19000, 20000), false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "amb@world_human_welding@male@idle_a",
                                anim = "idle_b",
                                flags = 17,
                            }, {}, {}, function() -- Done
                                isWorking = false
                                StopAnimTask(PlayerPedId(), "amb@world_human_welding@male@idle_a", "idle_b", 1.0)
                                JobDone()
                            end, function() -- Cancel
                                isWorking = false
                                StopAnimTask(PlayerPedId(), "amb@world_human_welding@male@idle_a", "idle_b", 1.0)
                                LSCore.Functions.Notify('Geannuleerd', "error")
                            end)
                        end
                    end)
                end,
                canInteract = function()
                    if InJail and not isWorking then
                        return true
                    end
                end,
            }
        },
        distance = 2.5
    })
end)
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

function GetInJailStatus()
    return InJail
end

function InPrisonHouse()
    return IsInHouse
end