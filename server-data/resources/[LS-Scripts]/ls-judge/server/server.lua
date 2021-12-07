local LSCore = exports['ls-core']:GetCoreObject()

-- Code

RegisterServerEvent('ls-judge:lawyer:add')
AddEventHandler('ls-judge:lawyer:add', function(TagetId)
local SelfPlayer = LSCore.Functions.GetPlayer(source)
local TagetPlayer = LSCore.Functions.GetPlayer(TagetId)
local LawyerInfo = {id = math.random(100000, 999999), firstname = TagetPlayer.PlayerData.charinfo.firstname, lastname = TagetPlayer.PlayerData.charinfo.lastname, citizenid = TagetPlayer.PlayerData.citizenid}
 if TagetPlayer ~= nil and SelfPlayer ~= nil then
    TagetPlayer.Functions.SetJob('lawyer', 1)
    TagetPlayer.Functions.AddItem("lawyerpass", 1, false, LawyerInfo, true)
    TriggerClientEvent('LSCore:Notify', SelfPlayer.PlayerData.source, 'Je hebt '..TagetPlayer.PlayerData.charinfo.firstname..' '..TagetPlayer.PlayerData.charinfo.lastname..' aangenomen!')
    TriggerClientEvent('LSCore:Notify', TagetPlayer.PlayerData.source, 'Gefeliciteerd je bent aangenomen als advocaat')
 end
end)

LSCore.Functions.CreateUseableItem("lawyerpass", function(source, item)
 local Player = LSCore.Functions.GetPlayer(source)
  if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    TriggerClientEvent("ls-judge:client:show:pass", -1, source, item.info)
  end
end)