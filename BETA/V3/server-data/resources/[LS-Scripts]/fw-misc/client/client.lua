-- LSCore = exports['fw-base']:GetCoreObject()
local strength = 0
local stamina = 0
local shooting = 0
local openui = false

local NearShop, CurrentShop = false, nil
RegisterNetEvent("LSCore:Client:OnPlayerLoaded")
AddEventHandler("LSCore:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(2750, function()
      LSCore.Functions.GetPlayerData(function(PlayerData)
        strength = PlayerData.metadata['drugs']
        stamina = PlayerData.metadata['baan']
        shooting = PlayerData.metadata['runs']
      end)
      LoggedIn = true
    end) 
end)

-- Citizen.CreateThread(function()
-- 		Citizen.SetTimeout(1500, function()
-- 			if LoggedIn then
-- 				LSCore.Functions.GetPlayerData(function(PlayerData)
-- 					strengthv = PlayerData.metadata['drugs']
-- 					staminav = PlayerData.metadata['baan']
-- 					shootingv = PlayerData.metadata['runs']
-- 				end)
-- 			end	
-- 		end)
-- end)
   
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

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if LoggedIn then
            NearShop = false
            for k, v in pairs(Config.Shops) do
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                if Distance < 2.5 then
                    NearShop = true
                    CurrentShop = k
                end
            end
            if not NearShop then
                Citizen.Wait(1000)
                CurrentShop = nil
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-stores:server:open:shop')
AddEventHandler('framework-stores:server:open:shop', function()
    print(CurrentShop)
    Citizen.SetTimeout(350, function()
        if CurrentShop ~= nil then 
            if CanOpenShop(CurrentShop) then
                if exports['fw-inv']:CanOpenInventory() then
                    local Shop = {['Type'] = 'Store', ['InvName'] = Config.Shops[CurrentShop]['Name'], ['Items'] = Config.Shops[CurrentShop]['Product']}
                    TriggerServerEvent('framework-inv:server:open:inventory:other', Shop, 'Store')
                end
            end
        end
    end)
end)

RegisterNetEvent('framework-stores:client:open:custom:store')
AddEventHandler('framework-stores:client:open:custom:store', function(ProductName)
    if exports['fw-inv']:CanOpenInventory() then
        local Shop = {['Type'] = 'Store', ['InvName'] = ProductName, ['Items'] = Config.Products[ProductName]}
        TriggerServerEvent('framework-inv:server:open:inventory:other', Shop, 'Store')
    end
end)

-- // Functions \\ --

function CanOpenShop(Storenumber)
    local PlayerData = LSCore.Functions.GetPlayerData()
    if Storenumber == 29 then
        print('Hunting')
        if PlayerData.metadata['licences']['hunting'] ~= nil then
            return true
        else
            LSCore.Functions.Notify('Je hebt geen jachtvergunning..', 'error')
            return false
        end
    else
        return true
    end
end

function IsNearStore()
    return NearShop
end

function GetStoreNumber()
    return CurrentShop
end

RegisterCommand('skills', function()
	if not openui then
		EnableGui(true)
		openui = true
	else
		EnableGui(false)
		openui = false
	end
end)

function EnableGui(enable)
    LSCore.Functions.GetPlayerData(function(PlayerData)
			SendNUIMessage({
				type = "enableui",
				enable = enable,
				strength = PlayerData.metadata['drugs'],
				stamina = PlayerData.metadata['baan'],
				shooting = PlayerData.metadata['runs']
			})
	end)
end

-- Weapon sling
local attached_weapons = {}
local hotbar = {}
local sling = "Back"

function FormatItemData(ItemData) 
    local ReturnData = {}
    for k, v in pairs(ItemData) do
        ReturnData[v.slot] = {
            ['Label'] = v.label,
            ['ItemName'] = v.name,
            ['Slot'] = v.slot,
            ['Type'] = v.type,
            ['Unique'] = v.unique,
            ['Amount'] = v.amount,
            ['Image'] = v.image,
            ['Weight'] = v.weight,
            ['Info'] = v.info,
            ['Description'] = v.description,
            ['Combinable'] = v.combinable,
        }
    end
    return ReturnData
end


Citizen.CreateThread(function()
  while true do
    if LoggedIn then
        local me = PlayerPedId()
        local items = FormatItemData(LSCore.Functions.GetPlayerData().inventory)
        if items ~= nil then 
          hotbar = { items[1], items[2], items[3], items[4], items[5], items[6] }
          for slot, item in pairs(hotbar) do
            if item ~= nil and item.Type == "weapon" and Config.Hashes[item.ItemName] ~= nil then
              local wep_model = Config.Hashes[item.ItemName].model
              local wep_hash = Config.Hashes[item.ItemName].hash
              
              if not attached_weapons[wep_model] and GetSelectedPedWeapon(me) ~= wep_hash then
                  AttachWeapon(wep_model, wep_hash, Config.Positions[sling].bone, Config.Positions[sling].x, Config.Positions[sling].y, Config.Positions[sling].z, Config.Positions[sling].x_rotation, Config.Positions[sling].y_rotation, Config.Positions[sling].z_rotation)
              end
            end
          end
          for key, attached_object in pairs(attached_weapons) do
              if GetSelectedPedWeapon(me) == attached_object.hash or not inHotbar(attached_object.hash) then -- equipped or not in weapon wheel
                DeleteObject(attached_object.handle)
                attached_weapons[key] = nil
              end
          end
        end
    end
    Wait(500)
  end
end)

function inHotbar(hash)
  for slot, item in pairs(hotbar) do
    if item ~= nil and item.Type == "weapon" and Config.Hashes[item.ItemName] ~= nil then
      if hash == GetHashKey(item.ItemName) then
        return true
      end
    end
  end
  return false
end

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR)
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end

  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
  }

	AttachEntityToEntity(attached_weapons[attachModel].handle, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

RegisterNetEvent('framework-misc:client:sling')
AddEventHandler('framework-misc:client:sling', function()
    if sling == "Back" then 
      sling = "Front"
    else
      sling = "Back"
    end
end)