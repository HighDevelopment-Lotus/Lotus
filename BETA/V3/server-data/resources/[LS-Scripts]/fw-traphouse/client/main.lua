local LSCore = exports['fw-base']:GetCoreObject()
local PlayerData = {}
local ClosestTraphouse = nil
local InsideTraphouse = false
local CurrentTraphouse = nil
local TraphouseObj = {}
local POIOffsets = nil
local IsKeyHolder = false
local IsHouseOwner = false
local InTraphouseRange = false
local CodeNPC = nil
local IsRobbingNPC = false
local LoggedIn = false
local Takeover = false
-- Code

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

Citizen.CreateThread(function()
    while true do
        if LoggedIn then
            SetClosestTraphouse()
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    Wait(1000)
    if LSCore.Functions.GetPlayerData() ~= nil then
        PlayerData = LSCore.Functions.GetPlayerData()
        LSCore.Functions.TriggerCallback('framework-traphouse:server:GetTraphousesData', function(trappies)
            Config.TrapHouses = trappies
        end)
    end
end)

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    PlayerData = LSCore.Functions.GetPlayerData()
    LSCore.Functions.TriggerCallback('framework-traphouse:server:GetTraphousesData', function(trappies)
        Config.TrapHouses = trappies
    end)
    LoggedIn = true
end)
local CanRob = true

function RobTimeout(timeout)
    SetTimeout(timeout, function()
        CanRob = true
    end)
end

local RobbingTime = 3

function IsInVehicle()
    local ply = PlayerPedId()
    if IsPedSittingInAnyVehicle(ply) then
      return true
    else
      return false
    end
  end

Citizen.CreateThread(function()
    while true do
        local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
        -- print(ClosestTraphouse)
        if targetPed ~= 0 and not IsPedAPlayer(targetPed) then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            if ClosestTraphouse ~= nil then
                local data = Config.TrapHouses[ClosestTraphouse]
                local dist = GetDistanceBetweenCoords(pos, data.coords["enter"].x, data.coords["enter"].y, data.coords["enter"].z, true)
                if dist < 100 then
                    if (IsInVehicle()) then
                        return
                    else
                        if aiming then
                            local pcoords = GetEntityCoords(targetPed)
                            local peddist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, pcoords.x, pcoords.y, pcoords.z, true)
                            if peddist < 4 then
                                InDistance = true
                                if not IsRobbingNPC and CanRob then
                                    if IsPedInAnyVehicle(targetPed) then
                                        TaskLeaveVehicle(targetPed, GetVehiclePedIsIn(targetPed), 1)
                                    end
                                    Citizen.Wait(500)
                                    InDistance = true
    
                                    local dict = 'random@mugging3'
                                    RequestAnimDict(dict)
                                    while not HasAnimDictLoaded(dict) do
                                        Citizen.Wait(10)
                                    end
                            
                                    SetEveryoneIgnorePlayer(PlayerId(), true)
                                    TaskStandStill(targetPed, RobbingTime * 1000)
                                    FreezeEntityPosition(targetPed, true)
                                    SetBlockingOfNonTemporaryEvents(targetPed, true)
                                    TaskPlayAnim(targetPed, dict, 'handsup_standing_base', 2.0, -2, 15.0, 1, 0, 0, 0, 0)
                                    for i = 1, RobbingTime / 2, 1 do
                                        PlayAmbientSpeech1(targetPed, "GUN_BEG", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
                                        Citizen.Wait(2000)
                                    end
                                    FreezeEntityPosition(targetPed, true)
                                    IsRobbingNPC = true
                                    SetTimeout(RobbingTime, function()
                                        IsRobbingNPC = false
                                        RobTimeout(math.random(30000, 60000))
                                        if not IsEntityDead(targetPed) then
                                            if CanRob then
                                                if InDistance then
                                                    SetEveryoneIgnorePlayer(PlayerId(), false)
                                                    SetBlockingOfNonTemporaryEvents(targetPed, false)
                                                    FreezeEntityPosition(targetPed, false)
                                                    ClearPedTasks(targetPed)
                                                    AddShockingEventAtPosition(99, GetEntityCoords(targetPed), 0.5)
                                                    LSCore.Functions.TriggerCallback('framework-traphouse:server:RobNpc', function(result)
                                                    end, ClosestTraphouse)
                                                    CanRob = false
                                                end
                                            end
                                        end
                                    end)
                                end
                            else
                                if InDistance then
                                    InDistance = false
                                end
                            end
                        end
                    end  
                end
            else
                Citizen.Wait(1000)
            end
        end
        Citizen.Wait(3)
    end
end)
RegisterNetEvent("framework-traphouse:removeProps")
AddEventHandler("framework-traphouse:removeProps", function()
    CleanUpArea()
end)
function CleanUpArea()
    local playerped = PlayerPedId()
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(plycoords - pos)
        if distance < 10.0 and ObjectFound ~= playerped then
        	if IsEntityAPed(ObjectFound) then
        		if IsPedAPlayer(ObjectFound) then
        		else
        			DeleteObject(ObjectFound)
        		end
        	else
        		if not IsEntityAVehicle(ObjectFound) and not IsEntityAttached(ObjectFound) then
	        		DeleteObject(ObjectFound)
	        	end
        	end            
        end
        success, ObjectFound = FindNextObject(handle)
    until not success
    SetEntityAsNoLongerNeeded(handle)
    DeleteEntity(handle)    
    EndFindObject(handle)
