LSCore.Functions = {}

LSCore.Functions.GetPlayerData = function(cb)
    if cb ~= nil then
        cb(LSCore.PlayerData)
    else
        return LSCore.PlayerData
    end
end

LSCore.Functions.GetCoords = function(entity)
    local coords = GetEntityCoords(entity, false)
    local heading = GetEntityHeading(entity)
    return {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        a = heading
    }
end

LSCore.Functions.DeleteVehicle = function(Vehicle)
	local Vehicle = Vehicle
	local Count, Found = 0, false
	NetworkRequestControlOfEntity(Vehicle)
	while not Found do
		Count = Count + 1
		if Count > 30 or NetworkHasControlOfEntity(Vehicle) then
			Found = true
		end
		Citizen.Wait(300)
	end
    SetEntityAsMissionEntity(Vehicle, false, true)
    DeleteVehicle(Vehicle)
end

LSCore.Functions.Notify = function(Text, TextType, TimeOut)
    local TextType = TextType ~= nil and TextType or "primary"
    local TimeOut = TimeOut ~= nil and TimeOut or 5000
	local Data = {['Message'] = Text, ['Type'] = TextType, ['TimeOut'] = TimeOut}
	exports['ls-ui']:AddNotify(Data)
end

LSCore.Functions.OpenMenu = function(MenuData)
	exports['ls-ui']:OpenMenu(MenuData)
end

LSCore.Functions.OpenInput = function(InputData, ReturnData)
	exports['ls-ui']:OpenInput(InputData, function(GotData)
		ReturnData(GotData)
	end)
end

LSCore.Functions.TriggerCallback = function(name, cb, ...)
	LSCore.ServerCallbacks[name] = cb
    TriggerServerEvent("LSCore:Server:TriggerCallback", name, ...)
end

LSCore.Functions.GetPlayers = function()
    local ReturnPlayers = {}
    for k, v in ipairs(GetActivePlayers()) do
        if DoesEntityExist(GetPlayerPed(v)) then
            table.insert(ReturnPlayers, v)
        end
    end
    return ReturnPlayers
end

LSCore.Functions.GetStreetLabel = function()
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, GetEntityCoords(GetPlayerPed(-1)).x, GetEntityCoords(GetPlayerPed(-1)).y, GetEntityCoords(GetPlayerPed(-1)).z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local FirstStreetLabel = GetStreetNameFromHashKey(s1)
    local SecondStreetLabel = GetStreetNameFromHashKey(s2)
    if SecondStreetLabel ~= nil and SecondStreetLabel ~= "" then 
        FirstStreetLabel = FirstStreetLabel .. " " .. SecondStreetLabel
    end
    return FirstStreetLabel
end

LSCore.Functions.EnumerateEntities = function(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end
		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next
		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
    end)
end

LSCore.Functions.GetVehicles = function()
    local Vehicles = {}
	for Vehicle in LSCore.Functions.EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle) do
		table.insert(Vehicles, Vehicle)
	end
	return Vehicles
end

LSCore.Functions.GetClosestVehicle = function(coords)	
	local Vehicles = LSCore.Functions.GetVehicles()
	local ClosesDistance, ClosestVehcile, Coords = -1, -1, Coords ~= nil and vector3(Coords.x, Coords.y, Coords.z) or GetEntityCoords(PlayerPedId())
	for i=1, #Vehicles, 1 do
		local VehicleCoords = GetEntityCoords(Vehicles[i])
		local Distance = #(VehicleCoords - Coords)
		if ClosesDistance == -1 or ClosesDistance > Distance then
			ClosestVehcile  = Vehicles[i]
			ClosesDistance = Distance
		end
	end
	return ClosestVehcile, ClosesDistance
end

LSCore.Functions.GetVehiclesInArea = function(Coords, Area)
	local Coords = vector3(Coords.x, Coords.y, Coords.z)
	local Vehicles, VehiclesInArea = LSCore.Functions.GetVehicles(), {}
	for i=1, #Vehicles, 1 do
		local VehicleCoords = GetEntityCoords(Vehicles[i])
		local Distance = #(VehicleCoords - Coords)
		if Distance <= Area then
			table.insert(VehiclesInArea, Vehicles[i])
		end
	end
	return VehiclesInArea
end

