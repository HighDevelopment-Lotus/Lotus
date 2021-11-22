local LSCore, LoggedIn, InventorySaveData, CurrentStealNumber = exports['ls-core']:GetCoreObject(), false, {}, nil
local CurrentWeapon, CurrentDrop, CurrentVehicle, ShowingHotbar, UsingKey = nil, nil, nil, false, false

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

RegisterNetEvent('LSCore:Client:CloseNui')
AddEventHandler('LSCore:Client:CloseNui', function()
    SetNuiFocus(false, false)
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         LoggedIn = true
--     end)
-- end)

-- Code 

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 157, true)
            DisableControlAction(0, 158, true)
            DisableControlAction(0, 160, true)
            DisableControlAction(0, 164, true)
            DisableControlAction(0, 165, true)
            if IsDisabledControlJustReleased(0, 37) then
                LSCore.Functions.GetPlayerData(function(PlayerData)
                    if Config.CanOpenInventory and not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] then
                        CurrentVehicle, Type, Vehicle = CheckVehicle()
                        local DumpsterFound = ClosestContainer()
                        local JailContainerFound = ClosestJailContainer()
                        if CurrentVehicle ~= false and Type == 'Glovebox' then
                            TriggerServerEvent('ls-inventory-new:server:open:inventory:other', CurrentVehicle, 'Glovebox', 5, 30000)
                        elseif CurrentVehicle ~= false and Type == 'Trunk' and GetVehicleClass(Vehicle) ~= 8 and GetVehicleClass(Vehicle) ~= 13 then
                            if Config.TrunkClasses[GetVehicleClass(Vehicle)] ~= nil then
                                TriggerServerEvent('ls-inventory-new:server:open:inventory:other', CurrentVehicle, 'Trunk', Config.TrunkClasses[GetVehicleClass(Vehicle)]['MaxSlots'], Config.TrunkClasses[GetVehicleClass(Vehicle)]['MaxWeight'], Vehicle)
                            end
                        elseif DumpsterFound ~= nil then
                            local InventoryName = 'Container: '..math.floor(DumpsterFound.x)..';'..math.floor(DumpsterFound.y)
                            TriggerServerEvent('ls-inventory-new:server:open:inventory:other', InventoryName, 'Stash', 15, 1000000)
                        elseif JailContainerFound ~= nil and exports['ls-prison']:GetInJailStatus() then
                            local InventoryName = 'Jail Container: '..math.floor(JailContainerFound.x)..';'..math.floor(JailContainerFound.y)
                            TriggerServerEvent('ls-inventory-new:server:open:inventory:other', InventoryName, 'Stash', 15, 1000000)
                        elseif CurrentDrop ~= 0 then
                            TriggerServerEvent('ls-inventory-new:server:open:inventory:other', Config.Drops[CurrentDrop], 'Drop', 15, 100000)
                        else
                            SetTimecycleModifier('hud_def_blur')
                            SetTimecycleModifierStrength(1.0)
                            Config.CanOpenInventory = false
                            SetNuiFocus(true, true)
                            Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.5)
                            TriggerEvent('ls-inventory-new:client:open:anim')
                            PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
                            SendNUIMessage({
                                action = 'OpenInventory',
                                Items = FormatItemData(PlayerData.inventory),
                                Slots = Config.InventorySlots,
                                Weight = GetTotalWeight(PlayerData.inventory),
                                OtherExtra = false,
                            })
                        end
                    end
                end)
            end
            if IsDisabledControlJustReleased(0, 157) then
                LSCore.Functions.GetPlayerData(function(PlayerData)
                    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] and Config.CanOpenInventory and not UsingKey then
                        UsingKey = true
                        Citizen.SetTimeout(150, function()
                            TriggerServerEvent("ls-inventory-new:server:use:item", 1)
                            Citizen.Wait(100)
                            UsingKey = false
                        end)
                    end
                end)
            end
            if IsDisabledControlJustReleased(0, 158) then
                LSCore.Functions.GetPlayerData(function(PlayerData)
                    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] and Config.CanOpenInventory and not UsingKey then
                        UsingKey = true
                        Citizen.SetTimeout(150, function()
                            TriggerServerEvent("ls-inventory-new:server:use:item", 2)
                            Citizen.Wait(100)
                            UsingKey = false
                        end)
                    end
                end)
            end
            if IsDisabledControlJustReleased(0, 160) then
                LSCore.Functions.GetPlayerData(function(PlayerData)
                    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] and Config.CanOpenInventory and not UsingKey then
                        UsingKey = true
                        Citizen.SetTimeout(150, function()
                            TriggerServerEvent("ls-inventory-new:server:use:item", 3)
                            Citizen.Wait(100)
                            UsingKey = false
                        end)
                    end
                end)
            end
            if IsDisabledControlJustReleased(0, 164) then
                LSCore.Functions.GetPlayerData(function(PlayerData)
                    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] and Config.CanOpenInventory and not UsingKey then
                        UsingKey = true
                        Citizen.SetTimeout(150, function()
                            TriggerServerEvent("ls-inventory-new:server:use:item", 4)
                            Citizen.Wait(100)
                            UsingKey = false
                        end)
                    end
                end)
            end
            if IsDisabledControlJustReleased(0, 165) then
                LSCore.Functions.GetPlayerData(function(PlayerData)
                    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] and Config.CanOpenInventory and not UsingKey then
                        UsingKey = true
                        Citizen.SetTimeout(150, function()
                            TriggerServerEvent("ls-inventory-new:server:use:item", 5)
                            Citizen.Wait(100)
                            UsingKey = false
                        end)
                    end
                end)
            end
            if IsControlJustPressed(0, 20) then
                if not ShowingHotbar then
                    ShowingHotbar = true
                    SendNUIMessage({
                        action = "ShowHotbar",
                        Items = FormatItemData(LSCore.Functions.GetPlayerData().inventory),
                    })
                end
            end
            if IsControlJustReleased(0, 20) then
                if ShowingHotbar then
                    ShowingHotbar = false
                    SendNUIMessage({
                        action = "HideHotbar",
                    })
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearAnything = false
            for k, v in pairs(Config.Drops) do 
                if Config.Drops[k] ~= nil and Config.Drops[k]['Coords'] ~= nil then
                    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                    local Distance = #(PlayerCoords - v['Coords'])
                    if Distance < 1.5 then
                        CurrentDrop = k
                        NearAnything = true
                    end
                end
            end
            if not NearAnything then
                CurrentDrop = 0
                Citizen.Wait(450)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearAnything = false
            for k, v in pairs(Config.Drops) do
                if Config.Drops[k] ~= nil and Config.Drops[k]['Coords'] ~= nil then
                    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                    local Distance = #(PlayerCoords - v['Coords'])
                    if Distance <= 9.5 then
                        NearAnything = true
                        DrawMarker(32, v['Coords'].x, v['Coords'].y, v['Coords'].z - 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.65, 0.2, 237, 145, 47, 255, false, false, false, true, false, false, false)
                    end
                end
            end
            if not NearAnything then
                Citizen.Wait(1500)
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-inventory-new:client:sync:drops')
AddEventHandler('ls-inventory-new:client:sync:drops', function(ConfigData)
    Config.Drops = ConfigData
end)

