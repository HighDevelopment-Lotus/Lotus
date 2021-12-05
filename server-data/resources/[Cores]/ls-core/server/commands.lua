LSCore.Commands = {}
LSCore.Commands.List = {}

LSCore.Commands.Add = function(name, help, arguments, argsrequired, callback, permission) -- [name] = command name (ex. /givemoney), [help] = help text, [arguments] = arguments that need to be passed (ex. {{name="id", help="ID of a player"}, {name="amount", help="amount of money"}}), [argsrequired] = set arguments required (true or false), [callback] = function(source, args) callback, [permission] = rank or job of a player
	LSCore.Commands.List[name:lower()] = {
		name = name:lower(),
		permission = permission ~= nil and permission:lower() or "user",
		help = help,
		arguments = arguments,
		argsrequired = argsrequired,
		callback = callback,
	}
end

LSCore.Commands.Refresh = function(source)
	local Player = LSCore.Functions.GetPlayer(tonumber(source))
	if Player ~= nil then
		for command, info in pairs(LSCore.Commands.List) do
			if LSCore.Functions.HasPermission(source, "god") or LSCore.Functions.HasPermission(source, LSCore.Commands.List[command].permission) then
				TriggerClientEvent('chat:addSuggestion', source, "/"..command, info.help, info.arguments)
			end
		end
	end
end

