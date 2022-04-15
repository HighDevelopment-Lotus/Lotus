local ImgurClientID = '6a84b9697dfe640' -- create account on imgur

AddEventHandler('playerDropped', function(reason) 
	local src = source
	TriggerClientEvent('LSCore:Client:OnPlayerUnload', src)
	TriggerClientEvent('LSCore:Player:UpdatePlayerPosition', src)
	TriggerEvent("framework-logs:server:SendLog", "joinleave", "Dropped", "red", "**".. GetPlayerName(src) .. "** ("..GetPlayerIdentifiers(src)[1]..")  left.. The reason is: " .. reason)
	if reason ~= "Reconnecting" and src > 60000 then return false end
	if(src==nil or (LSCore.Players[src] == nil)) then return false end
	LSCore.Players[src].Functions.Save()
	LSCore.Players[src] = nil
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	deferrals.defer()
	local src = source
	local name = GetPlayerName(src)

	deferrals.update("Checking name...")

	if name == nil then 
		LSCore.Functions.Kick(src, 'Gelieve geen lege steam naam te gebruiken.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	if(string.match(name, "[*%%'=`\"]")) then
        LSCore.Functions.Kick(src, 'Je hebt in je naam een teken('..string.match(name, "[*%%'=`\"]")..') zitten wat niet is toegestaan.\nGelieven deze uit je steam-naam te halen.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	if (string.match(name, "drop") or string.match(name, "table") or string.match(name, "database") or string.match(name, "update") or string.match(name, "delete")) then
        LSCore.Functions.Kick(src, 'Je hebt in je naam een woord (drop/table/database) zitten wat niet is toegestaan.\nGelieven je steam naam te veranderen.', setKickReason, deferrals)
        CancelEvent()
        return false
	end

    local identifiers = GetPlayerIdentifiers(src)
	local steamid = identifiers[1]
	local license = identifiers[2]
    if (Config.IdentifierType == "steam" and (steamid:sub(1,6) == "steam:") == false) then
        LSCore.Functions.Kick(src, 'Je moet steam aan hebben staan om te spelen.', setKickReason, deferrals)
        CancelEvent()
		return false
	elseif (Config.IdentifierType == "license" and (steamid:sub(1,6) == "license:") == false) then
		LSCore.Functions.Kick(src, 'Geen socialclub license gevonden.', setKickReason, deferrals)
        CancelEvent()
		return false
	end

	local isBanned, Message = LSCore.Functions.IsPlayerBanned(src)
    if (isBanned) then
		deferrals.update(Message)
        CancelEvent()
        return false
    end
	TriggerEvent("framework-logs:server:SendLog", "joinleave", "Queue", "orange", "**"..name .. "** ("..json.encode(GetPlayerIdentifiers(src))..") in queue..")
	TriggerEvent("connectqueue:playerConnect", src, setKickReason, deferrals)
end)

RegisterServerEvent("LSCore:Server:TriggerCallback")
AddEventHandler('LSCore:Server:TriggerCallback', function(name, ...)
	local src = source
	LSCore.Functions.TriggerCallback(name, src, function(...)
		TriggerClientEvent("LSCore:Client:TriggerCallback", src, name, ...)
	end, ...)
end)

RegisterServerEvent("LSCore:UpdatePlayer")
AddEventHandler('LSCore:UpdatePlayer', function(data)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player ~= nil then
		local NewHunger = Player.PlayerData.metadata["hunger"] - 3.0
		local NewThirst = Player.PlayerData.metadata["thirst"] - 3.0
		if NewHunger <= 0 then NewHunger = 0 end
		if NewThirst <= 0 then NewThirst = 0 end
		Player.Functions.SetMetaData("thirst", NewThirst)
		Player.Functions.SetMetaData("hunger", NewHunger)
		TriggerClientEvent("framework-ui:client:update:needs", source, NewHunger, NewThirst)
		Player.Functions.Save()
	end
end)

RegisterServerEvent("LSCore:Salary")
AddEventHandler('LSCore:Salary', function(data)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player ~= nil then
		Player.Functions.SetMetaData('paycheck', Player.PlayerData.metadata['paycheck'] + Player.PlayerData.job.payment)
	end
end)

RegisterServerEvent("LSCore:UpdatePlayerPosition")
AddEventHandler("LSCore:UpdatePlayerPosition", function(position)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player ~= nil then
		Player.PlayerData.position = position
	end
end)

RegisterServerEvent('LSCore:Server:SetMetaData')
AddEventHandler('LSCore:Server:SetMetaData', function(Meta, Data)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		if Meta == 'hunger' or Meta == 'thirst' then
			if Data >= 100 then
				Data = 100
			elseif Data <= 0 then
				Data = 0
			end
		end
		Player.Functions.SetMetaData(Meta, Data)
		TriggerClientEvent("framework-ui:client:update:needs", source, Player.PlayerData.metadata["hunger"], Player.PlayerData.metadata["thirst"])
	end
end)

