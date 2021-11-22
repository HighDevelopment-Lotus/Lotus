local TrainVehicles, ShowingInteraction, GoToNumber, IamTheHost = {}, false, 0, false
local LSCore, LoggedIn, IsInTrain, CurrentStationNumber, ForceRemove = exports['ls-core']:GetCoreObject(), false, false, nil, false

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

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearAnythings = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            SetClosestMetro()
            for k, v in pairs(Config.TrainData["Stations"]) do
                local Distance = #(PlayerCoords - v)
                if Distance < 1.0 then
                    NearAnythings = true
                    if not Config.TrainData['Busy'] then
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['ls-ui']:ShowInteraction('[E] Metro ($350)', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            LSCore.Functions.TriggerCallback('LSCore:RemoveCash', function(DidPay) 
                                if DidPay then
                                    IamTheHost = true
                                    CreateTrain(PlayerCoords)
                                    TriggerServerEvent('ls-trains:server:set:busy', true)
                                    exports['ls-ui']:EditInteraction('Metro', 'error')
                                else
                                    LSCore.Functions.Notify('Je hebt niet genoeg contant..', 'error', 5000)
                                end
                            end, 350)
                        end
                    else
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['ls-ui']:ShowInteraction('Metro', 'error')
                        end
                    end
                end
            end
            if not NearAnythings then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['ls-ui']:HideInteraction()
                end
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if GoToNumber ~= 0 and IamTheHost then
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                local Distance = #(PlayerCoords - Config.TrainStations[GoToNumber])
                if Distance > 50.0 then
                    SetTrainSpeed(TrainVehicles[1], 50.0)	
                    SetTrainCruiseSpeed(TrainVehicles[1], 50.0)
                end
                if Distance < 50.0 then
                    SetTrainSpeed(TrainVehicles[1], 20.0)	
                    SetTrainCruiseSpeed(TrainVehicles[1], 20.0)
                end
                if Distance < 20.0 then
                    SetTrainSpeed(TrainVehicles[1], 10.0)	
                    SetTrainCruiseSpeed(TrainVehicles[1], 10.0)
                end
                if Distance < 8.5 then
                    SetTrainSpeed(TrainVehicles[1], 0.0)	
                    SetTrainCruiseSpeed(TrainVehicles[1], 0.0)
                    FreezeEntityPosition(TrainVehicles[1], true)
                    if not DoingTimer then
                        local SetNext = GoToNumber
                        DoingTimer, GoToNumber = true, 0
                        TriggerServerEvent('ls-sound:server:play:distance', 30.0, 'metro-ding', 0.8)
                        Citizen.SetTimeout(50000, function()
                            local MainTrainPlayers = AreTheirAnyPlayersInThisTrain(TrainVehicles[1])
                            local TrailerTrainPlayers = AreTheirAnyPlayersInThisTrain(TrainVehicles[2])
                            if ForceRemove or MainTrainPlayer == false and TrailerTrainPlayers == false then
                                for k, v in pairs(TrainVehicles) do
                                    DeleteVehicle(v)
                                    LSCore.Functions.DeleteVehicle(v)
                                end
                                DeleteAllTrains()
                                DoingTimer = false
                                TrainVehicles, IamTheHost = {}, false
                                TriggerServerEvent('ls-trains:server:set:busy', false)
                            else
                                if math.random(1, 100) < 15 then
                                    TriggerServerEvent('ls-sound:server:play:distance', 30.0, 'metro-delay', 0.8)
                                    Citizen.SetTimeout(50000, function()
                                        local MainTrainPlayers = AreTheirAnyPlayersInThisTrain(TrainVehicles[1])
                                        local TrailerTrainPlayers = AreTheirAnyPlayersInThisTrain(TrainVehicles[2])
                                        if ForceRemove or MainTrainPlayer == false and TrailerTrainPlayers == false then
                                            for k, v in pairs(TrainVehicles) do
                                                DeleteVehicle(v)
                                                LSCore.Functions.DeleteVehicle(v)
                                            end
                                            DeleteAllTrains()
                                            DoingTimer = false
                                            TrainVehicles, IamTheHost = {}, false
                                            TriggerServerEvent('ls-trains:server:set:busy', false)
                                        else
                                            SetTrainSpeed(TrainVehicles[1], 10.0)	
                                            SetTrainCruiseSpeed(TrainVehicles[1], 10.0)
                                            FreezeEntityPosition(TrainVehicles[1], false)
                                            if SetNext + 1 > #Config.TrainStations then
                                                GoToNumber = 1
                                            else
                                                GoToNumber = SetNext + 1
                                            end
                                            DoingTimer = false
                                        end
                                    end)
                                else
                                    SetTrainSpeed(TrainVehicles[1], 10.0)	
                                    SetTrainCruiseSpeed(TrainVehicles[1], 10.0)
                                    FreezeEntityPosition(TrainVehicles[1], false)
                                    if SetNext + 1 > #Config.TrainStations then
                                        GoToNumber = 1
                                    else
                                        GoToNumber = SetNext + 1
                                    end
                                    DoingTimer = false
                                end
                            end
                        end)
                    end
                end
            else
                Citizen.Wait(100)
            end
        else    
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsControlJustReleased(0, 38) then
                local Vehicle = LSCore.Functions.GetClosestVehicle()
                if IsThisModelATrain(GetEntityModel(Vehicle)) then
                    if not IsInTrain then
                        local FreeSeat = GetFreeSeat(Vehicle)
                        if FreeSeat ~= false then
                            SetPedIntoVehicle(GetPlayerPed(-1), Vehicle, FreeSeat)
                            IsInTrain = true
                            if IamTheHost then
                                ForceRemove = false
                            end
                        end
                    else
                        if IsPedInAnyTrain(GetPlayerPed(-1)) and CurrentStationNumber ~= nil then
                            FreezeEntityPosition(PlayerPedId(), true)
                            TaskLeaveVehicle(PlayerPedId(), Vehicle, 1)
                            Citizen.Wait(2000)
                            FreezeEntityPosition(PlayerPedId(), false)
                            SetEntityCoords(GetPlayerPed(-1), Config.TrainData["Stations"][CurrentStationNumber])
                            IsInTrain = false
                            if IamTheHost then
                                ForceRemove = true
                            end
                        end
                    end    
                end
            end
        else    
            Citizen.Wait(450)
        end
    end
end)
-- // Events \\ --