LSCore.Commands.Add("tp", "Teleport naar een speler of location", {{name="id/x", help="ID van een speler of X positie"}, {name="y", help="Y positie"}, {name="z", help="Z positie"}}, false, function(source, args)
	if (args[1] ~= nil and (args[2] == nil and args[3] == nil)) then
		-- tp to player
		local Player = LSCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('LSCore:Command:TeleportToPlayer', source, Player.PlayerData.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		-- tp to location
		if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
			local x = tonumber(args[1])
			local y = tonumber(args[2])
			local z = tonumber(args[3])
			TriggerClientEvent('LSCore:Command:TeleportToCoords', source, x, y, z)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Niet elk argument is ingevuld (x, y, z)")
		end
	end
end, "admin")

LSCore.Commands.Add("addpermission", "Geef permissie aan iemand (god/admin)", {{name="id", help="ID van de speler"}, {name="permission", help="Permission level"}}, true, function(source, args)
	local Player = LSCore.Functions.GetPlayer(tonumber(args[1]))
	local permission = tostring(args[2]):lower()
	if Player ~= nil then
		LSCore.Functions.AddPermission(Player.PlayerData.source, permission)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")	
	end
end, "god")

LSCore.Commands.Add("removepermission", "Haal permissie weg van iemand", {{name="id", help="ID van de speler"}}, true, function(source, args)
	local Player = LSCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		LSCore.Functions.RemovePermission(Player.PlayerData.source)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")	
	end
end, "god")

LSCore.Commands.Add("sv", "Spawn een voertuig", {{name="model", help="Model naam van het voertuig"}}, true, function(source, args)
	LSCore.Functions.SpawnVehicle(source, args[1], nil, true)
	--TriggerClientEvent('LSCore:Command:SpawnVehicle', source, args[1])
end, "admin")

LSCore.Commands.Add("dv", "Despawn een voertuig", {}, false, function(source, args)
	TriggerClientEvent('LSCore:Command:DeleteVehicle', source)
end, "admin")

LSCore.Commands.Add("tpm", "Teleport naar een marker", {}, false, function(source, args)
	TriggerClientEvent('LSCore:Command:GoToMarker', source)
end, "admin")

LSCore.Commands.Add("givemoney", "Geef geld aan een speler", {{name="id", help="Speler ID"},{name="moneytype", help="Type geld (cash, bank)"}, {name="amount", help="Aantal moneys"}}, true, function(source, args)
	local Player = LSCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

LSCore.Commands.Add("setmoney", "Zet het geld voor een speler", {{name="id", help="Speler ID"},{name="moneytype", help="Type geld (cash, bank)"}, {name="amount", help="Aantal moneys"}}, true, function(source, args)
	local Player = LSCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

LSCore.Commands.Add("setjob", "Voeg een speler toe aan een baan", {{name="id", help="Player ID"}, {name="job", help="Baan"}, {name="grade", help="Rang"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player ~= nil then
        Player.Functions.SetJob(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
    end
end, "admin")


LSCore.Commands.Add("baan", "Bekijk jouw huidige baan", {}, false, function(source, args)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Baan: "..Player.PlayerData.job.label.." - "..Player.PlayerData.job.gradelabel)
end)

LSCore.Commands.Add("setgang", "Geef een gang positie aan een speler", {{name="id", help="Speler ID"}, {name="gang", help="Naam van de gang"}}, true, function(source, args)
	local Player = LSCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetGang(tostring(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

LSCore.Commands.Add("baan", "Kijk wat je baan is", {}, false, function(source, args)
	local Player = LSCore.Functions.GetPlayer(source)
	TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Baan: "..Player.PlayerData.job.label)
end)

LSCore.Commands.Add("clearinv", "Leeg de inventory van jezelf of een speler", {{name="id", help="Speler ID"}}, false, function(source, args)
	local playerId = args[1] ~= nil and args[1] or source 
	local Player = LSCore.Functions.GetPlayer(tonumber(playerId))
	if Player ~= nil then
		Player.Functions.ClearInventory()
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

LSCore.Commands.Add("giveitem", "Spawn een item in", {{name="id", help="Speler ID"}, {name="itemname", help="Item Naam"}, {name="amount", help="Item Hoeveelheid"}}, false, function(source, args)
	local PlayerId = args[1] ~= nil and args[1] or source 
	local Amount = args[3] ~= nil and tonumber(args[3]) or 1
	local ItemName = args[2]
	local Player = LSCore.Functions.GetPlayer(tonumber(PlayerId))
	if Player ~= nil then
		local Info = {}
		if ItemName == 'id_card' then
			Info.citizenid = Player.PlayerData.citizenid
			Info.firstname = Player.PlayerData.charinfo.firstname
			Info.lastname = Player.PlayerData.charinfo.lastname
			Info.birthdate = Player.PlayerData.charinfo.birthdate
			Info.gender = Player.PlayerData.charinfo.gender
			Info.nationality = Player.PlayerData.charinfo.nationality
		elseif ItemName == 'driver_license' then
			Info.firstname = Player.PlayerData.charinfo.firstname
			Info.lastname = Player.PlayerData.charinfo.lastname
			Info.birthdate = Player.PlayerData.charinfo.birthdate
			Info.type = "A1-A2-A | AM-B | C1-C-CE"
		elseif ItemName == 'markedbills' then
			Info.worth = math.random(5000, 10000)
		elseif ItemName == 'scuba-gear' then
			Info.air = 100
		elseif itemName == 'burger-box' then
			Info.boxid = math.random(11111,99999)
		elseif ItemName == 'duffel-bag' then
			Info.bagid = math.random(11111,99999)
		else
			Info = false
		end
		Player.Functions.AddItem(ItemName, Amount, false, Info, true)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

LSCore.Commands.Add("removeitem", "Verwijder een item van iemand", {{name="id", help="Speler ID"}, {name="itemname", help="Item Naam"}, {name="amount", help="Item Hoeveelheid"}}, false, function(source, args)
	local PlayerId = args[1] ~= nil and args[1] or source 
	local Player = LSCore.Functions.GetPlayer(tonumber(PlayerId))
	if Player ~= nil then
		Player.Functions.RemoveItem(args[2], tonumber(args[3]), false, false)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

LSCore.Commands.Add("ooc", "Out Of Character chat bericht (alleen gebruiken wanneer nodig)", {}, false, function(source, args)
	local message = table.concat(args, " ")
	TriggerClientEvent("LSCore:Client:LocalOutOfCharacter", -1, source, GetPlayerName(source), message)
	local Players = LSCore.Functions.GetPlayers()
	for k, v in pairs(LSCore.Functions.GetPlayers()) do
		if LSCore.Functions.HasPermission(v, "admin") then
			if LSCore.Functions.IsOptin(v) then
				TriggerClientEvent('chatMessage', v, "OOC | " .. GetPlayerName(source) .. " ["..source.."]", "normal", message)
			end
		end
	end
end)

LSCore.Commands.Add("id", "Zie wat je id is.", {}, false, function(source, args)
	local Player = LSCore.Functions.GetPlayer(source)
	TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Jouw id: "..source)
end)

LSCore.Commands.Add("duty", "Toggle je dienst", {}, false, function(source, args)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == 'taxi' or Player.PlayerData.job.name == 'mechanic' or Player.PlayerData.job.name == 'repairshop' or Player.PlayerData.job.name == 'lawyer' or Player.PlayerData.job.name == 'realestate' or Player.PlayerData.job.name == 'cardealer' or Player.PlayerData.job.name == 'ambulance' or Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'flightschool' then
		TriggerEvent('LSCore:ToggleDuty', source)
	end
end)