end

function SetClosestTraphouse()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for id, traphouse in pairs(Config.TrapHouses) do
        if current ~= nil then
            if #(pos - Config.TrapHouses[id].coords.enter) < dist then
                current = id
                dist = #(pos - Config.TrapHouses[id].coords.enter)
            end
        else
            dist = #(pos - Config.TrapHouses[id].coords.enter)
            current = id
        end
    end
    ClosestTraphouse = current
    IsKeyHolder = HasKey(PlayerData.citizenid)
    IsHouseOwner = IsOwner(PlayerData.citizenid)
end

function HasKey(CitizenId)
    local haskey = false
    if ClosestTraphouse ~= nil then
        if Config.TrapHouses[ClosestTraphouse].keyholders ~= nil and next(Config.TrapHouses[ClosestTraphouse].keyholders) ~= nil then
            for _, data in pairs(Config.TrapHouses[ClosestTraphouse].keyholders) do
                if data.citizenid == CitizenId then
                    haskey = true
                end
            end
        end
    end
    return haskey
end

function IsOwner(CitizenId)
    local retval = false
    if ClosestTraphouse ~= nil then
        if Config.TrapHouses[ClosestTraphouse].keyholders ~= nil and next(Config.TrapHouses[ClosestTraphouse].keyholders) ~= nil then
            for _, data in pairs(Config.TrapHouses[ClosestTraphouse].keyholders) do
                if data.citizenid == CitizenId then
                    if data.owner then
                        retval = true
                    else
                        retval = false
                    end
                end
            end
        end
    end
    return retval
end

RegisterCommand("entertraphouse", function()
    TriggerEvent('framework-traphouse:client:EnterTraphouse')
end)

RegisterNetEvent('framework-traphouse:client:open:craft')
AddEventHandler('framework-traphouse:client:open:craft', function()
    if exports['fw-inv']:CanOpenInventory() then
        local CraftingData = {['Type'] = 'Crafting', ['InvName'] = 'Traphouse', ['Items'] = Config.CraftingItems}
		TriggerServerEvent('framework-inv:server:open:inventory:other', CraftingData, 'Crafting')
    end
end)

RegisterNetEvent('framework-traphouse:client:EnterTraphouse')
AddEventHandler('framework-traphouse:client:EnterTraphouse', function(code)
    if ClosestTraphouse ~= nil then
        if InTraphouseRange then
            local data = Config.TrapHouses[ClosestTraphouse]
            if not IsKeyHolder then
                SendNUIMessage({
                    action = "open"
                })
                SetNuiFocus(true, true)
            else
                EnterTraphouse(data)
            end
        end
    end
end)