LSCore.Functions.IsSpawnPointClear = function(Coords, Radius)
	local Vehicles = LSCore.Functions.GetVehiclesInArea(Coords, Radius)
	if #Vehicles == 0 then
		return true
	end
end

LSCore.Functions.GetClosestPlayer = function(Coords)
    local ClosestDistance, ClosestPlayer = -1, -1
    local Coords = Coords ~= nil and Coords or GetEntityCoords(GetPlayerPed(-1))
    local ClosestPlayers = LSCore.Functions.GetPlayersFromCoords(Coords)
    for i=1, #ClosestPlayers, 1 do
        if ClosestPlayers[i] ~= PlayerId() and ClosestPlayers[i] ~= -1 then
            local TargetCoords = GetEntityCoords(GetPlayerPed(ClosestPlayers[i]))
            local Distance = #(TargetCoords - Coords)
            if ClosestDistance == -1 or ClosestDistance > Distance then
                ClosestPlayer = ClosestPlayers[i]
                ClosestDistance = Distance
            end
        end
    end
    return ClosestPlayer, ClosestDistance
end

LSCore.Functions.GetPlayersFromCoords = function(Coords, Distance)
    local Players, ClosestPlayers = LSCore.Functions.GetPlayers(), {}
    local Coords, Distance = Coords ~= nil and Coords or GetEntityCoords(GetPlayerPed(-1)), Distance ~= nil and Distance or 5.0
    for k, v in pairs(Players) do
        local TargetPed = GetPlayerPed(v)
        local TargetCoords = GetEntityCoords(TargetPed)
        local TargetDisctance = #(TargetCoords - Coords)
        if TargetDisctance <= Distance then
            table.insert(ClosestPlayers, v)
        end
    end
    return ClosestPlayers
end

LSCore.Functions.GetPeds = function(IgnoreList)
    local IgnoreList, Peds = IgnoreList ~= nil and IgnoreList or {}, {}
	for ped in LSCore.Functions.EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed) do
		local found = false
        for j=1, #IgnoreList, 1 do
			if IgnoreList[j] == ped then
				found = true
			end
		end
		if not found then
			table.insert(Peds, ped)
		end
	end
	return Peds
end

LSCore.Functions.GetClosestPed = function(Coords, IgnoreList)
	local IgnoreList = IgnoreList ~= nil and IgnoreList or {}
	local ClosesPeds = LSCore.Functions.GetPeds(IgnoreList)
	local ClosestDistance, ClosestPed, Coords = -1, -1, Coords ~= nil and Coords or GetEntityCoords(GetPlayerPed(-1))
	for i=1, #ClosesPeds, 1 do
		local TargetCoords = GetEntityCoords(ClosesPeds[i])
		local Distance = #(TargetCoords - Coords)
		if ClosestDistance == -1 or ClosestDistance > Distance then
			ClosestPed = ClosesPeds[i]
			ClosestDistance = Distance
		end
	end
	return ClosestPed, ClosestDistance
end

