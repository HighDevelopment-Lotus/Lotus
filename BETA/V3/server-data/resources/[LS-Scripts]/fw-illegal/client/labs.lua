
local ShowedNeededItem = false
local NearExit = false
local NearLab = false
InsideLab = false
CurrentLab = nil

-- Threads

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearLab = false
            for k,v in pairs(Config.Labs) do
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['Enter']['X'], v['Coords']['Enter']['Y'], v['Coords']['Enter']['Z'], true)
                local LabKeys = exports['fw-inv']:GetItemData(v['KeyName'])
                if Distance < 2.0 then
                    NearLab = true
                    CurrentLab = k
                    local ItemsNeeded = {[1] = {['Label'] = LabKeys["label"], ["Image"] = LabKeys["image"]}}
                    if not ShowedNeededItem then
                        ShowedNeededItem = true
                        TriggerEvent('framework-inv:client:set:required', ItemsNeeded, true)
                    end
                end
            end
            if not NearLab then
                if ShowedNeededItem then
                    ShowedNeededItem = false
                    TriggerEvent('framework-inv:client:set:required', ItemsNeeded, false)
                end
                Citizen.Wait(1000)
                if not InsideLab then
                    CurrentLab = nil
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearExit = false
            if InsideLab then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Labs[CurrentLab]['Coords']['Exit']['X'], Config.Labs[CurrentLab]['Coords']['Exit']['Y'], Config.Labs[CurrentLab]['Coords']['Exit']['Z'], true)
                if Distance < 1.0 then
                    NearExit = true
                    if not ShowingInteraction4 then
                        ShowingInteraction4 = true
                        exports['fw-ui']:ShowInteraction('[E] Verlaten', 'primary')
                    end
                    if IsControlJustReleased(0, 38) then
                        ExitCurrentLab()
                        exports['fw-ui']:HideInteraction()
                    end
                end
                if not NearExit then
                    if ShowingInteraction4 then
                        ShowingInteraction4 = false
                        exports['fw-ui']:HideInteraction()
                    end
                    Citizen.Wait(500)
                end
            end
        end
    end
end)

-- Events

RegisterNetEvent('framework-illegal:client:use:key', function(KeyName)
    if not InsideLab then
        if CurrentLab ~= nil then
            if KeyName == Config.Labs[CurrentLab]['KeyName'] then
                EnterCurrentLab()
            else
                LSCore.Functions.Notify('Dit is niet de juiste sleutel pannekoek', 'error')
            end
        end
    end
end)

RegisterNetEvent('framework-illegal:client:sync:inventory', function(LabId, data)
    Config.Labs[LabId]['Inventory'] = data
end)

-- Functions

function EnterCurrentLab()
    InsideLab = true
    TriggerEvent("framework-sound:client:play", "house-door-open", 0.1)
    OpenDoorAnim()
    Citizen.Wait(350)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    Citizen.Wait(100)
    SetEntityCoords(PlayerPedId(), Config.Labs[CurrentLab]['Coords']['Exit']['X'], Config.Labs[CurrentLab]['Coords']['Exit']['Y'], Config.Labs[CurrentLab]['Coords']['Exit']['Z'])
    Citizen.Wait(150)
    DoScreenFadeIn(500)
end

function ExitCurrentLab()
    TriggerEvent("framework-sound:client:play", "house-door-open", 0.1)
    OpenDoorAnim()
    Citizen.Wait(100)
    SetEntityCoords(PlayerPedId(), Config.Labs[CurrentLab]['Coords']['Enter']['X'], Config.Labs[CurrentLab]['Coords']['Enter']['Y'], Config.Labs[CurrentLab]['Coords']['Enter']['Z'])
    Citizen.Wait(150)
    InsideLab = false
end

function OpenDoorAnim()
    exports['fw-assets']:RequestAnimationDict('anim@heists@keycard@')
    TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(PlayerPedId())
end
