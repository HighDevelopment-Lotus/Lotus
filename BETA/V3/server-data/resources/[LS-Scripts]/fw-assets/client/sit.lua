local plyCoords = GetEntityCoords(PlayerPedId())
local isWithinObject = false
local oElement = {}

-- // BASIC
local InUse = false
local IsTextInUse = false
local PlyLastPos = 0

-- // ANIMATION
local Anim = 'sit'
local AnimScroll = 0

-- Fast Thread
CreateThread(function()
    while true do
        if isWithinObject and oElement.fObject ~= 0 then
            local ply = PlayerPedId()
            if (InUse) then
                if IsControlJustPressed(0, 73) then
                    InUse = false
                    TriggerServerEvent('framework-assets:Server:Leave', oElement.fObjectCoords)
                    ClearPedTasks(ply)
                    FreezeEntityPosition(ply, false)
                    
                    local x, y, z = table.unpack(PlyLastPos)
                    if GetDistanceBetweenCoords(x, y, z, plyCoords) < 10 then
                        SetEntityCoords(ply, PlyLastPos)
                    end
                end
            end
        end
        Wait(0)
    end
end)

-- Medium Thread
CreateThread(function()
    while true do
        plyCoords = GetEntityCoords(PlayerPedId())
        Wait(1000)
    end
end)


-- Slow Thread
CreateThread(function()
    Wait(1500)
    while true do
        for _, element in pairs(Config.Objects.locations) do
            local closestObject = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 3.0, GetHashKey(element.object), 0, 0, 0)
            local coordsObject = GetEntityCoords(closestObject)
            local distanceDiff = #(coordsObject - plyCoords)
            if (distanceDiff < 3.0 and closestObject ~= 0) then
                if (distanceDiff < 2.0) then
                    oElement = {
                        fObject = closestObject,
                        fObjectCoords = coordsObject,
                        fObjectcX = element.verticalOffsetX,
                        fObjectcY = element.verticalOffsetY,
                        fObjectcZ = element.verticalOffsetZ,
                        fObjectDir = element.direction,
                        fObjectIsBed = element.bed
                    }
                    isWithinObject = true
                end
                break
            else
                isWithinObject = false
            end
        end
        Wait(2000)
    end
end)

RegisterNetEvent('framework-assets:client:sitchair')
AddEventHandler('framework-assets:client:sitchair', function()
    TriggerServerEvent('framework-assets:Server:Enter', oElement, oElement.fObjectCoords)
end)

RegisterNetEvent('framework-assets:Client:Animation')
AddEventHandler('framework-assets:Client:Animation', function(v, coords)
    local object = v.fObject
    local vertx = v.fObjectcX
    local verty = v.fObjectcY
    local vertz = v.fObjectcZ
    local dir = v.fObjectDir
    local isBed = v.fObjectIsBed
    local objectcoords = coords
    
    local ped = PlayerPedId()
    PlyLastPos = GetEntityCoords(ped)
    FreezeEntityPosition(object, true)
    FreezeEntityPosition(ped, true)
    InUse = true
    if isBed == false then
        if Config.Objects.SitAnimation.dict ~= nil then
            SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
            SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
            local dict = Config.Objects.SitAnimation.dict
            local anim = Config.Objects.SitAnimation.anim
            
            AnimLoadDict(dict, anim, ped)
        else
            TaskStartScenarioAtPosition(ped, Config.Objects.SitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true)
        end
    else
        if Anim == 'sit' then
            if Config.Objects.LayAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                local dict = Config.Objects.LayAnimation.dict
                local anim = Config.Objects.LayAnimation.anim
                
                Animation(dict, anim, ped)
            else
                TaskStartScenarioAtPosition(ped, Config.Objects.LayAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + 180.0, 0, true, true)
            end
        end
    end
end)



function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 350
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

function Animation(dict, anim, ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    
    TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
end