RegisterNetEvent('ls-trains:client:sync:busy')
AddEventHandler('ls-trains:client:sync:busy', function(Bool)
    Config.TrainData['Busy'] = Bool
end)

-- // Functions \\ --

function CreateTrain(Coords)
    for k, v in pairs(Config.Models) do
        exports['ls-assets']:RequestModelHash(GetHashKey(v))
    end
    local MetroTrain = CreateMissionTrain(25, Coords.x, Coords.y, Coords.z, true)
	local TrainTrailer = GetTrainCarriage(MetroTrain, 1)
	SetVehicleHasBeenOwnedByPlayer(MetroTrain, true)
	SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(MetroTrain), false)
	SetVehicleHasBeenOwnedByPlayer(TrainTrailer, true)
	SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(TrainTrailer), false)
    table.insert(TrainVehicles, MetroTrain)
    table.insert(TrainVehicles, TrainTrailer)
    TriggerServerEvent('ls-sound:server:play:distance', 30.0, 'metro-ding', 0.5)
    SetTrainSpeed(MetroTrain, 0.0)	
    SetTrainCruiseSpeed(MetroTrain, 0.0)
    FreezeEntityPosition(MetroTrain, true)
    Citizen.SetTimeout(50000, function()
        local MainTrainPlayers = AreTheirAnyPlayersInThisTrain(MetroTrain)
        local TrailerTrainPlayers = AreTheirAnyPlayersInThisTrain(TrainTrailer)
        if ForceRemove or MainTrainPlayer == false and TrailerTrainPlayers == false then
            for k, v in pairs(TrainVehicles) do
                DeleteVehicle(v)
                LSCore.Functions.DeleteVehicle(v)
            end
            DeleteAllTrains()
            TrainVehicles, IamTheHost = {}, false
            TriggerServerEvent('ls-trains:server:set:busy', false)
        else
            SetTrainSpeed(MetroTrain, 50.0)	
            SetTrainCruiseSpeed(MetroTrain, 50.0)
            FreezeEntityPosition(MetroTrain, false)
            if CurrentStationNumber + 1 > #Config.TrainStations then
                GoToNumber = 1
            else
                GoToNumber = CurrentStationNumber + 1
            end
        end
    end)
end

function GetFreeSeat(Vehicle)
    for i = 0, 3 do
        if IsVehicleSeatFree(Vehicle, i) then
            return i
        end
    end
    return false
end

function AreTheirAnyPlayersInThisTrain(Vehicle)
    local Count = 0
    for i = 0, 3 do
        if IsVehicleSeatFree(Vehicle, i) then
            Count = Count + 1
        end
    end
    if Count == 4 then
        return false
    else
        return true
    end
end

function SetClosestMetro()
    local Distance = nil
    local Current = nil
    for k, v in pairs(Config.TrainData["Stations"]) do
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        if Config.TrainData["Stations"][k] ~= nil then
            if Current ~= nil then
                if (GetDistanceBetweenCoords(PlayerCoords, Config.TrainData["Stations"][k], true) < Distance) then
                    Current = k
                    Distance = #(PlayerCoords - Config.TrainData["Stations"][k])
                end
            else
                Distance = #(PlayerCoords - Config.TrainData["Stations"][k])
                Current = k
            end
        end
    end
    CurrentStationNumber = Current
end