LSCore.Functions.Progressbar = function(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    exports['ls-progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish ~= nil then
                onFinish()
            end
        else
            if onCancel ~= nil then
                onCancel()
            end
        end
    end)
end

LSCore.Functions.GetMiniGameSkill = function(MiniGameName)
	local PlayerData = LSCore.Functions.GetPlayerData()
	if MiniGameName == 'PhoneLetters' then
		local LetterSet, Speed, Spacing = 3, 15, 950
		if PlayerData.skills['hacking'] >= 1 or PlayerData.skills['hacking'] < 15 then
			LetterSet, Speed, Spacing = 3, 15, 950
		elseif PlayerData.skills['hacking'] >= 15 and PlayerData.skills['hacking'] < 21 then
			LetterSet, Speed, Spacing = 2, 14, 900
		elseif PlayerData.skills['hacking'] >= 20 and PlayerData.skills['hacking'] < 31 then
			LetterSet, Speed, Spacing = 2, 12, 1000
		elseif PlayerData.skills['hacking'] >= 30 and PlayerData.skills['hacking'] < 41 then
			LetterSet, Speed, Spacing = 1, 12, 1000
		end
		return LetterSet, Speed, Spacing
	elseif MiniGameName == 'Phone' then
		local CodeBlock, Time = 2, 9
		if PlayerData.skills['hacking'] >= 1 or PlayerData.skills['hacking'] <= 10 then
			CodeBlock, Time = math.random(1,3), math.random(9, 11)
		elseif PlayerData.skills['hacking'] >= 11 or PlayerData.skills['hacking'] <= 20 then
			CodeBlock, Time = math.random(2, 3), math.random(9, 12)
		elseif PlayerData.skills['hacking'] >= 21 or PlayerData.skills['hacking'] <= 30 then
			CodeBlock, Time = math.random(2, 4), math.random(9, 14)
		end
		return CodeBlock, Time
	elseif MiniGameName == 'Lockpick' then
		local RemovePrecent = 55
		if PlayerData.skills['lockpick'] >= 1 or PlayerData.skills['lockpick'] < 10 then
			RemovePrecent = 50
		elseif PlayerData.skills['lockpick'] >= 10 or PlayerData.skills['lockpick'] <= 15 then
			RemovePrecent = 45
		elseif PlayerData.skills['lockpick'] >= 16 or PlayerData.skills['lockpick'] <= 25 then
			RemovePrecent = 40
		elseif PlayerData.skills['lockpick'] >= 26 or PlayerData.skills['lockpick'] <= 35 then
			RemovePrecent = 35
		elseif PlayerData.skills['lockpick'] >= 36 or PlayerData.skills['lockpick'] <= 45 then
			RemovePrecent = 30
		elseif PlayerData.skills['lockpick'] >= 46 or PlayerData.skills['lockpick'] <= 55 then
			RemovePrecent = 25
		end
		return RemovePrecent
	end
end

LSCore.Functions.SetVehiclePlate = function(Vehicle, Plate)
	local Vehicle, Plate = Vehicle, Plate
	NetworkRequestControlOfEntity(Vehicle)
	Citizen.SetTimeout(100, function()
		SetVehicleNumberPlateText(Vehicle, Plate)
	end)
end

LSCore.Functions.GetVehicleProperties = function(Vehicle)
	local VehicleColorOne, VehicleColorTwo = GetVehicleColours(Vehicle)
	local PearlescentColor, WheelColor = GetVehicleExtraColours(Vehicle)
	local VehicleProperties = {
		dirtLevel = GetVehicleDirtLevel(Vehicle),
		plateIndex = GetVehicleNumberPlateTextIndex(Vehicle),
		color1 = VehicleColorOne,
		color2 = VehicleColorTwo,
		pearlescentColor = PearlescentColor,
		wheelColor = WheelColor,
		wheels = GetVehicleWheelType(Vehicle),
		windowTint = GetVehicleWindowTint(Vehicle),
		neonEnabled = {
			IsVehicleNeonLightEnabled(Vehicle, 0),
			IsVehicleNeonLightEnabled(Vehicle, 1),
			IsVehicleNeonLightEnabled(Vehicle, 2),
			IsVehicleNeonLightEnabled(Vehicle, 3)
		},
		neonColor = table.pack(GetVehicleNeonLightsColour(Vehicle)),
		tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(Vehicle)),
		modSpoilers = GetVehicleMod(Vehicle, 0),
		modFrontBumper = GetVehicleMod(Vehicle, 1),
		modRearBumper = GetVehicleMod(Vehicle, 2),
		modSideSkirt = GetVehicleMod(Vehicle, 3),
		modExhaust = GetVehicleMod(Vehicle, 4),
		modFrame = GetVehicleMod(Vehicle, 5),
		modGrille = GetVehicleMod(Vehicle, 6),
		modHood = GetVehicleMod(Vehicle, 7),
		modFender = GetVehicleMod(Vehicle, 8),
		modRightFender = GetVehicleMod(Vehicle, 9),
		modRoof = GetVehicleMod(Vehicle, 10),
		modEngine = GetVehicleMod(Vehicle, 11),
		modBrakes = GetVehicleMod(Vehicle, 12),
		modTransmission = GetVehicleMod(Vehicle, 13),
		modHorns = GetVehicleMod(Vehicle, 14),
		modSuspension = GetVehicleMod(Vehicle, 15),
		modArmor = GetVehicleMod(Vehicle, 16),
		modTurbo = IsToggleModOn(Vehicle, 18),
		modSmokeEnabled = IsToggleModOn(Vehicle, 20),
		modXenon = IsToggleModOn(Vehicle, 22),
		modFrontWheels = GetVehicleMod(Vehicle, 23),
		modBackWheels = GetVehicleMod(Vehicle, 24),
		modPlateHolder = GetVehicleMod(Vehicle, 25),
		modVanityPlate = GetVehicleMod(Vehicle, 26),
		modTrimA  = GetVehicleMod(Vehicle, 27),
		modOrnaments = GetVehicleMod(Vehicle, 28),
		modDashboard = GetVehicleMod(Vehicle, 29),
		modDial = GetVehicleMod(Vehicle, 30),
		modDoorSpeaker = GetVehicleMod(Vehicle, 31),
		modSeats = GetVehicleMod(Vehicle, 32),
		modSteeringWheel = GetVehicleMod(Vehicle, 33),
		modShifterLeavers = GetVehicleMod(Vehicle, 34),
		modAPlate = GetVehicleMod(Vehicle, 35),
		modSpeakers = GetVehicleMod(Vehicle, 36),
		modTrunk = GetVehicleMod(Vehicle, 37),
		modHydrolic = GetVehicleMod(Vehicle, 38),
		modEngineBlock = GetVehicleMod(Vehicle, 39),
		modAirFilter = GetVehicleMod(Vehicle, 40),
		modStruts = GetVehicleMod(Vehicle, 41),
		modArchCover = GetVehicleMod(Vehicle, 42),
		modAerials = GetVehicleMod(Vehicle, 43),
		modTrimB = GetVehicleMod(Vehicle, 44),
		modTank  = GetVehicleMod(Vehicle, 45),
		modWindows = GetVehicleMod(Vehicle, 46),
		modLivery = GetVehicleMod(Vehicle, 48),
		--modCustomTyres= GetVehicleModVariation(Vehicle, 23)
	}
	return VehicleProperties
