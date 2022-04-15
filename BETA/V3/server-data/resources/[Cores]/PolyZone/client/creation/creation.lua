lastCreatedZoneType = nil
lastCreatedZone = nil
createdZoneType = nil
createdZone = nil
drawZone = false

-- Create

RegisterNetEvent("polyzone:pzcreate")
AddEventHandler("polyzone:pzcreate", function(zoneType, name, data)
  if zoneType == 'poly' then
    polyStart(name)
  elseif zoneType == "circle" then
    local radius = data['radius']
    circleStart(name, radius)
  elseif zoneType == "box" then
    local length = data['length']
    local width = data['width']
    boxStart(name, 0, length, width)
  else
    return
  end
  createdZoneType = zoneType
  drawZone = true
  drawThread()
end)

-- Finish

RegisterNetEvent("polyzone:pzfinish")
AddEventHandler("polyzone:pzfinish", function()
  if createdZone == nil then
    return
  end
  if createdZoneType == 'poly' then
    polyFinish()
  elseif createdZoneType == "circle" then
    circleFinish()
  elseif createdZoneType == "box" then
    boxFinish()
  end

  lastCreatedZoneType = createdZoneType
  lastCreatedZone = createdZone
  drawZone = false
  createdZone = nil
  createdZoneType = nil
end)

-- Cancel

RegisterNetEvent("polyzone:pzcancel")
AddEventHandler("polyzone:pzcancel", function()
  if createdZone == nil then
    return
  end
  drawZone = false
  createdZone = nil
  createdZoneType = nil
end)

-- Last

RegisterNetEvent("polyzone:pzlast")
AddEventHandler("polyzone:pzlast", function(Name)
  if createdZone ~= nil or lastCreatedZone == nil then
    return
  end
  local name = Name
  createdZoneType = lastCreatedZoneType
  if createdZoneType == 'box' then
    local minHeight, maxHeight
    if lastCreatedZone.minZ then
      minHeight = lastCreatedZone.center.z - lastCreatedZone.minZ
    end
    if lastCreatedZone.maxZ then
      maxHeight = lastCreatedZone.maxZ - lastCreatedZone.center.z
    end
    boxStart(name, lastCreatedZone.offsetRot, lastCreatedZone.length, lastCreatedZone.width, minHeight, maxHeight)
  elseif createdZoneType == 'circle' then
    circleStart(name, lastCreatedZone.radius, lastCreatedZone.useZ)
  end
  drawZone = true
  drawThread()
end)

RegisterNetEvent("polyzone:client:copy:zone")
AddEventHandler("polyzone:client:copy:zone", function(output)
	SendNUIMessage({
		polyzonecreation = output
	})
end)

function GetCreatedZone()
  return createdZone
end

function GetLastCreatedZone()
  return lastCreatedZone
end

function GetLastCreatedZoneType()
  return lastCreatedZoneType
end

-- Drawing
function drawThread()
  Citizen.CreateThread(function()
    while drawZone do
      if createdZone then
        createdZone:draw()
      end
      Wait(0)
    end
  end)
end
