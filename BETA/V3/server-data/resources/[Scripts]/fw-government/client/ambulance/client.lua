local BedData, BedCam, CanCheckin, CanPersonRespawn, ShowingInteraction = nil, nil, false, false, false
RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LSCore.Functions.GetPlayerData(function(PlayerData)
            LoggedIn = true
            PlayerJob = PlayerData.job
            if PlayerJob.name == 'ambulance' then
                TriggerServerEvent("framework-police:server:update:blips")
            end
            if PlayerData.metadata["isdead"] then
                SetState('death', true)
            end
        end)
    end) 
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('framework-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
    LoggedIn = false
end)

RegisterNetEvent('LSCore:Client:OnJobUpdate')
AddEventHandler('LSCore:Client:OnJobUpdate', function(JobInfo)
    TriggerServerEvent("framework-police:server:update:blips")
    PlayerJob = LSCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('LSCore:Client:SetDuty')
AddEventHandler('LSCore:Client:SetDuty', function(PlayerJob)
    TriggerServerEvent("framework-police:server:update:blips")
    PlayerJob = LSCore.Functions.GetPlayerData().job
end)

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if LoggedIn then
            Citizen.Wait(20000)
            TriggerServerEvent('framework-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
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
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - Config.Locations["CheckIn"])
            if Distance < 1.5 then
                NearAnything, CanCheckin = true, true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['fw-ui']:ShowInteraction('[F1] Inchecken')
                end
            end
            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'], true) < 1.5) then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['fw-ui']:ShowInteraction('[E] Lift')
                end
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    -- TriggerEvent("framework-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(PlayerPedId(), Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end
            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'], true) < 1.5) then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['fw-ui']:ShowInteraction('[E] Lift')
                end
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    -- TriggerEvent("framework-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(PlayerPedId(), Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end
            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'], true) < 1.5) then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['fw-ui']:ShowInteraction('[E] Lift')
                end
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    SetEntityCoords(PlayerPedId(), Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end
            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'], true) < 1.5) then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['fw-ui']:ShowInteraction('[E] Lift')
                end
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    SetEntityCoords(PlayerPedId(), Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'])
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
                        exports['fw-ui']:ShowInteraction('[E] Ambulance Kluis')
                    end
                    if IsControlJustReleased(0, 38) then
                        if exports['fw-inv']:CanOpenInventory() then
                            local Shop = {['Type'] = 'Store', ['SubType'] = 'AmbulanceStore', ['InvName'] = 'Ambulance Kast', ['Items'] = Config.HospitalItems['Items']}
                            TriggerServerEvent('framework-inv:server:open:inventory:other', Shop, 'Store')
                        end
                    end
                end

                local Distance = #(PlayerCoords - Config.Locations["Storage"])
                if Distance < 1.5 then
                    NearAnything = true
                    if not ShowingInteraction then
                        ShowingInteraction = true
                        exports['fw-ui']:ShowInteraction('[E] Opslag')
                    end
                    if IsControlJustReleased(0, 38) then
                        if exports['fw-inv']:CanOpenInventory() then
                            TriggerServerEvent('framework-inv:server:open:inventory:other', 'AmbulanceKast', 'Stash', 200, 2000000)
                        end
                    end
                end
            end
            if not NearAnything then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['fw-ui']:HideInteraction()
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

RegisterNetEvent('framework-hospital:client:check:in')
AddEventHandler('framework-hospital:client:check:in', function()
    local BedSomething = GetAvailableBed()
    if BedSomething ~= nil or BedSomething ~= false then
        -- TriggerServerEvent('framework-banking:server:set:business:accounts', 'Add', 500, 'ZIEKENHUIS', 'Incheck kosten')
        LSCore.Functions.TriggerCallback("framework-hospital:server:pay:hospital", function(HasPaid)
            if HasPaid then
                DetachEntity(PlayerPedId(), true, false)
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
                    TriggerEvent('framework-hospital:client:send:to:bed', BedSomething)
                end, function() -- Cancel
                    LSCore.Functions.Notify("Proces geannuleerd..", "error")
                end)
            end
        end)
    else
        LSCore.Functions.Notify("Bedden zijn bezet..", 'error')
    end
end)

RegisterNetEvent('framework-hospital:client:revive')
AddEventHandler('framework-hospital:client:revive', function(UseAnim, IsAdmin)
    if Config.IsDeath then
        CanPersonRespawn = false
        SetState('death', false)
        SetEntityInvincible(PlayerPedId(), false)
        NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId(), true), true, true, false)   
    end
    ResetBodyHp()
    ClearPedTasks(PlayerPedId())
    SetEntityHealth(PlayerPedId(), 200)
    ClearPedBloodDamage(PlayerPedId())
    SetPlayerSprint(PlayerId(), true)
    if UseAnim then
        -- TriggerEvent('framework-hospital:client:revive:anim')
    end
    if IsAdmin then
        TriggerServerEvent("LSCore:Server:SetMetaData", "thirst", LSCore.Functions.GetPlayerData().metadata["thirst"] + 50)
        TriggerServerEvent("LSCore:Server:SetMetaData", "hunger", LSCore.Functions.GetPlayerData().metadata["hunger"] + 50)  
    else
        TriggerServerEvent("LSCore:Server:SetMetaData", "thirst", LSCore.Functions.GetPlayerData().metadata["thirst"] + 50)
        TriggerServerEvent("LSCore:Server:SetMetaData", "hunger", LSCore.Functions.GetPlayerData().metadata["hunger"] + 50)  
    end
    TriggerServerEvent('framework-ui:server:remove:stress', 30)
    TriggerEvent('framework-police:client:check:escort')
    TriggerEvent('animations:client:set:walkstyle')
    LSCore.Functions.Notify("Je voelt je weer kip lekker!", 'success')
end)

RegisterNetEvent('framework-hospital:client:armor:up')
AddEventHandler('framework-hospital:client:armor:up', function()
    SetPedArmour(PlayerPedId(), 100.0)
    LSCore.Functions.Notify("+ Armor", 'success')
    Citizen.SetTimeout(150, function()
        TriggerServerEvent('framework-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
    end)
end)

RegisterNetEvent('framework-hospital:client:heal:closest')
AddEventHandler('framework-hospital:client:heal:closest', function()
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
               TriggerServerEvent('framework-hospital:server:heal:player', GetPlayerServerId(Player))
               LSCore.Functions.Notify("Persoon geholpen", "success")
           end, function() -- Cancel
               LSCore.Functions.Notify("Proces geannuleerd..", "error")
           end)
        else
            LSCore.Functions.Notify("Deze burger is bewusteloos..", "error")
        end
    end
end)

RegisterNetEvent('framework-hospital:client:revive:closest')
AddEventHandler('framework-hospital:client:revive:closest', function()
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
                TriggerServerEvent('framework-hospital:server:revive:player', GetPlayerServerId(Player))
                StopAnimTask(PlayerPedId(), 'mini@cpr@char_a@cpr_str', "exit", 1.0)
                LSCore.Functions.Notify("Je hebt de persoon geholpen!")
            end, function() -- Cancel
                StopAnimTask(PlayerPedId(), 'mini@cpr@char_a@cpr_str', "exit", 1.0)
                LSCore.Functions.Notify("Mislukt!", "error")
            end)
        else
            LSCore.Functions.Notify("Burger is niet bewusteloos..", "error")
        end
    end
end)

RegisterNetEvent('framework-hospital:client:take:blood:closest')
AddEventHandler('framework-hospital:client:take:blood:closest', function()
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
            TriggerServerEvent('framework-hospital:server:take:blood:player', GetPlayerServerId(Player))
            LSCore.Functions.Notify("Bloed monster succesvol afgenomen", "success")
        end, function() -- Cancel
            LSCore.Functions.Notify("Proces geannuleerd..", "error")
        end)
    end
end)

