local HeistThermite, HeistBagScene = nil, nil
local HeistProps, ExplosiveAnimTwo = {}, nil
local MovingForward, Stage = false, 0
local IsPointing = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                if IsControlJustReleased(0, Config.Keys["LEFTCTRL"]) then
                    Stage = Stage + 1
                    if Stage == 2 then
                        ClearPedTasks(GetPlayerPed(-1))
                        RequestAnimSetEvent("move_ped_crouched")
                        SetPedMovementClipset(GetPlayerPed(-1), "move_ped_crouched",1.0)    
                        SetPedWeaponMovementClipset(GetPlayerPed(-1), "move_ped_crouched",1.0)
                        SetPedStrafeClipset(GetPlayerPed(-1), "move_ped_crouched_strafing",1.0)
                    elseif Stage == 3 then
                        ClearPedTasks(GetPlayerPed(-1))
                        RequestAnimSetEvent("move_crawl")
                    elseif Stage > 3 then
                        Stage = 0
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                        SetPedStealthMovement(GetPlayerPed(-1), 0, 0)
                        ResetAnimSet()
                    end
                end
                if Stage == 2 then
                    if GetEntitySpeed(GetPlayerPed(-1)) > 1.0 then
                        SetPedWeaponMovementClipset(GetPlayerPed(-1), "move_ped_crouched",1.0)
                        SetPedStrafeClipset(GetPlayerPed(-1), "move_ped_crouched_strafing",1.0)
                    elseif GetEntitySpeed(GetPlayerPed(-1)) < 1.0 and (GetFollowPedCamViewMode() == 4 or GetFollowVehicleCamViewMode() == 4) then
                        ResetPedWeaponMovementClipset(GetPlayerPed(-1))
                        ResetPedStrafeClipset(GetPlayerPed(-1))
                    end
                elseif Stage == 3 then
                    DisableControlAction(0, 21, true)
                    DisableControlAction(1, 140, true)
                    DisableControlAction(1, 141, true)
                    DisableControlAction(1, 142, true)
                    if (IsControlPressed(0, Config.Keys["W"]) and not MovingForward) then
                        MovingForward = true
                        SetPedMoveAnimsBlendOut(GetPlayerPed(-1))
                        local ProneCoords = GetEntityCoords(GetPlayerPed(-1))
                        TaskPlayAnimAdvanced(GetPlayerPed(-1), "move_crawl", "onfront_fwd", ProneCoords.x, ProneCoords.y, ProneCoords.z + 0.1, 0.0, 0.0, GetEntityHeading(GetPlayerPed(-1)), 100.0, 0.4, 1.0, 7, 2.0, 1, 1) 
                        Citizen.Wait(500)
                    elseif (not IsControlPressed(0, Config.Keys["W"]) and MovingForward) then
                        local ProneCoords = GetEntityCoords(GetPlayerPed(-1))
                        TaskPlayAnimAdvanced(GetPlayerPed(-1), "move_crawl", "onfront_fwd", ProneCoords.x, ProneCoords.y, ProneCoords.z + 0.1, 0.0, 0.0, GetEntityHeading(GetPlayerPed(-1)), 100.0, 0.4, 1.0, 6, 2.0, 1, 1)
                        Citizen.Wait(500)
                        MovingForward = false
                    end
                    if IsControlPressed(0, Config.Keys["A"]) then
                        SetEntityHeading(GetPlayerPed(-1), GetEntityHeading(GetPlayerPed(-1)) + 1)
                    end     
                    if IsControlPressed(0, Config.Keys["D"]) then
                        SetEntityHeading(GetPlayerPed(-1), GetEntityHeading(GetPlayerPed(-1)) - 1)
                    end 
                end
            else
                Citizen.Wait(50)
            end
        else
            Stage = 0
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsControlPressed(0, Config.Keys["B"]) and IsPedOnFoot(PlayerPedId()) then
                if not IsPointing then
                    StartPointing()
                end
                IsPointing = true
            else
                if IsPointing then
                    StopPointing()
                end
                IsPointing = false
            end
            if not IsPedOnFoot(PlayerPedId()) and IsPointing then
                IsPointing = false
                StopPointing()
            end
            if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
                if IsPedOnFoot(PlayerPedId()) and IsPointing then
                    local CamPitch = GetGameplayCamRelativePitch()
                    if CamPitch < -70.0 then
                        CamPitch = -70.0
                    elseif CamPitch > 42.0 then
                        CamPitch = 42.0
                    end
                    CamPitch = (CamPitch + 70.0) / 112.0
                    local CamHeading = GetGameplayCamRelativeHeading()
                    local CosCamHeading = Cos(CamHeading)
                    local SinCamHeading = Sin(CamHeading)
                    if CamHeading < -180.0 then
                        CamHeading = -180.0
                    elseif CamHeading > 180.0 then
                        CamHeading = 180.0
                    end
                    CamHeading = (CamHeading + 180.0) / 360.0
                    local Blocked, NN = 0, 0
                    local Coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), (CosCamHeading * -0.2) - (SinCamHeading * (0.4 * CamHeading + 0.3)), (SinCamHeading * -0.2) + (CosCamHeading * (0.4 * CamHeading + 0.3)), 0.6)
                    local RayCast = Cast_3dRayPointToPoint(Coords.x, Coords.y, Coords.z - 0.2, Coords.x, Coords.y, Coords.z + 0.2, 0.4, 95, GetPlayerPed(-1), 7);
                    NN, Blocked = GetRaycastResult(RayCast)
                    Citizen.InvokeNative(0xD5BB4025AE449A4E, GetPlayerPed(-1), "Pitch", CamPitch)
                    Citizen.InvokeNative(0xD5BB4025AE449A4E, GetPlayerPed(-1), "Heading", CamHeading * -1.0 + 1.0)
                    Citizen.InvokeNative(0xB0A6CFD2C69C1088, GetPlayerPed(-1), "isBlocked", Blocked)
                    Citizen.InvokeNative(0xB0A6CFD2C69C1088, GetPlayerPed(-1), "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
                else
                    Citizen.Wait(25)
                end
            else
                Citizen.Wait(50)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-assets:client:get:tackeled')
AddEventHandler('ls-assets:client:get:tackeled', function()
    SetPedToRagdoll(GetPlayerPed(-1), math.random(4000, 5000), math.random(4000, 5000), 0, 0, 0, 0) 
end)

RegisterNetEvent('ls-assets:client:lockpick:animation')
AddEventHandler('ls-assets:client:lockpick:animation', function(Bool)
    Lockpicking = Bool
    while Lockpicking do
        Citizen.Wait(4)
        RequestAnimationDict("veh@break_in@0h@p_m_one@")
        TaskPlayAnim(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
        Citizen.Wait(1000)
    end
    if not Bool then
        StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
    end
end)

RegisterNetEvent('ls-assets:client:thermite:anim')
AddEventHandler('ls-assets:client:thermite:anim', function(Coords)
    exports['ls-assets']:RequestModelHash("hei_p_m_bag_var22_arm_s")
    exports['ls-assets']:RequestAnimationDict("anim@heists@ornate_bank@thermal_charge")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(50)
    end
    Citizen.Wait(100)
    local Rotation = GetEntityRotation(PlayerPedId())
    HeistBagScene = NetworkCreateSynchronisedScene(Coords.x, Coords.y, Coords.z, Rotation.x, Rotation.y, Rotation.z, 2, false, false, 1065353216, 0, 1.3)
    local HeistBag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), Coords.x, Coords.y, Coords.z,  true,  true, false)
    table.insert(HeistProps, HeistBag)
    SetEntityCollision(HeistBag, false, true)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), HeistBagScene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(HeistBag, HeistBagScene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(HeistBagScene)
    Citizen.Wait(1500)
    local HeistThermite = CreateObject(GetHashKey("hei_prop_heist_thermite"), Coords.x, Coords.y, Coords.z + 0.2,  true,  true, true)
    table.insert(HeistProps, HeistThermite)
    SetEntityCollision(HeistThermite, false, true)
    AttachEntityToEntity(HeistThermite, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(4000)
    DeleteObject(HeistBag)
    DetachEntity(HeistThermite, 1, 1)
    FreezeEntityPosition(HeistThermite, true)
    TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
end)

RegisterNetEvent('ls-assets:client:reset:thermite:anim')
AddEventHandler('ls-assets:client:reset:thermite:anim', function()
    ClearPedTasks(PlayerPedId())
    for k, v in pairs(HeistProps) do
        if DoesEntityExist(v) then
            NetworkRequestControlOfEntity(v)
            DeleteEntity(v)
        end
    end
    HeistProps = {}
    NetworkStopSynchronisedScene(HeistBagScene)
    HeistThermite, HeistBagScene = nil, nil
end)

RegisterNetEvent('ls-assets:client:explosion:anim')
AddEventHandler('ls-assets:client:explosion:anim', function(Coords, Rotation)
    exports['ls-assets']:RequestModelHash("ch_prop_ch_explosive_01a")
    exports['ls-assets']:RequestAnimationDict("anim_heist@hs3f@ig8_vault_explosives@right@male@")
    local HeistBag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), Coords.x + 0.5, Coords.y, Coords.z,  true,  true, false)
    local HeistExplosive = CreateObject(GetHashKey("ch_prop_ch_explosive_01a"), Coords.x + 0.5, Coords.y, Coords.z,  true,  true, false)
    table.insert(HeistProps, HeistBag)
    table.insert(HeistProps, HeistExplosive)
    SetEntityCollision(HeistBag, false, true)
    SetEntityCollision(HeistExplosive, false, true)
    local EnterAnim = NetworkCreateSynchronisedScene(Coords.x, Coords.y, Coords.z + 0.5, Rotation.x, Rotation.y, Rotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), EnterAnim, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "player_ig8_vault_explosive_enter", 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(HeistBag, EnterAnim, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "bag_ig8_vault_explosive_enter", 1.0, -1.0, 0, 0)
    NetworkAddEntityToSynchronisedScene(HeistExplosive, EnterAnim, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "semtex_a_ig8_vault_explosive_enter", 1.0, -1.0, 0, 0)
    NetworkStartSynchronisedScene(EnterAnim)
    Citizen.Wait(1200)
    local ExplosiveAnimOne = NetworkCreateSynchronisedScene(Coords.x, Coords.y, Coords.z + 0.5, Rotation.x, Rotation.y, Rotation.z, 2, 0, 0, 1065353216, 0, 1.3)	
    NetworkAddPedToSynchronisedScene(PlayerPedId(), ExplosiveAnimOne, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "player_ig8_vault_explosive_plant_a", 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(HeistBag, ExplosiveAnimOne, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "bag_ig8_vault_explosive_plant_a", 1.0, -1.0, 0, 0)
    NetworkAddEntityToSynchronisedScene(HeistExplosive, ExplosiveAnimOne, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "semtex_a_ig8_vault_explosive_plant_a", 1.0, -1.0, 0, 0)
    NetworkStartSynchronisedScene(ExplosiveAnimOne)
    Citizen.Wait(2000)
    ExplosiveAnimTwo = NetworkCreateSynchronisedScene(Coords.x, Coords.y, Coords.z + 0.5, Rotation.x, Rotation.y, Rotation.z, 2, 0, 0, 1065353216, 0, 1.3)	
    NetworkAddPedToSynchronisedScene(PlayerPedId(), ExplosiveAnimTwo, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "player_ig8_vault_explosive_plant_b", 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(HeistBag, ExplosiveAnimTwo, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "bag_ig8_vault_explosive_plant_b", 1.0, -1.0, 0, 0)
    FreezeEntityPosition(HeistExplosive, true)
    SetEntityCollision(HeistExplosive, false, true)
    local HeistExplosiveTwo = CreateObject(GetHashKey("ch_prop_ch_explosive_01a"), Coords.x + 0.5, Coords.y, Coords.z,  true,  true, false)
    table.insert(HeistProps, HeistExplosiveTwo)
    SetEntityCollision(HeistExplosiveTwo, false, true)
    NetworkAddEntityToSynchronisedScene(HeistExplosiveTwo, ExplosiveAnimTwo, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "semtex_b_ig8_vault_explosive_plant_b", 1.0, -1.0, 0, 0)
    NetworkStartSynchronisedScene(ExplosiveAnimTwo)
    Citizen.Wait(2000)
    FreezeEntityPosition(HeistExplosiveTwo, true)
    SetEntityCollision(HeistExplosiveTwo, false, true)
    DeleteEntity(HeistBag)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('ls-assets:client:reset:expolsion:anim')
AddEventHandler('ls-assets:client:reset:expolsion:anim', function()
    ClearPedTasks(PlayerPedId())
    for k, v in pairs(HeistProps) do
        if DoesEntityExist(v) then
            NetworkRequestControlOfEntity(v)
            DeleteEntity(v)
        end
    end
    NetworkStopSynchronisedScene(ExplosiveAnimTwo)
    HeistProps, ExplosiveAnimTwo = {}, nil
end)

-- // Functions \\ --

function TackleAnim()
    if not IsPedRagdoll(GetPlayerPed(-1)) then
        RequestAnimDict("swimming@first_person@diving")
        while not HasAnimDictLoaded("swimming@first_person@diving") do
            Citizen.Wait(1)
        end
        if IsEntityPlayingAnim(GetPlayerPed(-1), "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
            ClearPedTasksImmediately(GetPlayerPed(-1))
        else
            TaskPlayAnim(GetPlayerPed(-1), "swimming@first_person@diving", "dive_run_fwd_-45_loop" ,3.0, 3.0, -1, 49, 0, false, false, false)
            Citizen.Wait(250)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            SetPedToRagdoll(GetPlayerPed(-1), math.random(4000, 5000), math.random(4000, 5000), 0, 0, 0, 0)
        end
    end
end

function StartPointing()
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(GetPlayerPed(-1), 0, 1, 1, 1)
    SetPedConfigFlag(GetPlayerPed(-1), 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, GetPlayerPed(-1), "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

function StopPointing()
    Citizen.InvokeNative(0xD01015C7316AE176, GetPlayerPed(-1), "Stop")
    if not IsPedInjured(GetPlayerPed(-1)) then
        ClearPedSecondaryTask(GetPlayerPed(-1))
    end
    if not IsPedInAnyVehicle(GetPlayerPed(-1), 1) then
        SetPedCurrentWeaponVisible(GetPlayerPed(-1), 1, 1, 1, 1)
    end
    SetPedConfigFlag(GetPlayerPed(-1), 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

function ResetAnimSet()
    ResetPedMovementClipset(GetPlayerPed(-1))
    ResetPedWeaponMovementClipset(GetPlayerPed(-1))
    ResetPedStrafeClipset(GetPlayerPed(-1))
    TriggerEvent('animations:client:set:walkstyle')
end

function RequestAnimSetEvent(AnimSet)
    RequestAnimSet(AnimSet)
    while not HasAnimSetLoaded(AnimSet) do
        Citizen.Wait(0)
    end
end

function RequestAnimationDict(AnimDict)
    RequestAnimDict(AnimDict)
    while not HasAnimDictLoaded(AnimDict) do
        Citizen.Wait(1)
    end
end