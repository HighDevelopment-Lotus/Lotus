DecoMode = false
local MainCamera = nil
local curPos
local speeds = {0.01, 0.03, 0.05, 0.1, 0.2, 0.4, 0.5}
local curSpeed = 1

local cursorEnabled = true

local SelectedObj = nil
local SelObjHash = {}
local SelObjPos = {}
local SelObjRot = {}

local curRotate = {}

local ObjectList = {}
local SelObjId = 0

local isEdit = false

local rotateActive = false
local peanut = false

local previewObj = nil

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- Only enable some controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if DecoMode then
			DisableAllControlActions(0)
			EnableControlAction(0, Keys["W"], true)
			EnableControlAction(0, Keys["S"], true)
			EnableControlAction(0, Keys["T"], true)
			EnableControlAction(0, Keys["LEFTSHIFT"], true)
			EnableControlAction(0, Keys["LEFTALT"], true)
			EnableControlAction(0, Keys["F1"], true)
            EnableControlAction(0, Keys["F2"], true)
            EnableControlAction(0, Keys["F3"], true)
			EnableControlAction(0, Keys["ENTER"], true)
			EnableControlAction(0, Keys["LEFT"], true)
			EnableControlAction(0, Keys["RIGHT"], true)
			EnableControlAction(0, Keys["TOP"], true)
			EnableControlAction(0, Keys["DOWN"], true)
			EnableControlAction(0, Keys["PAGEUP"], true)
            EnableControlAction(0, Keys["PAGEDOWN"], true)
            EnableControlAction(0, Keys["BACKSPACE"], true)

			DisplayRadar(false)

			CheckRotationInput()
            CheckMovementInput()
            
			if SelectedObj ~= nil and peanut then
				local color = {r = 116, g = 189, b = 252, a = 100}
				DrawEntityBoundingBox(SelectedObj, color)
                DrawMarker(21, SelObjPos.x, SelObjPos.y, SelObjPos.z + 1.28, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.6, 0.6, 0.6, 28, 149, 255, 100, true, true, 2, false, false, false, false)
                if rotateActive then 
                    CheckObjRotationInput()
                else
                    CheckObjMovementInput()
                end
                if IsControlJustReleased(0, Keys["F3"]) then
                    rotateActive = not rotateActive
				end
				if IsControlJustReleased(0, Keys["LEFTALT"]) then
					PlaceObjectOnGroundProperly(SelectedObj)
					local groundPos = GetEntityCoords(SelectedObj)
					SelObjPos.z = groundPos.z
                end
				if IsControlJustReleased(0, Keys["ENTER"]) then
					SetNuiFocus(true, true)
					cursorEnabled = not cursorEnabled
					if not isEdit then
						SendNUIMessage({
							type = "buyOption",
						})
					else
						SetNuiFocus(false, false)
						cursorEnabled = not cursorEnabled
						SaveDecorations()
						SelectedObj = nil
						SelObjId = 0
						peanut = false
						isEdit = false
					end
				end
			else
				if IsControlJustPressed(0, Keys["F5"]) then
					if not cursorEnabled then
						SetNuiFocus(true, true)
					end
				end
            end
		end
	end
end)

-- Out of area
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if DecoMode then
			local camPos = GetCamCoord(MainCamera)
			if GetDistanceBetweenCoords(camPos.x, camPos.y, camPos.z, Config.Houses[Currenthouse]['Coords']['Enter']['X'], Config.Houses[Currenthouse]['Coords']['Enter']['Y'], Config.Houses[Currenthouse]['Coords']['Enter']['Z'], false) > 50.0 then
				DisableEditMode()
				closeDecorateUI()
				LSCore.Functions.Notify("Je bent buiten de range gegaan!")
			end
		end
	end
end)


RegisterNetEvent("ls-housing:client:decorate")
AddEventHandler("ls-housing:client:decorate", function()
	Citizen.Wait(500)
	if IsInHouse then 
		if HasKey then 
			if not DecoMode then
				EnableEditMode()
				openDecorateUI()
			end
		else
			LSCore.Functions.Notify("Je moet de sleutels van het huis hebben!", "error")
		end
	else
		LSCore.Functions.Notify("Je bent niet in een huis!", "error")
	end
end)

