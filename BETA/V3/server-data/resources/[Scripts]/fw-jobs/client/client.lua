local JobProps = {}
LSCore, LoggedIn, PlayerJob, DoingJob, HasJobVehicle = exports['fw-base']:GetCoreObject(), false, {}, false, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1000, function()
        LSCore.Functions.TriggerCallback("framework-jobmanager:server:get:config", function(config)
           Config = config
        end)
        PlayerJob = LSCore.Functions.GetPlayerData().job
        SetupHuntingArea()
        SpawnJobProps()
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    if PlayerJob.name == 'tow' then
        ResetTowJob()
    elseif PlayerJob.name == 'garbage' then
        ResetTrash()
    end
    RemoveHuntingArea()
    DeSpawnJobProps()
    LoggedIn = false
end)

RegisterNetEvent('LSCore:Client:OnJobUpdate')
AddEventHandler('LSCore:Client:OnJobUpdate', function(JobInfo)
    if PlayerJob.name == 'tow' then
        ResetTowJob()
    elseif PlayerJob.name == 'garbage' then
        ResetTrash()
    end
    PlayerJob = JobInfo
end)

RegisterNetEvent('LSCore:Client:SetDuty')
AddEventHandler('LSCore:Client:SetDuty', function()
    PlayerJob = LSCore.Functions.GetPlayerData().job
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1000, function()
--      TriggerEvent('LSCore:GetObject', function(obj) LSCore = obj end)
--      Citizen.Wait(150)
--      LSCore.Functions.TriggerCallback("framework-jobmanager:server:get:config", function(config)
--         Config = config
--      end)
--      LoggedIn = true
--     end)
-- end)

-- Code

RegisterNetEvent('framework-jobmanager:client:request:payment')
AddEventHandler('framework-jobmanager:client:request:payment', function()
    local PlayerData = LSCore.Functions.GetPlayerData()
    if not DoingJob then
        if Config.JobData[PlayerData.citizenid] ~= nil and Config.JobData[PlayerData.citizenid]['Payment'] > 0 then
            TriggerServerEvent('framework-jobmanager:server:recieve:payment')
        else
            LSCore.Functions.Notify('Je bent nog niet wezen werken', 'error', 5500)
        end
    else
        LSCore.Functions.Notify('Je bent nog aan het werken', 'error', 5500)
    end
end)

RegisterNetEvent('framework-jobmanager:client:return:job:vehicle')
AddEventHandler('framework-jobmanager:client:return:job:vehicle', function(JobName, Entity)
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local Veh = LSCore.Functions.GetClosestVehicle()
    if JobName == 'tow' then
        if HasJobVehicle then
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.JobLocations['FlatBed']['X'], Config.JobLocations['FlatBed']['Y'], Config.JobLocations['FlatBed']['Z'], true)
            if Distance < 15.0 then
                if IsVehicleValid(Veh, 'flatbed') then
                    Citizen.SetTimeout(250, function()
                        HasJobVehicle = false
                        ResetTowJob()
                        LSCore.Functions.DeleteVehicle(Veh)
                        TriggerServerEvent('framework-jobmanager:server:set:duty', false)
                        LSCore.Functions.Notify('Voertuig ingeleverd. De borg staat bij je salaris opgeteld', 'success', 5500)
                    end)
                else
                    LSCore.Functions.Notify('Dit is geen werk voertuig', 'error', 5500)
                end
            else
                LSCore.Functions.Notify('Je bent te ver van je baan vandaan', 'error', 5500)
            end
        end
    elseif JobName == 'garbage' then
        if HasJobVehicle then
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.JobLocations['TrashVeh']['X'], Config.JobLocations['TrashVeh']['Y'], Config.JobLocations['TrashVeh']['Z'], true)
            if Distance < 15.0 then
                if IsVehicleValid(Veh, 'trash2') then
                    Citizen.SetTimeout(250, function()
                        ResetTrash()
                        HasJobVehicle = false
                        LSCore.Functions.DeleteVehicle(Veh)
                        TriggerServerEvent('framework-jobmanager:server:set:duty', false)
                        LSCore.Functions.Notify('Voertuig ingeleverd. De borg staat bij je salaris opgeteld', 'success', 5500)
                    end)
                else
                    LSCore.Functions.Notify('Dit is geen werk voertuig', 'error', 5500)
                end
            else
                LSCore.Functions.Notify('Je bent te ver van je baan vandaan', 'error', 5500)
            end
        end
    elseif JobName == 'taxi' then
        if HasJobVehicle then
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.JobLocations['TaxiVeh']['X'], Config.JobLocations['TaxiVeh']['Y'], Config.JobLocations['TaxiVeh']['Z'], true)
            if Distance < 15.0 then
                if IsVehicleValid(Veh, 'taxi') then
                    Citizen.SetTimeout(250, function()
                        DoingJob = false
                        HasJobVehicle = false
                        LSCore.Functions.DeleteVehicle(Veh)
                        TriggerServerEvent('framework-jobmanager:server:set:duty', false)
                        LSCore.Functions.Notify('Voertuig ingeleverd. De borg staat bij je salaris opgeteld', 'success', 5500)
                    end)
                else
                    LSCore.Functions.Notify('Dit is geen werk voertuig', 'error', 5500)
                end
            else
                LSCore.Functions.Notify('Je bent te ver van je baan vandaan', 'error', 5500)
            end
        end
    end
