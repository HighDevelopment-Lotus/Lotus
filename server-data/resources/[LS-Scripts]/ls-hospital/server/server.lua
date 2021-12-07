local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('ls-hospital:server:pay:hospital', function(source, cb)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveMoney('cash', Config.BedPayment, 'Ziekenhuis') then
		cb(true)
	elseif Player.Functions.RemoveMoney('bank', Config.BedPayment, 'Ziekenhuis') then
		cb(true)
	else
		TriggerClientEvent('LSCore:Notify', source, "Je hebt niet genoeg contant..", "error", 4500)
		cb(false)
	end

end)

RegisterServerEvent('ls-hospital:server:set:state')
AddEventHandler('ls-hospital:server:set:state', function(type, state)
	local src = source
	local Player = LSCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.Functions.SetMetaData(type, state)
	end
end)

RegisterServerEvent('ls-hospital:server:dead:respawn')
AddEventHandler('ls-hospital:server:dead:respawn', function()
	local Player = LSCore.Functions.GetPlayer(source)
	Player.Functions.RemoveMoney('bank', Config.RespawnPrice, 'respawn-fund')
	Player.Functions.ClearInventory()
	Citizen.SetTimeout(250, function()
		Player.Functions.Save()
	end)
end)

RegisterServerEvent('ls-hospital:server:save:health:armor')
AddEventHandler('ls-hospital:server:save:health:armor', function(PlayerHealth, PlayerArmor)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player ~= nil then
		Player.Functions.SetMetaData('health', PlayerHealth)
		Player.Functions.SetMetaData('armor', PlayerArmor)
	end
end)

RegisterServerEvent('ls-hospital:server:revive:player')
AddEventHandler('ls-hospital:server:revive:player', function(PlayerId)
	local TargetPlayer = LSCore.Functions.GetPlayer(PlayerId)
	if TargetPlayer ~= nil then
		TriggerClientEvent('ls-hospital:client:revive', TargetPlayer.PlayerData.source, true, true)
	end
end)

RegisterServerEvent('ls-hospital:server:heal:player')
AddEventHandler('ls-hospital:server:heal:player', function(TargetId)
	local TargetPlayer = LSCore.Functions.GetPlayer(TargetId)
	if TargetPlayer ~= nil then
		TriggerClientEvent('ls-hospital:client:heal', TargetPlayer.PlayerData.source)
	end
end)

RegisterServerEvent('ls-hospital:server:take:blood:player')
AddEventHandler('ls-hospital:server:take:blood:player', function(TargetId)
	local src = source
	local SourcePlayer = LSCore.Functions.GetPlayer(src)
	local TargetPlayer = LSCore.Functions.GetPlayer(TargetId)
	if TargetPlayer ~= nil then
	 local Info = {vialid = math.random(11111,99999), bloodtype = TargetPlayer.PlayerData.metadata['bloodtype'], vialbsn = TargetPlayer.PlayerData.citizenid}
	 SourcePlayer.Functions.AddItem('bloodvial', 1, false, Info, true)
	end
end)

RegisterServerEvent('ls-hospital:server:set:bed:state')
AddEventHandler('ls-hospital:server:set:bed:state', function(BedData, bool)
	Config.Beds[BedData]['Busy'] = bool
	TriggerClientEvent('ls-hospital:client:set:bed:state', -1 , BedData, bool)
end)

LSCore.Commands.Add("revive", "Revive een speler of jezelf", {{name="id", help="Speler ID (mag leeg zijn)"}}, false, function(source, args)
	if args[1] ~= nil then
		local Player = LSCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('ls-hospital:client:revive', Player.PlayerData.source, true, true)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		TriggerClientEvent('ls-hospital:client:revive', source, true, true)
	end
end, "admin")

LSCore.Commands.Add("armor", "Geef armor aan een speler of jezelf", {{name="id", help="Speler ID (mag leeg zijn)"}}, false, function(source, args)
	if args[1] ~= nil then
		local Player = LSCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('ls-hospital:client:armor:up', Player.PlayerData.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		TriggerClientEvent('ls-hospital:client:armor:up', source)
	end
end, "admin")

LSCore.Commands.Add("setambulance", "Neem neen ambulancier aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'ambulance' then
      	if TargetPlayer ~= nil then
      	    TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als ambulancier! gefeliciteerd!', 'success')
      	    TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als ambulancier!', 'success')
      	    TargetPlayer.Functions.SetJob('ambulance', 1)
      	end
    end
end)

LSCore.Commands.Add("fireambulance", "Ontsla een ambulancier", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      	if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'ambulance' then
      	  	TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
      	  	TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
      	  	TargetPlayer.Functions.SetJob('unemployed', 1)
      	end
    end
end)