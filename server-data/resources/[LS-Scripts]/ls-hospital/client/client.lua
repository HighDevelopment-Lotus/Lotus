local BedData, BedCam, CanCheckin, ShowingInteraction = nil, nil, false, false
LSCore, PlayerJob, LoggedIn, CanPersonRespawn = exports['ls-core']:GetCoreObject(), {}, false, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LSCore.Functions.GetPlayerData(function(PlayerData)
            LoggedIn = true
            PlayerJob = PlayerData.job
            if PlayerJob.name == 'ambulance' then
                TriggerServerEvent("ls-police:server:update:blips")
            end
            if PlayerData.metadata["isdead"] then
                SetState('death', true)
            end
        end)
    end) 
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('ls-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
    LoggedIn = false
end)

RegisterNetEvent('LSCore:Client:OnJobUpdate')
AddEventHandler('LSCore:Client:OnJobUpdate', function(JobInfo)
    TriggerServerEvent("ls-police:server:update:blips")
    PlayerJob = LSCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('LSCore:Client:SetDuty')
AddEventHandler('LSCore:Client:SetDuty', function(PlayerJob)
    TriggerServerEvent("ls-police:server:update:blips")
    PlayerJob = LSCore.Functions.GetPlayerData().job
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end)    
--         Citizen.Wait(250)
--         LoggedIn = true
--         TriggerServerEvent("ls-police:server:update:blips")
--     end) 
-- end)

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if LoggedIn then
            Citizen.Wait(20000)
            TriggerServerEvent('ls-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if LoggedIn then
            local NearAnything = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = #(PlayerCoords - Config.Locations["CheckIn"])
            if Distance < 1.5 then
                NearAnything, CanCheckin = true, true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['ls-ui']:ShowInteraction('[F1] Inchecken')
                end
            end
            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'], true) < 1.5) then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['ls-ui']:ShowInteraction('[E] Lift')
                end
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    TriggerEvent("ls-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(GetPlayerPed(-1), Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end
            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'], true) < 1.5) then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['ls-ui']:ShowInteraction('[E] Lift')
                end
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    TriggerEvent("ls-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(GetPlayerPed(-1), Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end
            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'], true) < 1.5) then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['ls-ui']:ShowInteraction('[E] Lift')
                end
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    TriggerEvent("ls-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(GetPlayerPed(-1), Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end
            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'], true) < 1.5) then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['ls-ui']:ShowInteraction('[E] Lift')
                end
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    TriggerEvent("ls-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(GetPlayerPed(-1), Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end
            if PlayerJob.name == 'ambulance' and PlayerJob.onduty then
                local Distance = #(PlayerCoords - Config.Locations["Shop"])
                if Distance < 1.5 then
                    NearAnything = true
                    if not ShowingInteraction then
                        ShowingInteraction = true
                        exports['ls-ui']:ShowInteraction('[E] Ambulance Kluis')
                    end
                    if IsControlJustReleased(0, 38) then
                        if exports['ls-inventory-new']:CanOpenInventory() then
                            local Shop = {['Type'] = 'Store', ['SubType'] = 'AmbulanceStore', ['InvName'] = 'Ambulance Kast', ['Items'] = Config.HospitalItems['Items']}
                            TriggerServerEvent('ls-inventory-new:server:open:inventory:other', Shop, 'Store')
                        end
                    end
                end

                local Distance = #(PlayerCoords - Config.Locations["Storage"])
                if Distance < 1.5 then
                    NearAnything = true
                    if not ShowingInteraction then
                        ShowingInteraction = true
                        exports['ls-ui']:ShowInteraction('[E] Opslag')
                    end
                    if IsControlJustReleased(0, 38) then
                        if exports['ls-inventory-new']:CanOpenInventory() then
                            TriggerServerEvent('ls-inventory-new:server:open:inventory:other', 'AmbulanceKast', 'Stash', 200, 2000000)
                        end
                    end
                end
            end
            if not NearAnything then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['ls-ui']:HideInteraction()
                end
                CanCheckin = false
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-hospital:client:check:in')
AddEventHandler('ls-hospital:client:check:in', function()
    local BedSomething = GetAvailableBed()
    if BedSomething ~= nil or BedSomething ~= false then
        TriggerServerEvent('ls-banking:server:set:business:accounts', 'Add', 500, 'ZIEKENHUIS', 'Incheck kosten')
        LSCore.Functions.TriggerCallback("ls-hospital:server:pay:hospital", function(HasPaid)
            if HasPaid then
                DetachEntity(GetPlayerPed(-1), true, false)
                LSCore.Functions.Progressbar("lockpick-door", "Inchecken..", 2500, false, false, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "missheistdockssetup1clipboard@base",
                    anim = "base",
                    flags = 49,
                }, {
                    model = "p_amb_clipboard_01",
                    bone = 18905,
                    coords = { x = 0.10, y = 0.02, z = 0.08 },
                    rotation = { x = -80.0, y = 0.0, z = 0.0 },
                }, {
                    model = "prop_pencil_01",
                    bone = 58866,
                    coords = { x = 0.12, y = 0.0, z = 0.001 },
                    rotation = { x = -150.0, y = 0.0, z = 0.0 },
                }, function() -- Done
                    TriggerEvent('ls-hospital:client:send:to:bed', BedSomething)
                end, function() -- Cancel
                    LSCore.Functions.Notify("Proces geannuleerd..", "error")
                end)
            end
        end)
    else
        LSCore.Functions.Notify("Bedden zijn bezet..", 'error')
    end
end)

RegisterNetEvent('ls-hospital:client:revive')
AddEventHandler('ls-hospital:client:revive', function(UseAnim, IsAdmin)
    if Config.IsDeath then
        CanPersonRespawn = false
        SetState('death', false)
        SetEntityInvincible(GetPlayerPed(-1), false)
        NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId(), true), true, true, false)   
    end
    ResetBodyHp()
    ClearPedTasks(GetPlayerPed(-1))
    SetEntityHealth(GetPlayerPed(-1), 200)
    ClearPedBloodDamage(GetPlayerPed(-1))
    SetPlayerSprint(PlayerId(), true)
    if UseAnim then
        TriggerEvent('ls-hospital:client:revive:anim')
    end
    if IsAdmin then
        TriggerServerEvent("LSCore:Server:SetMetaData", "thirst", LSCore.Functions.GetPlayerData().metadata["thirst"] + 25)
        TriggerServerEvent("LSCore:Server:SetMetaData", "hunger", LSCore.Functions.GetPlayerData().metadata["hunger"] + 25)  
    else
        TriggerServerEvent("LSCore:Server:SetMetaData", "thirst", LSCore.Functions.GetPlayerData().metadata["thirst"] + 5)
        TriggerServerEvent("LSCore:Server:SetMetaData", "hunger", LSCore.Functions.GetPlayerData().metadata["hunger"] + 5)  
    end
    TriggerServerEvent('ls-ui:server:remove:stress', 10)
    TriggerEvent('ls-police:client:check:escort')
    TriggerEvent('animations:client:set:walkstyle')
    LSCore.Functions.Notify("Je bent weer helemaal top!", 'success')
end)

RegisterNetEvent('ls-hospital:client:armor:up')
AddEventHandler('ls-hospital:client:armor:up', function()
    SetPedArmour(GetPlayerPed(-1), 100.0)
    LSCore.Functions.Notify("Lekker armortje hoor..", 'success')
    Citizen.SetTimeout(150, function()
        TriggerServerEvent('ls-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
    end)
end)

RegisterNetEvent('ls-hospital:client:heal:closest')
AddEventHandler('ls-hospital:client:heal:closest', function()
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    local RandomTime = math.random(10000, 15000)
    if Player ~= -1 and Distance < 1.5 then
        if not IsTargetDead(GetPlayerServerId(Player)) then
           HealAnim(RandomTime)
           LSCore.Functions.Progressbar("healing-citizen", "Persoon verzorgen..", RandomTime, false, true, {
               disableMovement = true,
               disableCarMovement = true,
               disableMouse = false,
               disableCombat = true,
           }, {}, {}, {}, function() -- Done
               TriggerServerEvent('ls-hospital:server:heal:player', GetPlayerServerId(Player))
               LSCore.Functions.Notify("Persoon geholpen", "success")
           end, function() -- Cancel
               LSCore.Functions.Notify("Proces geannuleerd..", "error")
           end)
        else
            LSCore.Functions.Notify("Deze burger is bewusteloos..", "error")
        end
    end
end)

RegisterNetEvent('ls-hospital:client:revive:closest')
AddEventHandler('ls-hospital:client:revive:closest', function()
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    local RandomTime = math.random(10000, 15000)
    if Player ~= -1 and Distance < 1.5 then
      if IsTargetDead(GetPlayerServerId(Player)) then
            HealAnim(RandomTime)
            LSCore.Functions.Progressbar("hospital_revive", "Persoon omhoog helpen..", RandomTime, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                TriggerServerEvent('ls-hospital:server:revive:player', GetPlayerServerId(Player))
                StopAnimTask(GetPlayerPed(-1), 'mini@cpr@char_a@cpr_str', "exit", 1.0)
                LSCore.Functions.Notify("Je hebt de persoon geholpen!")
            end, function() -- Cancel
                StopAnimTask(GetPlayerPed(-1), 'mini@cpr@char_a@cpr_str', "exit", 1.0)
                LSCore.Functions.Notify("Mislukt!", "error")
            end)
        else
            LSCore.Functions.Notify("Burger is niet bewusteloos..", "error")
        end
    end
end)

RegisterNetEvent('ls-hospital:client:take:blood:closest')
AddEventHandler('ls-hospital:client:take:blood:closest', function()
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    local RandomTime = math.random(7500, 10500)
    if Player ~= -1 and Distance < 1.5 then
        HealAnim(RandomTime)
        LSCore.Functions.Progressbar("healing-citizen", "Bloed monster afnemen..", RandomTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerServerEvent('ls-hospital:server:take:blood:player', GetPlayerServerId(Player))
            LSCore.Functions.Notify("Bloed monster succesvol afgenomen", "success")
        end, function() -- Cancel
            LSCore.Functions.Notify("Proces geannuleerd..", "error")
        end)
    end
end)

RegisterNetEvent('ls-hospital:client:heal')
AddEventHandler('ls-hospital:client:heal', function()
    local CurrentHealth = GetEntityHealth(GetPlayerPed(-1))
    local NewHealth = CurrentHealth + 15.0
    if CurrentHealth + 15.0 > 100.0 then
        NewHealth = 100.0
    end
    ResetBodyHp()
    ClearPedTasks(GetPlayerPed(-1))
    ClearPedBloodDamage(GetPlayerPed(-1))
    SetEntityHealth(GetPlayerPed(-1), NewHealth)
end)

RegisterNetEvent('ls-hospital:client:revive:anim')
AddEventHandler('ls-hospital:client:revive:anim', function()
    exports['ls-assets']:RequestAnimationDict("random@crash_rescue@help_victim_up")
    TaskPlayAnim(GetPlayerPed(-1), "random@crash_rescue@help_victim_up", "helping_victim_to_feet_victim", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(1850)
    ClearPedSecondaryTask(GetPlayerPed(-1))
end)

RegisterNetEvent('ls-hospital:client:set:bed:state')
AddEventHandler('ls-hospital:client:set:bed:state', function(BedData, bool)
  Config.Beds[BedData]['Busy'] = bool
end)

RegisterNetEvent('ls-hospital:client:send:to:bed')
AddEventHandler('ls-hospital:client:send:to:bed', function(BedId)
    Citizen.SetTimeout(50, function()
        EnterBedCam(BedId)
        LSCore.Functions.Notify('Je wordt geholpen door een dokter..', 'info')
        Citizen.Wait(25000)
        TriggerEvent('ls-hospital:client:revive', false, false)
        LeaveBed()
    end)
end)

RegisterNetEvent('ls-hospital:client:lay:bed')
AddEventHandler('ls-hospital:client:lay:bed', function(Niks, Entity)
    local Coords, Heading = GetEntityCoords(Entity['Entity']), GetEntityHeading(Entity['Entity'])
    SetEntityCoords(GetPlayerPed(-1), Coords.x , Coords.y, Coords.z + 1.0)
    SetEntityHeading(GetPlayerPed(-1), Heading + 180.0)
    TriggerEvent('animations:client:EmoteCommandStart', {'passout3'})
end)

-- // Functions \\ --

function EnterBedCam(BedId)
    Config.IsInBed = true
    BedData = BedId
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(100)
    end
    --BedObject = GetClosestObjectOfType(Config.Beds[BedData]['X'], Config.Beds[BedData]['Y'], Config.Beds[BedData]['Z'], 1.0, Config.Beds[BedData]['Hash'], false, false, false)
    SetEntityCoords(GetPlayerPed(-1), Config.Beds[BedData]['X'], Config.Beds[BedData]['Y'], Config.Beds[BedData]['Z'] + 0.02)
    Citizen.Wait(500)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    exports['ls-assets']:RequestAnimationDict("misslamar1dead_body")
    TaskPlayAnim(GetPlayerPed(-1), "misslamar1dead_body", "dead_idle", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    SetEntityHeading(GetPlayerPed(-1), Config.Beds[BedData]['H'])
    BedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(BedCam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(BedCam, GetPlayerPed(-1), 31085, 0, 1.0, 1.0 , true)
    SetCamFov(BedCam, 100.0)
    SetCamRot(BedCam, -45.0, 0.0, GetEntityHeading(GetPlayerPed(-1)) + 180, true)
    DoScreenFadeIn(1000)
end

function LeaveBed()
    exports['ls-assets']:RequestAnimationDict('switch@franklin@bed')
    FreezeEntityPosition(GetPlayerPed(-1), false)
    SetEntityInvincible(GetPlayerPed(-1), false)
    SetEntityHeading(GetPlayerPed(-1), Config.Beds[BedData]['H'] + 90)
    TaskPlayAnim(GetPlayerPed(-1), 'switch@franklin@bed', 'sleep_getup_rubeyes', 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Citizen.Wait(4000)
    ClearPedTasks(GetPlayerPed(-1))
    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(BedCam, false)
    TriggerServerEvent('ls-hospital:server:set:bed:state', BedData, false)
end

function HealAnim(Time)
    local Time = Time / 1000
    exports['ls-assets']:RequestAnimationDict("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")
    TaskPlayAnim(GetPlayerPed(-1), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor" ,3.0, 3.0, -1, 16, 0, false, false, false)
    Healing = true
    Citizen.CreateThread(function()
        while Healing do
            TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
            Time = Time - 2
            if Time <= 0 then
                Healing = false
                StopAnimTask(GetPlayerPed(-1), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
            end
        end
    end)
end

function GetAvailableBed()
    for k, v in pairs(Config.Beds) do
        if not v['Busy'] then
            TriggerServerEvent('ls-hospital:server:set:bed:state', k, true)
            return k
        end
    end
end

function NearCheckin()
    return CanCheckin
end

function IsTargetDead(TargetId)
    local IsDead = false
        LSCore.Functions.TriggerCallback('ls-police:server:is:player:dead', function(result)
            IsDead = result
        end, TargetId)
        Citizen.Wait(100)
    return IsDead
end