RegisterNetEvent('ls-inventory-new:client:set:inventory:state')
AddEventHandler('ls-inventory-new:client:set:inventory:state', function(Bool)
    Config.CanOpenInventory = Bool
end)

RegisterNetEvent('ls-inventory-new:client:open:empty:other')
AddEventHandler('ls-inventory-new:client:open:empty:other', function()
    SetTimecycleModifier('hud_def_blur')
    SetTimecycleModifierStrength(1.0)
    Config.CanOpenInventory = false
    SetNuiFocus(true, true)
    Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.5)
    TriggerEvent('ls-inventory-new:client:open:anim')
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    SendNUIMessage({
        action = 'OpenInventory',
        Items = FormatItemData(LSCore.Functions.GetPlayerData().inventory),
        Slots = Config.InventorySlots,
        Weight = GetTotalWeight(LSCore.Functions.GetPlayerData().inventory),
        OtherExtra = 'Empty'
    })
end)

RegisterNetEvent('ls-inventory-new:client:open:inventory:other')
AddEventHandler('ls-inventory-new:client:open:inventory:other', function(OtherData)
    if OtherData['Type'] == 'Store' then
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
        SetNuiFocus(true, true)
        Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.5)
        SendNUIMessage({
            action = 'OpenInventory',
            Slots = Config.InventorySlots,
            Items = FormatItemData(LSCore.Functions.GetPlayerData().inventory),
            Weight = GetTotalWeight(LSCore.Functions.GetPlayerData().inventory),
            Other = OtherData,
            OtherMaxWeight = 1000000,
            OtherItems = FormatNoDataItems(OtherData['Items']),
            OtherExtra = false,
        })
        TriggerEvent('ls-inventory-new:client:open:anim')
    elseif OtherData['Type'] == 'Crafting' then
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
        SetNuiFocus(true, true)
        Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.5)
        SendNUIMessage({
            action = 'OpenInventory',
            Slots = Config.InventorySlots,
            Items = FormatItemData(LSCore.Functions.GetPlayerData().inventory),
            Weight = GetTotalWeight(LSCore.Functions.GetPlayerData().inventory),
            Other = OtherData,
            OtherMaxWeight = 1000000,
            OtherItems = OtherData['Items'],
            OtherExtra = false,
        })
        TriggerEvent('ls-inventory-new:client:open:anim')
    elseif OtherData['Type'] == 'Glovebox' or OtherData['Type'] == 'Trunk' or OtherData['Type'] == 'Stash' or OtherData['Type'] == 'TempStashes' then
            SetTimecycleModifier('hud_def_blur')
            SetTimecycleModifierStrength(1.0)
            PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
            SetNuiFocus(true, true)
            Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.5)
            SendNUIMessage({
                action = 'OpenInventory',
                Slots = Config.InventorySlots,
                Items = FormatItemData(LSCore.Functions.GetPlayerData().inventory),
                Weight = GetTotalWeight(LSCore.Functions.GetPlayerData().inventory),
                Other = OtherData,
                OtherMaxWeight = OtherData['MaxWeight'],
                OtherItems = FormatNoDataItems(OtherData['Items']),
                OtherExtra = false,
            })
            if OtherData['Type'] == 'Trunk' then
                exports['ls-assets']:RequestAnimationDict('mini@repair')
                TaskPlayAnim(GetPlayerPed(-1), 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 16, 0, 0, 0, 0);
                SetVehicleDoorOpen(OtherData['ExtraData'], 5, false, true)
            else
                TriggerEvent('ls-inventory-new:client:open:anim')
            end
    elseif OtherData['Type'] == 'Drop' then
            SetTimecycleModifier('hud_def_blur')
            SetTimecycleModifierStrength(1.0)
            PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
            SetNuiFocus(true, true)
            Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.5)
            SendNUIMessage({
                action = 'OpenInventory',
                Items = FormatItemData(LSCore.Functions.GetPlayerData().inventory),
                Slots = Config.InventorySlots,
                Weight = GetTotalWeight(LSCore.Functions.GetPlayerData().inventory),
                Other = OtherData,
                OtherMaxWeight = 100000,
                OtherItems = FormatNoDataItems(OtherData['Items']),
                OtherExtra = false,
            })
    else
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
        SetNuiFocus(true, true)
        Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.5)
        SendNUIMessage({
            action = 'OpenInventory',
            Slots = Config.InventorySlots,
            Items = FormatItemData(LSCore.Functions.GetPlayerData().inventory),
            Weight = GetTotalWeight(LSCore.Functions.GetPlayerData().inventory),
            Other = OtherData,
            OtherMaxWeight = OtherData['MaxWeight'],
            OtherItems = FormatItemData(OtherData['Items']),
            OtherExtra = false,
        })
        TriggerEvent('ls-inventory-new:client:open:anim')
    end
    Config.CanOpenInventory = false