function openDecorateUI()
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = "openObjects",
		furniture = Config.Furniture,
	})
	SetCursorLocation(0.5, 0.5)
end

function closeDecorateUI()
	cursorEnabled = not cursorEnabled
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "closeUI",
	})
end

RegisterNetEvent("ls-housing:server:sethousedecorations")
AddEventHandler("ls-housing:server:sethousedecorations", function(house, decorations)
	if Config.Houses[house] ~= nil then
		Config.Houses[house]['Decorations'] = decorations
		if IsInHouse and Currenthouse == house then 
			LoadDecorations(house)
		end
	end
end)

RegisterNUICallback("closedecorations", function(data, cb)
	if previewObj ~= nil then 
		DeleteObject(previewObj)
	end
	DisableEditMode()
    SetNuiFocus(false, false)
end)

RegisterNUICallback("deleteSelectedObject", function(data, cb)
	DeleteObject(SelectedObj)
	SelectedObj = nil
	table.remove(ObjectList, SelObjId)
	Citizen.Wait(100)
	SaveDecorations()
	SelObjId = 0
	peanut = false
end)

RegisterNUICallback("cancelSelectedObject", function(data, cb)
	DeleteObject(SelectedObj)
	SelectedObj = nil
	SelObjId = 0
	peanut = false
end)

RegisterNUICallback("buySelectedObject", function(data, cb)
	SetNuiFocus(false, false)
	cursorEnabled = not cursorEnabled
	SaveDecorations()
	SelectedObj = nil
	SelObjId = 0
	peanut = false
end)

RegisterNUICallback('setupMyObjects', function(data, cb)
	local Objects = {}
	for k, v in pairs(ObjectList) do
		if ObjectList[k] ~= nil then
			table.insert(Objects, {
				rotx = v.rotx,
				object = v.object,
				y = v.y,
				hashname = v.hashname,
				x = v.x,
				rotz = v.rotz,
				objectId = v.objectId,
				roty = v.roty,
				z = v.z,
			})
		end
	end
	Wait(100)

	cb(Objects)
end)

RegisterNUICallback('removeObject', function()
	if previewObj ~= nil then 
		DeleteObject(previewObj)
	end
end)

RegisterNUICallback('toggleCursor', function()
	if cursorEnabled then
		SetNuiFocus(false, false)
	end

	cursorEnabled = not cursorEnabled
end)

RegisterNUICallback('selectOwnedObject', function(data)
	local objectData = data.objectData

	local ownedObject = GetClosestObjectOfType(objectData.x, objectData.y, objectData.z, 1.5, GetHashKey(objectData.hashname), false, 6, 7)
	local pos = GetEntityCoords(ownedObject, true)
    local rot = GetEntityRotation(ownedObject)
    SelObjRot = {x = rot.x, y = rot.y, z = rot.z}
	SelObjPos = {x = pos.x, y = pos.y, z = pos.z}
	SelObjHash = objectData.hashname
	SelObjId = objectData.objectId
	SelectedObj = ownedObject
	FreezeEntityPosition(SelectedObj, true)
	peanut = true
end)

RegisterNUICallback('editOwnedObject', function(data)
	SetNuiFocus(false, false)
	cursorEnabled = not cursorEnabled
	local objectData = data.objectData

	local ownedObject = GetClosestObjectOfType(objectData.x, objectData.y, objectData.z, 1.5, GetHashKey(objectData.hashname), false, 6, 7)
	local pos = GetEntityCoords(ownedObject, true)
	local rot = GetEntityRotation(ownedObject)
    SelObjRot = {x = rot.x, y = rot.y, z = rot.z}
	SelObjPos = {x = pos.x, y = pos.y, z = pos.z}
	SelObjHash = objectData.hashname
	SelObjId = objectData.objectId
	SelectedObj = ownedObject
	isEdit = true
	FreezeEntityPosition(SelectedObj, true)
	peanut = true
end)

RegisterNUICallback('deselectOwnedObject', function()
	SelectedObj = nil
	peanut = false
end)

RegisterNUICallback('ResetSelectedProp', function()
	SelectedObj = nil
	peanut = false
end)

