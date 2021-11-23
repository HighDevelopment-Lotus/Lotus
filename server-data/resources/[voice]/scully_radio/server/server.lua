local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateUseableItem("radio", function(source, item)
  local Player = LSCore.Functions.GetPlayer(source)
  TriggerClientEvent('ls-radio:use', source)
end)

LSCore.Functions.CreateCallback('ls-radio:server:GetItem', function(source, cb, item)
  local src = source
  local Player = LSCore.Functions.GetPlayer(src)
  if Player ~= nil then 
    local RadioItem = Player.Functions.GetItemByName(item)
    if RadioItem ~= nil then
      cb(true)
    else
      cb(false)
    end
  else
    cb(false)
  end
end)