end)

RegisterNetEvent('ls-inventory-new:client:open:anim')
AddEventHandler('ls-inventory-new:client:open:anim', function()
    exports['ls-assets']:RequestAnimationDict('pickup_object')
    TaskPlayAnim(GetPlayerPed(-1), 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    Citizen.Wait(650)
    ClearPedSecondaryTask(GetPlayerPed(-1))
end)

RegisterNetEvent('ls-inventory-new:client:item:box')
AddEventHandler('ls-inventory-new:client:item:box', function(Type, ItemData, Amount)
    local SendData = {['Image'] = ItemData['image'], ['Label'] = ItemData['label'], ['Amount'] = Amount, ['Type'] = Type}
    SendNUIMessage({
        action = "ShowItemBox",
        data = SendData
    })
end)

RegisterNetEvent('ls-inventory-new:client:set:required')
AddEventHandler('ls-inventory-new:client:set:required', function(ItemData, Bool)
    if Bool then
        SendNUIMessage({
            action = "ShowRequired",
            data = ItemData
        })
    else
        SendNUIMessage({action = "HideRequired"})
    end
end)

RegisterNetEvent('ls-inventory-new:client:update:drops')
AddEventHandler('ls-inventory-new:client:update:drops', function(DropData, DropId)
    Config.Drops[DropId] = DropData
end)

RegisterNetEvent('ls-inventory-new:client:use:weapon')
AddEventHandler('ls-inventory-new:client:use:weapon', function(ItemData)
    Citizen.SetTimeout(750, function()
        local WeaponName, Ammo = ItemData.name, ItemData.info ~= nil and ItemData.info.ammo
        if WeaponName == CurrentWeapon then
            TriggerEvent('ls-assets:client:do:holster:anim', 'weapon_unarmed')
            Citizen.SetTimeout(750, function()
                SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
                RemoveAllPedWeapons(GetPlayerPed(-1), true)
                TriggerEvent('ls-weapons:client:set:current:weapon', nil)
                CurrentWeapon = nil
            end)
        elseif WeaponName == "weapon_stickybomb" then
            TriggerEvent('ls-assets:client:do:holster:anim', WeaponName)
            Citizen.SetTimeout(500, function()
                GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(WeaponName), 1, false, false)
                SetPedAmmo(GetPlayerPed(-1), GetHashKey(WeaponName), 1)
                SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(WeaponName), true)
                TriggerEvent('ls-weapons:client:set:current:weapon', ItemData)
                CurrentWeapon = WeaponName
            end)
        elseif WeaponName == "weapon_molotov" or WeaponName == "weapon_brick" or WeaponName == 'weapon_flare' or WeaponName == 'weapon_smokegrenade' or WeaponName == 'weapon_shoe' then
            TriggerEvent('ls-assets:client:do:holster:anim', WeaponName)
            Citizen.SetTimeout(500, function()
                GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(WeaponName), 1, false, false)
                SetPedAmmo(GetPlayerPed(-1), GetHashKey(WeaponName), 1)
                SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(WeaponName), true)
                TriggerEvent('ls-weapons:client:set:current:weapon', ItemData)
                CurrentWeapon = WeaponName
            end)
        elseif WeaponName == "weapon_sniperrifle2" then
            if exports['ls-jobmanager']:IsNearHunting() then
                TriggerEvent('ls-assets:client:do:holster:anim', WeaponName)
                Citizen.SetTimeout(500, function()
                    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(WeaponName), Ammo, false, false)
                    SetPedAmmo(GetPlayerPed(-1), GetHashKey(WeaponName), Ammo)
                    SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(WeaponName), true)
                    TriggerEvent('ls-weapons:client:set:current:weapon', ItemData)
                    CurrentWeapon = WeaponName  
                end)
            end
        else
            TriggerEvent('ls-assets:client:reset:holster')
            Citizen.SetTimeout(15, function()
                TriggerEvent('ls-assets:client:do:holster:anim', WeaponName)
                Citizen.SetTimeout(500, function()
                    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(WeaponName), Ammo, false, false)
                    SetPedAmmo(GetPlayerPed(-1), GetHashKey(WeaponName), Ammo)
                    SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(WeaponName), true)
                    local Attachments =  HasAnyAttachments()
                    if Attachments ~= nil then
                        for k, v in pairs(Attachments) do
                            GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(WeaponName), GetHashKey(Config.Attachments[v][WeaponName]))
                        end
                    end
                    if WeaponName == 'weapon_pistol_mk2' then
                        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(WeaponName), GetHashKey('COMPONENT_AT_PI_FLSH_02'))
                    elseif WeaponName == 'weapon_m4' then
                        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(WeaponName), GetHashKey('COMPONENT_AT_M4_FLSH'))
                        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(WeaponName), GetHashKey('COMPONENT_AT_M4_AFGRIP'))
                        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(WeaponName), GetHashKey('COMPONENT_AT_SCOPE_M4'))
                    end
                    TriggerEvent('ls-weapons:client:set:current:weapon', ItemData)
                    CurrentWeapon = WeaponName
                end)
            end)
        end
    end)
