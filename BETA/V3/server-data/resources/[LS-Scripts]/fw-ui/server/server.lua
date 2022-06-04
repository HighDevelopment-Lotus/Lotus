local LSCore = exports['fw-base']:GetCoreObject()

-- Code

RegisterServerEvent('framework-ui:server:add:news:jail')
AddEventHandler('framework-ui:server:add:news:jail', function(Time)
    local Player = LSCore.Functions.GetPlayer(source)
    local Data = {['Name'] = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname, ['JailTime'] = Time}
    TriggerClientEvent('framework-ui:client:add:news:jail', -1, Data)
end)

RegisterServerEvent('framework-ui:server:show:police:id')
AddEventHandler('framework-ui:server:show:police:id', function(Target, PassData)
    local SourcePlayer = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(Target))
    TriggerClientEvent('framework-ui:client:show:police:id', SourcePlayer.PlayerData.source, PassData)
    TriggerClientEvent('framework-ui:client:show:police:id', TargetPlayer.PlayerData.source, PassData)
end)

RegisterServerEvent('framework-ui:server:scan:finger')
AddEventHandler('framework-ui:server:scan:finger', function()
    local SourcePlayer = LSCore.Functions.GetPlayer(source)
    TriggerClientEvent('framework-ui:client:scan:finger', -1, SourcePlayer.PlayerData.metadata['fingerprint'])
end)

LSCore.Commands.Add("ui-r", "Restart het ui script", {}, false, function(source, args)
    TriggerClientEvent('framework-ui:client:refresh', source)
    TriggerClientEvent('LSCore:Client:CloseNui', source)
    TriggerClientEvent('framework-phone:client:force:close', source)
    TriggerClientEvent('framework-radialmenu:client:force:close', source)
    TriggerClientEvent('framework-inv:client:force:close', source, source)
end)

RegisterServerEvent('framework-ui:server:gain:stress')
AddEventHandler('framework-ui:server:gain:stress', function(Amount)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player ~= nil then
      local NewStress = Player.PlayerData.metadata["stress"] + Amount
	  if NewStress <= 0 then NewStress = 0 end
	  if NewStress > 105 then NewStress = 100 end
	  Player.Functions.SetMetaData("stress", NewStress)
      TriggerClientEvent("framework-ui:client:update:stress", Player.PlayerData.source, NewStress)
	end
end)

RegisterServerEvent('framework-ui:server:remove:stress')
AddEventHandler('framework-ui:server:remove:stress', function(Amount)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player ~= nil then
      local NewStress = Player.PlayerData.metadata["stress"] - Amount
	  if NewStress <= 0 then NewStress = 0 end
	  if NewStress > 105 then NewStress = 100 end
	  Player.Functions.SetMetaData("stress", NewStress)
      TriggerClientEvent("framework-ui:client:update:stress", Player.PlayerData.source, NewStress)
	end
end)


LSCore.Functions.CreateCallback('framework-board:server:GetActiveCops', function(source, cb)
    local retval = 0
    
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                retval = retval + 1
            end
        end
    end

    cb(retval)
end)

-- LSCore.Functions.CreateCallback('framework-board:server:GetPlayers', function(source, cb)
--     local retval = 0
    
--     for k, v in pairs(LSCore.Functions.GetPlayers()) do
--         local Player = LSCore.Functions.GetPlayer(v)
--         if Player ~= nil then
--                 retval = retval + 1
--         end
--     end

--     cb(retval)
--     print(retval)
--     -- return retval
-- end)

LSCore.Functions.CreateCallback('kwk-scoreboard:server:GetActivity', function(source, cb)
    local PoliceCount = 0
    local AmbulanceCount = 0
    local AutocareCount = 0
    -- local CardealerCount = 0

    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                PoliceCount = PoliceCount + 1
            end

            if ((Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "doctor") and Player.PlayerData.job.onduty) then
                AmbulanceCount = AmbulanceCount + 1
            end

            if (Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty) then
                AutocareCount = AutocareCount + 1
            end
            
			-- if (Player.PlayerData.job.name == "cardealer" and Player.PlayerData.job.onduty) then
            --     CardealerCount = CardealerCount + 1
            -- end
        end
    end

    cb(PoliceCount, AmbulanceCount, AutocareCount)
end)

LSCore.Functions.CreateCallback('framework-board:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

RegisterServerEvent('framework-board:server:SetActivityBusy')
AddEventHandler('framework-board:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('framework-board:client:SetActivityBusy', -1, activity, bool)
end)

LSCore.Functions.CreateCallback('framework-board:server:GetPlayersArrays', function(source, cb)
    local players = {}
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            players[Player.PlayerData.source] = {}
            players[Player.PlayerData.source].permission = LSCore.Functions.IsOptinBoard(Player.PlayerData.source)
        end
    end
    cb(players)
end)

LSCore.Commands.Add("binds", "Open commandbinding menu", {}, false, function(source, args)
	TriggerClientEvent("framework-commandbinding:client:openUI", source)
end)

RegisterServerEvent('framework-commandbinding:server:set:keys')
AddEventHandler('framework-commandbinding:server:set:keys', function(keyMeta)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.SetMetaData("commandbinds", keyMeta)
end)