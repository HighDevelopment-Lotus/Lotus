local GrabProps = {}

-- Code

-- // Events \\ --

RegisterNetEvent('framework-heists:client:trolly:grab')
AddEventHandler('framework-heists:client:trolly:grab', function(Type, RewardType)
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local BagProp = "hei_p_m_bag_var22_arm_s"
    local GrabProp = "hei_prop_heist_cash_pile"
    local CurrentTrolly = "ch_prop_ch_cash_trolly_01c"
    exports['fw-assets']:RequestModelHash(GetHashKey(BagProp))
    exports['fw-assets']:RequestModelHash(GetHashKey(GrabProp))
    exports['fw-assets']:RequestAnimationDict("anim@heists@ornate_bank@grab_cash")
    local GrabObject = CreateObject(GetHashKey(GrabProp), PlayerCoords, true)
    FreezeEntityPosition(GrabObject, true)
    SetEntityInvincible(GrabObject, true)
    SetEntityNoCollisionEntity(GrabObject, PlayerPedId())
    SetEntityVisible(GrabObject, false, false)
    AttachEntityToEntity(GrabObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
    table.insert(GrabProps, GrabObject)
    local StartedGrabbing = GetGameTimer()
    Citizen.CreateThread(function()
        while GetGameTimer() - StartedGrabbing < 37000 do
            Citizen.Wait(4)
            DisableControlAction(0, 73, true)
            if HasAnimEventFired(PlayerPedId(), GetHashKey("CASH_APPEAR")) then
                if not IsEntityVisible(GrabObject) then
                    SetEntityVisible(GrabObject, true, false)
                end
            end
            if HasAnimEventFired(PlayerPedId(), GetHashKey("RELEASE_CASH_DESTROY")) then
                if IsEntityVisible(GrabObject) then
                    SetEntityVisible(GrabObject, false, false)                   
                end
            end
        end
    end)
    NetworkRequestControlOfEntity(CurrentTrolly)
    while not NetworkHasControlOfEntity(CurrentTrolly) do
		Citizen.Wait(1)
	end
    local BagObject = CreateObject(GetHashKey(BagProp), GetEntityCoords(PlayerPedId()), true, false, false)
    table.insert(GrabProps, BagObject)
    local GrabAnimationOne = NetworkCreateSynchronisedScene(GetEntityCoords(CurrentTrolly), GetEntityRotation(CurrentTrolly), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(PlayerPedId(), GrabAnimationOne, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(BagObject, GrabAnimationOne, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(GrabAnimationOne)
    Citizen.Wait(1500)
    local GrabAnimationTwo = NetworkCreateSynchronisedScene(GetEntityCoords(CurrentTrolly), GetEntityRotation(CurrentTrolly), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), GrabAnimationTwo, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(BagObject, GrabAnimationTwo, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(CurrentTrolly, GrabAnimationTwo, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(GrabAnimationTwo)
    Citizen.Wait(37000)
    local GrabAnimationThree = NetworkCreateSynchronisedScene(GetEntityCoords(CurrentTrolly), GetEntityRotation(CurrentTrolly), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), GrabAnimationThree, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(BagObject, GrabAnimationThree, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(GrabAnimationThree)
    Citizen.Wait(1800)
    NetworkRequestControlOfEntity(CurrentTrolly)
    DeleteEntity(CurrentTrolly)
    for k, v in pairs(GrabProps) do
        NetworkRequestControlOfEntity(v)
        DeleteEntity(v)
    end
    -- TriggerServerEvent('framework-heists:server:trolly:reward', RewardType)
    LSCore.Functions.TriggerCallback('framework-heists:server:trolly:reward', function(RewardType)
    end, RewardType)
    GrabProps = {}
end)

RegisterNetEvent('framework-heists:client:trolly:grab:crate')
AddEventHandler('framework-heists:client:trolly:grab:crate', function(Time, Entity, RewardType)
    local CurrentCrate = 'ch_prop_ch_cash_trolly_01c'
    NetworkRequestControlOfEntity(CurrentCrate)
    while not NetworkHasControlOfEntity(CurrentCrate) do
		Citizen.Wait(1)
	end
    TriggerEvent('framework-assets:client:lockpick:animation', true)
    Citizen.Wait(Time)
    NetworkRequestControlOfEntity(CurrentCrate)
    DeleteEntity(CurrentCrate)
    TriggerEvent('framework-assets:client:lockpick:animation', false)
    -- TriggerServerEvent('framework-heists:server:crate:reward', RewardType)
    LSCore.Functions.TriggerCallback('framework-heists:server:crate:reward', function(RewardType)
    end, RewardType)
end)

-- // Functions \\ --

function CreateTrolly(Coords)
    exports['fw-assets']:RequestModelHash('ch_prop_ch_cash_trolly_01c')
    local TrollyProp = CreateObject(GetHashKey('ch_prop_ch_cash_trolly_01c'), Coords.x, Coords.y, Coords.z, true, false, false)
    SetEntityHeading(TrollyProp, Coords.w)
    PlaceObjectOnGroundProperly(TrollyProp)
    FreezeEntityPosition(TrollyProp, true)
end

function CreateCrate(Coords)
    exports['fw-assets']:RequestModelHash('prop_mil_crate_02')
    local CrateProp = CreateObject(GetHashKey('prop_mil_crate_02'), Coords.x, Coords.y, Coords.z, true, false, false)
    SetEntityHeading(CrateProp, Coords.w)
    PlaceObjectOnGroundProperly(CrateProp)
    FreezeEntityPosition(CrateProp, true)
end