RegisterNUICallback("spawnobject", function(data, cb)
	SetNuiFocus(false, false)
	cursorEnabled = not cursorEnabled
	if previewObj ~= nil then 
		DeleteObject(previewObj)
	end
	local modelHash = GetHashKey(tostring(data.object))
	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
	    Citizen.Wait(1000)
	end
	local rotation = GetCamRot(MainCamera, 2)
	local xVect = 2.5 * math.sin( degToRad( rotation.z ) ) * -1.0
	local yVect = 2.5 * math.cos( degToRad( rotation.z ) )
	
    SelectedObj = CreateObject(modelHash, curPos.x + xVect, curPos.y + yVect, curPos.z, false, false, false)
    local pos = GetEntityCoords(SelectedObj, true)
    local rot = GetEntityRotation(SelectedObj)
    SelObjRot = {x = rot.x, y = rot.y, z = rot.z}
	SelObjPos = {x = pos.x, y = pos.y, z = pos.z}
	SelObjHash = data.object
	PlaceObjectOnGroundProperly(SelectedObj)
	SetEntityCompletelyDisableCollision(SelectedObj, true) -- Prevents crazy physics when collidin with other entitys
    peanut = true
end)

RegisterNUICallback("chooseobject", function(data, cb)
	if previewObj ~= nil then 
		DeleteObject(previewObj)
	end
    local modelHash = GetHashKey(tostring(data.object))
	RequestModel(modelHash)

	local count = 0
	while not HasModelLoaded(modelHash) do
		-- Counter to prevent infinite loading when object does not exist
		if count > 10 then
			break
		end
		count = count + 1
	    Citizen.Wait(1000)
	end

	-- Make buttons selectable again
	SendNUIMessage({
		type = "objectLoaded",
	})

	local rotation = GetCamRot(MainCamera, 2)
	local xVect = 2.5 * math.sin( degToRad( rotation.z ) ) * -1.0
    local yVect = 2.5 * math.cos( degToRad( rotation.z ) )
    previewObj = CreateObject(modelHash, curPos.x + xVect, curPos.y + yVect, curPos.z, false, false, false)
    PlaceObjectOnGroundProperly(previewObj)
end)

function EnableEditMode()
	local pos = GetEntityCoords(GetPlayerPed(-1), true)
	curPos = {x = pos.x, y = pos.y, z = pos.z}
	SetEntityVisible(GetPlayerPed(-1), false)
	FreezeEntityPosition(GetPlayerPed(-1), true)
	SetEntityCollision(GetPlayerPed(-1), false, false)
	CreateEditCamera()
	DecoMode = true
end

function DisableEditMode()
	SaveDecorations()
	SetEntityVisible(GetPlayerPed(-1), true)
	FreezeEntityPosition(GetPlayerPed(-1), false)
	SetEntityCollision(GetPlayerPed(-1), true, true)
	SetDefaultCamera()
	EnableAllControlActions(0)
	ObjectList = nil
	SelectedObj = nil
	peanut = false
	DecoMode = false
end

function UnloadDecorations()
	if ObjectList ~= nil then 
		for k, v in pairs(ObjectList) do
			if DoesEntityExist(v.object) then
				DeleteObject(v.object)
			end
		end
	end
end