AddEventHandler('chatMessage', function(source, n, message)
	if string.sub(message, 1, 1) == "/" then
		local args = LSCore.Shared.SplitStr(message, " ")
		local command = string.gsub(args[1]:lower(), "/", "")
		CancelEvent()
		if LSCore.Commands.List[command] ~= nil then
			local Player = LSCore.Functions.GetPlayer(tonumber(source))
			if Player ~= nil then
				table.remove(args, 1)
				if (LSCore.Functions.HasPermission(source, "god") or LSCore.Functions.HasPermission(source, LSCore.Commands.List[command].permission)) then
					if (LSCore.Commands.List[command].argsrequired and #LSCore.Commands.List[command].arguments ~= 0 and args[#LSCore.Commands.List[command].arguments] == nil) then
					    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Alle argumenten moeten ingevuld worden!")
					    local agus = ""
					    for name, help in pairs(LSCore.Commands.List[command].arguments) do
					    	agus = agus .. " ["..help.name.."]"
					    end
				        TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
					else
						LSCore.Commands.List[command].callback(source, args)
					end
				else
					TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt geen toegang tot dit commando..")
				end
			end
		end
	end
end)

RegisterServerEvent('LSCore:CallCommand')
AddEventHandler('LSCore:CallCommand', function(command, args)
	if LSCore.Commands.List[command] ~= nil then
		local Player = LSCore.Functions.GetPlayer(tonumber(source))
		if Player ~= nil then
			if (LSCore.Functions.HasPermission(source, "god")) or (LSCore.Functions.HasPermission(source, LSCore.Commands.List[command].permission)) or (LSCore.Commands.List[command].permission == Player.PlayerData.job.name) then
				if (LSCore.Commands.List[command].argsrequired and #LSCore.Commands.List[command].arguments ~= 0 and args[#LSCore.Commands.List[command].arguments] == nil) then
					TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Alle argumenten moeten ingevuld worden!")
					local agus = ""
					for name, help in pairs(LSCore.Commands.List[command].arguments) do
						agus = agus .. " ["..help.name.."]"
					end
					TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
				else
					LSCore.Commands.List[command].callback(source, args)
				end
			else
				TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt geen toegang tot dit commando..")
			end
		end
	end
end)

RegisterServerEvent("LSCore:AddCommand")
AddEventHandler('LSCore:AddCommand', function(name, help, arguments, argsrequired, callback, persmission)
	LSCore.Commands.Add(name, help, arguments, argsrequired, callback, persmission)
end)

RegisterServerEvent("LSCore:ToggleDuty")
AddEventHandler('LSCore:ToggleDuty', function(Source)
	local src = Source ~= nil and Source or source
	local Player = LSCore.Functions.GetPlayer(src)
	if not Player.PlayerData.job.onduty then
		Player.Functions.SetJobDuty(true)
		TriggerClientEvent('LSCore:Notify', src, "Je bent nu in dienst!")
		TriggerClientEvent("LSCore:Client:SetDuty", src, true)
		if Player.PlayerData.job.name == 'police' then
			TriggerEvent("framework-police:server:UpdateCurrentCops")
		end
	else
		Player.Functions.SetJobDuty(false)
		TriggerClientEvent('LSCore:Notify', src, "Je bent nu uit dienst!")
		TriggerClientEvent("LSCore:Client:SetDuty", src, false)
		if Player.PlayerData.job.name == 'police' then
			TriggerEvent("framework-police:server:UpdateCurrentCops")
		end
 	end
end)

RegisterServerEvent("LSCore:Server:recieve:paycheck")
AddEventHandler('LSCore:Server:recieve:paycheck', function()
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.PlayerData.metadata['paycheck'] > 0 then
		Player.Functions.AddMoney('cash', Player.PlayerData.metadata['paycheck'])
		Player.Functions.SetMetaData('paycheck', 0)
	else
		TriggerClientEvent('LSCore:Notify', source, "Je hebt geen salaris om op te halen..", "error")
	end
end)

Citizen.CreateThread(function()
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
end)

LSCore.Functions.CreateCallback('LSCore:HasItem', function(source, cb, ItemName)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player ~= nil then
		if Player.Functions.GetItemByName(ItemName) ~= nil then
			cb(true)
		else
			cb(false)
		end
	end
end)	

LSCore.Functions.CreateCallback('LSCore:RemoveItem', function(source, cb, ItemName, Amount, Slot)
	local Player = LSCore.Functions.GetPlayer(source)
	local Amount = Amount ~= nil and Amount or 1
	local Slot = Slot ~= nil and Slot or false
	if Player.Functions.RemoveItem(ItemName, Amount, Slot, true) then
		cb(true)
	else
		cb(false)
	end
end)	

LSCore.Functions.CreateCallback('LSCore:RemoveCash', function(source, cb, amount)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem("cash", amount) then
        cb(true)
    else 
        cb(false)
    end
end)

LSCore.Functions.CreateCallback('LSCore:server:spawn:vehicle', function(source, cb, Model, Coords, IsAdmin, Plate)
	local SpawnVehicle = LSCore.Functions.SpawnVehicle(source, Model, Coords, IsAdmin, Plate)
	cb(SpawnVehicle)
end)	

LSCore.Functions.CreateCallback('LSCore:server:get:imgur:key', function(source, cb)
	cb(ImgurClientID)
end)