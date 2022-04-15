local TotalPain = 0
local TotalBroken = 0
local LastDamage, Bone = {}
local DamageDone = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if LoggedIn then
            if not Config.IsDeath then
                LastDamage, Bone = GetPedLastDamageBone(PlayerPedId())
                if Bone ~= LastBone then
                    if Config.BodyParts[Bone] ~= 'NONE' then
                        ApplyDamageToBodyPart(Config.BodyParts[Bone])
                        LastBone = Bone
                    end
                else
                    Citizen.Wait(100)
                end
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if LoggedIn then
            if not Config.IsDeath then
                for k, v in pairs(Config.BodyHealth) do
                    Citizen.Wait(10)
                    if v['Health'] <= 2 and not v['IsDead'] then
                        if not v['Pain'] then
                            v['Pain'] = true
                            TotalPain = TotalPain + 1
                        else
                            Citizen.Wait(150)
                        end
                    else
                        Citizen.Wait(150)         
                    end
                end
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if LoggedIn then
            if not Config.IsDeath then
               for k, v in pairs(Config.BodyHealth) do
                   Citizen.Wait(25)
                   if v['Pain'] then
                        if TotalPain > 1 then
                          LSCore.Functions.Notify("Je hebt last op meerdere plekken..", 'info')
                        else
                          LSCore.Functions.Notify("Je hebt last van je "..v['Name']..'..', 'info')
                        end
                        ApplyDamageToBodyPart(k)
                        HurtPlayer(TotalPain)
                        Citizen.Wait(30000)
                    elseif not v['Pain'] and v['IsDead'] then
                        if TotalBroken > 1 then
                            LSCore.Functions.Notify("Er zijn meerdere lichaamsdelen gebroken..", 'error')
                        else
                            LSCore.Functions.Notify("Je "..v['Name'].. ' is gebroken..', 'error')
                        end
                        if k == 'HEAD' then
                            if math.random(1, 100) <= 55 then
                                BlackOut()
                            end
                        elseif k == 'LLEG' or k == 'RLEG' or k == 'LFOOT' or k == 'RFOOT' then
                            if math.random(1, 130) < 5 then
                                SetPedToRagdollWithFall(PlayerPedId(), 2500, 9000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                            end
                        end
                        Citizen.Wait(30000)
                    end
                    Citizen.Wait(150)
               end
            else
                Citizen.Wait(1500)
            end
        end
    end
end)

-- // Events \\ -- 

RegisterNetEvent('framework-hospital:client:use:bandage')
AddEventHandler('framework-hospital:client:use:bandage', function()
    if not exports['fw-progressbar']:GetTaskBarStatus() then
        Citizen.SetTimeout(1000, function()
            exports['fw-assets']:AddProp('HealthPack')
            TriggerEvent('framework-inv:client:set:inventory:state', false)
            LSCore.Functions.Progressbar("use_bandage", "Verband omdoen..", 4000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
               animDict = "amb@world_human_clipboard@male@idle_a",
               anim = "idle_c",
               flags = 49,
            }, {}, {}, function() -- Done
                exports['fw-assets']:RemoveProp()
                TriggerEvent('framework-inv:client:set:inventory:state', true)
                StopAnimTask(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove) 
                    if DidRemove then
                        HealRandomBodyPart()
                        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 10)
                    else
                        LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
                    end
                end, 'bandage', 1, false)
            end, function() -- Cancel
                exports['fw-assets']:RemoveProp()
                TriggerEvent('framework-inv:client:set:inventory:state', true)
                StopAnimTask(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
                LSCore.Functions.Notify("Mislukt", "error")
            end)
        end)
    end
end)

RegisterNetEvent('framework-hospital:client:use:health-pack')
AddEventHandler('framework-hospital:client:use:health-pack', function()
    if not exports['fw-progressbar']:GetTaskBarStatus() then
        Citizen.SetTimeout(1000, function()
            local Player, Distance = LSCore.Functions.GetClosestPlayer()
            local RandomTime = math.random(15000, 20000)
            if Player ~= -1 and Distance < 1.5 then
              if IsTargetDead(GetPlayerServerId(Player)) then
                    TriggerEvent('framework-inv:client:set:inventory:state', false)
                    exports['fw-assets']:RequestAnimationDict("mini@cpr@char_a@cpr_str")
                    TaskPlayAnim(PlayerPedId(), "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 8.0, 1.0, -1, 1, 0, 0, 0, 0)
                    LSCore.Functions.Progressbar("hospital_revive", "Persoon omhoog helpen..", RandomTime, false, true, {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function() -- Done
                        TriggerEvent('framework-inv:client:set:inventory:state', true)
                        StopAnimTask(PlayerPedId(), 'mini@cpr@char_a@cpr_str', "cpr_pumpchest", 1.0)
                        LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove) 
                            if DidRemove then
                                TriggerServerEvent('framework-hospital:server:revive:player', GetPlayerServerId(Player))
                            else
                                LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
                            end
                        end, 'health-pack', 1, false)
                    end, function() -- Cancel
                        TriggerEvent('framework-inv:client:set:inventory:state', true)
                        StopAnimTask(PlayerPedId(), 'mini@cpr@char_a@cpr_str', "cpr_pumpchest", 1.0)
                        LSCore.Functions.Notify("Mislukt!", "error")
                    end)
                else
                    LSCore.Functions.Notify("Burger is niet bewusteloos..", "error")
                end
            end
        end)
    end
end)

