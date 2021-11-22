local ShowingInteraction = false
LSCore, LoggedIn, PlayerJob, DutyBlips = exports['ls-core']:GetCoreObject(), false, {}, {}

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(2500, function()
        LSCore.Functions.TriggerCallback('ls-police:server:get:config', function(ConfigData)
            Config = ConfigData
        end)
        PlayerJob = LSCore.Functions.GetPlayerData().job
        SpawnPoliceProps()
        Citizen.Wait(3500)
        LSCore.Functions.GetPlayerData(function(PlayerData)
            if PlayerData.metadata['tracker'] then
              TriggerEvent('ls-police:client:set:tracker', true)
            end
            if PlayerData.metadata['ishandcuffed'] then
                TriggerServerEvent('ls-sound:server:play:distance', 2.0, 'handcuff', 0.2)
                Config.IsHandCuffed = true
            end
        end)
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    TriggerServerEvent("ls-police:server:update:blips")
    TriggerServerEvent("ls-police:server:update:current:cops")
    if DutyBlips ~= nil then
        for k, v in pairs(DutyBlips) do
            RemoveBlip(v)
        end
        DutyBlips = {}
    end
    ClearPedTasks(GetPlayerPed(-1))
    DetachEntity(GetPlayerPed(-1), true, false)
    DeSpawnPoliceProps()
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
        TriggerServerEvent("ls-police:server:update:blips")
        TriggerServerEvent("ls-police:server:update:current:cops")
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
        TriggerServerEvent("ls-police:server:update:blips")
        TriggerServerEvent("ls-police:server:update:current:cops")
    end)
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end)    
--         Citizen.Wait(100)
--         LSCore.Functions.TriggerCallback('ls-police:server:get:config', function(ConfigData)
--             Config = ConfigData
--         end)
--         PlayerJob = LSCore.Functions.GetPlayerData().job
--         SpawnPoliceProps()
--         Citizen.Wait(3500)
--         LSCore.Functions.GetPlayerData(function(PlayerData)
--             if PlayerData ~= nil then
--                 if PlayerData.metadata['tracker'] then
--                   TriggerEvent('ls-police:client:set:tracker', true)
--                 end
--                 if PlayerData.metadata['ishandcuffed'] then
--                     TriggerServerEvent('ls-sound:server:play:distance', 2.0, 'handcuff', 0.2)
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
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                for k, v in pairs(Config.PoliceLocations['FingerPrint']) do
                    local Distance = #(PlayerCoords - v['Coords'])
                    if Distance < 1.0 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['ls-ui']:ShowInteraction('[E] Vinger Scanner', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            local Player, Distance = LSCore.Functions.GetClosestPlayer()
                            if Distance < 1.5 then
                                local ServerId = GetPlayerServerId(Player)
                                exports['ls-ui']:OpenPoliceFinger()
                                TriggerServerEvent('ls-police:server:give:finger:scanner', ServerId)
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
                            exports['ls-ui']:ShowInteraction('[E] Kluis', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            if exports['ls-inventory-new']:CanOpenInventory() then
                                TriggerServerEvent('ls-inventory-new:server:open:inventory:other', "personalsafe_"..LSCore.Functions.GetPlayerData().citizenid, 'Stash', 30, 2000000)
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
                            exports['ls-ui']:ShowInteraction('[E] Politie Kluis', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            Citizen.SetTimeout(125, function()
                                if exports['ls-inventory-new']:CanOpenInventory() then
                                    local Shop = {['Type'] = 'Store', ['SubType'] = 'PoliceStore', ['InvName'] = 'Politie Kluis', ['Items'] = Config.PoliceSafe['Items']}
                                    TriggerServerEvent('ls-inventory-new:server:open:inventory:other', Shop, 'Store')
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
                            exports['ls-ui']:ShowInteraction('[E] Deleter', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                            LSCore.Functions.DeleteVehicle(Vehicle)
                        end
                    end
                end
                for k, v in pairs(Config.PoliceLocations['Evidence']) do
                    local Distance = #(PlayerCoords - v['Coords'])
                    if Distance < 1.0 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['ls-ui']:ShowInteraction('[E] Bewijs Kluis', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            local Data = {['Title'] = 'Kluis Nummer', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-sort-numeric-up"></i>'}
                            LSCore.Functions.OpenInput(Data, function(ReturnData)
                                if ReturnData ~= false then
                                    Citizen.SetTimeout(250, function()
                                        if exports['ls-inventory-new']:CanOpenInventory() then
                                            TriggerServerEvent('ls-inventory-new:server:open:inventory:other', "evidencestash_"..ReturnData, 'Stash', 50, 2500000)
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
                        exports['ls-ui']:HideInteraction()
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

RegisterNetEvent('ls-police:client:update:blips')
AddEventHandler('ls-police:client:update:blips', function(PlayerData)
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

RegisterNetEvent('ls-police:client:impound:closest')
AddEventHandler('ls-police:client:impound:closest', function() 
    local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if Vehicle ~= 0 and Distance < 1.7 then
        LSCore.Functions.TriggerCallback('ls-materials:server:is:vehicle:owned', function(IsOwned)
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
                            TriggerServerEvent('ls-garages:server:set:vehicle:state', Plate, 'depotprice', ReturnData)
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

RegisterNetEvent('ls-police:client:impound:force:closest')
AddEventHandler('ls-police:client:impound:force:closest', function()
    local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if Vehicle ~= 0 and Distance < 1.7 then
        LSCore.Functions.TriggerCallback('ls-materials:server:is:vehicle:owned', function(IsOwned)
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
                            TriggerServerEvent('ls-garages:server:set:vehicle:state', Plate, 'impounded', ReturnData)
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

RegisterNetEvent('ls-police:client:enkelband:closest')
AddEventHandler('ls-police:client:enkelband:closest', function()
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    local ServerId = GetPlayerServerId(Player)
    if Player ~= -1 and Distance < 2.5 then
        TriggerServerEvent("ls-police:server:set:tracker", ServerId)
    else
        LSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('ls-police:client:set:tracker')
AddEventHandler('ls-police:client:set:tracker', function(bool)
    local ClothingData = {}
    if bool then
        ClothingData.outfitData = {["accessory"] = {item = 159, texture = 0}}
        TriggerEvent('ls-clothing:client:loadOutfit', ClothingData)
    else
        ClothingData.outfitData = {["accessory"] = {item = -1, texture = 0}}
        TriggerEvent('ls-clothing:client:loadOutfit', ClothingData)
    end
end)

RegisterNetEvent('ls-police:client:send:tracker:location')
AddEventHandler('ls-police:client:send:tracker:location', function(RequestId)
    local Coords = GetEntityCoords(GetPlayerPed(-1))
    TriggerServerEvent('ls-police:server:send:tracker:location', Coords, RequestId)
end)

RegisterNetEvent('ls-police:client:show:tablet')
AddEventHandler('ls-police:client:show:tablet', function()
    exports['ls-assets']:AddProp('Tablet')
    exports['ls-assets']:RequestAnimationDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')
    TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
    Citizen.SetTimeout(450, function()
        exports['ls-ui']:OpenPoliceTablet()
    end)
end)

RegisterNetEvent('ls-police:client:give:finger:scanner')
AddEventHandler('ls-police:client:give:finger:scanner', function()
    exports['ls-ui']:OpenPoliceFinger()
end)

RegisterNetEvent('ls-police:client:send:alert')
AddEventHandler('ls-police:client:send:alert', function(Message, Anoniem)
    local PlayerData = LSCore.Functions.GetPlayerData()
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    if Anoniem then
        if (LSCore.Functions.GetPlayerData().job.name == "police") and LSCore.Functions.GetPlayerData().job.onduty then
            TriggerEvent('chatMessage', "ANONIEME MELDING", "warning", Message)
            PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
        end
    else
        if Message:len() < 150 then
            TriggerServerEvent("ls-police:server:send:call:alert", PlayerCoords, Message)
            TriggerEvent("ls-police:client:call:anim")
        else
            LSCore.Functions.Notify("Teveel karakters..", "error")
        end
    end
end)

RegisterNetEvent('ls-police:client:call:anim')
AddEventHandler('ls-police:client:call:anim', function()
    local IsCalling = true
    local CallCOunt = 5
    exports['ls-assets']:RequestAnimationDict("cellphone@")
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