local LoggedIn = false
local CanPress = true
local LSCore = exports['ls-core']:GetCoreObject()

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function() 
        LoggedIn = true
    end) 
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

RegisterNetEvent('ls-judge:client:lawyer:add:closest')
AddEventHandler('ls-judge:client:lawyer:add:closest', function()
  local Player, Distance = LSCore.Functions.GetClosestPlayer()
  if Player ~= -1 and Distance < 1.5 then
    local ServerId = GetPlayerServerId(Player)
    TriggerServerEvent('ls-judge:lawyer:add', ServerId)
  end
end)

RegisterNetEvent("ls-judge:client:show:pass")
AddEventHandler("ls-judge:client:show:pass", function(SourceId, data)
    local SourceCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(SourceId)), false)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, SourceCoords.x, SourceCoords.y, SourceCoords.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Pas-ID:</strong> {1} <br><strong>Voornaam:</strong> {2} <br><strong>Achternaam:</strong> {3} <br><strong>BSN:</strong> {4} </div></div>',
            args = {'Advocatenpas', data.id, data.firstname, data.lastname, data.citizenid}
        })
    end
end)