end)

RegisterNetEvent("ls-inventory-new:client:reset:weapon")
AddEventHandler("ls-inventory-new:client:reset:weapon", function()
    TriggerEvent('ls-assets:client:reset:holster')
    Citizen.SetTimeout(100, function()
        DisablePlayerFiring(PlayerId(), false)
        SetPlayerCanDoDriveBy(PlayerId(), true)
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(GetPlayerPed(-1), true)
        TriggerEvent('ls-weapons:client:set:current:weapon', nil)
        CurrentWeapon = nil
    end)
end)

RegisterNetEvent("ls-inventory-new:client:show:button:steal")
AddEventHandler("ls-inventory-new:client:show:button:steal", function(TargetId)
    CurrentStealNumber = TargetId
    SendNUIMessage({action = "ShowStealButton"})
end)

RegisterNetEvent("ls-inventory-new:client:force:close")
AddEventHandler("ls-inventory-new:client:force:close", function()
    SendNUIMessage({action = "ForceClose"})
end)

RegisterNetEvent("ls-inventory-new:client:update:player")
AddEventHandler("ls-inventory-new:client:update:player", function()
    if not Config.CanOpenInventory then
        local PlayerData = LSCore.Functions.GetPlayerData()
        SendNUIMessage({
            action = 'RefreshInventory',
            Slots = Config.InventorySlots,
            Items = FormatItemData(PlayerData.inventory),
            Weight = GetTotalWeight(PlayerData.inventory),
        })
    end
end)

