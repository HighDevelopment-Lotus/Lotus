local PlacedBait, InHuntingArea = false, false
local HuntingBlips = {[1] = nil, [2] = nil}

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.HuntingData['HuntingArea']['Coords']['X'], Config.HuntingData['HuntingArea']['Coords']['Y'], Config.HuntingData['HuntingArea']['Coords']['Z'], false)
            if Distance < 475.0 then
                InHuntingArea = true
            else
                InHuntingArea = false
                if IsPedArmed(PlayerPedId(), 6) then
                    local Weapon = GetSelectedPedWeapon(PlayerPedId())
                    if Weapon == GetHashKey('weapon_sniperrifle2') then
                        TriggerEvent('framework-inv:client:reset:weapon')
                    end
                end
            end
            Citizen.Wait(500)
        else
            Citizen.Wait(1000)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-jobmanager:client:use:knife')
AddEventHandler('framework-jobmanager:client:use:knife', function()
    if not exports['fw-progressbar']:GetTaskBarStatus() then
        Citizen.SetTimeout(1000, function()
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Player, Distance = LSCore.Functions.GetClosestPlayer()
            local ClosestNpcPed, ClosestNpcDistance = LSCore.Functions.GetClosestPed(PlayerCoords, GetActiveServerPlayers())
            if InHuntingArea then
                if GetPedType(ClosestNpcPed) == 28 and ClosestNpcDistance < 1.5 then
                    if IsPedDeadOrDying(ClosestNpcPed) then
                        if Player ~= -1 and Distance < 2.0 then
                            LSCore.Functions.Notify("Er is teveel volk in de buurt", "error")
                        else
                            TriggerEvent('framework-inv:client:set:inventory:state', false)
                            TaskTurnPedToFaceEntity(PlayerPedId(), ClosestNpcPed, -1)
                            Citizen.Wait(1000)
                            ClearPedTasksImmediately(PlayerPedId())
                            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
                            LSCore.Functions.Progressbar("drink", "Dier aan het villen", 15000, false, true, {
                                disableMovement = true,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                local UsedBait = Config.HuntingData['BaitEntitys'][ClosestNpcPed] ~= nil and Config.HuntingData['BaitEntitys'][ClosestNpcPed] or false
                                -- TriggerServerEvent('framework-jobmanager:server:recieve:carcas', GetAnimalName(GetEntityModel(ClosestNpcPed)), IsThisAnimalIllegal(GetEntityModel(ClosestNpcPed)), UsedBait, ClosestNpcPed)
                                LSCore.Functions.TriggerCallback('framework-jobmanager:server:recieve:carcas', function() end, GetAnimalName(GetEntityModel(ClosestNpcPed)), IsThisAnimalIllegal(GetEntityModel(ClosestNpcPed)), UsedBait, ClosestNpcPed)
                                TriggerEvent('framework-inv:client:set:inventory:state', true) 
                                ClearPedTasks(PlayerPedId())
                                NetworkRequestControlOfEntity(ClosestNpcPed)
                                DeleteEntity(ClosestNpcPed)
                            end, function()
                                TriggerEvent('framework-inv:client:set:inventory:state', true)
                                LSCore.Functions.Notify("Geannuleerd", "error")
                                ClearPedTasks(PlayerPedId())
                            end)
                        end
                    else
                        LSCore.Functions.Notify("This animal is not dead...", "error")
                    end
                end
            else
                LSCore.Functions.Notify("Je bent niet in het jaag gebied", "error")
            end
        end)
    end
end)

RegisterNetEvent('framework-jobmanager:client:use:bait')
AddEventHandler('framework-jobmanager:client:use:bait', function()
    if InHuntingArea then
        if not PlacedBait then
            if not exports['fw-progressbar']:GetTaskBarStatus() then
                ClearPedTasks(PlayerPedId())
                TriggerEvent('framework-inv:client:set:inventory:state', false) 
                TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
                local PlayerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.75, 0) GetEntityCoords(PlayerPedId())
                LSCore.Functions.Progressbar("drink", "Aas Neerleggen..", 15000, false, true, {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    PlacedBait = true
                    TriggerEvent('framework-inv:client:set:inventory:state', true) 
                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'hunting-bait', 1, false)
                    ClearPedTasks(PlayerPedId())
                    StartBait(PlayerCoords)
                    Citizen.SetTimeout((60 * 1000) * 2, function()
                        PlacedBait = false
                    end)
                end, function()
                    PlacedBait = false
                    TriggerEvent('framework-inv:client:set:inventory:state', true)
                    LSCore.Functions.Notify("Geannuleerd", "error")
                    ClearPedTasks(PlayerPedId())
                end)
            end
        else
            LSCore.Functions.Notify("Je moet nog iets langer wachten", "error")
        end
    else
        LSCore.Functions.Notify("Je bent niet in het jaag gebied", "error")
    end
end)

RegisterNetEvent('framework-jobmanager:client:hunting:sync:bait:data')
AddEventHandler('framework-jobmanager:client:hunting:sync:bait:data', function(AnimalId, ConfigData)
    Config.HuntingData['BaitEntitys'][AnimalId] = ConfigData
end)

-- // Functions \\ --

