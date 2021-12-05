local HouseData, OffSets, HouseBlips, Other = nil, nil, {}, nil
local NearGarage, PlacedBlips, RealestateBlips = false, false, {}
local StashLocation, ClothingLocation, LogoutLocation = nil, nil, nil
LSCore, LoggedIn, Currenthouse = exports['ls-core']:GetCoreObject(), false, nil
HasKey, IsInHouse = false, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LSCore.Functions.TriggerCallback("ls-housing:server:get:config", function(config)
           Config = config
        end)
        Citizen.Wait(145)
        AddBlipForHouse()
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    RemoveHouseBlip()
    IsInHouse = false
    IsNearHouse = false
    Currenthouse = nil
    HasKey = false
    LoggedIn = false
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end)
--         Citizen.Wait(125)
--         LSCore.Functions.TriggerCallback("ls-housing:server:get:config", function(config)
--            Config = config
--         end)
--         Citizen.Wait(145)
--         AddBlipForHouse()
--         LoggedIn = true
--     end)
-- end)

-- Code

-- // Loops \\

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            SetClosestHouse()
            Citizen.Wait(2000)
        else
            Citizen.Wait(400)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if Currenthouse ~= nil then
                NearAnything = false
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                if not IsInHouse then
                    if not Config.Houses[Currenthouse]['Owned'] then
                        local Distance = #(PlayerCoords - vector3(Config.Houses[Currenthouse]['Coords']['Enter']['X'], Config.Houses[Currenthouse]['Coords']['Enter']['Y'], Config.Houses[Currenthouse]['Coords']['Enter']['Z']))
                        if Distance < 1.3 then
                            NearAnything = true
                            if not ShowingInteraction then
                                ShowingInteraction = true
                                exports['ls-ui']:ShowInteraction('[E] Huis Bezichtigen', 'primary')
                            end
                            if IsControlJustReleased(0, 38) then
                                TriggerServerEvent('ls-housing:server:view:house', Currenthouse)
                            end
                        end
                    end
                    if Config.Houses[Currenthouse]['Owned'] and not Config.Houses[Currenthouse]['Door-Lock'] or HasKey then
                        local Distance = #(PlayerCoords - vector3(Config.Houses[Currenthouse]['Coords']['Enter']['X'], Config.Houses[Currenthouse]['Coords']['Enter']['Y'], Config.Houses[Currenthouse]['Coords']['Enter']['Z']))
                        if Distance < 1.3 then
                            NearAnything = true
                            if not ShowingInteraction then
                                ShowingInteraction = true
                                exports['ls-ui']:ShowInteraction('[E] Naar Binnen', 'primary')
                            end
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent('ls-housing:client:enter:house')
                            end
                        end
                    end
                    if Config.Houses[Currenthouse]['Owned'] and HasKey then
                        if Config.Houses[Currenthouse]['HasGarage'] ~= 'false' and (Config.Houses[Currenthouse]['HasGarage'] or Config.Houses[Currenthouse]['HasGarage'] == 'true')  then
                            local Distance = #(PlayerCoords - vector3(Config.Houses[Currenthouse]['Garage']['X'], Config.Houses[Currenthouse]['Garage']['Y'], Config.Houses[Currenthouse]['Garage']['Z']))
                            if Distance < 3.0 then
                                NearGarage = true
                                NearAnything = true
                                DrawMarker(2, Config.Houses[Currenthouse]['Garage']['X'], Config.Houses[Currenthouse]['Garage']['Y'], Config.Houses[Currenthouse]['Garage']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                                DrawText3D(Config.Houses[Currenthouse]['Garage']['X'], Config.Houses[Currenthouse]['Garage']['Y'], Config.Houses[Currenthouse]['Garage']['Z'] + 0.15, '~g~E~s~ - Garage')
                                if IsControlJustReleased(0, 38) then
                                    local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                                    if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                                        TriggerEvent('ls-garages:client:open:house:menu', Currenthouse)
                                    else
                                        LSCore.Functions.TriggerCallback('ls-materials:server:is:vehicle:owned', function(IsOwned)
                                            if IsOwned then
                                                if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                                                    TriggerEvent('ls-garages:client:try:park:house:vehicle', Currenthouse)
                                                end
                                            else
                                                LSCore.Functions.Notify("Dit voertuig is van niemand..", "error")
                                            end
                                        end, GetVehicleNumberPlateText(Vehicle))
                                    end
                                end
                            else
                                NearGarage = false
                            end
                        end
                    end
                end
                if IsInHouse then
                    if OffSets ~= nil then
                        -- // Verlaten \\ --
                        local Distance = #(PlayerCoords - vector3(Config.Houses[Currenthouse]['Coords']['Enter']['X'] - OffSets.exit.x, Config.Houses[Currenthouse]['Coords']['Enter']['Y'] - OffSets.exit.y, Config.Houses[Currenthouse]['Coords']['Enter']['Z'] - OffSets.exit.z))
                        if Distance < 1.0 then
                            NearAnything = true
                            if not ShowingInteraction then
                                ShowingInteraction = true
                                exports['ls-ui']:ShowInteraction('[E] Verlaten', 'primary')
                            end
                            if IsControlJustReleased(0, 38) then
                                LeaveHouse()
                            end
                        end
                        -- // Stash \\ --
                        if CurrentBell ~= nil then
                            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Houses[Currenthouse]['Coords']['Enter']['X'] - OffSets.exit.x, Config.Houses[Currenthouse]['Coords']['Enter']['Y'] - OffSets.exit.y, Config.Houses[Currenthouse]['Coords']['Enter']['Z'] - OffSets.exit.z, true) < 2.0) then
                                DrawMarker(2, Config.Houses[Currenthouse]['Coords']['Enter']['X'] - OffSets.exit.x, Config.Houses[Currenthouse]['Coords']['Enter']['Y'] - OffSets.exit.y, Config.Houses[Currenthouse]['Coords']['Enter']['Z'] - OffSets.exit.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                                DrawText3D(Config.Houses[Currenthouse]['Coords']['Enter']['X'] - OffSets.exit.x, Config.Houses[Currenthouse]['Coords']['Enter']['Y'] - OffSets.exit.y, Config.Houses[Currenthouse]['Coords']['Enter']['Z'] - OffSets.exit.z + 0.32, '~g~G~s~ - Open Doen')
                                if IsControlJustReleased(0, 47) then
                                    TriggerServerEvent("ls-housing:server:open:door", CurrentBell, Currenthouse)
                                    CurrentBell = nil
                                end
                            end
                        end
                        if StashLocation ~= nil then
                            local Distance = #(PlayerCoords - vector3(StashLocation['X'], StashLocation['Y'], StashLocation['Z']))
                            if Distance < 1.45 then
                                NearAnything = true
                                if not ShowingInteraction then
                                    ShowingInteraction = true
                                    exports['ls-ui']:ShowInteraction('[E] Stash', 'primary')
                                end
                                if IsControlJustReleased(0, 38) then
                                    if exports['ls-inventory-new']:CanOpenInventory() then
                                        TriggerServerEvent('ls-inventory-new:server:open:inventory:other', Currenthouse, 'Stash', Other.slots, Other.maxweight)
                                        TriggerEvent("ls-sound:client:play", "stash-open", 0.4)
                                    end
                                end
                            end
                        end
                        if ClothingLocation ~= nil then
                            local Distance = #(PlayerCoords - vector3(ClothingLocation['X'], ClothingLocation['Y'], ClothingLocation['Z']))
                            if Distance < 1.45 then
                                NearAnything = true
                                if not ShowingInteraction then
                                    ShowingInteraction = true
                                    exports['ls-ui']:ShowInteraction('[E] Kledingkast', 'primary')
                                end
                                if IsControlJustReleased(0, 38) then
                                 --   TriggerEvent('ls-clothing:client:openOutfitMenu')
                                 TriggerEvent('fivem-appearance:outfitsMenu')
                                end
                            end
                        end
                        if LogoutLocation ~= nil then
                            local Distance = #(PlayerCoords - vector3(LogoutLocation['X'], LogoutLocation['Y'], LogoutLocation['Z']))
                            if Distance < 1.45 then
                                NearAnything = true
                                if not ShowingInteraction then
                                    ShowingInteraction = true
                                    exports['ls-ui']:ShowInteraction('[E] Slapen', 'primary')
                                end
                                if IsControlJustReleased(0, 38) then
                                    LogoutPlayer()
                                end
                            end
                        end
                    end 
                end
                if not NearAnything then
                    if ShowingInteraction then
                        ShowingInteraction = false
                        exports['ls-ui']:HideInteraction()
                    end
                    Citizen.Wait(500)
                end
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-housing:client:enter:house')
AddEventHandler('ls-housing:client:enter:house', function()
    local Housing = {}
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    local CoordsTable = {x = Config.Houses[Currenthouse]['Coords']['Enter']['X'], y = Config.Houses[Currenthouse]['Coords']['Enter']['Y'], z = Config.Houses[Currenthouse]['Coords']['Enter']['Z'] - 35.0}
    IsInHouse = true
    if Config.Houses[Currenthouse]['Tier'] == 15 then
        TriggerEvent("ls-sound:client:play", "hospital-elevator", 0.20)
    else
        TriggerEvent("ls-sound:client:play", "house-door-open", 0.7)
    end
    OpenDoorAnim()
    Citizen.Wait(350)
    SetHouseLocations()
    if Config.Houses[Currenthouse]['Tier'] == 1 then
        Other = {maxweight = 1300000, slots = 55}  -- 650000
        Housing = exports['ls-interiors']:HouseTierOne(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 2 then
        Other = {maxweight = 1300000, slots = 55} -- 1300000
        Housing = exports['ls-interiors']:HouseTierTwo(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 3 then
        Other = {maxweight = 1300000, slots = 55} -- 1300000
        Housing = exports['ls-interiors']:HouseTierThree(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 4 then
        Other = {maxweight = 1900000, slots = 55} -- 950000
        Housing = exports['ls-interiors']:HouseTierFour(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 5 then
        Other = {maxweight = 2400000, slots = 55} -- 1200000
        Housing = exports['ls-interiors']:HouseTierFive(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 6 then
        Other = {maxweight = 1300000, slots = 55} -- 650000
        Housing = exports['ls-interiors']:HouseTierSix(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 7 then
        Other = {maxweight = 2400000, slots = 55} -- 1200000
        Housing = exports['ls-interiors']:HouseTierSeven(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 8 then
        Other = {maxweight = 2400000, slots = 55} -- 1200000
        Housing = exports['ls-interiors']:HouseTierEight(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 9 then
        Other = {maxweight = 2400000, slots = 55} -- 1200000
        Housing = exports['ls-interiors']:HouseTierNine(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 10 then
        Other = {maxweight = 2400000, slots = 55} -- 1200000
        Housing = exports['ls-interiors']:HouseTierTen(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 11 then
        Other = {maxweight = 3100000, slots = 55} -- 1550000
        Housing = exports['ls-interiors']:GarageTierOne(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 12 then
        Other = {maxweight = 3900000, slots = 55} -- 1950000
        Housing = exports['ls-interiors']:GarageTierTwo(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 13 then
        Other = {maxweight = 2500000, slots = 55} -- 1250000
        Housing = exports['ls-interiors']:GarageTierThree(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 14 then
        Other = {maxweight = 2300000, slots = 55} -- 1150000
        Housing = exports['ls-interiors']:SpawnWinkel(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 15 then
        Other = {maxweight = 1300000, slots = 55} -- 650000
        Housing = exports['ls-interiors']:SpawnKantoor(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 16 then
        Other = {maxweight = 2300000, slots = 55} -- 1150000
        Housing = exports['ls-interiors']:SpawnDrugs(CoordsTable)
    end
    LoadDecorations(Currenthouse)
    exports['ls-weathersync']:SetClientSync(false)
    HouseData, OffSets = Housing[1], Housing[2]
    TriggerEvent("ls-sound:client:play", "house-door-close", 0.1)
    Citizen.SetTimeout(450, function()
        exports['ls-houseplants']:LoadHousePlants(Currenthouse)
    end)
end)

RegisterNetEvent('ls-housing:client:sync:config')
AddEventHandler('ls-housing:client:sync:config', function(HouseId, ConfigData)
    Config.Houses[HouseId] = ConfigData
    Currenthouse = nil
    SetClosestHouse()
end)

RegisterNetEvent('ls-housing:client:set:owned')
AddEventHandler('ls-housing:client:set:owned', function(HouseId, Owned, CitizenId)
    Config.Houses[HouseId]['Owner'] = CitizenId
    Config.Houses[HouseId]['Owned'] = Owned
    Config.Houses[HouseId]['Key-Holders'] = {[1] = CitizenId}
    Citizen.SetTimeout(100, function()
        RefreshHouseBlips()
    end)
end)

RegisterNetEvent('ls-housing:client:create:house')
AddEventHandler('ls-housing:client:create:house', function(Price, Tier)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    local PlayerHeading = GetEntityHeading(GetPlayerPed(-1))
    local StreetNative = Citizen.InvokeNative(0x2EB41072B4C1E4C0, PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local StreetName = GetStreetNameFromHashKey(StreetNative)
    local CoordsTable = {['Enter'] = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z, ['H'] = PlayerHeading}}
    TriggerServerEvent('ls-housing:server:add:new:house', StreetName:gsub("%-", " "), CoordsTable, Price, Tier)
end)

RegisterNetEvent('ls-housing:client:delete:house')
AddEventHandler('ls-housing:client:delete:house', function()
    if Currenthouse ~= nil then 
        TriggerServerEvent('ls-housing:server:detlete:house', Currenthouse)
    else
        LSCore.Functions.Notify("Geen huis in de buurt..", "error")
    end
end)

RegisterNetEvent('ls-housing:client:add:garage')
AddEventHandler('ls-housing:client:add:garage', function()
    if Currenthouse ~= nil then 
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        local PlayerHeading = GetEntityHeading(GetPlayerPed(-1))
        local CoordsTable = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z, ['H'] = PlayerHeading}
        TriggerServerEvent('ls-housing:server:add:garage', Currenthouse, Config.Houses[Currenthouse]['Adres'], CoordsTable)
    else
        LSCore.Functions.Notify("Geen huis in de buurt..", "error")
    end
end)

RegisterNetEvent('ls-housing:client:set:location')
AddEventHandler('ls-housing:client:set:location', function(Type)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    local CoordsTable = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z}
    if IsInHouse then
        if HasKey then
            if Type == 'stash' then
                TriggerServerEvent('ls-housing:server:set:location', Currenthouse, CoordsTable, 'stash')
            elseif Type == 'clothes' then
                TriggerServerEvent('ls-housing:server:set:location', Currenthouse, CoordsTable, 'clothes')
            elseif Type == 'logout' then
                TriggerServerEvent('ls-housing:server:set:location', Currenthouse, CoordsTable, 'logout')
           end
        end
    end
end)

RegisterNetEvent('ls-housing:client:refresh:location')
AddEventHandler('ls-housing:client:refresh:location', function(HouseId, CoordsTable, Type)
    if HouseId == Currenthouse then
        if IsInHouse then
            if Type == 'stash' then
               StashLocation = CoordsTable
            elseif Type == 'clothes' then
                ClothingLocation = CoordsTable
            elseif Type == 'logout' then
                LogoutLocation = CoordsTable
            end
        end
    end
end)

RegisterNetEvent('ls-housing:client:give:keys')
AddEventHandler('ls-housing:client:give:keys', function()
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 1.5 then  
        LSCore.Functions.GetPlayerData(function(PlayerData)
            if Config.Houses[Currenthouse]['Owner'] == PlayerData.citizenid then
               TriggerServerEvent('ls-housing:server:give:keys', Currenthouse, GetPlayerServerId(Player))
            else
              LSCore.Functions.Notify("Je bent niet de eigenaar van dit huis..", "error")
            end
        end)
    else
        LSCore.Functions.Notify("Niemand gevonden?", "error")
    end
end)

RegisterNetEvent('ls-housing:client:ring:door')
AddEventHandler('ls-housing:client:ring:door', function()                  
    if Currenthouse ~= nil then
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        local Distance = #(PlayerCoords - vector3(Config.Houses[Currenthouse]['Coords']['Enter']['X'], Config.Houses[Currenthouse]['Coords']['Enter']['Y'], Config.Houses[Currenthouse]['Coords']['Enter']['Z']))
        if Distance < 1.2 then
            LSCore.Functions.Notify("Je hebt aangebeld!", "success")
            TriggerServerEvent('ls-housing:server:ring:door', Currenthouse)
        end
    end
end)

RegisterNetEvent('ls-housing:client:ringdoor')
AddEventHandler('ls-housing:client:ringdoor', function(Player, HouseId)
    if Currenthouse == HouseId and IsInHouse then
        CurrentBell = Player
        TriggerEvent("ls-sound:client:play", "house-doorbell", 0.1)
        LSCore.Functions.Notify("Er staat iemand aan de deur..")
    end
end)

RegisterNetEvent('ls-housing:client:set:in:house')
AddEventHandler('ls-housing:client:set:in:house', function(House)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Houses[House]['Coords']['Enter']['X'], Config.Houses[House]['Coords']['Enter']['Y'], Config.Houses[House]['Coords']['Enter']['Z'], true) < 5.0) then
        TriggerEvent('ls-housing:client:enter:house')
    end
end)

RegisterNetEvent('ls-housing:client:set:new:key:holders')
AddEventHandler('ls-housing:client:set:new:key:holders', function(HouseId, HouseKeys)
    Config.Houses[HouseId]['Key-Holders'] = HouseKeys
end)

RegisterNetEvent('ls-housing:client:set:house:door')
AddEventHandler('ls-housing:client:set:house:door', function(HouseId, bool)
    Config.Houses[HouseId]['Door-Lock'] = bool
end)

RegisterNetEvent('ls-housing:client:view:house')
AddEventHandler('ls-housing:client:view:house', function(houseprice, brokerfee, bankfee, taxes, firstname, lastname)
    OpenHouseContract(true)
    SendNUIMessage({
        type = "setupContract",
        firstname = firstname,
        lastname = lastname,
        street = Config.Houses[Currenthouse]['Adres'],
        houseprice = houseprice,
        brokerfee = brokerfee,
        bankfee = bankfee,
        taxes = taxes,
        totalprice = (houseprice + brokerfee + bankfee + taxes)
    })
end)

RegisterNetEvent('ls-housing:client:reset:house:door')
AddEventHandler('ls-housing:client:reset:house:door', function()
    if Currenthouse ~= nil then
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        local Distance = #(PlayerCoords - vector3(Config.Houses[Currenthouse]['Coords']['Enter']['X'], Config.Houses[Currenthouse]['Coords']['Enter']['Y'], Config.Houses[Currenthouse]['Coords']['Enter']['Z']))
        if Distance < 2.3 then
            if not Config.Houses[Currenthouse]['Door-Lock'] then
                OpenDoorAnim()
                TriggerServerEvent('ls-sound:server:play:source', 'doorlock-keys', 0.4)
                TriggerServerEvent('ls-housing:server:set:house:door', Currenthouse, true)
            else
                LSCore.Functions.Notify("Deur is al dicht..", 'error')
            end
        end
    else
        LSCore.Functions.Notify("Geen huis?!?", 'error')
    end
end)

RegisterNetEvent('ls-housing:client:toggle:blips')
AddEventHandler('ls-housing:client:toggle:blips', function()
    ToggleRealesteBlips()
end)

RegisterNetEvent('ls-housing:client:breaking:door')
AddEventHandler('ls-housing:client:breaking:door', function()
    if Currenthouse ~= nil then
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        local Distance = #(PlayerCoords - vector3(Config.Houses[Currenthouse]['Coords']['Enter']['X'], Config.Houses[Currenthouse]['Coords']['Enter']['Y'], Config.Houses[Currenthouse]['Coords']['Enter']['Z']))
        if Distance < 2.3 then
            if Config.Houses[Currenthouse]['Door-Lock'] then
                RamAnimation(true)
                LSCore.Functions.Progressbar("bonk-door", "Deur Bonken..", 15000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    RamAnimation(false)
                    TriggerServerEvent('ls-housing:server:set:house:door', Currenthouse, false)
                end, function() -- Cancel
                    RamAnimation(false)
                end)
            else
                LSCore.Functions.Notify("Deur is al open..", 'error')
            end
        end
    else
        LSCore.Functions.Notify("Geen huis?!?", 'error')
    end
end)

-- // Functions \\ --

function ToggleRealesteBlips()
    if PlacedBlips then
        for k, v in pairs(RealestateBlips) do
            RemoveBlip(v)
        end
        PlacedBlips = false
        RealestateBlips = {}
        LSCore.Functions.Notify("Huis blips verwijderd!", 'error')
    else
        for k, v in pairs(Config.Houses) do
            if Config.Houses[k] ~= nil and Config.Houses[k]['Coords'] ~= nil then
                Blips = AddBlipForCoord(v['Coords']['Enter']['X'], v['Coords']['Enter']['Y'], v['Coords']['Enter']['Z'])
                SetBlipSprite(Blips, 40)
                SetBlipDisplay(Blips, 4)
                SetBlipScale(Blips, 0.48)
                SetBlipAsShortRange(Blips, true)
                SetBlipColour(Blips, 26)
                SetBlipCategory(Blips, 11)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName(v['Adres'])
                EndTextCommandSetBlipName(Blips)
                table.insert(RealestateBlips, Blips)
            end
        end
        PlacedBlips = true
        LSCore.Functions.Notify("Huis blips geplaatst.", 'success')
    end
end

function LeaveHouse()
    if Config.Houses[Currenthouse]['Tier'] == 15 then
        TriggerEvent("ls-sound:client:play", "hospital-elevator", 0.20)
    else
        TriggerEvent("ls-sound:client:play", "house-door-open", 0.7)
    end
    OpenDoorAnim()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    exports['ls-interiors']:DespawnInterior(HouseData, function()
        SetEntityCoords(GetPlayerPed(-1), Config.Houses[Currenthouse]['Coords']['Enter']['X'], Config.Houses[Currenthouse]['Coords']['Enter']['Y'], Config.Houses[Currenthouse]['Coords']['Enter']['Z'])
        exports['ls-weathersync']:SetClientSync(true)
        exports['ls-houseplants']:UnloadHousePlants(Currenthouse)
        UnloadDecorations()
        Citizen.Wait(1000)
        IsInHouse = false
        Other = nil
        Currenthouse = nil
        StashLocation, ClothingLocation, LogoutLocation = nil, nil, nil
        HouseData, OffSets = nil, nil
        DoScreenFadeIn(1000)
        if Config.Houses[Currenthouse]['Tier'] ~= 15 then
            TriggerEvent("ls-sound:client:play", "house-door-close", 0.1)
        end
    end)
end

function LogoutPlayer()
    if Config.Houses[Currenthouse]['Tier'] == 15 then
        TriggerEvent("ls-sound:client:play", "hospital-elevator", 0.20)
    else
        TriggerEvent("ls-sound:client:play", "house-door-open", 0.7)
    end
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    exports['ls-interiors']:DespawnInterior(HouseData, function()
        SetEntityCoords(GetPlayerPed(-1), Config.Houses[Currenthouse]['Coords']['Enter']['X'], Config.Houses[Currenthouse]['Coords']['Enter']['Y'], Config.Houses[Currenthouse]['Coords']['Enter']['Z'])
        exports['ls-weathersync']:SetClientSync(true)
        UnloadDecorations()
        Citizen.Wait(1000)
        IsInHouse = false
        Other = nil
        Currenthouse = nil
        StashLocation, ClothingLocation, LogoutLocation = nil, nil, nil
        HouseData, OffSets = nil, nil
        TriggerEvent("ls-sound:client:play", "house-door-close", 0.1)
        Citizen.Wait(450)
        TriggerServerEvent('ls-housing:server:logout')
    end)
end

function SetClosestHouse()
    local Distance = nil
    local Current = nil
    if not IsInHouse then
        for k, v in pairs(Config.Houses) do
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            if Config.Houses[k] ~= nil and Config.Houses[k]['Coords'] ~= nil then
                if Current ~= nil then
                    if (GetDistanceBetweenCoords(PlayerCoords, Config.Houses[k]['Coords']['Enter']['X'], Config.Houses[k]['Coords']['Enter']['Y'], Config.Houses[k]['Coords']['Enter']['Z'], true) < Distance) then
                        Current = k
                        Distance = GetDistanceBetweenCoords(PlayerCoords, Config.Houses[k]['Coords']['Enter']['X'], Config.Houses[k]['Coords']['Enter']['Y'], Config.Houses[k]['Coords']['Enter']['Z'], true)
                    end
                else
                   Distance = GetDistanceBetweenCoords(PlayerCoords, Config.Houses[k]['Coords']['Enter']['X'], Config.Houses[k]['Coords']['Enter']['Y'], Config.Houses[k]['Coords']['Enter']['Z'], true)
                   Current = k
                end
            end
        end
        Currenthouse = Current
        if Currenthouse ~= nil then
            LSCore.Functions.TriggerCallback('ls-housing:server:has:house:key', function(HasHouseKey)
                HasKey = HasHouseKey
            end, Currenthouse)
        end
    end
end

function SetHouseLocations()
    if Currenthouse ~= nil then
        LSCore.Functions.TriggerCallback('ls-housing:server:get:locations', function(result)
            if result ~= nil then
                if result.stash ~= nil then
                  StashLocation = json.decode(result.stash)
                end  
                if result.outfit ~= nil then
                  ClothingLocation = json.decode(result.outfit)
                end  
                if result.logout ~= nil then
                  LogoutLocation = json.decode(result.logout)
                end
            end
        end, Currenthouse)
    end
end

function RamAnimation(bool)
    if bool then
        exports['ls-assets']:RequestAnimationDict("missheistfbi3b_ig7")
        TaskPlayAnim(GetPlayerPed(-1), "missheistfbi3b_ig7", "lift_fibagent_loop", 8.0, 8.0, -1, 1, -1, false, false, false)
    else
        exports['ls-assets']:RequestAnimationDict("missheistfbi3b_ig7")
        TaskPlayAnim(GetPlayerPed(-1), "missheistfbi3b_ig7", "exit", 8.0, 8.0, -1, 1, -1, false, false, false)
    end
end

function HasEnterdHouse()
    if IsInHouse and HasKey then
        return true
    end
end

function OpenDoorAnim()
   exports['ls-assets']:RequestAnimationDict('anim@heists@keycard@')
   TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
   Citizen.Wait(400)
   ClearPedTasks(GetPlayerPed(-1))
end

function GetGarageCoords()
    return Config.Houses[Currenthouse]['Garage']
end

function GetClosesBuyHouse()
    if Currenthouse ~= nil then
        if not Config.Houses[Currenthouse]['Owned'] then
            return Config.Houses[Currenthouse]
        else
            return false
        end
    else
        return false
    end
end

function AddBlipForHouse()
    LSCore.Functions.GetPlayerData(function(PlayerData)
        for k, v in pairs(Config.Houses) do
            if Config.Houses[k]['Owner'] == PlayerData.citizenid then
               Blips = AddBlipForCoord(Config.Houses[k]['Coords']['Enter']['X'], Config.Houses[k]['Coords']['Enter']['Y'], Config.Houses[k]['Coords']['Enter']['Z'])
               SetBlipSprite (Blips, 40)
               SetBlipDisplay(Blips, 4)
               SetBlipScale  (Blips, 0.48)
               SetBlipAsShortRange(Blips, true)
               SetBlipColour(Blips, 26)
               SetBlipCategory(Blips, 10)
               BeginTextCommandSetBlipName("STRING")
               AddTextComponentSubstringPlayerName(Config.Houses[k]['Adres'])
               EndTextCommandSetBlipName(Blips)
               table.insert(HouseBlips, Blips)
            end
        end
    end)
end

function RefreshHouseBlips()
    RemoveHouseBlip()
    Citizen.SetTimeout(450, function()
        AddBlipForHouse()
    end)
end

function RemoveHouseBlip()
    if HouseBlips ~= nil then
      for k, v in pairs(HouseBlips) do
          RemoveBlip(v)
      end
      HouseBlips = {}
    end
end

function OpenHouseContract(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "toggle",
        status = bool,
    })
end

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

-- // NUI \\ --

RegisterNUICallback('buy', function()
    OpenHouseContract(false)
    if DoesCamExist(HouseCam) then
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(HouseCam, false)
        DestroyCam(HouseCam, true)
    end
    TriggerServerEvent('ls-housing:server:buy:house', Currenthouse)
end)

RegisterNUICallback('exit', function()
    OpenHouseContract(false)
end)