LSCore = exports['fw-base']:GetCoreObject()

-- Items

LSCore.Functions.CreateUseableItem("radio", function(source, item)
  TriggerClientEvent('framework-radio:use', source)
end)

-- Callbacks

LSCore.Functions.CreateCallback('framework-radio:server:GetItem', function(source, cb, item)
  local src = source
  local Player = LSCore.Functions.GetPlayer(src)
  if Player ~= nil then
      local RadioItem = Player.Functions.GetItemByName(item)
      if RadioItem ~= nil and not Player.PlayerData.metadata["isdead"] then
          cb(true)
      else
          cb(false)
      end
  else
      cb(false)
  end
end)