LSCore.Functions = {}

LSCore.Functions.ExecuteSql = function(wait, query, cb)
	local rtndata = {}
	local waiting = true
	exports['ghmattimysql']:execute(query, {}, function(data)
		if cb ~= nil and wait == false then
			cb(data)
		end
		rtndata = data
		waiting = false
	end)
	if wait then
		while waiting do
			Citizen.Wait(5)
		end
		if cb ~= nil and wait == true then
			cb(rtndata)
		end
	end
	return rtndata
end

LSCore.Functions.GetIdentifier = function(source, idtype)
	local idtype = idtype ~=nil and idtype or Config.IdentifierType
	for _, identifier in pairs(GetPlayerIdentifiers(source)) do
		if string.find(identifier, idtype) then
			return identifier
		end
	end
	return nil
end

LSCore.Functions.GetSource = function(identifier)
	for src, player in pairs(LSCore.Players) do
		local idens = GetPlayerIdentifiers(src)
		for _, id in pairs(idens) do
			if identifier == id then
				return src
			end
		end
	end
	return 0
end

LSCore.Functions.GetPlayer = function(source)
	if type(source) == "number" then
		return LSCore.Players[source]
	else
		return LSCore.Players[LSCore.Functions.GetSource(source)]
	end
end

LSCore.Functions.GetPlayerByCitizenId = function(citizenid)
	for src, player in pairs(LSCore.Players) do
		local cid = citizenid
		if LSCore.Players[src].PlayerData.citizenid == cid then
			return LSCore.Players[src]
		end
	end
	return nil
end

LSCore.Functions.GetPlayerByPhone = function(number)
	for src, player in pairs(LSCore.Players) do
		local cid = citizenid
		if LSCore.Players[src].PlayerData.charinfo.phone == number then
			return LSCore.Players[src]
		end
	end
	return nil
end

LSCore.Functions.GetPlayerCharName = function(CitizenId)
	local ReturnValue = nil
	LSCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..CitizenId.."'", function(result)
		if result[1] ~= nil then
			local CharData = json.decode(result[1].charinfo)
			ReturnValue = CharData.firstname..' '..CharData.lastname
		else
			ReturnValue = nil
		end
	end)
	return ReturnValue
end

LSCore.Functions.GetAddictionLevel = function(Source, Type)
	local Player = LSCore.Functions.GetPlayer(Source)
	if Player.PlayerData.addiction[Type] >= 10 then
		return 1
	elseif Player.PlayerData.addiction[Type] >= 20 then
		return 2
	elseif Player.PlayerData.addiction[Type] >= 30 then
		return 3
	elseif Player.PlayerData.addiction[Type] >= 40 then
		return 4
	end
end

LSCore.Functions.GetPlayers = function()
	local sources = {}
	for k, v in pairs(LSCore.Players) do
		table.insert(sources, k)
	end
	return sources
end

LSCore.Functions.CreateCallback = function(name, cb)
	LSCore.ServerCallbacks[name] = cb
end

LSCore.Functions.TriggerCallback = function(name, source, cb, ...)
	if LSCore.ServerCallbacks[name] ~= nil then
		LSCore.ServerCallbacks[name](source, cb, ...)
	end
end

LSCore.Functions.CreateUseableItem = function(item, cb)
	LSCore.UseableItems[item] = cb
end

LSCore.Functions.CanUseItem = function(item)
	return LSCore.UseableItems[item] ~= nil
end

LSCore.Functions.UseItem = function(source, item)
	LSCore.UseableItems[item.name](source, item)
end

LSCore.Functions.Kick = function(source, reason, setKickReason, deferrals)
	local src = source
	reason = "\n"..reason.."\n🔸 Kijk op onze discord voor meer informatie!"
	if(setKickReason ~=nil) then
		setKickReason(reason)
	end
	Citizen.CreateThread(function()
		if(deferrals ~= nil)then
			deferrals.update(reason)
			Citizen.Wait(2500)
		end
		if src ~= nil then
			DropPlayer(src, reason)
		end
		local i = 0
		while (i <= 4) do
			i = i + 1
			while true do
				if src ~= nil then
					if(GetPlayerPing(src) >= 0) then
						break
					end
					Citizen.Wait(100)
					Citizen.CreateThread(function() 
						DropPlayer(src, reason)
					end)
				end
			end
			Citizen.Wait(5000)
		end
	end)
end

