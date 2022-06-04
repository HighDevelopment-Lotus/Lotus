local NearBobcat, InteriorId = false, nil
local NearThermite, NearCard, NearExplosion = false, false, false
local ShowingItemsFirst, ShowingItemsSecond, ShowingItemsThird = false, false
local ThermiteData, CardData, ExplosiveData, NeededItemsFirst, NeededItemsSecond, NeededItemsThird = {}, {}, {}, {}, {}, {}

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    ThermiteData = exports['fw-inv']:GetItemData('heavy-thermite')
    CardData = exports['fw-inv']:GetItemData('black-card')
    ExplosiveData = exports['fw-inv']:GetItemData('explosive')
    NeededItemsFirst = {[1] = {['Label'] = ThermiteData['label'], ['Image'] = ThermiteData["image"]}}
    NeededItemsSecond = {[1] = {['Label'] = CardData['label'], ['Image'] = CardData["image"]}}
    NeededItemsThird = {[1] = {['Label'] = ExplosiveData['label'], ['Image'] = ExplosiveData["image"]}}
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Interior = GetInteriorAtCoords(PlayerCoords)
            if Interior == InteriorId then
                NearBobcat = true
            else
                NearBobcat = false
            end
            Citizen.Wait(450)
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and NearBobcat then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - vector3(Config.MainDoorsCoords.x, Config.MainDoorsCoords.y, Config.MainDoorsCoords.z))
            if Distance < 1.0 and not Config.MainDoorsThermited and CurrentCops >= Config.CopsNeeded then
                NearThermite = true
                if not ShowingItemsFirst then
                    ShowingItemsFirst = true
                    TriggerEvent('framework-inv:client:set:required', NeededItemsFirst, true)
                end
            else
                if ShowingItemsFirst then
                    ShowingItemsFirst = false
                    TriggerEvent('framework-inv:client:set:required', NeededItemsFirst, false)
                end
                NearThermite = false
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and NearBobcat then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - vector3(Config.SecondDoorsCoords.x, Config.SecondDoorsCoords.y, Config.SecondDoorsCoords.z))
            if Distance < 1.0 and not Config.SecondDoorsUsedCard and CurrentCops >= Config.CopsNeeded then
                NearCard = true
                if not ShowingItemsSecond then
                    ShowingItemsSecond = true
                    TriggerEvent('framework-inv:client:set:required', NeededItemsSecond, true)
                end
            else
                if ShowingItemsSecond then
                    ShowingItemsSecond = false
                    TriggerEvent('framework-inv:client:set:required', NeededItemsSecond, false)
                end
                NearCard = false
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and NearBobcat then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - vector3(Config.BlowVaultCoords.x, Config.BlowVaultCoords.y, Config.BlowVaultCoords.z))
            if Distance < 1.0 and not Config.IsBobcatExploded and CurrentCops >= Config.CopsNeeded then
                NearExplosion = true
                if not ShowingItemsThird then
                    ShowingItemsThird = true
                    TriggerEvent('framework-inv:client:set:required', NeededItemsThird, true)
                end
            else
                if ShowingItemsThird then
                    ShowingItemsThird = false
                    TriggerEvent('framework-inv:client:set:required', NeededItemsThird, false)
                end
                NearExplosion = false
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --
RegisterNetEvent('framework-heists:client:bobcat:reset')
AddEventHandler('framework-heists:client:bobcat:reset', function()
    Config.IsBobcatExploded = false
    Config.MainDoorsThermited = false
    Config.SecondDoorsUsedCard = false
end)

RegisterNetEvent('framework-heists:client:bobcat:set:map')
AddEventHandler('framework-heists:client:bobcat:set:map', function(Type)
    if Type:lower() == 'exploded' then
        Config.IsBobcatExploded = true
        DeactivateInteriorEntitySet(InteriorId, "np_prolog_clean")
        ActivateInteriorEntitySet(InteriorId, "np_prolog_broken")
        RefreshInterior(InteriorId)
    else
        Config.IsBobcatExploded = false
        DeactivateInteriorEntitySet(InteriorId, "np_prolog_broken")
        ActivateInteriorEntitySet(InteriorId, "np_prolog_clean")
        RefreshInterior(InteriorId)
    end
end)