RegisterNetEvent('framework-traphouse:client:openmenu', function()
    Citizen.SetTimeout(500, function()
        local MenuItems = {
            [1] = {['Title'] = 'Stash', ['Desc'] = 'Open stash', ['Data'] = { ['Event'] = 'framework-traphouse:client:submenus', ['Type'] = 'Client', ['args'] = 'stash'} }, 
            [2] = {['Title'] = 'Sleutelhouders', ['Desc'] = 'Bekijk huidige sleutelhouders (Pincode: '..Config.TrapHouses[CurrentTraphouse]['pincode']..')', ['Data'] = { ['Event'] = 'framework-traphouse:client:submenus', ['Type'] = 'Client', ['args'] = 'keyholders'} }, 
            [3] = {['Title'] = 'Financieen', ['Desc'] = 'Open financiele zaken', ['Data'] = { ['Event'] = 'framework-traphouse:client:submenus', ['Type'] = 'Client', ['args'] = 'financial'} }, 
            }
            local Data = {['Title'] = 'Traphouse', ['Desc'] = 'Selecteer je keuze', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
        end)
end)

AddEventHandler('framework-traphouse:client:submenus' , function(data)
    local MenuItemsHolder = {}
    Citizen.SetTimeout(500, function()
        if(data['args'] == 'financial') then
            local MenuItems = {
                [1] = {['Title'] = 'Huidig Balans', ['Desc'] = '€ '..Config.TrapHouses[CurrentTraphouse].money..'', ['Data'] = { ['Event'] = '', ['Type'] = 'Server', ['args'] = '1'} }, 
                [2] = {['Title'] = 'Opnemen', ['Desc'] = '', ['Data'] = { ['Event'] = 'framework-traphouse:server:TakeMoney', ['Type'] = 'Server', ['args'] = CurrentTraphouse} }, 
                [3] = {['Title'] = 'Terug', ['Desc'] = 'Ga naar het vorige menu', ['Data'] = { ['Event'] = 'framework-traphouse:client:openmenu', ['Type'] = 'Client', ['args'] = '1'} }, 
                }
            local Data = {['Title'] = 'Financiele zaken', ['Desc'] = '', ['MainMenuItems'] = MenuItems}
            LSCore.Functions.OpenMenu(Data)
        elseif(data['args'] == 'keyholders') then
                for k, v in pairs(Config.TrapHouses[CurrentTraphouse].keyholders) do
                    local TempData = {}
                    TempData['Title'] = v.citizenid
                    TempData['Desc'] = 'Speler'
                    TempData['Data'] = {['Event'] = '', ['Type'] = 'Client', ['args'] = v.citizenid}
                    table.insert(MenuItemsHolder, TempData)
                end
                if (#MenuItemsHolder > 0) then
                    local Banen = {['Title'] = 'Sleutelhouders', ['Desc'] = '', ['MainMenuItems'] = MenuItemsHolder}
                    LSCore.Functions.OpenMenu(Banen)
                end
        elseif(data['args'] == 'stash') then
                if exports['fw-inv']:CanOpenInventory() then
                    TriggerServerEvent('framework-inv:server:open:inventory:other', "traphouse_"..CurrentTraphouse, 'Stash', 20, 5000000)
                end
        end
    end)
end)

RegisterNUICallback('PinpadClose', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ErrorMessage', function(data)
    LSCore.Functions.Notify(data.message, 'error')
end)

RegisterNUICallback('EnterPincode', function(d)
    local data = Config.TrapHouses[ClosestTraphouse]
    if tonumber(d.pin) == data.pincode then
        EnterTraphouse(data)
    else
        LSCore.Functions.Notify("De code is onjuist", 'error')
    end
end)

Citizen.CreateThread(function()
    while true do

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        local NearAnything = false
        if ClosestTraphouse ~= nil then
            local data = Config.TrapHouses[ClosestTraphouse]
            if InsideTraphouse then
                NearAnything = false
                local ExitDistance = #(pos - vector3(-1202.069, -1312.171, -27.63992))
                if ExitDistance < 3 then
                    inRange = true
                    if ExitDistance < 1 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['fw-ui']:ShowInteraction('[E] Huis Verlaten', 'primary')
                        end
                        if IsControlJustPressed(0, 38) then
                            LeaveTraphouse(data)
                        end
                    end
                end

                local InteractDistance = #(pos - vector3(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z))
                if InteractDistance < 3 then
                    inRange = true
                    if InteractDistance < 1.5 then
                        if not IsKeyHolder then
                            if Takeover then
                                NearAnything = true
                                if not ShowingInteraction then
                                    ShowingInteraction = true
                                    exports['fw-ui']:ShowInteraction('Aan het overnemen', 'primary')
                                end
                            else
                                NearAnything = true
                                if not ShowingInteraction then
                                    ShowingInteraction = true
                                    exports['fw-ui']:ShowInteraction('[E] Huis Overnemen', 'primary')
                                end
                                if IsControlJustPressed(0, 38) then
                                    TriggerServerEvent('framework-traphouse:server:TakeoverHouse', CurrentTraphouse)
                                end
                            end
                        else
                            if IsHouseOwner or IsKeyHolder then
                                NearAnything = true
                                if not ShowingInteraction then
                                    ShowingInteraction = true
                                    exports['fw-ui']:ShowInteraction('[E] Huis Opties', 'primary')
                                end
                                 if IsControlJustPressed(0, 38) then
                                    TriggerEvent('framework-traphouse:client:openmenu')
                                end
                            end
                        end
                    end
                end
            else
                local EnterDistance = #(pos - data.coords["enter"])
                if EnterDistance < 3 then
                    inRange = true
                    if EnterDistance < 1 then
                        InTraphouseRange = true
                    else
                        if InTraphouseRange then
                            InTraphouseRange = false
                        end
                    end
                end
            end
            if not NearAnything then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['fw-ui']:HideInteraction()
                end
                Citizen.Wait(500)
            end
        else
            Citizen.Wait(2000)
        end

        Citizen.Wait(3)
    end
end)

function EnterTraphouse(data)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    local coords = { x = data.coords["enter"].x, y = data.coords["enter"].y, z= data.coords["enter"].z - Config.MinZOffset}
    data = exports['fw-interiors']:HouseTierTwo(coords)
    TraphouseObj = data[1]
    POIOffsets = data[2]
    CurrentTraphouse = ClosestTraphouse
    InsideTraphouse = true
    renderTraphouseprops()
    TriggerEvent('framework-weathersync:client:DisableSync')
    FreezeEntityPosition(TraphouseObj, true)
end

function renderTraphouseprops()
    Couch = CreateObject(GetHashKey("v_res_j_sofa"),-1209.772, -1304.825, -27.63995,false,false,false)
    Table = CreateObject(GetHashKey("prop_patio_lounger1_table"),-1209.859, -1307.653, -27.63993,false,false,false)
    CraftingBench = CreateObject(GetHashKey("prop_toolchest_05"),-1206.891, -1304.73, -27.63992,false,false,false)
    PlaceObjectOnGroundProperly(Couch)
    PlaceObjectOnGroundProperly(Table)
    PlaceObjectOnGroundProperly(CraftingBench)
    FreezeEntityPosition(Couch, true)
    FreezeEntityPosition(Table, true)
    FreezeEntityPosition(CraftingBench, true)
end
function LeaveTraphouse(data)
    local ped = PlayerPedId()
    DoScreenFadeOut(250)
    CleanUpArea()
    Citizen.Wait(250)
    exports['fw-interiors']:DespawnInterior(TraphouseObj, function()
        TriggerEvent('framework-weathersync:client:EnableSync')
        DoScreenFadeIn(250)
        SetEntityCoords(ped, data.coords["enter"].x, data.coords["enter"].y, data.coords["enter"].z + 0.5)
        SetEntityHeading(ped, 107.71)
        TraphouseObj = nil
        POIOffsets = nil
        CurrentTraphouse = nil
        InsideTraphouse = false
    end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
        if Takeover then
            if Config.Timer > 0 then
                exports['fw-ui']:ShowInfoLong('show', 'Traphouse</br> Je bent nog: '..math.ceil(Config.Timer)..' minuten aan het overnemen')
            else
                dood = true
                Takeover = false
                exports['fw-ui']:HideInfo()
            end
        else
            -- Takeover = false
            if dood then
                exports['fw-ui']:HideInfo()
                dood = false
                Takeover = false
            end
             Citizen.Wait(450)
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if Takeover then
                if Config.Timer > 0 then
                    Config.Timer = Config.Timer - 1
                    if Config.Timer == 0 and not CanPersonRespawn then
                        CanPersonRespawn = true
                        Takeover = false
                        dood = false
                        exports['fw-ui']:HideInfo()
                        LSCore.Functions.TriggerCallback('framework-traphouse:server:AddHouseKeyHolder', function(result)
                        end, PlayerData.citizenid, CurrentTraphouse, true)  
                    end
                end
                Citizen.Wait(1000)
            end
        end
    end
end)

RegisterNetEvent('framework-traphouse:client:TakeoverHouse')
AddEventHandler('framework-traphouse:client:TakeoverHouse', function(TraphouseId)
    local ped = PlayerPedId()
    LSCore.Functions.Progressbar("takeover_traphouse", "Overname bekend maken...", math.random(1000, 3000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        Takeover = true
        if #Config.TrapHouses[TraphouseId].keyholders == 0 then
            print('Eerste overname')
        else
            for k, v in pairs(Config.TrapHouses[TraphouseId].keyholders) do
                TriggerServerEvent('framework-phone:server:sendNewtrapMail', v.citizenid, {
                    -- citizenid = v.citizenid,
                    sender = "Traphouse Alarm",
                    subject = "Traphouse Overname",
                    message = "De traphouse word overgenomen ga snel naar de locatie",
                })
            end
            print('Melding verstuurd naar '..#Config.TrapHouses[TraphouseId].keyholders..' mensen')
        end
    end, function()
        LSCore.Functions.Notify("Overname geannuleerd", "error")
    end)
end)


function HasCitizenIdHasKey(CitizenId, Traphouse)
    local retval = false
    for _, data in pairs(Config.TrapHouses[Traphouse].keyholders) do
        if data.citizenid == CitizenId then
            retval = true
            break
        end
    end
    return retval
end

function AddKeyHolder(CitizenId, Traphouse)
    if #Config.TrapHouses[Traphouse].keyholders <= 6 then
        if not HasCitizenIdHasKey(CitizenId, Traphouse) then
            if #Config.TrapHouses[Traphouse].keyholders == 0 then
                Config.TrapHouses[Traphouse].keyholders[#Config.TrapHouses[Traphouse].keyholders+1] = {
                    citizenid = CitizenId,
                    owner = true,
                }
            else
                Config.TrapHouses[Traphouse].keyholders[#Config.TrapHouses[Traphouse].keyholders+1] = {
                    citizenid = CitizenId,
                    owner = false,
                }
            end
            LSCore.Functions.Notify(CitizenId.." is toegevoegd aan de traphouse")
        else
            LSCore.Functions.Notify(CitizenId.." heeft al sleutels")
        end
    else
        LSCore.Functions.Notify("Je kunt maximaal 6 mensen toewijzen aan de traphouse")
    end
    IsKeyHolder = HasKey(CitizenId)
    IsHouseOwner = IsOwner(CitizenId)
end

RegisterNetEvent('framework-traphouse:client:SyncData')
AddEventHandler('framework-traphouse:client:SyncData', function(k, data)
    Config.TrapHouses[k] = data
    IsKeyHolder = HasKey(PlayerData.citizenid)
    IsHouseOwner = IsOwner(PlayerData.citizenid)
end)