end

LSCore.Functions.SetVehicleProperties = function(Vehicle, Props)
	SetVehicleModKit(Vehicle, 0)
	for k, v in pairs(Props) do
		if k == 'plateIndex' then
			SetVehicleNumberPlateTextIndex(Vehicle, v)
		end
		if k == 'dirtLevel' then
			SetVehicleDirtLevel(Vehicle, v)
		end
		if k == 'color1' then
			local ColorOne, ColorTwo = GetVehicleColours(Vehicle)
			SetVehicleColours(Vehicle, v, ColorTwo)
		end
		if k == 'color2' then
			local ColorOne, ColorTwo = GetVehicleColours(Vehicle)
			SetVehicleColours(Vehicle, ColorOne, v)
		end
		if k == 'pearlescentColor' then
			local PearlescentColor, WheelColor = GetVehicleExtraColours(Vehicle)
			SetVehicleExtraColours(Vehicle, v, WheelColor)
		end
		if k == 'wheelColor' then
			local PearlescentColor, WheelColor = GetVehicleExtraColours(Vehicle)
			SetVehicleExtraColours(Vehicle, PearlescentColor, v)
		end
		if k == 'wheels' then
			SetVehicleWheelType(Vehicle, v)
		end
		if k == 'windowTint' then
			SetVehicleWindowTint(Vehicle, v)
		end
		if k == 'neonEnabled' then
			SetVehicleNeonLightEnabled(Vehicle, 0, v[1])
			SetVehicleNeonLightEnabled(Vehicle, 1, v[2])
			SetVehicleNeonLightEnabled(Vehicle, 2, v[3])
			SetVehicleNeonLightEnabled(Vehicle, 3, v[4])
		end
		if k == 'neonColor' then
			SetVehicleNeonLightsColour(Vehicle, v[1], v[2], v[3])
		end
		if k == 'modSmokeEnabled' then
			ToggleVehicleMod(Vehicle, 20, true)
		end
		if k == 'tyreSmokeColor' then
			SetVehicleTyreSmokeColor(Vehicle, v[1], v[2], v[3])
		end
		if k == 'modSpoilers' then
			SetVehicleMod(Vehicle, 0, v, false)
		end
		if k == 'modFrontBumper' then
			SetVehicleMod(Vehicle, 1, v, false)
		end
		if k == 'modRearBumper' then
			SetVehicleMod(Vehicle, 2, v, false)
		end
		if k == 'modSideSkirt' then
			SetVehicleMod(Vehicle, 3, v, false)
		end
		if k == 'modExhaust' then
			SetVehicleMod(Vehicle, 4, v, false)
		end
		if k == 'modFrame' then
			SetVehicleMod(Vehicle, 5, v, false)
		end
		if k == 'modGrille' then
			SetVehicleMod(Vehicle, 6, v, false)
		end
		if k == 'modHood' then
			SetVehicleMod(Vehicle, 7, v, false)
		end
		if k == 'modFender' then
			SetVehicleMod(Vehicle, 8, v, false)
		end
		if k == 'modRightFender' then
			SetVehicleMod(Vehicle, 9, v, false)
		end
		if k == 'modRoof' then
			SetVehicleMod(Vehicle, 10, v, false)
		end
		if k == 'modEngine' then
			SetVehicleMod(Vehicle, 11, v, false)
		end
		if k == 'modBrakes' then
			SetVehicleMod(Vehicle, 12, v, false)
		end
		if k == 'modTransmission' then
			SetVehicleMod(Vehicle, 13, v, false)
		end
		if k == 'modHorns' then
			SetVehicleMod(Vehicle, 14, v, false)
		end
		if k == 'modSuspension' then
			SetVehicleMod(Vehicle, 15, v, false)
		end
		if k == 'modArmor' then
			SetVehicleMod(Vehicle, 16, v, false)
		end
		if k == 'modTurbo' then
			ToggleVehicleMod(Vehicle,  18, v)
		end
		if k == 'modXenon' then
			ToggleVehicleMod(Vehicle,  22, v)
		end
		if k == 'modFrontWheels' then
			SetVehicleMod(Vehicle, 23, v, false)
		end
		if k == 'modBackWheels' then
			SetVehicleMod(Vehicle, 24, v, false)
		end
		if k == 'modPlateHolder' then
			SetVehicleMod(Vehicle, 25, v, false)
		end
		if k == 'modVanityPlate' then
			SetVehicleMod(Vehicle, 26, v, false)
		end
		if k == 'modTrimA' then
			SetVehicleMod(Vehicle, 27, v, false)
		end
		if k == 'modOrnaments' then
			SetVehicleMod(Vehicle, 28, v, false)
		end
		if k == 'modDashboard' then
			SetVehicleMod(Vehicle, 29, v, false)
		end
		if k == 'modDial' then
			SetVehicleMod(Vehicle, 30, v, false)
		end
		if k == 'modDoorSpeaker' then
			SetVehicleMod(Vehicle, 31, v, false)
		end
		if k == 'modSeats' then
			SetVehicleMod(Vehicle, 32, v, false)
		end
		if k == 'modSteeringWheel' then
			SetVehicleMod(Vehicle, 33, v, false)
		end
		if k == 'modShifterLeavers' then
			SetVehicleMod(Vehicle, 34, v, false)
		end
		if k == 'modAPlate' then
			SetVehicleMod(Vehicle, 35, v, false)
		end
		if k == 'modSpeakers' then
			SetVehicleMod(Vehicle, 36, v, false)
		end
		if k == 'modTrunk' then
			SetVehicleMod(Vehicle, 37, v, false)
		end
		if k == 'modHydrolic' then
			SetVehicleMod(Vehicle, 38, v, false)
		end
		if k == 'modEngineBlock' then
			SetVehicleMod(Vehicle, 39, v, false)
		end
		if k == 'modAirFilter' then
			SetVehicleMod(Vehicle, 40, v, false)
		end
		if k == 'modStruts' then
			SetVehicleMod(Vehicle, 41, v, false)
		end
		if k == 'modArchCover' then
			SetVehicleMod(Vehicle, 42, v, false)
		end
		if k == 'modAerials' then
			SetVehicleMod(Vehicle, 43, v, false)
		end
		if k == 'modTrimB' then
			SetVehicleMod(Vehicle, 44, v, false)
		end
		if k == 'modTank' then
			SetVehicleMod(Vehicle, 45, v, false)
		end
		if k == 'modWindows' then
			SetVehicleMod(Vehicle, 46, v, false)
		end
		if k == 'modLivery' then
			SetVehicleMod(Vehicle, 48, v, false)
		end
		--if k == 'modCustomTyres' then 
		--	SetVehicleMod(Vehicle, 23, v, true)
		--end
	end
end