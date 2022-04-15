exports("getEntityInDirection", function(coordA, coordB)
    return getEntityInDirection(coordA, coordB)
end)

function getEntityInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local entity

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, entity = GetRaycastResult(rayHandle)
        offset = offset - 1
        if entity ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(entity))
    if distance > 25 then entity = nil end
    return entity ~= nil and entity or 0
end