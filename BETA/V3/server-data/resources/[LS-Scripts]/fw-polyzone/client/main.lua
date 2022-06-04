local CurrentResourceName = GetCurrentResourceName()
local Config, Players, Types, Entities, Models, Zones, Bones, PlayerData = load(LoadResourceFile(CurrentResourceName, 'config.lua'))()
local playerPed, targetActive, hasFocus, success, PedsReady, AllowTarget, curFlag, sendData = PlayerPedId(), false, false, false, false, true, 30, nil
local comboZone = nil
local DEBUG_ENABLED = false
local insideZone = false
local createdZones = {}
LSCore = exports['fw-base']:GetCoreObject()

-- Zone Creator

local function CreateToComboZone(zone)
    if comboZone ~= nil then
        comboZone:AddZone(zone)
    else
        comboZone = ComboZone:Create({ zone }, { name = 'fw-polyzone' })
        comboZone:onPlayerInOutExhaustive(function(isPointInside, point, insideZones, enteredZones, leftZones)
            if leftZones ~= nil then
                for i = 1, #leftZones do
                    TriggerEvent('framework-polyzone:exit', leftZones[i].name)
                end
            end
            if enteredZones ~= nil then
                for i = 1, #enteredZones do
                    TriggerEvent('framework-polyzone:enter', enteredZones[i].name, enteredZones[i].data, enteredZones[i].center)
                end   
            end
        end, 500)
    end
end

local function doCreateZone(options)
    if options.data and options.data.id then
        local key = options.name .. '_' .. tostring(options.data.id)
        if not createdZones[key] then
            createdZones[key] = true
            return true
        else
            print('polyzone with name/id already added, skipping: ', key)
            return false
        end
    end
    return true
end

local function CreateBoxZone(name, vectors, length, width, options)
    if not options then options = {} end
    options.name = name
    options.debugPoly = DEBUG_ENABLED or options.debugPoly
    if not doCreateZone(options) then return end
    local boxCenter = type(vectors) ~= 'vector3' and vector3(vectors.x, vectors.y, vectors.z) or vectors
    local zone = BoxZone:Create(boxCenter, length, width, options)
    CreateToComboZone(zone)
end

local function CreateCircleZone(name, center, radius, options)
  if not options then options = {} end
  options.name = name
  options.debugPoly = DEBUG_ENABLED or options.debugPoly
  if not doCreateZone(options) then return end
  local circleCenter = type(center) ~= 'vector3' and vector3(center.x, center.y, center.z) or center
  local zone = CircleZone:Create(circleCenter, radius, options)
  CreateToComboZone(zone)
end

local function CreatePolyZone(name, vectors, options)
    if not options then options = {} end
    options.name = name
    options.debugPoly = DEBUG_ENABLED or options.debugPoly
    if not doCreateZone(options) then return end
    local zone = PolyZone:Create(vectors, options)
    CreateToComboZone(zone)
end

exports('CreateBoxZone', CreateBoxZone)
exports('CreateCircleZone', CreateCircleZone)
exports('CreatePolyZone', CreatePolyZone)

-- Target Zone Creator

