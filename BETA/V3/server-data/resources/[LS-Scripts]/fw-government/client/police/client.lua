local ShowingInteraction = false
LSCore, LoggedIn, PlayerJob, DutyBlips = exports['fw-base']:GetCoreObject(), false, {}, {}

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(2500, function()
        LSCore.Functions.TriggerCallback('framework-police:server:get:config', function(ConfigData)
            Config = ConfigData
        end)
        PlayerJob = LSCore.Functions.GetPlayerData().job
        -- SpawnPoliceProps()
        Citizen.Wait(3500)
        LSCore.Functions.GetPlayerData(function(PlayerData)
            if PlayerData.metadata['tracker'] then
              TriggerEvent('framework-police:client:set:tracker', true)
            end
            if PlayerData.metadata['ishandcuffed'] then
                TriggerServerEvent('framework-sound:server:play:distance', 2.0, 'handcuff', 0.2)
                Config.IsHandCuffed = true
            end
        end)
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    TriggerServerEvent("framework-police:server:update:blips")
    TriggerServerEvent("framework-police:server:update:current:cops")
    if DutyBlips ~= nil then
        for k, v in pairs(DutyBlips) do
            RemoveBlip(v)
        end
        DutyBlips = {}
    end
    ClearPedTasks(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
    -- DeSpawnPoliceProps()
    LoggedIn = false
end)

RegisterNetEvent('LSCore:Client:OnJobUpdate')
AddEventHandler('LSCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if DutyBlips ~= nil then
        for k, v in pairs(DutyBlips) do
            RemoveBlip(v)
        end
        DutyBlips = {}
    end
    if PlayerJob.name == 'police' or PlayerJob.name == 'ambulance' then
        TriggerServerEvent("framework-police:server:update:blips")
        TriggerServerEvent("framework-police:server:update:current:cops")
    end
end)

RegisterNetEvent('LSCore:Client:SetDuty')
AddEventHandler('LSCore:Client:SetDuty', function()
    Citizen.SetTimeout(5000, function()
        PlayerJob = LSCore.Functions.GetPlayerData().job
        if DutyBlips ~= nil then
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
            DutyBlips = {}
        end
        TriggerServerEvent("framework-police:server:update:blips")
        TriggerServerEvent("framework-police:server:update:current:cops")
    end)
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end)    
--         Citizen.Wait(100)
--         LSCore.Functions.TriggerCallback('framework-police:server:get:config', function(ConfigData)
--             Config = ConfigData
--         end)
--         PlayerJob = LSCore.Functions.GetPlayerData().job
--         SpawnPoliceProps()
--         Citizen.Wait(3500)
--         LSCore.Functions.GetPlayerData(function(PlayerData)
--             if PlayerData ~= nil then
--                 if PlayerData.metadata['tracker'] then
--                   TriggerEvent('framework-police:client:set:tracker', true)
--                 end
--                 if PlayerData.metadata['ishandcuffed'] then
--                     TriggerServerEvent('framework-sound:server:play:distance', 2.0, 'handcuff', 0.2)
--                     Config.IsHandCuffed = true
--                 end
--             end
--         end)
--         LoggedIn = true
--     end)
-- end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if PlayerJob.name == 'police' and PlayerJob.onduty then
                local NearAnything = false
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                for k, v in pairs(Config.PoliceLocations['FingerPrint']) do
                    local Distance = #(PlayerCoords - v['Coords'])
                    if Distance < 1.0 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['fw-ui']:ShowInteraction('[E] Vinger Scanner', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            local Player, Distance = LSCore.Functions.GetClosestPlayer()
                            if Distance < 1.5 then
                                local ServerId = GetPlayerServerId(Player)
                                exports['fw-ui']:OpenPoliceFinger()
                                TriggerServerEvent('framework-police:server:give:finger:scanner', ServerId)
                            else
                                LSCore.Functions.Notify("Er is niemand in de buurt..", "error")
                            end
                        end
                    end
                end
                for k, v in pairs(Config.PoliceLocations['Locker']) do
                    local Distance = #(PlayerCoords - v['Coords'])
                    if Distance < 1.0 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['fw-ui']:ShowInteraction('[E] Kluis', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            if exports['fw-inv']:CanOpenInventory() then
                                TriggerServerEvent('framework-inv:server:open:inventory:other', "personalsafe_"..LSCore.Functions.GetPlayerData().citizenid, 'Stash', 30, 2000000)
                            end
                        end
                    end
                end
                for k, v in pairs(Config.PoliceLocations['PoliceSafe']) do
                    local Distance = #(PlayerCoords - v['Coords'])
                    if Distance < 1.0 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['fw-ui']:ShowInteraction('[E] Politie Kluis', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            Citizen.SetTimeout(125, function()
                                if exports['fw-inv']:CanOpenInventory() then
                                    local Shop = {['Type'] = 'Store', ['SubType'] = 'PoliceStore', ['InvName'] = 'Politie Kluis', ['Items'] = Config.PoliceSafe['Items']}
                                    TriggerServerEvent('framework-inv:server:open:inventory:other', Shop, 'Store')
                                end
                            end)
                        end
                    end
                end
                for k, v in pairs(Config.PoliceLocations['Delete']) do
                    local Distance = #(PlayerCoords - v['Coords'])
                    if Distance < 2.5 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['fw-ui']:ShowInteraction('[E] Deleter', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            -- Citizen.SetTimeout(125, function()
                                local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                                LSCore.Functions.DeleteVehicle(Vehicle)
                            -- end)
                        end
                    end
                end
                for k, v in pairs(Config.PoliceLocations['Evidence']) do
                    local Distance = #(PlayerCoords - v['Coords'])
                    if Distance < 1.0 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['fw-ui']:ShowInteraction('[E] Bewijs Kluis', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            local Data = {['Title'] = 'Kluis Nummer', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-sort-numeric-up"></i>'}
                            LSCore.Functions.OpenInput(Data, function(ReturnData)
                                if ReturnData ~= false then
                                    Citizen.SetTimeout(250, function()
                                        if exports['fw-inv']:CanOpenInventory() then
                                            TriggerServerEvent('framework-inv:server:open:inventory:other', "evidencestash_"..ReturnData, 'Stash', 50, 2500000)
                                        end
                                    end)
                                end
                            end)
                        end
                    end
                end
                if not NearAnything then
                    if ShowingInteraction then
                        ShowingInteraction = false
                        exports['fw-ui']:HideInteraction()
                    end
                    Citizen.Wait(500)
                end
            else
                Citizen.Wait(500)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-police:client:update:blips')
AddEventHandler('framework-police:client:update:blips', function(PlayerData)
    LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
        if HasItem then
            if PlayerJob ~= nil and (PlayerJob.name == 'police' or PlayerJob.name == 'ambulance') and PlayerJob.onduty then
                if DutyBlips ~= nil then
                    for k, v in pairs(DutyBlips) do
                        RemoveBlip(v)
                    end
                    DutyBlips = {}
                end
                for k, v in pairs(PlayerData) do
                    local ServerPlayer = GetPlayerFromServerId(v['Source'])
                    if NetworkIsPlayerActive(ServerPlayer) and GetPlayerPed(ServerPlayer) ~= PlayerPedId() then
                        CreateDutyBlips(ServerPlayer, v['Label'], v['Job'])
                    end
                end
            end
        else
            if DutyBlips ~= nil then
                for k, v in pairs(DutyBlips) do
                    RemoveBlip(v)
                end
                DutyBlips = {}
            end
        end
    end, 'radio')
end)

RegisterNetEvent('framework-police:client:impound:closest')
AddEventHandler('framework-police:client:impound:closest', function() 
    print('Voertuig in impound nemen')
    local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if Vehicle ~= 0 and Distance < 1.7 then
        LSCore.Functions.TriggerCallback('framework-garage:server:is:vehicle:owner', function(IsOwned)
            if IsOwned then
                local Data = {['Title'] = 'Kosten?', ['Type'] = 'number', ['Logo'] = '<i class="fas fa-coins"></i>'}
                LSCore.Functions.OpenInput(Data, function(ReturnData)
                    if ReturnData ~= false then
                        LSCore.Functions.Progressbar("impound-vehicle", "Voertuig in beslag nemen..", math.random(5000, 10000), false, true, {
                            disableMovement = true,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "random@mugging4",
                            anim = "struggle_loop_b_thief",
                            flags = 49,
                        }, {}, {}, function() -- Done
                            TriggerServerEvent('framework-garages:server:set:vehicle:state', Plate, 'depotprice', ReturnData)
                            LSCore.Functions.DeleteVehicle(Vehicle)
                            LSCore.Functions.Notify("Gelukt", "success")
                        end, function()
                            LSCore.Functions.Notify("Geannuleerd..", "error")
                        end)
                    end
                end)
            else
                LSCore.Functions.Progressbar("impound-vehicle", "Voertuig in beslag nemen..", math.random(5000, 10000), false, true, {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "random@mugging4",
                    anim = "struggle_loop_b_thief",
                    flags = 49,
                }, {}, {}, function() -- Done
                     LSCore.Functions.DeleteVehicle(Vehicle)
                     LSCore.Functions.Notify("Gelukt", "success")
                end, function()
                    LSCore.Functions.Notify("Geannuleerd..", "error")
                end)
            end
        end, GetVehicleNumberPlateText(Vehicle))
    else
        LSCore.Functions.Notify("Geen voertuig gevonden..", "error")
    end
end)

RegisterNetEvent('framework-police:client:impound:force:closest')
AddEventHandler('framework-police:client:impound:force:closest', function()
    print('Voertuig in beslag nemen')
    local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if Vehicle ~= 0 and Distance < 1.7 then
        LSCore.Functions.TriggerCallback('framework-garage:server:is:vehicle:owner', function(IsOwned)
            if IsOwned then
                local Data = {['Title'] = 'Reden?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-pencil-alt"></i>'}
                LSCore.Functions.OpenInput(Data, function(ReturnData)
                    if ReturnData ~= false then
                        LSCore.Functions.Progressbar("impound-vehicle", "Beslag Leggen..", math.random(5000, 10000), false, true, {
                            disableMovement = true,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "random@mugging4",
                            anim = "struggle_loop_b_thief",
                            flags = 49,
                        }, {}, {}, function() -- Done
                            TriggerServerEvent('framework-garages:server:set:vehicle:state', Plate, 'impounded', ReturnData)
                            LSCore.Functions.DeleteVehicle(Vehicle)
                            LSCore.Functions.Notify("Gelukt", "success")
                        end, function()
                            LSCore.Functions.Notify("Geannuleerd..", "error")
                        end)
                    end
                end)
            else
                LSCore.Functions.Notify("Dit voertuig is van niemand..", "error")
            end
        end, GetVehicleNumberPlateText(Vehicle))
    else
        LSCore.Functions.Notify("Geen voertuig gevonden..", "error")
    end
end)

RegisterNetEvent('framework-police:client:enkelband:closest')
AddEventHandler('framework-police:client:enkelband:closest', function()
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    local ServerId = GetPlayerServerId(Player)
    if Player ~= -1 and Distance < 2.5 then
        TriggerServerEvent("framework-police:server:set:tracker", ServerId)
    else
        LSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('framework-police:polyzone:fingerscanner', function()
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    if Distance < 1.5 then
        local ServerId = GetPlayerServerId(Player)
        exports['fw-ui']:OpenPoliceFinger()
        TriggerServerEvent('framework-police:server:give:finger:scanner', ServerId)
    else
        LSCore.Functions.Notify("Er is niemand in de buurt", "error")
    end
end)

RegisterNetEvent('framework-police:polyzone:personallocker', function()
    if exports['fw-inventory']:CanOpenInventory() then
        TriggerServerEvent('framework-inv:server:open:inventory:other', "personallocker_"..LSCore.Functions.GetPlayerData().citizenid, 'Stash', 30, 2000000)
    end
end)

RegisterNetEvent('framework-police:polyzone:weaponry', function()
    if exports['fw-inventory']:CanOpenInventory() then
        local Shop = {['Type'] = 'Store', ['SubType'] = 'PoliceStore', ['InvName'] = 'PD Weaponry', ['Items'] = Config.PoliceSafe['Items']}
        TriggerServerEvent('framework-inv:server:open:inventory:other', Shop, 'Store')
    end
end)

RegisterNetEvent('framework-police:polyzone:evidence', function()
    local Data = {['Title'] = 'Kluis Nummer', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-sort-numeric-up"></i>'}
    LSCore.Functions.OpenInput(Data, function(ReturnData)
        if ReturnData ~= false then
            if exports['fw-inventory']:CanOpenInventory() then
                TriggerServerEvent('framework-inv:server:open:inventory:other', "evidencesafe_"..ReturnData, 'Stash', 50, 2500000)
            end
        end
    end)
end)

RegisterNetEvent('framework-police:client:set:tracker')
AddEventHandler('framework-police:client:set:tracker', function(bool)
    local ClothingData = {}
    if bool then
        ClothingData.outfitData = {["accessory"] = {item = 159, texture = 0}}
        TriggerEvent('framework-clothing:client:loadOutfit', ClothingData)
    else
        ClothingData.outfitData = {["accessory"] = {item = -1, texture = 0}}
        TriggerEvent('framework-clothing:client:loadOutfit', ClothingData)
    end
end)

RegisterNetEvent('framework-police:client:send:tracker:location')
AddEventHandler('framework-police:client:send:tracker:location', function(RequestId)
    local Coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('framework-police:server:send:tracker:location', Coords, RequestId)
end)

RegisterNetEvent('framework-police:client:show:tablet')
AddEventHandler('framework-police:client:show:tablet', function()
    exports['fw-assets']:AddProp('Tablet')
    exports['fw-assets']:RequestAnimationDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')
    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
    Citizen.SetTimeout(450, function()
        exports['fw-ui']:OpenPoliceTablet()
    end)
end)

RegisterNetEvent('framework-police:client:give:finger:scanner')
AddEventHandler('framework-police:client:give:finger:scanner', function()
    exports['fw-ui']:OpenPoliceFinger()
end)

RegisterNetEvent('framework-police:client:send:alert')
AddEventHandler('framework-police:client:send:alert', function(Message, Anoniem)
    local PlayerData = LSCore.Functions.GetPlayerData()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    if Anoniem then
        if (LSCore.Functions.GetPlayerData().job.name == "police") and LSCore.Functions.GetPlayerData().job.onduty then
            TriggerEvent('chatMessage', "ANONIEME MELDING", "warning", Message)
            PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
        end
    else
        if Message:len() < 150 then
            TriggerServerEvent("framework-police:server:send:call:alert", PlayerCoords, Message)
            TriggerEvent("framework-police:client:call:anim")
        else
            LSCore.Functions.Notify("Teveel karakters..", "error")
        end
    end
end)

RegisterNetEvent('framework-police:client:call:anim')
AddEventHandler('framework-police:client:call:anim', function()
    local IsCalling = true
    local CallCOunt = 5
    exports['fw-assets']:RequestAnimationDict("cellphone@")
    TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 3.0, -1, -1, 49, 0, false, false, false)
    Citizen.Wait(1000)
    Citizen.CreateThread(function()
        while IsCalling do
            Citizen.Wait(1000)
            CallCOunt = CallCOunt - 1
            if CallCOunt <= 0 then
                IsCalling = false
                StopAnimTask(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 1.0)
            end
        end
    end)
end)