function LoadDecorations(house)
	if Config.Houses[house] ~= nil then
		if Config.Houses[house]['Decorations'] == nil or next(Config.Houses[house]['Decorations']) == nil then
			LSCore.Functions.TriggerCallback('ls-housing:server:get:decorations', function(result)
				Config.Houses[house]['Decorations'] = result
				if Config.Houses[house]['Decorations'] ~= nil then
					ObjectList = {}
					for k, v in pairs(Config.Houses[house]['Decorations']) do
						if Config.Houses[house]['Decorations'][k] ~= nil then 
							if Config.Houses[house]['Decorations'][k].object ~= nil then
								if DoesEntityExist(Config.Houses[house]['Decorations'][k].object) then
									DeleteObject(Config.Houses[house]['Decorations'][k].object)
								end
							end
							local modelHash = GetHashKey(Config.Houses[house]['Decorations'][k].hashname)
							RequestModel(modelHash)
							while not HasModelLoaded(modelHash) do
								Citizen.Wait(10)
							end
							local decorateObject = CreateObject(modelHash, Config.Houses[house]['Decorations'][k].x, Config.Houses[house]['Decorations'][k].y, Config.Houses[house]['Decorations'][k].z, false, false, false)
							SetEntityRotation(decorateObject, Config.Houses[house]['Decorations'][k].rotx, Config.Houses[house]['Decorations'][k].roty, Config.Houses[house]['Decorations'][k].rotz)
							ObjectList[Config.Houses[house]['Decorations'][k].objectId] = {hashname = Config.Houses[house]['Decorations'][k].hashname, x = Config.Houses[house]['Decorations'][k].x, y = Config.Houses[house]['Decorations'][k].y, z = Config.Houses[house]['Decorations'][k].z, rotx = Config.Houses[house]['Decorations'][k].rotx, roty = Config.Houses[house]['Decorations'][k].roty, rotz = Config.Houses[house]['Decorations'][k].rotz, object = decorateObject, objectId = Config.Houses[house]['Decorations'][k].objectId}
							FreezeEntityPosition(decorateObject, true)
						end
					end
				end
			end, house)
		elseif Config.Houses[house]['Decorations'] ~= nil then
			ObjectList = {}
			for k, v in pairs(Config.Houses[house]['Decorations']) do
				if Config.Houses[house]['Decorations'][k] ~= nil then 
					if Config.Houses[house]['Decorations'][k].object ~= nil then
						if DoesEntityExist(Config.Houses[house]['Decorations'][k].object) then
							DeleteObject(Config.Houses[house]['Decorations'][k].object)
						end
					end
					local modelHash = GetHashKey(Config.Houses[house]['Decorations'][k].hashname)
					RequestModel(modelHash)
					while not HasModelLoaded(modelHash) do
						Citizen.Wait(10)
					end
					local decorateObject = CreateObject(modelHash, Config.Houses[house]['Decorations'][k].x, Config.Houses[house]['Decorations'][k].y, Config.Houses[house]['Decorations'][k].z, false, false, false)
					Config.Houses[house]['Decorations'][k].object = decorateObject
					SetEntityRotation(decorateObject, Config.Houses[house]['Decorations'][k].rotx, Config.Houses[house]['Decorations'][k].roty, Config.Houses[house]['Decorations'][k].rotz)
					ObjectList[Config.Houses[house]['Decorations'][k].objectId] = {hashname = Config.Houses[house]['Decorations'][k].hashname, x = Config.Houses[house]['Decorations'][k].x, y = Config.Houses[house]['Decorations'][k].y, z = Config.Houses[house]['Decorations'][k].z, rotx = Config.Houses[house]['Decorations'][k].rotx, roty = Config.Houses[house]['Decorations'][k].roty, rotz = Config.Houses[house]['Decorations'][k].rotz, object = decorateObject, objectId = Config.Houses[house]['Decorations'][k].objectId}
					FreezeEntityPosition(decorateObject, true)
				end
			end
		end
	end
end

