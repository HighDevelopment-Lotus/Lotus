local CurrentTarget, IsInVehicle = nil, false

-- // Loops \\ --

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(4)
--         if LoggedIn then
--             local Entity, EntityType, EntityCoords = GetEntityPlayerIsLookingAt(3.0, 0.2, 286, PlayerPedId())
--             if Entity and EntityType ~= 0 then
--                 if Entity ~= CurrentTarget then
--                     CurrentTarget = Entity
--                     TriggerEvent('ls-ui:client:taget:changed', CurrentTarget, EntityType, EntityCoords)
--                 end
--             elseif CurrentTarget then
--                 CurrentTarget = nil
--                 TriggerEvent('ls-ui:client:taget:changed', CurrentTarget)
--             end
--             Citizen.Wait(250)
--         else
--             Citizen.Wait(450)
--         end
--     end 
-- end)    

-- // Events \\ --

AddEventHandler('baseevents:enteredVehicle', function()
    IsInVehicle = true
end)

AddEventHandler('baseevents:leftVehicle', function()
    IsInVehicle = false
end)

-- // Functions \\ --

function GetEntityPlayerIsLookingAt(Distance, Radius, Flag, Ignore)
    local Distance = Distance or 3.0
    local OriginCoords = GetPedBoneCoords(PlayerPedId(), 31086)
    local ForwardVectors = GetForwardVector(GetGameplayCamRot(2))
    local ForwardCoords = OriginCoords + (ForwardVectors * (IsInVehicle and Distance + 1.5 or Distance))
    if ForwardVectors then 
        local _, Hit, TargetCoords, _, TargetEntity = RayCast(OriginCoords, ForwardCoords, Flag or 286, Ignore, Radius or 0.2)
        if Hit and TargetEntity ~= 0 then 
            local EntityType = GetEntityType(TargetEntity)
            return TargetEntity, EntityType, TargetCoords
        end
    end
end

function GetForwardVector(Rotation)
    local Rotations = (math.pi / 180.0) * Rotation
    return vector3(-math.sin(Rotations.z) * math.abs(math.cos(Rotations.x)), math.cos(Rotations.z) * math.abs(math.cos(Rotations.x)), math.sin(Rotations.x))
end

function RayCast(Origin, Target, Options, IgnoreEntity, Radius)
    local Handle = StartShapeTestSweptSphere(Origin.x, Origin.y, Origin.z, Target.x, Target.y, Target.z, Radius, Options, IgnoreEntity, 0)
    return GetShapeTestResult(Handle)
end