end)

-- RegisterNetEvent('framework-jobmanager:client:return:job:vehicle')
-- AddEventHandler('framework-jobmanager:client:return:job:vehicle', function(JobName, Entity)
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(4)
--         if LoggedIn then
--             local PlayerCoords = GetEntityCoords(PlayerPedId())
--             local veh = GetPedNearbyVehicles(PlayerPedId())
--             if PlayerJob.name == 'tow' then
--                 if HasJobVehicle and IsPedInAnyVehicle(PlayerPedId()) then
--                     local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.JobLocations['FlatBed']['X'], Config.JobLocations['FlatBed']['Y'], Config.JobLocations['FlatBed']['Z'], true)
--                     if Distance < 15.0 then
--                         if IsControlJustReleased(0, 38) then
--                             if IsVehicleValid(veh, 'flatbed') then
--                                 Citizen.SetTimeout(250, function()
--                                     HasJobVehicle = false
--                                     ResetTowJob()
--                                     LSCore.Functions.DeleteVehicle(veh)
--                                     TriggerServerEvent('framework-jobmanager:server:set:duty', false)
--                                     LSCore.Functions.Notify('Vehicle turned in! The deposit is included in your paycheck.', 'success', 5500)
--                                 end)
--                             else
--                                 LSCore.Functions.Notify("This isn't not a work vehicle...", 'error', 5500)
--                             end
--                         end
--                     else
--                         LSCore.Functions.Notify('You are nowhere near your work....', 'error', 5500)
--                     end
--                 end
--             elseif PlayerJob.name == 'garbage' then
--                 if HasJobVehicle and IsPedInAnyVehicle(PlayerPedId()) then
--                     local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.JobLocations['TrashVeh']['X'], Config.JobLocations['TrashVeh']['Y'], Config.JobLocations['TrashVeh']['Z'], true)
--                     if Distance < 15.0 then
--                         if IsControlJustReleased(0, 38) then
--                             if IsVehicleValid(veh, 'trash2') then
--                                 Citizen.SetTimeout(250, function()
--                                     ResetTrash()
--                                     HasJobVehicle = false
--                                     LSCore.Functions.DeleteVehicle(veh)
--                                     TriggerServerEvent('framework-jobmanager:server:set:duty', false)
--                                     LSCore.Functions.Notify('Vehicle turned in! The deposit is included in your paycheck.', 'success', 5500)
--                                 end)
--                             else
--                                 LSCore.Functions.Notify('Dit is geen werk voertuig', 'error', 5500)
--                             end
--                         end
--                     else
--                         LSCore.Functions.Notify('You are nowhere near your work....', 'error', 5500)
--                     end
--                 end
--             elseif PlayerJob.name == 'taxi' then
--                 if HasJobVehicle and IsPedInAnyVehicle(PlayerPedId()) then
--                     local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.JobLocations['TaxiVeh']['X'], Config.JobLocations['TaxiVeh']['Y'], Config.JobLocations['TaxiVeh']['Z'], true)
--                     if Distance < 15.0 then
--                         if IsControlJustReleased(0, 38) then
--                             if IsVehicleValid(veh, 'taxi') then
--                                 Citizen.SetTimeout(250, function()
--                                     DoingJob = false
--                                     HasJobVehicle = false
--                                     LSCore.Functions.DeleteVehicle(veh)
--                                     TriggerServerEvent('framework-jobmanager:server:set:duty', false)
--                                     LSCore.Functions.Notify('Vehicle turned in! The deposit is included in your paycheck.', 'success', 5500)
--                                 end)
--                             else
--                                 LSCore.Functions.Notify('Dit is geen werk voertuig', 'error', 5500)
--                             end
--                         end
--                     else
--                         LSCore.Functions.Notify('You are nowhere near your work....', 'error', 5500)
--                     end
--                 end
--             end
--         end
--     end
-- end)

