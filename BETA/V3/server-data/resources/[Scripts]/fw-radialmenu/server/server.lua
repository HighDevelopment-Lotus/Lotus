local LSCore = exports['fw-base']:GetCoreObject()

RegisterServerEvent('framework-radialmenu:server:open:dispatch')
AddEventHandler('framework-radialmenu:server:open:dispatch', function()
   local src = source
   local Player = LSCore.Functions.GetPlayer(src)
   Citizen.SetTimeout(650, function()
      if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) or (Player.PlayerData.job.name == "ambulance" and Player.PlayerData.job.onduty) then
         TriggerClientEvent('framework-alerts:client:open:previous:alert', src, Player.PlayerData.job.name)
      end
   end)
end)

LSCore.Functions.CreateCallback('framework-radialmenu:server:HasItem', function(source, cb, itemName)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player ~= nil then
      local Item = Player.Functions.GetItemByName(itemName)
      if Item ~= nil then
			cb(true)
      else
			cb(false)
      end
	end
end)