RegisterNetEvent('framework-items:client:use:heavy-thermite')
AddEventHandler('framework-items:client:use:heavy-thermite', function()
    if NearThermite then
        if not Config.MainDoorsThermited then
            if CurrentCops >= Config.CopsNeeded then
                TriggerEvent('framework-inv:client:set:inventory:state', false)
                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'heavy-thermite', 1, false)
                TriggerEvent('framework-inv:client:set:required', NeededItemsFirst, false)
                TriggerEvent('framework-assets:client:thermite:anim', Config.MainDoorsCoords)
                Citizen.Wait(6500)
                exports['fw-ui']:StartBlocksGame(function(Outcome)
                    if Outcome then
                        RequestNamedPtfxAsset("scr_ornate_heist")
                        SetPtfxAssetNextCall("scr_ornate_heist")
                        local Effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", Config.MainDoorsCoords, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                        Citizen.Wait(10000)
                        StopParticleFxLooped(Effect, 0)
                        TriggerEvent('framework-assets:client:reset:thermite:anim')
                        TriggerServerEvent('framework-heists:server:bobcat:set:door:thermited', true)
                        TriggerEvent('framework-inv:client:set:inventory:state', true)
                        Citizen.SetTimeout(75, function()
                            ShowingItemsFirst = false
                        end)
                    else
                        Citizen.SetTimeout(200, function()
                            ShowingItemsFirst = false
                        end)
                        TriggerEvent('framework-inv:client:set:inventory:state', true)
                        TriggerEvent('framework-assets:client:reset:thermite:anim')
                    end
                end)
            else
                LSCore.Functions.Notify("Niet genoeg agenten..", "info")
            end
        else
            LSCore.Functions.Notify("Deze deur is al open gebrand..", "error")
        end
    end
end)

RegisterNetEvent('framework-items:client:use:black-card')
AddEventHandler('framework-items:client:use:black-card', function()
    if NearCard then
        if not Config.SecondDoorsUsedCard then
            if CurrentCops >= Config.CopsNeeded then
                exports['minigame-shape']:StartShapeGame(function(Outcome)
                    if Outcome then
                        LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'black-card', 1, false)
                        TriggerServerEvent('framework-heists:server:bobcat:set:door:card', true)
                        TriggerEvent('framework-inv:client:set:required', NeededItemsSecond, false)
                        -- SpawnSecurity()
                        Citizen.SetTimeout(75, function()
                            ShowingItemsSecond = false
                        end)
                    else
                        ShowingItemsSecond = true
                        TriggerEvent('framework-inv:client:set:required', NeededItemsSecond, true)
                        LSCore.Functions.Notify("Je faalde..", "error")
                    end
                end)
            else
                LSCore.Functions.Notify("Niet genoeg agenten..", "info")
            end
        else
            LSCore.Functions.Notify("Deze deur is al open..", "error")
        end
    end
end)

RegisterNetEvent('framework-items:client:use:explosive')
AddEventHandler('framework-items:client:use:explosive', function()
    if NearExplosion then
        if not Config.IsBobcatExploded then
            if CurrentCops >= Config.CopsNeeded then
                local Coords = vector3(890.47, -2284.56, 32.44)
                local Rotation = vec3(180.0, 180.0, 0.0)
                TriggerEvent('framework-inv:client:set:inventory:state', false)
                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'explosive', 1, false)
                TriggerEvent('framework-assets:client:explosion:anim', Coords, Rotation)
                LSCore.Functions.Progressbar("lockpick-door", "Explosieve plaatsen..", 6000, false, false, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = false,
                }, {}, {}, {}, function() -- Done
                    TriggerEvent('framework-inv:client:set:inventory:state', true)
                    Citizen.SetTimeout(6000, function()
                        TriggerEvent('framework-assets:client:reset:expolsion:anim')
                        TriggerServerEvent('framework-heists:server:bobcat:explosion')
                        TriggerServerEvent('framework-heists:server:bobcat:set:vault:door', true)
                        TriggerEvent('framework-heists:client:bobcat:activate:loot')
                    end)
                end, function() -- Cancel
                end)
            else
                LSCore.Functions.Notify("Niet genoeg agenten..", "info")
            end
        end
    end
end)

RegisterNetEvent('framework-heists:client:bobcat:try:grab:trolly')
AddEventHandler('framework-heists:client:bobcat:try:grab:trolly', function()
    if CurrentCops >= Config.CopsNeeded then
        local Player, Distance = LSCore.Functions.GetClosestPlayer()
        if Player ~= -1 and Distance < 4.15 then
            LSCore.Functions.Notify("Uhm volgensmij is er iemand anders ook in de buurt..", "error")
        else
            TriggerEvent('framework-inv:client:set:inventory:state', false)
            TriggerEvent('framework-heists:client:trolly:grab', 'Money', GetClosestObjectOfType(GetEntityCoords(ped), 1.0, GetHashKey("ch_prop_ch_cash_trolly_01c"), false, false, false), 'Bobcat')
            
            LSCore.Functions.Progressbar("lockpick-door", "Trolly leeghalen..", 40300, false, false, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                TriggerEvent('framework-inv:client:set:inventory:state', true)
            end, function() -- Cancel
                -- Kan je niet cancelen
            end)
        end 
    else
        LSCore.Functions.Notify("Niet genoeg agenten..", "info")
    end   
end)