RegisterNetEvent("ls-inventory-new:client:craft")
AddEventHandler("ls-inventory-new:client:craft", function(ItemName, Amount, ToSlot, Info, Cost)
    SendNUIMessage({action = "ForceClose"})
    Citizen.SetTimeout(550, function()
        Config.CanOpenInventory = false
        LSCore.Functions.Progressbar("repair_vehicle", "Bezig met craften..", math.random(5000, 7500), false, true, {
	    	disableMovement = true,
	    	disableCarMovement = true,
	    	disableMouse = false,
	    	disableCombat = true,
	    }, {
	    	animDict = "mini@repair",
	    	anim = "fixing_a_player",
	    	flags = 16,
	    }, {}, {}, function() -- Done
	    	StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
            TriggerServerEvent("LSCore:Server:SetMetaData", "iscrafting", false)
            TriggerServerEvent("ls-inventory-new:server:done:crafting", ItemName, Amount, ToSlot, Info, Cost)
            Config.CanOpenInventory = true
	    end, function() -- Cancel
	    	StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
            Config.CanOpenInventory = true
	    end)
    end)
end)

-- // Functions \\ --

function CheckVehicle()
    local Vehicle = LSCore.Functions.GetClosestVehicle()
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)))
        return Plate, 'Glovebox', Vehicle
    elseif not IsPedInAnyVehicle(GetPlayerPed(-1)) and Vehicle ~= 0 and Vehicle ~= nil and GetVehicleDoorLockStatus(Vehicle) < 2 then
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        local TrunkCoords = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -2.5, 0)
        local Distance = #(PlayerCoords - TrunkCoords)
        if Distance < 1.5 then
            local Plate = GetVehicleNumberPlateText(Vehicle)
            return Plate, 'Trunk', Vehicle
        end
    else
        return false, nil
    end
end

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

