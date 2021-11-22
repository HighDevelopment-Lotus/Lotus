local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('ls-radio:server:HasItem', function(source, cb, itemName)
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

LSCore.Functions.CreateUseableItem("radio", function(source, item)
  local Player = LSCore.Functions.GetPlayer(source)
  TriggerClientEvent('ls-radio:use:radio', source)
end)