RegisterNetEvent('framework-hospital:client:use:painkillers')
AddEventHandler('framework-hospital:client:use:painkillers', function()
    if not exports['fw-progressbar']:GetTaskBarStatus() then
        Citizen.SetTimeout(1000, function()
            if not Config.OnOxy then
                TriggerEvent('framework-inv:client:set:inventory:state', false)
                LSCore.Functions.Progressbar("use_bandage", "Oxycodon innemen..", 3000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "mp_suicide",
                    anim = "pill",
                    flags = 49,
                }, {}, {}, function() -- Done
                    StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
                    TriggerEvent('framework-inv:client:set:inventory:state', true)
                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove) 
                        if DidRemove then
                            Config.OnOxy = true
                            Citizen.SetTimeout(60000, function()
                                Config.OnOxy = false
                            end)
                        else    
                            LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
                        end
                    end, 'painkillers', 1, false)
                end, function() -- Cancel
                    TriggerEvent('framework-inv:client:set:inventory:state', true)
                    StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
                    LSCore.Functions.Notify("Mislukt", "error")
                end)
           else
                LSCore.Functions.Notify("Je hebt nog oxycodon in je lichaam..", "error")
           end 
        end)
    end
end)

-- // Functions \\ --

function ApplyDamageToBodyPart(BodyPart)
    if not Config.OnOxy then
        if BodyPart == 'LLEG' or BodyPart == 'RLEG' or BodyPart == 'LFOOT' or BodyPart == 'RFOOT' then
            if math.random(1, 130) < 5 then
                SetPedToRagdollWithFall(PlayerPedId(), 2500, 9000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            end
        elseif BodyPart == 'HEAD' and Config.BodyHealth['HEAD']['Health'] < 2 and not Config.BodyHealth['HEAD']['IsDead'] then
            if math.random(1, 100) < 35 then
                BlackOut()
            end
        end
        if Config.BodyHealth[BodyPart]['Health'] > 0 and not Config.BodyHealth[BodyPart]['IsDead'] then
            Config.BodyHealth[BodyPart]['Health'] = Config.BodyHealth[BodyPart]['Health'] - 1
        elseif Config.BodyHealth[BodyPart]['Health'] == 0 then
            if not Config.BodyHealth[BodyPart]['IsDead'] and Config.BodyHealth[BodyPart]['CanDie'] then
                Config.BodyHealth[BodyPart]['Pain'] = false
                Config.BodyHealth[BodyPart]['IsDead'] = true
                TotalPain = TotalPain - 1
                TotalBroken = TotalBroken + 1
            end
        end
    end
    while IsPedRagdoll(PlayerPedId()) do
        Citizen.Wait(10)
    end
    TriggerServerEvent("framework-police:server:create:evidence", 'Blood', GetEntityCoords(PlayerPedId()))
end 

function HurtPlayer(Multiplier)
    local CurrentHealth = GetEntityHealth(PlayerPedId())
    local NewHealth = CurrentHealth - math.random(1,8) * Multiplier
    if not Config.OnOxy then
        SetEntityHealth(PlayerPedId(), NewHealth)
    end
end

function BlackOut()
    if not Config.OnOxy then
       SetFlash(0, 0, 100, 4000, 100)
       DoScreenFadeOut(500)
       while not IsScreenFadedOut() do
           Citizen.Wait(0)
       end
       if IsPedOnFoot(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedSwimming(PlayerPedId()) then
           ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
           SetPedToRagdollWithFall(PlayerPedId(), 7500, 9000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
       end
       Citizen.Wait(1500)
       DoScreenFadeIn(1000)
       Citizen.Wait(1000)
       DoScreenFadeOut(750)
       while not IsScreenFadedOut() do
           Citizen.Wait(0)
       end
       Citizen.Wait(500)
       DoScreenFadeIn(700)
    end
end

function HealRandomBodyPart()
    for k,v in pairs(Config.BodyHealth) do
        if not v['IsDead'] then
            if v['Pain'] then
                if v['Health'] < 4 then
                    v['Health'] = v['Health'] + 1.0 
                end
                if v['Health'] == 4 then
                    v['Pain'] = false
                    TotalPain = TotalPain - 1
                end
            end
        end
    end
end

function ResetBodyHp()
    for k,v in pairs(Config.BodyHealth) do
        v['Health'] = Config.MaxBodyPartHealth
        v['IsDead'] = false
        v['Pain'] = false
        TotalPain = 0
        TotalBroken = 0
    end
end