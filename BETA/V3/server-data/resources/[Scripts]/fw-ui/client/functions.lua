function RayCastGamePlayCamera()
    local CameraRotation = GetGameplayCamRot()
    local CameraCoords = GetGameplayCamCoord()
    local Direction = RotationToDirection(CameraRotation)
    local TargetDistance = 4.0
    local Destination = {
        x = CameraCoords.x + Direction.x * TargetDistance,
        y = CameraCoords.y + Direction.y * TargetDistance,
        z = CameraCoords.z + Direction.z * TargetDistance
    }
    local Retval, Hit, EndCoords, Surface, EntityHit = GetShapeTestResult(StartShapeTestRay(CameraCoords.x, CameraCoords.y, CameraCoords.z, Destination.x, Destination.y, Destination.z, 30, PlayerPedId(), 0))
    return Retval, Hit, EndCoords, Surface, EntityHit, Destination
end

function RotationToDirection(Rotation)
    local AdjustedRotation = {
        x = (math.pi / 180) * Rotation.x,
        y = (math.pi / 180) * Rotation.y,
        z = (math.pi / 180) * Rotation.z
    }
    local Direction = {
        x = -math.sin(AdjustedRotation.z) * math.abs(math.cos(AdjustedRotation.x)),
        y = math.cos(AdjustedRotation.z) * math.abs(math.cos(AdjustedRotation.x)),
        z = math.sin(AdjustedRotation.x)
    }
    return Direction
end