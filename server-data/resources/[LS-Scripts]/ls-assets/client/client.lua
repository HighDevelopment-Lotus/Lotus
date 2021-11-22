LSCore, LoggedIn, DisableSeatShuff = exports['ls-core']:GetCoreObject(), false, true
local DisplayCount = 0

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(3500, function()
        SetDiscordButtons()
        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(PlayerPedId(), true, true)
        LSCore.Functions.TriggerCallback("ls-assets:server:get:dui:data", function(DuiData)
            Config.SavedDuiData = DuiData
        end)
        Citizen.Wait(3500)
        SetFollowPedCamViewMode(0)
        LoggedIn = true
        LoadVehicles()
    end)
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         SetDiscordButtons()
--         NetworkSetFriendlyFireOption(true)
--         SetCanAttackFriendly(PlayerPedId(), true, true)
--         -- LSCore.Functions.TriggerCallback("ls-assets:server:get:dui:data", function(DuiData)
--         --     Config.SavedDuiData = DuiData
--         -- end)
--         Citizen.Wait(3500)
--         SetFollowPedCamViewMode(0)
--         LoggedIn = true
--         LoadVehicles()
--     end)
-- end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    WeaponHolstered, DidDisable, CanFire = true, true, true
    PoliceHolsterData = {['HolsterProp'] = nil}
    LoggedIn = false
end)

-- Code

-- // Events \\ --

function SetDiscordButtons()
    SetDiscordRichPresenceAction(0, 'Connecten', 'fivem://connect/game.lotusrp.nl')
    SetDiscordRichPresenceAction(1, 'Discord', 'https://discord.gg/whFmsne')
end

RegisterNetEvent('ls-assets:client:seat:shuffle')
AddEventHandler('ls-assets:client:seat:shuffle', function()
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        DisableSeatShuff = false
        Citizen.Wait(5000)
        DisableSeatShuff = true
    else
        CancelEvent()
    end
end)

RegisterNetEvent('ls-assets:client:me:show')
AddEventHandler('ls-assets:client:me:show', function(Text, Source)
    local PlayerId = GetPlayerFromServerId(Source)
    local IsDisplaying = true
    Citizen.CreateThread(function()
        local DisplayOffset = 0 + (DisplayCount * 0.14)
        DisplayCount = DisplayCount + 1
        while IsDisplaying do
            Citizen.Wait(4)
            local SourceCoords = GetEntityCoords(GetPlayerPed(PlayerId))
            local NearCoords = GetEntityCoords(PlayerPedId())
            local Distance = Vdist2(SourceCoords, NearCoords)
            if Distance < 25.0 then
                DrawText3D(SourceCoords.x, SourceCoords.y, SourceCoords.z + DisplayOffset, Text)
            end
        end
        DisplayCount = DisplayCount - 1
    end)
    Citizen.CreateThread(function()
        Citizen.Wait(6500)
        IsDisplaying = false
    end)
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Blips) do
        local Blips = AddBlipForCoord(Config.Blips[k]['X'], Config.Blips[k]['Y'], Config.Blips[k]['Z'])
        SetBlipSprite(Blips, Config.Blips[k]['SpriteId'])
        SetBlipDisplay(Blips, 4)
        SetBlipScale(Blips, Config.Blips[k]['Scale'])
        SetBlipAsShortRange(Blips, true)
        SetBlipColour(Blips, Config.Blips[k]['Color'])
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Blips[k]['Name'])
        EndTextCommandSetBlipName(Blips)
    end
end)

function LoadVehicles()
    Citizen.CreateThread(function()
        for k, v in pairs(LSCore.Shared.Vehicles) do
           if not HasModelLoaded(k) and (v['Class'] == 'custom' or v['Class'] == 'emergency') then
               RequestModel(k)
           end
           Citizen.Wait(100)
        end
    end)
end

function AddBlipToCoords(Coords, Sprite, Scale, Color, Text)
    Blips = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
    SetBlipSprite (Blips, Sprite)
    SetBlipDisplay(Blips, 4)
    SetBlipScale  (Blips, Scale)
    SetBlipAsShortRange(Blips, true)
    SetBlipColour(Blips, Color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Text)
    EndTextCommandSetBlipName(Blips)
end

-- // Brighter Lights \\ --
function stringsplit(inputstr, sep)
	  if sep == nil then
	  	sep = "%s"
	  end
	    local t={} ; i=1
	    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
	    	t[i] = str
	    	i = i + 1
	    end
	  return t
end

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

Citizen.CreateThread(function()
	  local settingsFile = LoadResourceFile(GetCurrentResourceName(), "misc/visualsettings.dat")
	  local lines = stringsplit(settingsFile, "\n")
	  for k,v in ipairs(lines) do
	  	  if not starts_with(v, '#') and not starts_with(v, '//') and (v ~= "" or v ~= " ") and #v > 1 then
	  	  	  v = v:gsub("%s+", " ")
	  	  	  local setting = stringsplit(v, " ")
	  	  	  if setting[1] ~= nil and setting[2] ~= nil and tonumber(setting[2]) ~= nil then
	  	  	  	  if setting[1] ~= 'weather.CycleDuration' then	
	  	  	  	  	Citizen.InvokeNative(GetHashKey('SET_VISUAL_SETTING_FLOAT') & 0xFFFFFFFF, setting[1], tonumber(setting[2])+.0)
	  	  	  	  end
	  	  	  end
	      end
	  end
end)

RegisterNUICallback('CheckDevtools', function()
   TriggerServerEvent('ls-assets:server:drop')
end)

function DrawText3D(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end