local JobProps = {}
LSCore, LoggedIn, PlayerJob, DoingJob, HasJobVehicle = exports['ls-core']:GetCoreObject(), false, {}, false, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1000, function()
        LSCore.Functions.TriggerCallback("ls-jobmanager:server:get:config", function(config)
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

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1000, function()
--      TriggerEvent('LSCore:GetObject', function(obj) LSCore = obj end)
--      Citizen.Wait(150)
--      LSCore.Functions.TriggerCallback("ls-jobmanager:server:get:config", function(config)
--         Config = config
--      end)
--      LoggedIn = true
--     end)
-- end)

-- Code

RegisterNetEvent('ls-jobmanager:client:request:payment')
AddEventHandler('ls-jobmanager:client:request:payment', function()
    local PlayerData = LSCore.Functions.GetPlayerData()
    if not DoingJob then
        if Config.JobData[PlayerData.citizenid] ~= nil and Config.JobData[PlayerData.citizenid]['Payment'] > 0 then
            TriggerServerEvent('ls-jobmanager:server:recieve:payment')
        else
            LSCore.Functions.Notify('Je hebt nog niet eens gewerkt joh..', 'error', 5500)
        end
    else
        LSCore.Functions.Notify('Je bent nog bezig met werken joh..', 'error', 5500)
    end
end)

RegisterNetEvent('ls-jobmanager:client:return:job:vehicle')
AddEventHandler('ls-jobmanager:client:return:job:vehicle', function(JobName, Entity)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    if JobName == 'tow' then
        if HasJobVehicle then
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.JobLocations['FlatBed']['X'], Config.JobLocations['FlatBed']['Y'], Config.JobLocations['FlatBed']['Z'], true)
            if Distance < 15.0 then
                if IsVehicleValid(Entity['Entity'], 'flatbed') then
                    Citizen.SetTimeout(250, function()
                        HasJobVehicle = false
                        ResetTowJob()
                        LSCore.Functions.DeleteVehicle(Entity['Entity'])
                        TriggerServerEvent('ls-jobmanager:server:set:duty', false)
                        LSCore.Functions.Notify('Voertuig ingeleverd! De borg is inbegrepen bij je salaris.', 'success', 5500)
                    end)
                else
                    LSCore.Functions.Notify('Dit is geen werk voertuig..', 'error', 5500)
                end
            else
                LSCore.Functions.Notify('Je bent niet in de buurt van je werk..', 'error', 5500)
            end
        end
    elseif JobName == 'garbage' then
        if HasJobVehicle then
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.JobLocations['TrashVeh']['X'], Config.JobLocations['TrashVeh']['Y'], Config.JobLocations['TrashVeh']['Z'], true)
            if Distance < 15.0 then
                if IsVehicleValid(Entity['Entity'], 'trash2') then
                    Citizen.SetTimeout(250, function()
                        ResetTrash()
                        HasJobVehicle = false
                        LSCore.Functions.DeleteVehicle(Entity['Entity'])
                        TriggerServerEvent('ls-jobmanager:server:set:duty', false)
                        LSCore.Functions.Notify('Voertuig ingeleverd! De borg is inbegrepen bij je salaris.', 'success', 5500)
                    end)
                else
                    LSCore.Functions.Notify('Dit is geen werk voertuig..', 'error', 5500)
                end
            else
                LSCore.Functions.Notify('Je bent niet in de buurt van je werk..', 'error', 5500)
            end
        end
    elseif JobName == 'taxi' then
        if HasJobVehicle then
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.JobLocations['TaxiVeh']['X'], Config.JobLocations['TaxiVeh']['Y'], Config.JobLocations['TaxiVeh']['Z'], true)
            if Distance < 15.0 then
                if IsVehicleValid(Entity['Entity'], 'taxi') then
                    Citizen.SetTimeout(250, function()
                        DoingJob = false
                        HasJobVehicle = false
                        LSCore.Functions.DeleteVehicle(Entity['Entity'])
                        TriggerServerEvent('ls-jobmanager:server:set:duty', false)
                        LSCore.Functions.Notify('Voertuig ingeleverd! De borg is inbegrepen bij je salaris.', 'success', 5500)
                    end)
                else
                    LSCore.Functions.Notify('Dit is geen werk voertuig..', 'error', 5500)
                end
            else
                LSCore.Functions.Notify('Je bent niet in de buurt van je werk..', 'error', 5500)
            end
        end
    end
end)

RegisterNetEvent('ls-jobmanager:client:sync:payment')
AddEventHandler('ls-jobmanager:client:sync:payment', function(ConfigData)
    Config.JobData = ConfigData
end)

RegisterNetEvent('ls-jobmanager:client:add:temp:blip')
AddEventHandler('ls-jobmanager:client:add:temp:blip', function(Coords, Title)
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
        exports['ls-assets']:RequestModelHash(Prop)
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