RegisterNetEvent('framework-jobmanager:client:sync:payment')
AddEventHandler('framework-jobmanager:client:sync:payment', function(ConfigData)
    Config.JobData = ConfigData
end)

RegisterNetEvent('framework-jobmanager:client:add:temp:blip')
AddEventHandler('framework-jobmanager:client:add:temp:blip', function(Coords, Title)
    ShowTempBlip(Coords, Title)
end)

-- // Functions \\ --

function DrawText3D(x, y, z, text)
   SetTextScale(0.28, 0.28)
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

function SpawnJobProps()
    for k, v in pairs(Config.JobProps) do
        local Prop = GetHashKey(v['Prop'])
        exports['fw-assets']:RequestModelHash(Prop)
        local Object = CreateObject(Prop, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], false, false, false)
        SetEntityHeading(Object, v['Coords']['H'])
        FreezeEntityPosition(Object, true)
        SetEntityInvincible(Object, true)
        if not v['Visible'] then
            SetEntityVisible(Object, false)
        end
        if v['PlacePropGood'] then
            PlaceObjectOnGroundProperly(Object)
        end
        table.insert(JobProps, Object)
    end
end

function DeSpawnJobProps()
    for k, v in pairs(JobProps) do
        NetworkRequestControlOfEntity(v)
        DeleteEntity(v)
        DeleteObject(v)
    end
    JobProps = {}
end

function GetActiveServerPlayers()
    local PlayerPeds = {}
    if next(PlayerPeds) == nil then
        for _, Player in ipairs(GetActivePlayers()) do
            local PlayerPed = GetPlayerPed(Player)
            table.insert(PlayerPeds, PlayerPed)
        end
        return PlayerPeds
    end
end

function IsVehicleValid(Vehicle, RequestedVehicle)
    if GetEntityModel(Vehicle) == GetHashKey(RequestedVehicle) then
        return true
    else
        return false
    end
end

function ShowTempBlip(Coords, Text)
    local Transition = 150
    local Blips = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
    SetBlipSprite(Blips, 126)
    SetBlipColour(Blips, 6)
    SetBlipDisplay(Blips, 4)
    SetBlipScale(Blips, 1.0)
    SetBlipAsShortRange(Blips, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Text)
    EndTextCommandSetBlipName(Blips)
    while Transition ~= 0 do
        Wait(180 * 4)
        Transition = Transition - 1
        SetBlipAlpha(Blips, Transition)
        if Transition == 0 then
            SetBlipSprite(Blips, 2)
            RemoveBlip(Blips)
            return
        end
    end
end