RegisterNetEvent('framework-heists:client:bobcat:try:grab:crate')
AddEventHandler('framework-heists:client:bobcat:try:grab:crate', function()
    if CurrentCops >= Config.CopsNeeded then
        local Player, Distance = LSCore.Functions.GetClosestPlayer()
        if Player ~= -1 and Distance < 4.15 then
            LSCore.Functions.Notify("Uhm volgensmij is er iemand anders ook in de buurt..", "error")
        else
            TriggerEvent('framework-inv:client:set:inventory:state', false)
            TriggerEvent('framework-heists:client:trolly:grab:crate', 12000, GetClosestObjectOfType(GetEntityCoords(ped), 1.0, GetHashKey("prop_mil_crate_02"), false, false, false), 'Bobcat')
            LSCore.Functions.Progressbar("lockpick-door", "Krat Openbreken..", 12000, false, false, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                TriggerEvent('framework-inv:client:set:inventory:state', true)
            end, function() -- Cancel
                -- Kan je niet cancelen
            end)
        end 
    else
        LSCore.Functions.Notify("Niet genoeg agenten..", "info")
    end   
end)

RegisterNetEvent('framework-heists:client:bobcat:explosion')
AddEventHandler('framework-heists:client:bobcat:explosion', function()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
	if #(PlayerCoords - vector3(890.80, -2284.75, 32.44)) < 100 then	
        RequestNamedPtfxAsset('scr_josh3')
		while not HasNamedPtfxAssetLoaded('scr_josh3') do
			Citizen.Wait(1)
		end	
		UseParticleFxAssetNextCall('scr_josh3')
		local Explosion = StartParticleFxLoopedAtCoord("scr_josh3_explosion", 890.80, -2284.75, 32.44, 0.0, 0.0, 0.0, 3.0, false, false, false, 0)		
		PlaySoundFromCoord(-1, "MAIN_EXPLOSION_CHEAP", 890.80, -2284.75, 32.44, 0, 0, 100, 0)
	end
end)

RegisterNetEvent('framework-heists:client:bobcat:activate:loot')
AddEventHandler('framework-heists:client:bobcat:activate:loot', function()
    local CoordsFirst = vector4(881.37, -2282.40, 32.44, 227.74)
    CreateTrolly(CoordsFirst)
    Citizen.Wait(1000)
    local CoordsSecond = vector4(886.73, -2282.44, 32.44, 171.84)
    CreateTrolly(CoordsSecond)
    Citizen.Wait(1000)
    local Coords = vector4(888.20, -2287.25, 32.44, 355.17)
    CreateCrate(Coords)
end)

RegisterNetEvent('framework-heists:server:bobcat:set:door:thermited')
AddEventHandler('framework-heists:server:bobcat:set:door:thermited', function(ConfigData)
    Config.MainDoorsThermited = ConfigData
end)

RegisterNetEvent('framework-heists:server:bobcat:set:door:card')
AddEventHandler('framework-heists:server:bobcat:set:door:card', function(ConfigData)
    Config.SecondDoorsUsedCard = ConfigData
end)

-- // Functions \\ --

function LoadInteriorBobcat()
    InteriorId = GetInteriorAtCoords(883.4142, -2282.372, 31.44168)
    RequestIpl("prologue06_int_np")
    if Config.IsBobcatExploded then
        ActivateInteriorEntitySet(InteriorId, "np_prolog_broken")
        DeactivateInteriorEntitySet(InteriorId, "np_prolog_clean")
    else
        ActivateInteriorEntitySet(InteriorId, "np_prolog_clean")
        DeactivateInteriorEntitySet(InteriorId, "np_prolog_broken")
    end
	RefreshInterior(InteriorId)
end

-- function SpawnSecurity()
--     for k, v in pairs(Config.BobcatSecurity) do
--         exports['fw-assets']:RequestModelHash(v['Model'])
--         local Security = CreatePed(7, v['Model'], v['Coords'].x, v['Coords'].y, v['Coords'].z, v['Coords'].w, true, false)
--         SetPedShootRate(Security, 750)
--         SetPedCombatAttributes(Security, 46, true)
--         SetPedFleeAttributes(Security, 0, 0)
--         SetPedAsEnemy(Security, true)
--         SetPedMaxHealth(Security, 900)
--         SetPedAlertness(Security, 3)
--         SetPedCombatRange(Security, 0)
--         SetPedCombatMovement(Security, 3)
--         TaskCombatPed(Security, PlayerPedId(), 0, 16)
--         GiveWeaponToPed(Security, GetHashKey("WEAPON_SMG"), 5000, true, true)
--         SetPedRelationshipGroupHash( Security, GetHashKey("HATES_PLAYER"))
--         SetPedDropsWeaponsWhenDead(Security, false)
--         SetEntityCollision(Security, true, true)
--     end
-- end

function IsInsideBobcat()
    return NearBobcat
end