local NoclipCam = nil
local MinY, MaxY = -89.0, 89.0
local Speed, MaxSpeed = 1.0, 32.0

-- Functions

function ToggleNoclip()
    CreateThread(function()
        local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local InVehicle = false
        if Vehicle ~= 0 then
            InVehicle = true
            Entity = Vehicle
        else
            Entity = PlayerPedId()
        end
        local EntityCoords = GetEntityCoords(Entity)
        local EntityRoation = GetEntityRotation(Entity)
        NoclipCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", EntityCoords, 0.0, 0.0, EntityRoation.z, 75.0, true, 2)
        AttachCamToEntity(NoclipCam, Entity, 0.0, 0.0, 0.0, true)
        RenderScriptCams(true, false, 3000, true, false)
        FreezeEntityPosition(Entity, true)
        SetEntityCollision(Entity, false, false)
        SetEntityAlpha(Entity, 0)
        SetPedCanRagdoll(Entity, false)
        SetEntityVisible(Entity, false)
        ClearPedTasksImmediately(PlayerPedId())
        if InVehicle then
            FreezeEntityPosition(PlayerPedId(), true)
            SetEntityCollision(PlayerPedId(), false, false)
            SetEntityAlpha(PlayerPedId(), 0)
            SetEntityVisible(PlayerPedId(), false)
        end
        while IsInNoclip do
            Citizen.Wait(4)
            local rv, fv, uv, campos = GetCamMatrix(NoclipCam)
            if IsDisabledControlPressed(2, 17) then
                Speed = math.min(Speed + 0.1, MaxSpeed)
            elseif IsDisabledControlPressed(2, 16) then
                Speed = math.max(0.1, Speed - 0.1)
            end
          
            local multiplier = 1.0;
            if IsDisabledControlPressed(2, 209) then
                multiplier = 2.0
            elseif IsDisabledControlPressed(2, 19) then
                multiplier = 4.0
            elseif IsDisabledControlPressed(2, 36) then
                multiplier = 0.25
            end
            if IsDisabledControlPressed(2, 32) then -- W
                local setpos = GetEntityCoords(Entity) + fv * (Speed * multiplier)
                SetEntityCoordsNoOffset(Entity, setpos)
                if InVehicle then
                    SetEntityCoordsNoOffset(PlayerPedId(), setpos)
                end
            elseif IsDisabledControlPressed(2, 33) then -- S
                local setpos = GetEntityCoords(Entity) - fv * (Speed * multiplier)
                SetEntityCoordsNoOffset(Entity, setpos)
                if InVehicle then
                    SetEntityCoordsNoOffset(PlayerPedId(), setpos)
                end
            end
            if IsDisabledControlPressed(2, 34) then -- A
                local setpos = GetOffsetFromEntityInWorldCoords(Entity, -Speed * multiplier, 0.0, 0.0)
                SetEntityCoordsNoOffset(Entity, setpos.x, setpos.y, GetEntityCoords(Entity).z)
                if InVehicle then
                  SetEntityCoordsNoOffset(PlayerPedId(), setpos.x, setpos.y, GetEntityCoords(Entity).z)
                end
            elseif IsDisabledControlPressed(2, 35) then -- D
                local setpos = GetOffsetFromEntityInWorldCoords(Entity, Speed * multiplier, 0.0, 0.0)
                SetEntityCoordsNoOffset(Entity, setpos.x, setpos.y, GetEntityCoords(Entity).z)
                if InVehicle then
                    SetEntityCoordsNoOffset(PlayerPedId(), setpos.x, setpos.y, GetEntityCoords(Entity).z)
                end
            end
            if IsDisabledControlPressed(2, 51) then -- E
                local setpos = GetOffsetFromEntityInWorldCoords(Entity, 0.0, 0.0, multiplier * Speed / 2)
                SetEntityCoordsNoOffset(Entity, setpos)
                if InVehicle then
                    SetEntityCoordsNoOffset(PlayerPedId(), setpos)
                end
            elseif IsDisabledControlPressed(2, 52) then
                local setpos = GetOffsetFromEntityInWorldCoords(Entity, 0.0, 0.0, multiplier * - Speed / 2) -- Q
                SetEntityCoordsNoOffset(Entity, setpos)
                if InVehicle then
                    SetEntityCoordsNoOffset(PlayerPedId(), setpos)
                end
            end
            local CameraRotation = GetCamRot(NoclipCam, 2)
            SetEntityHeading(Entity, (360 + CameraRotation.z) % 360.0)
            SetEntityVisible(Entity, false)
            if InVehicle then
                SetEntityVisible(PlayerPedId(), false)
            end
            DisableControlAction(2, 32, true)
            DisableControlAction(2, 33, true)
            DisableControlAction(2, 34, true)
            DisableControlAction(2, 35, true)
            DisableControlAction(2, 36, true)
            DisableControlAction(2, 12, true)
            DisableControlAction(2, 13, true)
            DisableControlAction(2, 14, true)
            DisableControlAction(2, 15, true)
            DisableControlAction(2, 16, true)
            DisableControlAction(2, 17, true)
            DisablePlayerFiring(PlayerId(), true)
        end
        DestroyCam(NoclipCam, false)
        NoclipCam = nil
        RenderScriptCams(false, false, 3000, true, false)
        FreezeEntityPosition(Entity, false)
        ApplyForceToEntityCenterOfMass(Entity, 0, 0.0, 0.0, 0.0, 0, 0, 0, 0)
        SetEntityCollision(Entity, true, true)
        SetEntityAlpha(Entity, 255)
        SetPedCanRagdoll(Entity, true)
        SetEntityVisible(Entity, true)
        ClearPedTasksImmediately(PlayerPedId())
        if InVehicle then
            FreezeEntityPosition(PlayerPedId(), false)
            SetEntityCollision(PlayerPedId(), true, true)
            SetEntityAlpha(PlayerPedId(), 255)
            SetEntityVisible(PlayerPedId(), true)
            SetPedIntoVehicle(PlayerPedId(), Entity, -1)
        end
    end)
end

function CheckInputRotation()
    CreateThread(function()
        while IsInNoclip do
            Citizen.Wait(4)
            while NoclipCam == nil do
                Citizen.Wait(0)
            end
            local rightAxisX = GetDisabledControlNormal(0, 220)
            local rightAxisY = GetDisabledControlNormal(0, 221)
            if (math.abs(rightAxisX) > 0) and (math.abs(rightAxisY) > 0) then
                local rotation = GetCamRot(NoclipCam, 2)
                rotz = rotation.z + rightAxisX * -10.0
                local yValue = rightAxisY * -5.0
                rotx = rotation.x
                if rotx + yValue > MinY and rotx + yValue < MaxY then
                    rotx = rotation.x + yValue
                end
                SetCamRot(NoclipCam, rotx, rotation.y, rotz, 2)
            end
        end
    end)
end