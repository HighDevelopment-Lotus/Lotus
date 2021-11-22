local PreviousWalkset = nil

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(6000, function()
        local PlayerData = LSCore.Functions.GetPlayerData()
        if PlayerData.metadata['walkstyle'] ~= nil and PlayerData.metadata['walkstyle'] ~= false then
           exports['ls-assets']:RequestAnimSetEvent(PlayerData.metadata['walkstyle'])
           SetPedMovementClipset(PlayerPedId(), PlayerData.metadata['walkstyle'], 0.2) 
           print('Setting walkstyle', PlayerData.metadata['walkstyle'])
        end
    end)
end)

-- Code

-- // Events \\ --

RegisterNetEvent('animations:client:set:walkstyle')
AddEventHandler('animations:client:set:walkstyle', function()
    local PlayerData = LSCore.Functions.GetPlayerData()
    if PlayerData.metadata['walkstyle'] ~= nil and PlayerData.metadata['walkstyle'] ~= false then
       exports['ls-assets']:RequestAnimSetEvent(PlayerData.metadata['walkstyle'])
       SetPedMovementClipset(PlayerPedId(), PlayerData.metadata['walkstyle'], 0.2) 
       print('Setting walkstyle', PlayerData.metadata['walkstyle'])
    end
end)

-- // Functions \\ --

function WalkMenuStart(name)
   exports['ls-assets']:RequestAnimSetEvent(name)
   SetPedMovementClipset(PlayerPedId(), name, 0.2) 
   TriggerServerEvent('LSCore:Server:SetMetaData', 'walkstyle', name)
   PreviousWalkset = name
end

function WalksOnCommand(source, args, raw)
   local WalksCommand = ""
   for a in pairsByKeys(AnimationList.Walks) do
       WalksCommand = WalksCommand .. ""..string.lower(a)..", "
   end
end

function WalkCommandStart(source, args, raw)
   local name = firstToUpper(args[1])
   if name == "Reset" then
       ResetPedMovementClipset(PlayerPedId()) return
   end
   local name2 = table.unpack(AnimationList.Walks[name])
   if name2 ~= nil then
      WalkMenuStart(name2)
   end
end

function RequestWalking(set)
   RequestAnimSet(set)
   while not HasAnimSetLoaded(set) do
       Citizen.Wait(1)
   end 
end