function SaveDecorations()
	if Currenthouse ~= nil then
		if SelectedObj ~= nil then
			if SelObjId ~= 0 then
				ObjectList[SelObjId] = {hashname = SelObjHash, x = SelObjPos.x, y = SelObjPos.y, z = SelObjPos.z, rotx = SelObjRot.x, roty = SelObjRot.y, rotz = SelObjRot.z, object = SelectedObj, objectId = SelObjId}
			else
				if ObjectList ~= nil then
					ObjectList[#ObjectList+1] = {hashname = SelObjHash, x = SelObjPos.x, y = SelObjPos.y, z = SelObjPos.z, rotx = SelObjRot.x, roty = SelObjRot.y, rotz = SelObjRot.z, object = SelectedObj, objectId = #ObjectList+1}
				else
					ObjectList[1] = {hashname = SelObjHash, x = SelObjPos.x, y = SelObjPos.y, z = SelObjPos.z, rotx = SelObjRot.x, roty = SelObjRot.y, rotz = SelObjRot.z, object = SelectedObj, objectId = #ObjectList+1}
				end
			end

			for k, v in pairs(ObjectList) do
				DeleteObject(v.object)
			end
		end
		TriggerServerEvent("ls-housing:server:save:decorations", Currenthouse, ObjectList)
	end
end

function CheckObjMovementInput()
	local xVect = speeds[curSpeed]
    local yVect = speeds[curSpeed]
    local zVect = speeds[curSpeed]

    if IsControlPressed( 1, Keys["TOP"]) or IsDisabledControlPressed(1, Keys["TOP"]) then
    	SelObjPos.x = SelObjPos.x + xVect
    end

    if IsControlPressed( 1, Keys["DOWN"]) or IsDisabledControlPressed(1, Keys["DOWN"]) then
    	SelObjPos.x = SelObjPos.x - xVect
    end

    if IsControlPressed( 1, Keys["LEFT"]) or IsDisabledControlPressed(1, Keys["LEFT"]) then
    	SelObjPos.y = SelObjPos.y + yVect
    end

    if IsControlPressed( 1, Keys["RIGHT"]) or IsDisabledControlPressed(1, Keys["RIGHT"]) then
    	SelObjPos.y = SelObjPos.y - yVect
    end

    if IsControlPressed( 1, Keys["PAGEUP"]) or IsDisabledControlPressed(1, Keys["PAGEUP"]) then
    	SelObjPos.z = SelObjPos.z + zVect
    end

    if IsControlPressed( 1, Keys["PAGEDOWN"]) or IsDisabledControlPressed(1, Keys["PAGEDOWN"]) then
    	SelObjPos.z = SelObjPos.z - zVect
    end

    SetEntityCoords(SelectedObj, SelObjPos.x, SelObjPos.y, SelObjPos.z)
end

function CheckObjRotationInput()
	local xVect = speeds[curSpeed] * 5.5
    local yVect = speeds[curSpeed] * 5.5
    local zVect = speeds[curSpeed] * 5.5

	if IsControlPressed( 1, Keys["TOP"]) or IsDisabledControlPressed(1, Keys["TOP"]) then
    	SelObjRot.x = SelObjRot.x + xVect
    end

    if IsControlPressed( 1, Keys["DOWN"]) or IsDisabledControlPressed(1, Keys["DOWN"]) then
    	SelObjRot.x = SelObjRot.x - xVect
    end

    if IsControlPressed( 1, Keys["LEFT"]) or IsDisabledControlPressed(1, Keys["LEFT"]) then
    	SelObjRot.z = SelObjRot.z + zVect
    end

    if IsControlPressed( 1, Keys["RIGHT"]) or IsDisabledControlPressed(1, Keys["RIGHT"]) then
    	SelObjRot.z = SelObjRot.z - zVect
    end

    if IsControlPressed( 1, Keys["PAGEUP"]) or IsDisabledControlPressed(1, Keys["PAGEUP"]) then
    	SelObjRot.y = SelObjRot.y + yVect
    end

    if IsControlPressed( 1, Keys["PAGEDOWN"]) or IsDisabledControlPressed(1, Keys["PAGEDOWN"]) then
    	SelObjRot.y = SelObjRot.y - yVect
    end

	SetEntityRotation(SelectedObj, SelObjRot.x, SelObjRot.y, SelObjRot.z)
end

function CheckRotationInput()
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(MainCamera, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(2.0)*(4.0+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(2.0)*(4.0+0.1)), -20.5)
		SetCamRot(MainCamera, new_x, 0.0, new_z, 2)
	end
end

function CheckMovementInput()
	local rotation = GetCamRot(MainCamera, 2)

	if IsControlJustReleased(0, Keys["LEFTSHIFT"]) then
		curSpeed = curSpeed + 1
		if curSpeed > getTableLength(speeds) then
			curSpeed = 1
		end
		LSCore.Functions.Notify("Speed is ".. tostring(speeds[curSpeed]))
	end

	local xVect = speeds[curSpeed] * math.sin( degToRad( rotation.z ) ) * -1.0
    local yVect = speeds[curSpeed] * math.cos( degToRad( rotation.z ) )
    local zVect = speeds[curSpeed] * math.tan( degToRad( rotation.x ) - degToRad( rotation.y ))

    if IsControlPressed( 1, Keys["W"]) or IsDisabledControlPressed(1, Keys["W"]) then
    	curPos.x = curPos.x + xVect
        curPos.y = curPos.y + yVect
        curPos.z = curPos.z + zVect
    end

    if IsControlPressed( 1, Keys["S"]) or IsDisabledControlPressed(1, Keys["S"]) then
    	curPos.x = curPos.x - xVect
        curPos.y = curPos.y - yVect
        curPos.z = curPos.z - zVect
	end

	SetCamCoord(MainCamera, curPos.x, curPos.y, curPos.z)
end

function CreateEditCamera()
	local rot = GetEntityRotation(GetPlayerPed(-1))
	local pos = GetEntityCoords(GetPlayerPed(-1), true)
	MainCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 60.00, false, 0)
	SetCamActive(MainCamera, true)
	RenderScriptCams(true, false, 1, true, true)
end

function SetDefaultCamera()
	RenderScriptCams(false, true, 500, true, true)
	SetCamActive(MainCamera, false)
	DestroyCam(MainCamera, true)
	DestroyAllCams(true)
end

function ShowHelpNotification(msg)
	BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function getTableLength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function degToRad( degs )
    return degs * 3.141592653589793 / 180
end

-- Draws boundingbox around the object with given color parms
function DrawEntityBoundingBox(entity, color)
	local model = GetEntityModel(entity)
    local min, max = GetModelDimensions(model)
    local rightVector, forwardVector, upVector, position = GetEntityMatrix(entity)

    -- Calculate size
    local dim = 
	{ 
		x = 0.5*(max.x - min.x), 
		y = 0.5*(max.y - min.y), 
		z = 0.5*(max.z - min.z)
	}

    local FUR = 
    {
		x = position.x + dim.y*rightVector.x + dim.x*forwardVector.x + dim.z*upVector.x, 
		y = position.y + dim.y*rightVector.y + dim.x*forwardVector.y + dim.z*upVector.y, 
		z = 0
    }

    local FUR_bool, FUR_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    FUR.z = FUR_z
    FUR.z = position.z + 2 * dim.z

    local BLL = 
    {
        x = position.x - dim.y*rightVector.x - dim.x*forwardVector.x - dim.z*upVector.x,
        y = position.y - dim.y*rightVector.y - dim.x*forwardVector.y - dim.z*upVector.y,
        z = 0
    }
    local BLL_bool, BLL_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    BLL.z = position.z

    -- DEBUG
    local edge1 = BLL
    local edge5 = FUR

    local edge2 = 
    {
        x = edge1.x + 2 * dim.y*rightVector.x,
        y = edge1.y + 2 * dim.y*rightVector.y,
        z = edge1.z + 2 * dim.y*rightVector.z
    }

    local edge3 = 
    {
        x = edge2.x + 2 * dim.z*upVector.x,
        y = edge2.y + 2 * dim.z*upVector.y,
        z = edge2.z + 2 * dim.z*upVector.z
    }

    local edge4 = 
    {
        x = edge1.x + 2 * dim.z*upVector.x,
        y = edge1.y + 2 * dim.z*upVector.y,
        z = edge1.z + 2 * dim.z*upVector.z
    }

    local edge6 = 
    {
        x = edge5.x - 2 * dim.y*rightVector.x,
        y = edge5.y - 2 * dim.y*rightVector.y,
        z = edge5.z - 2 * dim.y*rightVector.z
    }

    local edge7 = 
    {
        x = edge6.x - 2 * dim.z*upVector.x,
        y = edge6.y - 2 * dim.z*upVector.y,
        z = edge6.z - 2 * dim.z*upVector.z
    }

    local edge8 = 
    {
        x = edge5.x - 2 * dim.z*upVector.x,
        y = edge5.y - 2 * dim.z*upVector.y,
        z = edge5.z - 2 * dim.z*upVector.z
    }

    DrawLine(edge1.x, edge1.y, edge1.z, edge2.x, edge2.y, edge2.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge3.x, edge3.y, edge3.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge6.x, edge6.y, edge6.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge7.x, edge7.y, edge7.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge5.x, edge5.y, edge5.z, color.r, color.g, color.b, color.a)
    DrawLine(edge4.x, edge4.y, edge4.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
end