local LSCore = exports['ls-core']:GetCoreObject()

-- Code

RegisterServerEvent('ls-ui:server:add:news:jail')
AddEventHandler('ls-ui:server:add:news:jail', function(Time)
    local Player = LSCore.Functions.GetPlayer(source)
    local Data = {['Name'] = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname, ['JailTime'] = Time}
    TriggerClientEvent('ls-ui:client:add:news:jail', -1, Data)
end)

RegisterServerEvent('ls-ui:server:show:police:id')
AddEventHandler('ls-ui:server:show:police:id', function(Target, PassData)
    local SourcePlayer = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(Target))
    TriggerClientEvent('ls-ui:client:show:police:id', SourcePlayer.PlayerData.source, PassData)
    TriggerClientEvent('ls-ui:client:show:police:id', TargetPlayer.PlayerData.source, PassData)
end)

RegisterServerEvent('ls-ui:server:scan:finger')
AddEventHandler('ls-ui:server:scan:finger', function()
    local SourcePlayer = LSCore.Functions.GetPlayer(source)
    TriggerClientEvent('ls-ui:client:scan:finger', -1, SourcePlayer.PlayerData.metadata['fingerprint'])
end)

LSCore.Commands.Add("ui-r", "Restart het ui script", {}, false, function(source, args)
    TriggerClientEvent('ls-ui:client:refresh', source)
    TriggerClientEvent('LSCore:Client:CloseNui', source)
    TriggerClientEvent('ls-phone_new:client:force:close', source)
    TriggerClientEvent('ls-radialmenu:client:force:close', source)
    TriggerClientEvent('ls-inventory-new:client:force:close', source, source)
end)

LSCore.Commands.Add("cash", "Kijk hoeveel geld je bij je hebt", {}, false, function(source, args)
    TriggerClientEvent('ls-ui:client:show:cash', source)
end)

LSCore.Commands.Add("players", "Kijk hoeveel spelers er online zijn", {}, false, function(source, args)
	TriggerClientEvent('ls-ui:client:show:current:players', source)
end)

RegisterServerEvent('ls-ui:server:gain:stress')
AddEventHandler('ls-ui:server:gain:stress', function(Amount)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player ~= nil then
      local NewStress = Player.PlayerData.metadata["stress"] + Amount
	  if NewStress <= 0 then NewStress = 0 end
	  if NewStress > 105 then NewStress = 100 end
	  Player.Functions.SetMetaData("stress", NewStress)
      TriggerClientEvent("ls-ui:client:update:stress", Player.PlayerData.source, NewStress)
	end
end)

RegisterServerEvent('ls-ui:server:remove:stress')
AddEventHandler('ls-ui:server:remove:stress', function(Amount)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player ~= nil then
      local NewStress = Player.PlayerData.metadata["stress"] - Amount
	  if NewStress <= 0 then NewStress = 0 end
	  if NewStress > 105 then NewStress = 100 end
	  Player.Functions.SetMetaData("stress", NewStress)
      TriggerClientEvent("ls-ui:client:update:stress", Player.PlayerData.source, NewStress)
	end
end)