function AddFoodProp(Coords)
    exports['fw-assets']:RequestModelHash(GetHashKey('prop_peanut_bowl_01'))
    local Object = CreateObject(GetHashKey('prop_peanut_bowl_01'), Coords.x, Coords.y, Coords.z, true, false, false)
    PlaceObjectOnGroundProperly(Object)
    return Object
end

function StartBait(Coords)
    local PropId = AddFoodProp(Coords)
    local SpawnCoords = GetAnimalSpawnCoords(Coords)
    local RandomModel = Config.HuntingData['Animals'][math.random(1, #Config.HuntingData['Animals'])]
    Citizen.SetTimeout(15000, function()
        Citizen.Wait(math.random(15000,120000))
        exports['fw-assets']:RequestModelHash(RandomModel['Animal'])
        local SpawnAnimal = CreatePed(28, RandomModel['Animal'], SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, 1.0, true, true)
        TriggerServerEvent('framework-jobmanager:server:hunting:register:bait:animal', SpawnAnimal, true)
        TaskGoStraightToCoord(SpawnAnimal, Coords, 20.0, -1, 0.0, 0.0)
        Citizen.CreateThread(function()
            local Finished = false
            while not Finished and not IsPedDeadOrDying(SpawnAnimal) and not IsPedFleeing(SpawnAnimal) do
                Citizen.Wait(0)
                local AnimalCoords = GetEntityCoords(SpawnAnimal)
                if #(Coords - AnimalCoords) < 1.0 then
                    ClearPedTasks(SpawnAnimal)
                    Citizen.Wait(350)
                    TaskStartScenarioInPlace(SpawnAnimal, "WORLD_DEER_GRAZING", 0, true)
                    Citizen.SetTimeout(7500, function()
                        Finished = true
                        ClearPedTasks(SpawnAnimal)
                        NetworkRequestControlOfEntity(PropId)
                        DeleteEntity(PropId)
                        TaskSmartFleePed(SpawnAnimal, PlayerPedId(), 10.0, -1)
                    end)
                end
                if #(AnimalCoords - GetEntityCoords(PlayerPedId())) < 15.0 then
                    ClearPedTasks(SpawnAnimal)
                    TaskSmartFleePed(SpawnAnimal, PlayerPedId(), 600.0, -1)
                    NetworkRequestControlOfEntity(PropId)
                    DeleteEntity(PropId)
                    Finished = true
                end
                if IsPedDeadOrDying(SpawnAnimal) then
                    ClearPedTasks(SpawnAnimal)
                    TaskSmartFleePed(SpawnAnimal, PlayerPedId(), 600.0, -1)
                    NetworkRequestControlOfEntity(PropId)
                    DeleteEntity(PropId)
                    Finished = true
                end
            end
        end)
    end)
end

function GetAnimalSpawnCoords(Coords)
    local RandomX = math.random(-50, 50)
    local RandomY = math.random(-50, 50)
    local NewCoords = vector3(Coords.x + RandomX, Coords.y + RandomY, Coords.z)
    local Nothing, ResultZ = GetGroundZAndNormalFor_3dCoord(NewCoords.x, NewCoords.y, 1023.9)
    NewCoords = vector3(NewCoords.x, NewCoords.y, ResultZ)
    return NewCoords
end

function SetupHuntingArea()
    local CurrentRadiosBlip = AddBlipForRadius(Config.HuntingData['HuntingArea']['Coords']['X'], Config.HuntingData['HuntingArea']['Coords']['Y'], Config.HuntingData['HuntingArea']['Coords']['Z'], 475.0)        
    SetBlipRotation(CurrentRadiosBlip, 0)
    SetBlipColour(CurrentRadiosBlip, 0)
    SetBlipAlpha(CurrentRadiosBlip, 100)
    HuntingBlips[1] = CurrentRadiosBlip

    local CurrentBlip = AddBlipForCoord(Config.HuntingData['HuntingArea']['Coords']['X'], Config.HuntingData['HuntingArea']['Coords']['Y'], Config.HuntingData['HuntingArea']['Coords']['Z'])
    SetBlipSprite(CurrentBlip, 141)
    SetBlipDisplay(CurrentBlip, 4)
    SetBlipScale(CurrentBlip, 0.7)
    SetBlipColour(CurrentBlip, 22)
    SetBlipAsShortRange(CurrentBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Hunting Spot')
    EndTextCommandSetBlipName(CurrentBlip)
    HuntingBlips[2] = CurrentBlip
end

function IsThisAnimalIllegal(AnimalName)
    for i = 1, #Config.HuntingData['Animals'] do
        if Config.HuntingData['Animals'][i]['HashName'] == AnimalName then
            return Config.HuntingData['Animals'][i]['Illegal']
        end
    end
    return false
end

function GetAnimalName(Model)
    for i = 1, #Config.HuntingData['Animals'] do
        if Config.HuntingData['Animals'][i]['HashName'] == Model then
            return Config.HuntingData['Animals'][i]['AnimalName']
        end
    end
    return false
end

function RemoveHuntingArea()
    RemoveBlip(HuntingBlips[1])
    RemoveBlip(HuntingBlips[2])
    HuntingBlips = {[1] = nil, [2] = nil}
end

function IsNearHunting()
    return InHuntingArea
end