RegisterNetEvent('framework-hospital:client:heal')
AddEventHandler('framework-hospital:client:heal', function()
    local CurrentHealth = GetEntityHealth(PlayerPedId())
    local NewHealth = CurrentHealth + 15.0
    if CurrentHealth + 15.0 > 100.0 then
        NewHealth = 100.0
    end
    ResetBodyHp()
    ClearPedTasks(PlayerPedId())
    ClearPedBloodDamage(PlayerPedId())
    SetEntityHealth(PlayerPedId(), NewHealth)
end)

RegisterNetEvent('framework-hospital:client:revive:anim')
AddEventHandler('framework-hospital:client:revive:anim', function()
    exports['fw-assets']:RequestAnimationDict("random@crash_rescue@help_victim_up")
    TaskPlayAnim(PlayerPedId(), "random@crash_rescue@help_victim_up", "helping_victim_to_feet_victim", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(1850)
    ClearPedSecondaryTask(PlayerPedId())
end)

RegisterNetEvent('framework-hospital:client:set:bed:state')
AddEventHandler('framework-hospital:client:set:bed:state', function(BedData, bool)
  Config.Beds[BedData]['Busy'] = bool
end)

RegisterNetEvent('framework-hospital:client:send:to:bed')
AddEventHandler('framework-hospital:client:send:to:bed', function(BedId)
    Citizen.SetTimeout(50, function()
        EnterBedCam(BedId)
        LSCore.Functions.Notify('Je wordt geholpen door een dokter..', 'info')
        Citizen.Wait(25000)
        TriggerEvent('framework-hospital:client:revive', false, false)
        LeaveBed()
    end)
end)

RegisterNetEvent('framework-hospital:client:lay:bed')
AddEventHandler('framework-hospital:client:lay:bed', function(Niks, Entity)
    local Coords, Heading = GetEntityCoords(Entity['Entity']), GetEntityHeading(Entity['Entity'])
    SetEntityCoords(PlayerPedId(), Coords.x , Coords.y, Coords.z + 1.0)
    SetEntityHeading(PlayerPedId(), Heading + 180.0)
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
    SetEntityCoords(PlayerPedId(), Config.Beds[BedData]['X'], Config.Beds[BedData]['Y'], Config.Beds[BedData]['Z'] + 0.02)
    Citizen.Wait(500)
    FreezeEntityPosition(PlayerPedId(), true)
    exports['fw-assets']:RequestAnimationDict("misslamar1dead_body")
    TaskPlayAnim(PlayerPedId(), "misslamar1dead_body", "dead_idle", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    SetEntityHeading(PlayerPedId(), Config.Beds[BedData]['H'])
    BedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(BedCam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(BedCam, PlayerPedId(), 31085, 0, 1.0, 1.0 , true)
    SetCamFov(BedCam, 100.0)
    SetCamRot(BedCam, -45.0, 0.0, GetEntityHeading(PlayerPedId()) + 180, true)
    DoScreenFadeIn(1000)
end

function LeaveBed()
    exports['fw-assets']:RequestAnimationDict('switch@franklin@bed')
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityInvincible(PlayerPedId(), false)
    SetEntityHeading(PlayerPedId(), Config.Beds[BedData]['H'] + 90)
    TaskPlayAnim(PlayerPedId(), 'switch@franklin@bed', 'sleep_getup_rubeyes', 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Citizen.Wait(4000)
    ClearPedTasks(PlayerPedId())
    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(BedCam, false)
    TriggerServerEvent('framework-hospital:server:set:bed:state', BedData, false)
end

function HealAnim(Time)
    local Time = Time / 1000
    exports['fw-assets']:RequestAnimationDict("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")
    TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor" ,3.0, 3.0, -1, 16, 0, false, false, false)
    Healing = true
    Citizen.CreateThread(function()
        while Healing do
            TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
            Time = Time - 2
            if Time <= 0 then
                Healing = false
                StopAnimTask(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
            end
        end
    end)
end

function GetAvailableBed()
    for k, v in pairs(Config.Beds) do
        if not v['Busy'] then
            TriggerServerEvent('framework-hospital:server:set:bed:state', k, true)
            return k
        end
    end
end

function NearCheckin()
    return CanCheckin
end

function IsTargetDead(TargetId)
    local IsDead = false
        LSCore.Functions.TriggerCallback('framework-police:server:is:player:dead', function(result)
            IsDead = result
        end, TargetId)
        Citizen.Wait(100)
    return IsDead
end