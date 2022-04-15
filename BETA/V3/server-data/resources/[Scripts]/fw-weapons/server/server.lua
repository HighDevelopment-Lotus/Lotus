local LSCore = exports['fw-base']:GetCoreObject()

-- Code

LSCore.Commands.Add("addammo", "Geef kogels voor het wapen wat je vast hebt", {{name="Hoeveelheid", help="hoeveel kogels?"}}, true, function(source, args)
    if args[1] ~= nil then
      TriggerClientEvent('framework-weapons:client:set:ammo', source, args[1])
    end
end, "admin")

LSCore.Functions.CreateUseableItem("pistol_ammo", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-weapons:client:reload:ammo', source, 'AMMO_PISTOL', 'pistol_ammo')
    end
end)

LSCore.Functions.CreateUseableItem("rifle_ammo", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-weapons:client:reload:ammo', source, 'AMMO_RIFLE', 'rifle_ammo')
    end
end)

LSCore.Functions.CreateUseableItem("smg_ammo", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-weapons:client:reload:ammo', source, 'AMMO_SMG', 'smg_ammo')
    end
end)

LSCore.Functions.CreateUseableItem("shotgun_ammo", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-weapons:client:reload:ammo', source, 'AMMO_SHOTGUN', 'shotgun_ammo')
    end
end)

LSCore.Functions.CreateUseableItem("taser_ammo", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-weapons:client:reload:ammo', source, 'AMMO_TAZER', 'taser_ammo')
    end
end)

LSCore.Functions.CreateUseableItem("paintball_ammo", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-weapons:client:reload:ammo', source, 'AMMO_PAINTBALL', 'paintball_ammo')
    end
end)

RegisterServerEvent('framework-weapons:server:update:quality')
AddEventHandler('framework-weapons:server:update:quality', function(data)
    if data ~= nil and data.name ~= nil then
        local Player = LSCore.Functions.GetPlayer(source)
        local WeaponData = Config.WeaponsList[GetHashKey(data.name)]
        local WeaponSlot = Player.PlayerData.inventory[data.slot]
        local DecreaseAmount = Config.DurabilityMultiplier[data.name] ~= nil and Config.DurabilityMultiplier[data.name] or 0.10
        if WeaponSlot ~= nil then
            if not IsWeaponBlocked(WeaponData['IdName']) then
                if WeaponSlot.info.quality ~= nil then
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('framework-inv:client:reset:weapon', source)
                        TriggerClientEvent('LSCore:Notify', source, "Jouw wapen is gebroken.", "error")
                    end
                    Player.Functions.SetItemData(Player.PlayerData.inventory)
                end
            end
        end
    else
        TriggerClientEvent('framework-inv:client:reset:weapon', source)
    end
end)

RegisterServerEvent("framework-weapons:server:update:weapon:ammo")
AddEventHandler('framework-weapons:server:update:weapon:ammo', function(CurrentWeaponData, Amount)
    local Player = LSCore.Functions.GetPlayer(source)
    local Amount = tonumber(Amount)
    if CurrentWeaponData ~= nil then
        if Player.PlayerData.inventory[CurrentWeaponData.slot] ~= nil then
            Player.PlayerData.inventory[CurrentWeaponData.slot].info.ammo = Amount
        end
        Player.Functions.SetItemData(Player.PlayerData.inventory)
    end
end)

-- // Functions \\ --

function IsWeaponBlocked(WeaponName)
    for k, v in pairs(Config.DurabilityBlockedWeapons) do
        if v == WeaponName then
          return true
        end 
    end
    return false
end

function GetWeaponList(Weapon)
    return Config.WeaponsList[Weapon]
end