function FormatNoDataItems(ItemData) 
    local ReturnData = {}
    for k, v in pairs(ItemData) do
        local Data = Shared.ItemList[v.name:lower()]
        ReturnData[v.slot] = {
            ['Label'] = Data['label'],
            ['ItemName'] = v.name,
            ['Slot'] = v.slot,
            ['Type'] = Data['type'],
            ['Unique'] = Data['unique'],
            ['Amount'] = v.amount,
            ['Image'] = Data['image'],
            ['Weight'] = Data['weight'],
            ['Info'] = v.info,
            ['Price'] = v.price ~= nil and v.price or 0,
            ['Description'] = Data['description'],
            ['Combinable'] = Data['combinable'],
        }
    end
    return ReturnData
end

function ClosestContainer()
    for k, v in pairs(Config.Dumpsters) do
        local StartShape = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.1, 0)
        local EndShape = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.8, -0.4)
        local RayCast = StartShapeTestRay(StartShape.x, StartShape.y, StartShape.z, EndShape.x, EndShape.y, EndShape.z, 16, GetPlayerPed(-1), 0)
        local Retval, Hit, Coords, Surface, EntityHit = GetShapeTestResult(RayCast)
        local BinModel = 0
        if EntityHit then
            BinModel = GetEntityModel(EntityHit)
        end
        if v['Model'] == BinModel then
            local EntityHitCoords = GetEntityCoords(EntityHit)
            if EntityHitCoords.x < 0 or EntityHitCoords.y < 0 then
                EntityHitCoords = {x = EntityHitCoords.x + 5000,y = EntityHitCoords.y + 5000}
            end
            return EntityHitCoords
        end
    end
end

function ClosestJailContainer()
    for k, v in pairs(Config.JailContainers) do
        local StartShape = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.1, 0)
        local EndShape = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.8, -0.4)
        local RayCast = StartShapeTestRay(StartShape.x, StartShape.y, StartShape.z, EndShape.x, EndShape.y, EndShape.z, 16, GetPlayerPed(-1), 0)
        local Retval, Hit, Coords, Surface, EntityHit = GetShapeTestResult(RayCast)
        local BinModel = 0
        if EntityHit then
            BinModel = GetEntityModel(EntityHit)
        end
        if v['Model'] == BinModel then
            local EntityHitCoords = GetEntityCoords(EntityHit)
            if EntityHitCoords.x < 0 or EntityHitCoords.y < 0 then
                EntityHitCoords = {x = EntityHitCoords.x + 5000,y = EntityHitCoords.y + 5000}
            end
            return EntityHitCoords
        end
    end
end

function CanOpenInventory()
    return Config.CanOpenInventory
end

function GetItemData(ItemName)
	return Shared.ItemList[ItemName]
end

function GetTotalWeight(Inventory)
    local ReturnWeight = 0
	for k, v in pairs(Inventory) do
		ReturnWeight = ReturnWeight + (v.weight * v.amount)
	end
	return ReturnWeight
end

function HasAnyAttachments()
    local ReturnItems = {}
    local PlayerData = LSCore.Functions.GetPlayerData()
    for k, v in pairs(PlayerData.inventory) do
        if Config.Attachments[v.name] ~= nil then
            table.insert(ReturnItems, v.name)
        end
    end
    return ReturnItems
end

function HasEnoughOfItem(ItemName, Amount)
    local PlayerData = LSCore.Functions.GetPlayerData()
    for k, v in pairs(PlayerData.inventory) do
        if v.name == ItemName and v.amount >= Amount then
            return true
        end
    end
    return false
end

