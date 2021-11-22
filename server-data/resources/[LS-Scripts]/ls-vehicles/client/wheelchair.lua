local CurrentWheelChair, IsPushingWheelchair, HasWalkVelocity, IsWheelChairEmpty, WheelChairDriver = nil, false, false, false, nil
local CurrentStearingAngle, CurrentForwardSpeed, CanMove, IsIsOnFourWheels = 0, 0, false, false

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and IsPushingWheelchair then
            local IsWalking = false
            local ForwardSpeed, SteerAngle = 1.5, 30.0
            local IsMovingForward, IsMovingBackwards = IsControlPressed(0, 32), IsControlPressed(0, 8)
            local IsStearingLeft, IsStearingRight = IsControlPressed(0, 34), IsControlPressed(0, 9)
            if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then
                TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 51, 0, false, false, false)
            end
            if IsEmpty then
                NetworkRequestControlOfEntity(CurrentWheelChair)
            end
            if IsControlPressed(0, 21) then
                ForwardSpeed = 2.5
                SteerAngle = 30.0 / ForwardSpeed
            end
            if CanMove and IsMovingForward then
                IsWalking, CurrentForwardSpeed = true, ForwardSpeed
                --Citizen.InvokeNative(0x211AB1DD8D0F363A, PlayerPedId(), "ForwardSpeed", ForwardSpeed)
                if IsEmpty then
                    SetVehicleForwardSpeed(CurrentWheelChair, ForwardSpeed)
                end
            end
            if CanMove and IsMovingBackwards then
                IsWalking, CurrentForwardSpeed = true, -1.0
                --Citizen.InvokeNative(0x211AB1DD8D0F363A, PlayerPedId(), "ForwardSpeed", -1.0)
                if IsEmpty then
                    SetVehicleForwardSpeed(CurrentWheelChair, -1.0)
                end
            end
            if CurrentForwardSpeed ~= 0.0 and not IsMovingForward and not IsMovingBackwards then
                CurrentForwardSpeed = 0.0
                --Citizen.InvokeNative(0x211AB1DD8D0F363A, PlayerPedId(), "ForwardSpeed", 0.0)
            end
            if IsStearingLeft then
                CurrentStearingAngle = SteerAngle
                --Citizen.InvokeNative(0x211AB1DD8D0F363A, PlayerPedId(), "SteerAngle", CurrentStearingAngle * 0.01)
                if IsEmpty then
                    SetVehicleSteeringAngle(CurrentWheelChair, SteerAngle)
                end
            end
            if IsStearingRight then
                CurrentStearingAngle = -SteerAngle
                --Citizen.InvokeNative(0x211AB1DD8D0F363A, PlayerPedId(), "SteerAngle", CurrentStearingAngle * 0.01)
                if IsEmpty then
                    SetVehicleSteeringAngle(CurrentWheelChair, -SteerAngle)
                end
            end
            if CurrentStearingAngle ~= 0.0 and (IsMovingForward or IsMovingBackwards) and (not IsStearingLeft and not IsStearingRight) then
                CurrentStearingAngle = 0.0
                --Citizen.InvokeNative(0x211AB1DD8D0F363A, PlayerPedId(), "SteerAngle", 0.0)
                if IsEmpty then
                    SetVehicleSteeringAngle(CurrentWheelChair, 0.0)
                end
            end
            local IsPlayingWalkAnim = IsEntityPlayingAnim(PlayerPedId(), "move_action@generic@core", "walk", 3)
            if (IsWalking or HasWalkVelocity) and not IsPlayingWalkAnim then
                TaskPlayAnim(PlayerPedId(), "move_action@generic@core", "walk", 8.0, 8.0, -1, 1, 0, false, false, false)
            elseif not IsWalking and not HasWalkVelocity and IsPlayingWalkAnim then
                StopAnimTask(PlayerPedId(), "move_action@generic@core", "walk", 3.0)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and IsPushingWheelchair then
            local HasDriver = not IsVehicleSeatFree(CurrentWheelChair, -1)
            local IsEngineOn = GetIsVehicleEngineRunning(CurrentWheelChair)
            local Velocity, IsUpright = GetEntityVelocity(CurrentWheelChair), IsEntityUpright(CurrentWheelChair, 50.0)
            local VY, VZ = math.abs(Velocity.y), math.abs(Velocity.z)
            IsOnFourWheels, CanMove, HasWalkVelocity = IsVehicleOnAllWheels(CurrentWheelChair), false, false
            if IsOnFourWheels or VZ < 0.3 then
                CanMove = true
            end
            if VY > 0.5 then 
                HasWalkVelocity = true
            end
            if VZ > 2.0 or not IsEntityAttachedToEntity(PlayerPedId(), CurrentWheelChair) or IsPedDeadOrDying(PlayerPedId(), 1) then
                IsPushingWheelchair = false
            end
            if not IsUpright then
                IsPushingWheelchair = false
            end
            Citizen.Wait(400)
        else
            Citizen.Wait(450)
        end
    end
end)

function StopControling()
    CurrentWheelChair = nil
    DetachEntity(PlayerPedId(), false, true)
    StopAnimTask(PlayerPedId(), "move_action@generic@core", "walk", 1.0)
    StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 1.0)
end

RegisterCommand('Stop', function(source, args)
    StopControling()
end)

-- // Events \\ --

RegisterNetEvent('ls-vehicles:client:control:vehicle')
AddEventHandler('ls-vehicles:client:control:vehicle', function(Nothing, Entity)
    if not IsPushingWheelChair then
        IsPushingWheelchair = true
        CurrentWheelChair = Entity['Entity']
        IsEmpty, Driver = IsVehicleSeatFree(CurrentWheelChair, -1)
        exports['ls-assets']:RequestAnimationDict("move_action@generic@core")
        exports['ls-assets']:RequestAnimationDict("anim@heists@box_carry@")
	    AttachEntityToEntity(PlayerPedId(), CurrentWheelChair, GetEntityBoneIndexByName(CurrentWheelChair, "misc_b"), -0.23, -0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 0, 1, 0, 1)
    end
end)