local Functions = {
	AddCircleZone = function(self, name, center, radius, options, targetoptions)
		Zones[name] = CircleZone:Create(center, radius, options)
		if targetoptions.distance == nil then targetoptions.distance = Config.MaxDistance end
		Zones[name].targetoptions = targetoptions
		local circleZone = CircleZone:Create(center, radius, options)
        CreateToComboZone(circleZone)
	end,

	AddBoxZone = function(self, name, center, length, width, options, targetoptions)
		Zones[name] = BoxZone:Create(center, length, width, options)
		if targetoptions.distance == nil then targetoptions.distance = Config.MaxDistance end
		Zones[name].targetoptions = targetoptions
		local boxzone = BoxZone:Create(center, length, width, options)
        CreateToComboZone(boxzone)
	end,

	AddPolyZone = function(self, name, points, options, targetoptions)
		Zones[name] = PolyZone:Create(points, options)
		if targetoptions.distance == nil then targetoptions.distance = Config.MaxDistance end
		Zones[name].targetoptions = targetoptions
		local polyZone = PolyZone:Create(points, options)
        CreateToComboZone(polyZone)
	end,

	AddComboZone = function(self, zones, options, targetoptions)
		Zones[name] = ComboZone:Create(zones, options)
		if targetoptions.distance == nil then targetoptions.distance = Config.MaxDistance end
		Zones[name].targetoptions = targetoptions
	end,

	AddTargetBone = function(self, bones, parameters)
		local distance, options = parameters.distance or Config.MaxDistance, parameters.options
		if type(bones) == 'table' then
			for _, bone in pairs(bones) do
				if not Bones[bone] then Bones[bone] = {} end
				for k, v in pairs(options) do
					if v.distance == nil or not v.distance or v.distance > distance then v.distance = distance end
					Bones[bone][v.label] = v
				end
			end
		elseif type(bones) == 'string' then
			if not Bones[bones] then Bones[bones] = {} end
			for k, v in pairs(options) do
				if v.distance == nil or not v.distance or v.distance > distance then v.distance = distance end
				Bones[bones][v.label] = v
			end
		end
	end,

	AddTargetEntity = function(self, entities, parameters)
		local distance, options = parameters.distance or Config.MaxDistance, parameters.options
		if type(entities) == 'table' then
			for _, entity in pairs(entities) do
				if entity then
					if not Entities[entity] then Entities[entity] = {} end
					for k, v in pairs(options) do
						if v.distance == nil or not v.distance or v.distance > distance then v.distance = distance end
						Entities[entity][v.label] = v
					end
				end
			end
		elseif type(entities) == 'number' then
			if not Entities[entities] then Entities[entities] = {} end
			for k, v in pairs(options) do
				if v.distance == nil or not v.distance or v.distance > distance then v.distance = distance end
				Entities[entities][v.label] = v
			end
        end
    end,

	AddEntityZone = function(self, name, entity, options, targetoptions)
		Zones[name] = EntityZone:Create(entity, options)
		if targetoptions.distance == nil then targetoptions.distance = Config.MaxDistance end
		Zones[name].targetoptions = targetoptions
	end,

	AddTargetModel = function(self, models, parameters)
		local distance, options = parameters.distance or Config.MaxDistance, parameters.options
		if type(models) == 'table' then
			for _, model in pairs(models) do
				if type(model) == 'string' then model = GetHashKey(model) end
				if not Models[model] then Models[model] = {} end
				for k, v in pairs(options) do
					if v.distance == nil or not v.distance or v.distance > distance then v.distance = distance end
					Models[model][v.label] = v
				end
			end
		else
			if type(models) == 'string' then models = GetHashKey(models) end
			if not Models[models] then Models[models] = {} end
			for k, v in pairs(options) do
				if v.distance == nil or not v.distance or v.distance > distance then v.distance = distance end
				Models[models][v.label] = v
			end
		end
	end,

	RemoveZone = function(self, name)
		if not Zones[name] then return end
		if Zones[name].destroy then
			Zones[name]:destroy()
		end
		Zones[name] = nil
	end,

	RemoveTargetBone = function(self, bones, labels)
		if type(bones) == 'table' then
			for _, bone in pairs(bones) do
				if type(labels) == 'table' then
					for k, v in pairs(labels) do
						if Bones[bone] then
							Bones[bone][v] = nil
						end
					end
				elseif type(labels) == 'string' then
					if Bones[bone] then
						Bones[bone][labels] = nil
					end
				end
			end
		else
			if type(labels) == 'table' then
				for k, v in pairs(labels) do
					if Bones[bones] then
						Bones[bones][v] = nil
					end
				end
			elseif type(labels) == 'string' then
				if Bones[bones] then
					Bones[bones][labels] = nil
				end
			end
		end
	end,

	RemoveTargetModel = function(self, models, labels)
		if type(models) == 'table' then
			for _, model in pairs(models) do
				if type(model) == 'string' then model = GetHashKey(model) end
				if type(labels) == 'table' then
					for k, v in pairs(labels) do
						if Models[model] then
							Models[model][v] = nil
						end
					end
				elseif type(labels) == 'string' then
					if Models[model] then
						Models[model][labels] = nil
					end
				end
			end
		else
			if type(models) == 'string' then models = GetHashKey(models) end
			if type(labels) == 'table' then
				for k, v in pairs(labels) do
					if Models[models] then
						Models[models][v] = nil
					end
				end
			elseif type(labels) == 'string' then
				if Models[models] then
					Models[models][labels] = nil
				end
			end
		end
	end,

	RemoveTargetEntity = function(self, entities, labels)
		if type(entities) == 'table' then
			for _, entity in pairs(entities) do
				if entity then
					if type(labels) == 'table' then
						for k, v in pairs(labels) do
							if Entities[entity] then
								Entities[entity][v] = nil
							end
						end
					elseif type(labels) == 'string' then
						if Entities[entity] then
							Entities[entity][labels] = nil
						end
					end
				end
			end
		elseif type(entities) == 'string' then
			if type(labels) == 'table' then
				for k, v in pairs(labels) do
					if Entities[entities] then
						Entities[entities][v] = nil
					end
				end
			elseif type(labels) == 'string' then
				if Entities[entities] then
					Entities[entities][labels] = nil
				end
			end
		end
	end,

	AddGlobalTypeOptions = function(self, type, parameters)
		local distance, options = parameters.distance or Config.MaxDistance, parameters.options
		for k, v in pairs(options) do
			if v.distance == nil or not v.distance or v.distance > distance then v.distance = distance end
			Types[type][v.label] = v
		end
	end,

	AddGlobalPedOptions = function(self, parameters) self:AddGlobalTypeOptions(1, parameters) end,

	AddGlobalVehicleOptions = function(self, parameters) self:AddGlobalTypeOptions(2, parameters) end,

	AddGlobalObjectOptions = function(self, parameters) self:AddGlobalTypeOptions(3, parameters) end,

	AddGlobalPlayerOptions = function(self, parameters)
		local distance, options = parameters.distance or Config.MaxDistance, parameters.options
		for k, v in pairs(options) do
			if v.distance == nil or not v.distance or v.distance > distance then v.distance = distance end
			Players[v.label] = v
		end
	end,

	RemoveGlobalTypeOptions = function(self, type, labels)
		if type(labels) == 'table' then
			for k, v in pairs(labels) do
				Types[type][v] = nil
			end
		elseif type(labels) == 'string' then
			Types[type][labels] = nil
		end
	end,

	RemoveGlobalPedOptions = function(self, labels) self:RemoveGlobalTypeOptions(1, labels) end,

	RemoveGlobalVehicleOptions = function(self, labels) self:RemoveGlobalTypeOptions(2, labels) end,

	RemoveGlobalObjectOptions = function(self, labels) self:RemoveGlobalTypeOptions(3, labels) end,

	RemoveGlobalPlayerOptions = function(self, labels)
		if type(labels) == 'table' then
			for k, v in pairs(labels) do
				Players[v.label] = nil
			end
		elseif type(labels) == 'string' then
			Players[labels] = nil
		end
	end,

	RaycastCamera = function(self, flag)
		local cam = GetGameplayCamCoord()
		local direction = GetGameplayCamRot()
		direction = vec2(math.rad(direction.x), math.rad(direction.z))
		local num = math.abs(math.cos(direction.x))
		direction = vec3((-math.sin(direction.y) * num), (math.cos(direction.y) * num), math.sin(direction.x))
		local destination = vec3(cam.x + direction.x * 30, cam.y + direction.y * 30, cam.z + direction.z * 30)
		local rayHandle = StartShapeTestLosProbe(cam, destination, flag or -1, playerPed or PlayerPedId(), 0)
		while true do
			local result, datatwo, endCoords, datathree, entityHit = GetShapeTestResult(rayHandle)
			if Config.RaycastDebug then
				local entCoords = GetEntityCoords(playerPed or PlayerPedId())
				DrawLine(entCoords.x, entCoords.y, entCoords.z, destination.x, destination.y, destination.z, 255, 0, 255, 255)
				DrawLine(destination.x, destination.y, destination.z, endCoords.x, endCoords.y, endCoords.z, 255, 0, 255, 255)
			end
			if result ~= 1 then
				local entityType = 0
				if entityHit then entityType = GetEntityType(entityHit) end
				return flag, endCoords, entityHit, entityType
			end
			Wait(2)
		end
	end,

	IsTargetActive = function(self)
		return targetActive
	end,

	IsTargetSuccess = function(self)
		return success
	end,

	GetTargetTypeData = function(self, type, label)
		return Types[type][label]
	end,

	GetTargetZoneData = function(self, name)
		return Zones[name]
	end,

	GetTargetBoneData = function(self, bone, label)
		return Bones[bone][label]
	end,

	GetTargetEntityData = function(self, entity, label)
		return Entities[entity][label]
	end,

	GetTargetModelData = function(self, model, label)
		return Models[model][label]
	end,

	GetTargetPedData = function(self, label)
		return self:GetTargetTypeData(1, label)
	end,

	GetTargetVehicleData = function(self, label)
		return self:GetTargetTypeData(2, label)
	end,

	GetTargetObjectData = function(self, label)
		return self:GetTargetTypeData(3, label)
	end,

	GetTargetPlayerData = function(self, label)
		return Players[label]
	end,

	UpdateTargetTypeData = function(self, type, label, data)
		Types[type][label] = data
	end,

	UpdateTargetZoneData = function(self, name, data)
		Zones[name] = data
	end,

	UpdateTargetBoneData = function(self, bone, label, data)
		Bones[bone][label] = data
	end,

	UpdateTargetEntityData = function(self, entity, label, data)
		Entities[entity][label] = data
	end,

	UpdateTargetModelData = function(self, model, label, data)
		Models[model][label] = data
	end,

	UpdateTargetPedData = function(self, label, data)
		self:UpdateTargetTypeData(1, label, data)
	end,

	UpdateTargetVehicleData = function(self, label, data)
		self:UpdateTargetTypeData(2, label, data)
	end,

	UpdateTargetObjectData = function(self, label, data)
		self:UpdateTargetTypeData(3, label, data)
	end,

	UpdateTargetPlayerData = function(self, label, data)
		Players[label] = data
	end,

	CloneTable = function(self, table)
		local copy = {}
		for k,v in pairs(table) do
			if type(v) == 'table' then
				copy[k] = self:CloneTable(v)
			else
				if type(v) == 'function' then v = nil end
				copy[k] = v
			end
		end
		return copy
	end,

	CheckOptions = function(self, data, entity, distance)
		if (data.distance == nil or distance <= data.distance)
		and (data.job == nil or data.job == PlayerData.job.name or (data.job[PlayerData.job.name] and data.job[PlayerData.job.name] <= PlayerData.job.grade.level))
		and (data.gang == nil or data.gang == PlayerData.gang.name or (data.gang[PlayerData.gang.name] and data.gang[PlayerData.gang.name] <= PlayerData.gang.grade.level))
		and (data.item == nil or data.item and self:ItemCount(data.item) > 0)
		and (data.canInteract == nil or data.canInteract(entity, distance, data)) then return true
		end
		return false
	end,

	switch = function(self)
		if curFlag == 30 then curFlag = -1 else curFlag = 30 end
		return curFlag
	end,

	EnableTarget = function(self)
		if not AllowTarget or success or not isLoggedIn then return end
		if not targetActive then
			targetActive = true
			SendNUIMessage({response = "openTarget"})
			CreateThread(function()
				repeat
					SetPauseMenuActive(false)
					if hasFocus then
						DisableControlAction(0, 1, true)
						DisableControlAction(0, 2, true)
					end
					DisablePlayerFiring(PlayerId(), true)
					DisableControlAction(0, 24, true)
					DisableControlAction(0, 25, true)
					DisableControlAction(0, 37, true)
					DisableControlAction(0, 47, true)
					DisableControlAction(0, 58, true)
					DisableControlAction(0, 140, true)
					DisableControlAction(0, 141, true)
					DisableControlAction(0, 142, true)
					DisableControlAction(0, 143, true)
					DisableControlAction(0, 257, true)
					DisableControlAction(0, 263, true)
					DisableControlAction(0, 264, true)
					Wait(3)
				until not targetActive
			end)
			playerPed = PlayerPedId()

			PlayerData = LSCore.Functions.GetPlayerData()

			while targetActive do
				local sleep = 10
				local plyCoords = GetEntityCoords(playerPed)
				local hit, coords, entity, entityType = self:RaycastCamera(self:switch())
				if entityType > 0 then

					-- Entity targets
					local data = Entities[entity]
					if data ~= nil then
						self:CheckEntity(hit, data, entity, #(plyCoords - coords))
					end

					-- Player and Ped targets
					if entityType == 1 then
						local data = Models[GetEntityModel(entity)]
						if IsPedAPlayer(entity) then data = Players end
						if data ~= nil then
							self:CheckEntity(hit, data, entity, #(plyCoords - coords))
						end

					-- Vehicle bones
					elseif entityType == 2 then
						local min, max = GetModelDimensions(GetEntityModel(entity))
						local closestBone, closestPos, closestBoneName = self:CheckBones(coords, entity, min, max, Config.VehicleBones)
						local datatable = Bones[closestBoneName]
						if closestBone then
							local send_options, send_distance, slot = {}, {}, 0
							for o, data in pairs(datatable) do
								if self:CheckOptions(data, entity, #(plyCoords - coords)) then
									slot = #send_options + 1
									send_options[slot] = data
									send_options[slot].entity = entity
									send_distance[data.distance] = true
								else send_distance[data.distance] = false end
							end
							sendData = send_options
							if next(send_options) then
								success = true
								SendNUIMessage({response = "foundTarget", data = sendData[slot].targeticon})
								self:DrawOutlineEntity(entity, true)
								while targetActive and success do
									local _, coords, entity2 = self:RaycastCamera(hit)
									if hit and entity == entity2 then
										local playerCoords = GetEntityCoords(playerPed)
										local closestBone2, closestPos2, closestBoneName2 = self:CheckBones(coords, entity, min, max, Config.VehicleBones)
										local dist = #(playerCoords - coords)

										if closestBone ~= closestBone2 then
											if IsControlReleased(0, 47) or IsDisabledControlReleased(0, 47) then
												self:DisableTarget(true)
											else
												self:LeftTarget()
											end
											self:DrawOutlineEntity(entity, false)
											break
										elseif not hasFocus and (IsControlPressed(0, 238) or IsDisabledControlPressed(0, 238)) then
											self:EnableNUI(self:CloneTable(sendData))
											self:DrawOutlineEntity(entity, false)
										else
											for k, v in pairs(send_distance) do
												if v and dist > k then
													if IsControlReleased(0, 47) or IsDisabledControlReleased(0, 47) then
														self:DisableTarget(true)
													else
														self:LeftTarget()
													end
													self:DrawOutlineEntity(entity, false)
													break
												end
											end
										end
									else
										if IsControlReleased(0, 47) or IsDisabledControlReleased(0, 47) then
											self:DisableTarget(true)
										else
											self:LeftTarget()
										end
										self:DrawOutlineEntity(entity, false)
										break
									end
									Wait(5)
								end
								if IsControlReleased(0, 47) or IsDisabledControlReleased(0, 47) then
									self:DisableTarget(true)
								else
									self:LeftTarget()
								end
								self:DrawOutlineEntity(entity, false)
							end
						end

						-- Specific Vehicle targets
						local data = Models[GetEntityModel(entity)]
						if data ~= nil then
							self:CheckEntity(hit, data, entity, #(plyCoords - coords))
						end

					-- Entity targets
					elseif entityType > 2 then
						local data = Models[GetEntityModel(entity)]
						if data ~= nil then
							self:CheckEntity(hit, data, entity, #(plyCoords - coords))
						end
					end

					-- Generic targets
					if not success then
						local data = Types[entityType]
						if data ~= nil then
							self:CheckEntity(hit, data, entity, #(plyCoords - coords))
						end
					end
				end
				if not success then
					-- Zone targets
					for _, zone in pairs(Zones) do
						local distance = #(plyCoords - zone.center)
						if zone:isPointInside(coords) and distance <= zone.targetoptions.distance then
							local send_options, slot = {}, 0
							for o, data in pairs(zone.targetoptions.options) do
								if self:CheckOptions(data, entity, distance) then
									slot = #send_options + 1
									send_options[slot] = data
									send_options[slot].entity = entity
								end
							end
							TriggerEvent(CurrentResourceName..':client:enterPolyZone', send_options[slot])
							TriggerServerEvent(CurrentResourceName..':server:enterPolyZone', send_options[slot])
							sendData = send_options
							if next(send_options) then
								success = true
								SendNUIMessage({response = "foundTarget", data = sendData[slot].targeticon})
								self:DrawOutlineEntity(entity, true)
								while targetActive and success do
									local playerCoords = GetEntityCoords(playerPed)
									local _, endcoords, entity2 = self:RaycastCamera(hit)
									if not zone:isPointInside(endcoords) then
										if IsControlReleased(0, 47) or IsDisabledControlReleased(0, 47) then
											self:DisableTarget(true)
										else
											self:LeftTarget()
										end
										self:DrawOutlineEntity(entity, false)
									elseif not hasFocus and (IsControlPressed(0, 238) or IsDisabledControlPressed(0, 238)) then
										self:EnableNUI(self:CloneTable(sendData))
										self:DrawOutlineEntity(entity, false)
									elseif #(playerCoords - zone.center) > zone.targetoptions.distance then
										if IsControlReleased(0, 47) or IsDisabledControlReleased(0, 47) then
											self:DisableTarget(true)
										else
											self:LeftTarget()
										end
										self:DrawOutlineEntity(entity, false)
									end
									Wait(5)
								end
								if IsControlReleased(0, 47) or IsDisabledControlReleased(0, 47) then
									self:DisableTarget(true)
								else
									self:LeftTarget()
								end
								TriggerEvent(CurrentResourceName..':client:exitPolyZone', send_options[slot])
								TriggerServerEvent(CurrentResourceName..':server:exitPolyZone', send_options[slot])
								self:DrawOutlineEntity(entity, false)
							end
						end
					end
				end
				Wait(sleep)
			end
			self:DisableTarget(false)
		end
	end,

	EnableNUI = function(self, options)
		if targetActive and not hasFocus then
			SetCursorLocation(0.5, 0.5)
			SetNuiFocus(true, true)
			SetNuiFocusKeepInput(true)
			hasFocus = true
			SendNUIMessage({response = "validTarget", data = options})
		end
	end,

	DisableNUI = function(self)
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
		hasFocus = false
	end,

	LeftTarget = function(self)
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
		success, hasFocus = false, false
		SendNUIMessage({response = "leftTarget"})
	end,

	DisableTarget = function(self, forcedisable)
		if (targetActive and not hasFocus) or forcedisable then
			SetNuiFocus(false, false)
			SetNuiFocusKeepInput(false)
			Wait(100)
			targetActive, success, hasFocus = false, false, false
			SendNUIMessage({response = "closeTarget"})
		end
	end,

	ItemCount = function(self, item)
		for k, v in pairs(PlayerData.items) do
			if v.name == item then
				return v.amount
			end
		end
		return 0
	end,

	DrawOutlineEntity = function(self, entity, bool)
		if Config.EnableOutline then
			if not IsEntityAPed(entity) then
				SetEntityDrawOutline(entity, bool)
			end
		end
	end,

	CheckEntity = function(self, hit, datatable, entity, distance)
		local send_options, send_distance, slot = {}, {}, 0
		for o, data in pairs(datatable) do
			if self:CheckOptions(data, entity, distance) then
				slot = #send_options + 1
				send_options[slot] = data
				send_options[slot].entity = entity
				send_distance[data.distance] = true
			else send_distance[data.distance] = false end
		end
		sendData = send_options
		if next(send_options) then
			success = true
			SendNUIMessage({response = "foundTarget", data = sendData[slot].targeticon})
			self:DrawOutlineEntity(entity, true)
			while targetActive and success do
				local playerCoords = GetEntityCoords(playerPed)
				local _, coords, entity2 = self:RaycastCamera(hit)
				local dist = #(playerCoords - coords)
				if entity ~= entity2 then
					if IsControlReleased(0, 47) or IsDisabledControlReleased(0, 47) then
						self:DisableTarget(true)
					else
						self:LeftTarget()
					end
					self:DrawOutlineEntity(entity, false)
					break
				elseif not hasFocus and (IsControlPressed(0, 238) or IsDisabledControlPressed(0, 238)) then
					self:EnableNUI(self:CloneTable(sendData))
					self:DrawOutlineEntity(entity, false)
				else
					for k, v in pairs(send_distance) do
						if v and dist > k then
							if IsControlReleased(0, 47) or IsDisabledControlReleased(0, 47) then
								self:DisableTarget(true)
							else
								self:LeftTarget()
							end
							self:DrawOutlineEntity(entity, false)
							break
						end
					end
				end
				Wait(5)
			end
			if IsControlReleased(0, 47) or IsDisabledControlReleased(0, 47) then
				self:DisableTarget(true)
			else
				self:LeftTarget()
			end
			self:DrawOutlineEntity(entity, false)
		end
	end,

	CheckBones = function(self, coords, entity, min, max, bonelist)
		local closestBone, closestDistance, closestPos, closestBoneName = -1, 20
		for k, v in pairs(bonelist) do
			if Bones[v] then
				local boneId = GetEntityBoneIndexByName(entity, v)
				local bonePos = GetWorldPositionOfEntityBone(entity, boneId)
				local distance = #(coords - bonePos)
				if closestBone == -1 or distance < closestDistance then
					closestBone, closestDistance, closestPos, closestBoneName = boneId, distance, bonePos, v
				end
			end
		end
		if closestBone ~= -1 then return closestBone, closestPos, closestBoneName
		else return false end
	end,

	AllowTargeting = function(self, bool)
		AllowTarget = bool
	end,

	SpawnPeds = function(self)
		if not PedsReady then
			if next(Config.Peds) then
				for k, v in pairs(Config.Peds) do
					local spawnedped = 0
					local networked = v.networked or false
					RequestModel(v.model)
					while not HasModelLoaded(v.model) do
						Wait(1)
					end

					if type(v.model) == 'string' then v.model = GetHashKey(v.model) end

					if v.minusOne then
						spawnedped = CreatePed(0, v.model, v.coords.x, v.coords.y, v.coords.z - 1.0, v.coords.w, networked, true)
					else
						spawnedped = CreatePed(0, v.model, v.coords.x, v.coords.y, v.coords.z, v.coords.w, networked, true)
					end

					if v.freeze then
						FreezeEntityPosition(spawnedped, true)
					end

					if v.invincible then
						SetEntityInvincible(spawnedped, true)
					end

					if v.blockevents then
						SetBlockingOfNonTemporaryEvents(spawnedped, true)
					end

					if v.animDict and v.anim then
						RequestAnimDict(v.animDict)
						while not HasAnimDictLoaded(v.animDict) do
							Wait(1)
						end

						TaskPlayAnim(spawnedped, v.animDict, v.anim, 8.0, 0, -1, v.flag or 1, 0, 0, 0, 0)
					end

					if v.scenario then
						TaskStartScenarioInPlace(spawnedped, v.scenario, 0, true)
					end

					if v.target then
						self:AddTargetModel(v.model, {
							options = v.target.options,
							distance = v.target.distance
						})
					end

					Config.Peds[k].currentpednumber = spawnedped
				end
				PedsReady = true
			end
		end
	end,

	DeletePeds = function(self)
		if PedsReady then
			if next(Config.Peds) then
				for k, v in pairs(Config.Peds) do
					DeletePed(v.currentpednumber)
					Config.Peds[k].currentpednumber = 0
				end
				PedsReady = false
			end
		end
	end,

	GetPeds = function(self)
		return Config.Peds
	end,

	UpdatePedsData = function(self, index, data)
		Config.Peds[index] = data
	end,

	SpawnPed = function(self, data)
		local spawnedped = 0
		if type(data[2]) == 'table' then
			for k, v in pairs(data) do
				local networked = v.networked or false
				RequestModel(v.model)
				while not HasModelLoaded(v.model) do
					Wait(50)
				end

				if type(v.model) == 'string' then v.model = GetHashKey(v.model) end

				if v.minusOne then
					spawnedped = CreatePed(0, v.model, v.coords.x, v.coords.y, v.coords.z - 1.0, v.coords.w, networked, true)
				else
					spawnedped = CreatePed(0, v.model, v.coords.x, v.coords.y, v.coords.z, v.coords.w, networked, true)
				end

				if v.freeze then
					FreezeEntityPosition(spawnedped, true)
				end

				if v.invincible then
					SetEntityInvincible(spawnedped, true)
				end

				if v.blockevents then
					SetBlockingOfNonTemporaryEvents(spawnedped, true)
				end

				if v.animDict and v.anim then
					RequestAnimDict(v.animDict)
					while not HasAnimDictLoaded(v.animDict) do
						Wait(50)
					end

					TaskPlayAnim(spawnedped, v.animDict, v.anim, 8.0, 0, -1, v.flag or 1, 0, 0, 0, 0)
				end

				if v.scenario then
					TaskStartScenarioInPlace(spawnedped, v.scenario, 0, true)
				end

				if v.target then
					self:AddTargetModel(v.model, {
						options = v.target.options,
						distance = v.target.distance
					})
				end
				v.currentpednumber = spawnedped

				local nextnumber = #Config.Peds + 1
				if nextnumber <= 0 then
					nextnumber = 1
				end

				Config.Peds[nextnumber] = v
			end
		else
			if type(data[1]) == 'table' then
				if Config.Debug then
					print('Wrong table format for spawn ped export')
				end
				return
			end
			local networked = data.networked or false
			RequestModel(data.model)
			while not HasModelLoaded(data.model) do
				Wait(50)
			end

			if type(data.model) == 'string' then data.model = GetHashKey(data.model) end

			if data.minusOne then
				spawnedped = CreatePed(0, data.model, data.coords.x, data.coords.y, data.coords.z - 1.0, data.coords.w, networked, true)
			else
				spawnedped = CreatePed(0, data.model, data.coords.x, data.coords.y, data.coords.z, data.coords.w, networked, true)
			end

			if data.freeze then
				FreezeEntityPosition(spawnedped, true)
			end

			if data.invincible then
				SetEntityInvincible(spawnedped, true)
			end

			if data.blockevents then
				SetBlockingOfNonTemporaryEvents(spawnedped, true)
			end

			if data.animDict and data.anim then
				RequestAnimDict(data.animDict)
				while not HasAnimDictLoaded(data.animDict) do
					Wait(50)
				end

				TaskPlayAnim(spawnedped, data.animDict, data.anim, 8.0, 0, -1, data.flag or 1, 0, 0, 0, 0)
			end

			if data.scenario then
				TaskStartScenarioInPlace(spawnedped, data.scenario, 0, true)
			end

			if data.target then
				self:AddTargetModel(data.model, {
					options = data.target.options,
					distance = data.target.distance
				})
			end

			data.currentpednumber = spawnedped

			local nextnumber = #Config.Peds + 1
			if nextnumber <= 0 then
				nextnumber = 1
			end

			Config.Peds[nextnumber] = data
		end
	end,
}

-- Exports
exports("AddCircleZone", function(name, center, radius, options, targetoptions)
    Functions:AddCircleZone(name, center, radius, options, targetoptions)
end)

exports("AddBoxZone", function(name, center, length, width, options, targetoptions)
    Functions:AddBoxZone(name, center, length, width, options, targetoptions)
end)

exports("AddPolyZone", function(name, points, options, targetoptions)
    Functions:AddPolyZone(name, points, options, targetoptions)
end)

exports("AddComboZone", function(zones, options, targetoptions)
	Functions:AddComboZone(zones, options, targetoptions)
end)

exports("AddTargetBone", function(bones, parameters)
    Functions:AddTargetBone(bones, parameters)
end)

exports("AddTargetEntity", function(entity, parameters)
    Functions:AddTargetEntity(entity, parameters)
end)

exports("AddEntityZone", function(name, entity, options, targetoptions)
    Functions:AddEntityZone(name, entity, options, targetoptions)
end)

exports("AddTargetModel", function(models, parameters)
    Functions:AddTargetModel(models, parameters)
end)

exports("RemoveZone", function(name)
    Functions:RemoveZone(name)
end)

exports("RemoveTargetModel", function(models, labels)
    Functions:RemoveTargetModel(models, labels)
end)

exports("RemoveTargetEntity", function(entity, labels)
    Functions:RemoveTargetEntity(entity, labels)
end)

exports("AddType", function(type, parameters)
	Functions:AddGlobalTypeOptions(type, parameters)
end)

exports("AddPed", function(parameters)
    Functions:AddGlobalPedOptions(parameters)
end)

exports("AddVehicle", function(parameters)
    Functions:AddGlobalVehicleOptions(parameters)
end)

exports("AddObject", function(parameters)
    Functions:AddGlobalObjectOptions(parameters)
end)

exports("AddPlayer", function(parameters)
    Functions:AddGlobalPlayerOptions(parameters)
end)

exports("RemoveType", function(type, labels)
	Functions:RemoveGlobalTypeOptions(type, labels)
end)

exports("RemovePed", function(labels)
    Functions:RemoveGlobalPedOptions(labels)
end)

exports("RemoveVehicle", function(labels)
    Functions:RemoveGlobalVehicleOptions(labels)
end)

exports("RemoveObject", function(labels)
    Functions:RemoveGlobalObjectOptions(labels)
end)

exports("RemovePlayer", function(labels)
    Functions:RemoveGlobalPlayerOptions(labels)
end)

exports("IsTargetActive", function()
	return Functions:IsTargetActive()
end)

exports("IsTargetSuccess", function()
	return Functions:IsTargetSuccess()
end)

exports("GetTargetTypeData", function(type, label)
	return Functions:GetTargetTypeData(type, label)
end)

exports("GetTargetZoneData", function(name)
	return Functions:GetTargetZoneData(name)
end)

exports("GetTargetBoneData", function(bone)
	return Functions:GetTargetBoneData(bone)
end)

exports("GetTargetEntityData", function(entity, label)
	return Functions:GetTargetEntityData(entity, label)
end)

exports("GetTargetModelData", function(model, label)
	return Functions:GetTargetModelData(model, label)
end)

exports("GetTargetPedData", function(label)
	return Functions:GetTargetPedData(label)
end)

exports("GetTargetVehicleData", function(label)
	return Functions:GetTargetVehicleData(label)
end)

exports("GetTargetObjectData", function(label)
	return Functions:GetTargetObjectData(label)
end)

exports("GetTargetPlayerData", function(label)
	return Functions:GetTargetPlayerData(label)
end)

exports("UpdateTargetZoneData", function(name, data)
	Functions:UpdateTargetZoneData(name, data)
end)

exports("UpdateTargetBoneData", function(bone, label, data)
	Functions:UpdateTargetBoneData(bone, label, data)
end)

exports("UpdateTargetEntityData", function(entity, label, data)
	Functions:UpdateTargetEntityData(entity, label, data)
end)

exports("UpdateTargetModelData", function(model, label, data)
	Functions:UpdateTargetModelData(model, label, data)
end)

exports("UpdateTargetPedData", function(label, data)
	Functions:UpdateTargetPedData(label, data)
end)

exports("UpdateTargetVehicleData", function(label, data)
	Functions:UpdateTargetVehicleData(label, data)
end)

exports("UpdateTargetObjectData", function(label, data)
	Functions:UpdateTargetObjectData(label, data)
end)

exports("UpdateTargetPlayerData", function(label, data)
	Functions:UpdateTargetPlayerData(label, data)
end)

exports("SpawnPed", function(spawntable)
	Functions:SpawnPed(spawntable)
end)

exports("GetPeds", function()
	return Functions:GetPeds()
end)

exports("UpdatePedsData", function(index, data)
	Functions:UpdatePedsData(index, data)
end)

exports("AllowTargeting", function(bool)
	Functions:AllowTargeting(bool)
end)

exports("FetchFunctions", function()
    return Functions
end)

-- NUI Callbacks
RegisterNUICallback('selectTarget', function(option, cb)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
	Wait(100)
	targetActive, success, hasFocus = false, false, false
    local data = sendData[option]
    CreateThread(function()
        Wait(50)
        if data.action then
            data.action(data.entity)
        elseif data.event then
            if data.type == "client" then
                TriggerEvent(data.event, data)
            elseif data.type == "server" then
                TriggerServerEvent(data.event, data)
            elseif data.type == "command" then
                ExecuteCommand(data.event)
            elseif data.type == "xzcommand" then
                TriggerServerEvent('LSCore:CallCommand', data.event, data)
            else
                TriggerEvent(data.event, data)
            end
        else
            if Config.Debug then
            	print("No trigger setup")
            end
        end
    end)

    sendData = nil
end)

RegisterNUICallback('closeTarget', function(data, cb)
	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
	Wait(100)
	targetActive, success, hasFocus = false, false, false
end)

-- Startup thread
CreateThread(function()
    RegisterCommand('+playerTarget', function()
		Functions:EnableTarget()
	end, false)
    RegisterCommand('-playerTarget', function()
		Functions:DisableTarget(false)
	end, false)
    RegisterKeyMapping("+playerTarget", "Enable targeting~", "keyboard", "G")
    TriggerEvent("chat:removeSuggestion", "/+playerTarget")
    TriggerEvent("chat:removeSuggestion", "/-playerTarget")

    if next(Config.CircleZones) then
        for k, v in pairs(Config.CircleZones) do
            Functions:AddCircleZone(v.name, v.coords, v.radius, {
                name = v.name,
                debugPoly = v.debugPoly,
            }, {
                options = v.options,
                distance = v.distance
            })
        end
    end

    if next(Config.BoxZones) then
        for k, v in pairs(Config.BoxZones) do
            Functions:AddBoxZone(v.name, v.coords, v.length, v.width, {
                name = v.name,
                heading = v.heading,
                debugPoly = v.debugPoly,
                minZ = v.minZ,
                maxZ = v.maxZ
            }, {
                options = v.options,
                distance = v.distance
            })
        end
    end

    if next(Config.PolyZones) then
        for k, v in pairs(Config.PolyZones) do
            Functions:AddPolyZone(v.name, v.points, {
                name = v.name,
                debugPoly = v.debugPoly,
                minZ = v.minZ,
                maxZ = v.maxZ
            }, {
                options = v.options,
                distance = v.distance
            })
        end
    end

    if next(Config.TargetBones) then
        for k, v in pairs(Config.TargetBones) do
            Functions:AddTargetBone(v.bones, {
                options = v.options,
                distance = v.distance
            })
        end
    end

    if next(Config.TargetEntities) then
        for k, v in pairs(Config.TargetEntities) do
            Functions:AddTargetEntity(v.entity, {
                options = v.options,
                distance = v.distance
            })
        end
    end

    if next(Config.EntityZones) then
        for k, v in pairs(Config.EntityZones) do
            Functions:AddEntityZone(v.name, v.entity, {
                name = v.name,
                heading = v.heading,
                debugPoly = v.debugPoly,
            }, {
                options = v.options,
                distance = v.distance,
            })
        end
    end

    if next(Config.TargetModels) then
        for k, v in pairs(Config.TargetModels) do
            Functions:AddTargetModel(v.models, {
                options = v.options,
                distance = v.distance
            })
        end
    end

    if next(Config.GlobalPedOptions) then
        Functions:AddGlobalPedOptions(Config.GlobalPedOptions)
    end

    if next(Config.GlobalVehicleOptions) then
        Functions:AddGlobalVehicleOptions(Config.GlobalVehicleOptions)
    end

    if next(Config.GlobalObjectOptions) then
        Functions:AddGlobalObjectOptions(Config.GlobalObjectOptions)
    end

    if next(Config.GlobalPlayerOptions) then
        Functions:AddGlobalPlayerOptions(Config.GlobalPlayerOptions)
    end
end)

-- Events

-- This makes sure that only when you are logged in that you can access the target
RegisterNetEvent('LSCore:Client:OnPlayerLoaded', function()
	PlayerData = LSCore.Functions.GetPlayerData()
	isLoggedIn = true
	Functions:SpawnPeds()
end)

-- This will make sure everything resets and the player can't access the target when they are logged out
RegisterNetEvent('LSCore:Client:OnPlayerUnload', function()
	isLoggedIn = false
	PlayerData = {}
	Functions:DeletePeds()
end)

-- This will update the job when a new job has been assigned to a player
RegisterNetEvent('LSCore:Client:OnJobUpdate', function(JobInfo)
	PlayerData.job = JobInfo
end)

-- Updates the PlayerData to make sure it doesn't 'stay behind'
RegisterNetEvent('LSCore:Client:SetPlayerData', function(val)
	PlayerData = val
end)

-- This is to make sure you can restart the resource manually without having to log-out.
AddEventHandler('onResourceStart', function(resource)
	if resource == CurrentResourceName then
		PlayerData = LSCore.Functions.GetPlayerData()
		isLoggedIn = true
		Functions:SpawnPeds()
	end
end)

-- Debug Options

if Config.Debug then

	RegisterNetEvent('framework-polyzone:debug', function()
		DEBUG_ENABLED = not DEBUG_ENABLED
		while DEBUG_ENABLED do
			comboZone:draw()
			Wait(0)
		end
	end)

	-- will make the polyzone resource draw walls where your zone is

    RegisterCommand('comboinfo',function()
        comboZone:printInfo()
    end)

    -- lists info about your combozone such as the name and amount of zones currently created
    if Config.RemoveZonesOnStop then
        AddEventHandler('onResourceStop', function(resourceName)
            if (GetCurrentResourceName() ~= resourceName) then
				Functions:DeletePeds()
                return
            end
            print(resourceName.." destroyed its zones on resource stop!")
            comboZone:destroy()
        end)
        -- this just prevents zones from staying if the resource is restarted. This can be disabled in the config!
    end
end

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(4)
-- 		SetPlayerLockon(PlayerId(), false)
-- 	end
-- end)