RegisterNUICallback('IsHoldingWeapon', function(data, cb)
    local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    if Weapon ~= GetHashKey('weapon_unarmed') and IsPedArmed(GetPlayerPed(-1), 6) then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNUICallback('UseItem', function(data)
    Citizen.SetTimeout(300, function()
        TriggerServerEvent('ls-inventory-new:server:use:item', data.Slot)
    end)
end)

RegisterNUICallback('RefreshInv', function(data)
    SendNUIMessage({
        action = 'RefreshInventory',
        Slots = Config.InventorySlots,
        Items = FormatItemData(LSCore.Functions.GetPlayerData().inventory),
        Weight = GetTotalWeight(LSCore.Functions.GetPlayerData().inventory),
    })
end)

RegisterNUICallback('DoItemData', function(data, cb)
    local SendData = {['Amount'] = data.Amount, ['ToSlot'] = data.ToSlot, ['FromSlot'] = data.FromSlot, ['ToInventory'] = data.ToInv, ['FromInventory'] = data.FromInv, ['Type'] = data.Type, ['SubType'] = data.SubType, ['OtherItems'] = data.OtherItems, ['ExtraData'] = data.ExtraData, ['MaxOtherWeight'] = data.MaxOtherWeight}
    LSCore.Functions.TriggerCallback('ls-inventory:server:do:item:data', function(DidData)
        cb(DidData)
    end, SendData)
end)

RegisterNUICallback('CloseInventory', function(data)
    Config.CanOpenInventory = true
    SetTimecycleModifier('default')
    if IsEntityPlayingAnim(PlayerPedId(), 'mini@repair', 'fixing_a_player', 3) then
        SetVehicleDoorShut(Vehicle, 5, false, true)
        StopAnimTask(PlayerPedId(), 'mini@repair', 'fixing_a_player', 1.0)
    else
        TriggerEvent('ls-inventory-new:client:open:anim')
    end
    if data.OtherInv ~= 'Crafting' then
        TriggerServerEvent("LSCore:Server:SetMetaData", "iscrafting", false)
    end
    TriggerServerEvent('ls-inventory-new:server:check:other', data.OtherInv, data.OtherName)
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    CurrentStealNumber = nil
    CurrentVehicle = nil
    UsingKey = false
    SetNuiFocus(false, false)
end)

RegisterNUICallback('StealMoney', function()
    TriggerServerEvent('ls-inventory-new:server:steal:money', CurrentStealNumber)
    CurrentStealNumber = nil
end)

RegisterNUICallback('ResetWeapons', function()
    TriggerEvent('ls-inventory-new:client:reset:weapon')
end)

RegisterNUICallback('ErrorSound', function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('CopyToClipboard', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    LSCore.Functions.Notify("Item info gekopieerd naar je clipbord!")
end)

RegisterNUICallback('SuccessSound', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('SaveInventory', function(data)
    if data.Type == 'TableInput' then
        local InventoryData = data.InventoryData
        InventorySaveData[tonumber(InventoryData['Slot'])] = {
            label = InventoryData['Label'],
	    	name = InventoryData['ItemName'],
	    	slot = tonumber(InventoryData['Slot']),
	    	type = InventoryData['Type'],
	    	unique = InventoryData['Unique'],
	    	amount = InventoryData['Amount'],
	    	image = InventoryData['Image'],
	    	weight = InventoryData['Weight'],
	    	info = InventoryData['Info'],
	    	description = InventoryData['Description'],
	    	combinable = InventoryData['Combinable'],
        }
    elseif data.Type == 'SaveNow' then
        TriggerServerEvent('ls-inventory-new:server:set:player:items', InventorySaveData)
        InventorySaveData = {}
    end
end)

RegisterNUICallback('CombineItems', function(data)
    Citizen.SetTimeout(1500, function()
        Config.CanOpenInventory = false
        LSCore.Functions.Progressbar("repair_vehicle", "Spullen Combineren..", math.random(5000, 6500), false, true, {
	    	disableMovement = false,
	    	disableCarMovement = false,
	    	disableMouse = false,
	    	disableCombat = true,
	    }, {
	    	animDict = "amb@world_human_clipboard@male@idle_a",
	    	anim = "idle_c",
	    	flags = 49,
	    }, {}, {}, function() -- Done
	    	StopAnimTask(GetPlayerPed(-1), "amb@world_human_clipboard@male@idle_a", "idle_c", 1.0)
            TriggerServerEvent("ls-inventory-new:server:done:combinding", data.FromSlot, data.FromItem, data.ToSlot, data.ToItem, data.Reward)
            Config.CanOpenInventory = true
	    end, function() -- Cancel
	    	StopAnimTask(GetPlayerPed(-1), "amb@world_human_clipboard@male@idle_a", "idle_c", 1.0)
            Config.CanOpenInventory = true
	    end)
    end)
end)