LSCore.Functions.AddPermission = function(source, permission)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		LSCore.Config.Server.PermissionList[GetPlayerIdentifiers(source)[1]] = {
			steam = GetPlayerIdentifiers(source)[1],
			license = GetPlayerIdentifiers(source)[2],
			permission = permission:lower(),
		}
		LSCore.Functions.ExecuteSql(true, "UPDATE `server_extra` SET permission='"..permission:lower().."' WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		Player.Functions.UpdatePlayerData()
	end
end

LSCore.Functions.RemovePermission = function(source)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		LSCore.Config.Server.PermissionList[GetPlayerIdentifiers(source)[1]] = nil
		LSCore.Functions.ExecuteSql(true, "UPDATE `server_extra` SET permission='user' WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		Player.Functions.UpdatePlayerData()
	end
end

LSCore.Functions.HasPermission = function(source, permission)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	local permission = tostring(permission:lower())
	if permission == "user" then
		retval = true
	else
		if LSCore.Config.Server.PermissionList[steamid] ~= nil then 
			if LSCore.Config.Server.PermissionList[steamid].steam == steamid and LSCore.Config.Server.PermissionList[steamid].license == licenseid then
				if LSCore.Config.Server.PermissionList[steamid].permission == permission or LSCore.Config.Server.PermissionList[steamid].permission == "god" then
					retval = true
				end
			end
		end
	end
	return retval
end

LSCore.Functions.GetPermission = function(source)
	local retval = "user"
	Player = LSCore.Functions.GetPlayer(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	if Player ~= nil then
		if LSCore.Config.Server.PermissionList[Player.PlayerData.steam] ~= nil then 
			if LSCore.Config.Server.PermissionList[Player.PlayerData.steam].steam == steamid and LSCore.Config.Server.PermissionList[Player.PlayerData.steam].license == licenseid then
				retval = LSCore.Config.Server.PermissionList[Player.PlayerData.steam].permission
			end
		end
	end
	return retval
end

LSCore.Functions.IsOptin = function(source)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	if LSCore.Functions.HasPermission(source, "admin") then
		retval = LSCore.Config.Server.PermissionList[steamid].optin
	end
	return retval
end

LSCore.Functions.ToggleOptin = function(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	if LSCore.Functions.HasPermission(source, "admin") then
		LSCore.Config.Server.PermissionList[steamid].optin = not LSCore.Config.Server.PermissionList[steamid].optin
	end
end

LSCore.Functions.RefreshPerms = function()
 	LSCore.Config.Server.PermissionList = {}
 	LSCore.Functions.ExecuteSql(true, "SELECT * FROM `server_extra`", function(result)
 		if result[1] ~= nil then
 			for k, v in pairs(result) do
 				 LSCore.Config.Server.PermissionList[v.steam] = {
 					 steam = v.steam,
 					 license = v.license,
 					 permission = v.permission,
 					 optin = true,
 				 }
 			end
 	  	end
 	end)
end

LSCore.Functions.IsPlayerBanned = function(source)
	local Source, IsBanned, Message = source, nil, nil
	LSCore.Functions.ExecuteSql(true, "SELECT * FROM `server_bans` WHERE `steam` = '"..GetPlayerIdentifiers(Source)[1].."' OR `license` = '"..GetPlayerIdentifiers(Source)[2].."'", function(result)
		if result ~= nil and result[1] ~= nil then
			Message = "\n🔰 Je bent verbannen van de server. \n🛑 Reden: " ..result[1].reason.. '\n🛑 Verbannen Door: ' ..result[1].bannedby.. '\n\n Voor een unban kan je een ticket openen in de discord.'
			IsBanned = true
		else
			IsBanned = false
		end
	end)
	return IsBanned, Message
end

LSCore.Functions.SpawnVehicle = function(Source, SendModel, SpawnCoords, IsAdmin, Plate)
	local CreateAutoMobile = GetHashKey("CREATE_AUTOMOBILE")
    local Model = (type(SendModel) == "number" and SendModel or GetHashKey(SendModel))
    local Coords = SpawnCoords ~= nil and SpawnCoords or GetEntityCoords(GetPlayerPed(Source))
	local Heading = SpawnCoords ~= nil and SpawnCoords.a ~= nil and SpawnCoords.a or GetEntityHeading(GetPlayerPed(Source))
    local Vehicle = Citizen.InvokeNative(CreateAutoMobile, Model, Coords.x, Coords.y, Coords.z, Heading);
    while not DoesEntityExist(Vehicle) do
        Citizen.Wait(1)
    end
	if Plate ~= nil and Plate ~= false then
		SetVehicleNumberPlateText(Vehicle, Plate)
		TriggerClientEvent('LSCore:client:set:vehicle:plate', Source, NetworkGetNetworkIdFromEntity(Vehicle), Plate)
	end
	if IsAdmin then
		TriggerClientEvent('LSCore:client:spawn:vehicle', Source, NetworkGetNetworkIdFromEntity(Vehicle), SendModel)
		return;
	else
		TriggerClientEvent('LSCore:client:add:vehicle:properties', Source, NetworkGetNetworkIdFromEntity(Vehicle))
		return NetworkGetNetworkIdFromEntity(Vehicle)
	end
end