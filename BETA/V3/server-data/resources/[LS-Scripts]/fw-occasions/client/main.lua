Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}


LSCore = exports["fw-base"]:GetCoreObject()

-- Code

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local occasionVehicles = {}
local inRange
local vehiclesSpawned = false
local isConfirming = false
local ShowingInfo = false
Citizen.CreateThread(function()
    while true do
        inRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        if LSCore ~= nil then
            for _,slot in pairs(Config.OccasionSlots) do
                local dist = #(pos - vector3(slot["x"], slot["y"], slot["z"]))

                if dist <= 60 then
                    inRange = true
                    if not vehiclesSpawned then
                        vehiclesSpawned = true

                        LSCore.Functions.TriggerCallback('framework-occasions:server:getVehicles', function(vehicles)
                            occasionVehicles = vehicles
                            despawnOccasionsVehicles()
                            spawnOccasionsVehicles(vehicles)
                        end)
                    end
                end
            end

            if inRange then
                for i = 1, #Config.OccasionSlots, 1 do
                    local vehPos = GetEntityCoords(Config.OccasionSlots[i]["occasionId"])
                    local dstCheck = #(pos - vehPos)
                    NearCar = false
                    if dstCheck <= 2 then
                        if not IsPedInAnyVehicle(ped) then
                            NearCar = true
                            if not isConfirming then
                                
                                -- local Data = {['Title'] = Config.OccasionSlots[i]["model"], ['Items'] = {[1] = {['Text'] = 'Voertuig kosten: €'..Config.OccasionSlots[i]["price"]..',-'}}}
                                -- exports['fw-ui']:ShowInfo(Data)

                                DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.45, '~g~E~w~ Om voertuig te bekijken')
                                DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.25, Config.OccasionSlots[i]["model"]..' Prijs: €'..Config.OccasionSlots[i]["price"]..',-')
                                if Config.OccasionSlots[i]["owner"] == LSCore.Functions.GetPlayerData().citizenid then
                                    DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.05, '~r~G~w~ Om voertuig terug te nemen')
                                    if IsControlJustPressed(0, Keys["G"]) then
                                        isConfirming = true
                                    end
                                end

                                if IsControlJustPressed(0, Keys["E"]) then
                                    currentVehicle = i
                                    
                                    LSCore.Functions.TriggerCallback('framework-occasions:server:getSellerInformation', function(info)
                                        if info ~= nil then 
                                            info.charinfo = json.decode(info.charinfo)
                                        else
                                            info = {}
                                            info.charinfo = {
                                                firstname = "Niet",
                                                lastname = "bekend..",
                                                account = "Account niet bekend..",
                                                phone = "Telefoonnummer niet bekend.."
                                            }
                                        end
                                        
                                        openBuyContract(info, Config.OccasionSlots[currentVehicle])
                                    end, Config.OccasionSlots[currentVehicle]["owner"])
                                end
                            else
                                -- local Data = {['Title'] = Config.OccasionSlots[i]["model"], ['Items'] = {[1] = {['Text'] = 'Weet je zeker dat je je voertuig van de occasions wilt halen?'}, [2] = {['Text'] = '[7] - Ja | [8] - Nee'}}}
                                -- exports['fw-ui']:ShowInfo(Data)

                                DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.45, 'Weet je zeker dat je je voertuig van de occasions wilt halen?')
                                DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.25, '~g~7~w~ - Ja | ~r~8~w~ - Nee')
                                if IsDisabledControlJustPressed(0, Keys["7"]) then
                                    isConfirming = false
                                    currentVehicle = i
                                    TriggerServerEvent("framework-occasions:server:ReturnVehicle", Config.OccasionSlots[i])
                                end
                                if IsDisabledControlJustPressed(0, Keys["8"]) then
                                    isConfirming = false
                                end
                            end
                        end
                    end
                end
            end
            if not inRange then
                if vehiclesSpawned then
                    vehiclesSpawned = false
                    despawnOccasionsVehicles()
                end
                Citizen.Wait(5000)
            end
        end

        Citizen.Wait(3)
    end
end)

function spawnOccasionsVehicles(vehicles)
    if vehicles ~= nil then
        for i = 1, #vehicles, 1 do
            local model = GetHashKey(vehicles[i].model)
            -- exports['fw-assets']:RequestModelHash(model)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            Config.OccasionSlots[i]["occasionId"] = CreateVehicle(model, Config.OccasionSlots[i]["x"], Config.OccasionSlots[i]["y"], Config.OccasionSlots[i]["z"], false, false)
            LSCore.Functions.SetVehicleProperties(Config.OccasionSlots[i]["occasionId"], json.decode(vehicles[i].mods))
            Config.OccasionSlots[i]["price"] = vehicles[i].price
            Config.OccasionSlots[i]["owner"] = vehicles[i].seller
            Config.OccasionSlots[i]["model"] = vehicles[i].model
            Config.OccasionSlots[i]["plate"] = vehicles[i].plate
            Config.OccasionSlots[i]["oid"]   = vehicles[i].occasionId
            Config.OccasionSlots[i]["desc"]  = vehicles[i].description
            Config.OccasionSlots[i]["mods"]  = vehicles[i].mods
            SetModelAsNoLongerNeeded(model)
            SetVehicleOnGroundProperly(Config.OccasionSlots[i]["occasionId"])
            SetEntityInvincible(Config.OccasionSlots[i]["occasionId"], true)
            SetEntityHeading(Config.OccasionSlots[i]["occasionId"], Config.OccasionSlots[i]["h"])
            SetVehicleDoorsLocked(Config.OccasionSlots[i]["occasionId"], 3)
            SetVehicleNumberPlateText(Config.OccasionSlots[i]["occasionId"], vehicles[i].occasionId)
            FreezeEntityPosition(Config.OccasionSlots[i]["occasionId"],true)
        end
    end
end

function despawnOccasionsVehicles()
    for _, slot in pairs(Config.OccasionSlots) do
        local oldVehicle = GetClosestVehicle(slot["x"], slot["y"], slot["z"], 1.3, 0, 70)
        if oldVehicle ~= 0 then
            LSCore.Functions.DeleteVehicle(oldVehicle)
        end
    end
end

function openSellContract(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "sellVehicle",
        pData = LSCore.Functions.GetPlayerData(),
        plate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId()))
    })
end

function openBuyContract(sellerData, vehicleData)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "buyVehicle",
        sellerData = sellerData,
        vehicleData = vehicleData
    })
end

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('error', function(data)
    LSCore.Functions.Notify(data.message, 'error')
end)

RegisterNUICallback('buyVehicle', function()
    local vehData = Config.OccasionSlots[currentVehicle]
    -- print(vehData)
    TriggerServerEvent('framework-occasions:server:buyVehicle', vehData)
end)

RegisterNetEvent('framework-occasions:client:openmenu')
AddEventHandler('framework-occasions:client:openmenu', function()
    local VehiclePlate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId()))
    LSCore.Functions.TriggerCallback('framework-garage:server:is:vehicle:owner', function(owned)
        if owned then
            openSellContract(true)
        else
            LSCore.Functions.Notify('Dit is niet jou voertuig?', 'error', 3500)
        end
    end, VehiclePlate)
end)
RegisterNetEvent('framework-occasions:client:BuyFinished')
AddEventHandler('framework-occasions:client:BuyFinished', function(model, plate, mods)
    local vehData = Config.OccasionSlots[currentVehicle]
    local vehmods = json.decode(mods)
    Citizen.Wait(500)
    LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
        while not NetworkDoesEntityExistWithNetworkId(Veh) do
            Citizen.Wait(350)
        end
        local Vehicle = NetToVeh(Veh)
        while not DoesEntityExist(Vehicle) do
            Citizen.Wait(100)
        end
        NetworkFadeInEntity(Vehicle, true)
        NetworkRequestControlOfEntity(Vehicle)
        -- ClearAreaOfPeds(CoordTable.x, CoordTable.y, CoordTable.z, 3.5)
        -- exports['fw-autocare']:SetupVehicleData(vehData["plate"])
        exports['fw-vehicles']:SetVehicleKeys(vehData["plate"], true, false)
        exports['fw-vehicles']:SetFuelLevel(Vehicle, vehData["plate"], 50, false)
        Citizen.SetTimeout(1000, function()
            LSCore.Functions.TriggerCallback('framework-garages:server:get:vehicle:mods', function(Mods)
                LSCore.Functions.SetVehicleProperties(Vehicle, Mods)
                NetworkFadeInEntity(Vehicle, true)	
                NetworkRegisterEntityAsNetworked(Vehicle)
                LSCore.Functions.SetVehiclePlate(Vehicle, vehData["plate"])
                TriggerServerEvent('framework-garages:server:set:vehicle:state', vehData["plate"], 'out')
                LSCore.Functions.Notify("Voertuig staat om de hoek!", "success")
            end, vehData["plate"])
        end)
    end, vehData["model"], Config.BuyVehicle, false, vehData["plate"])
    Citizen.Wait(500)
    currentVehicle = nil
end)

RegisterNetEvent('framework-occasions:client:ReturnOwnedVehicle')
AddEventHandler('framework-occasions:client:ReturnOwnedVehicle', function(mods)
    local vehData = Config.OccasionSlots[currentVehicle]
    local vehmods = json.decode(mods)
    DoScreenFadeOut(250)
    Citizen.Wait(900)
    LSCore.Functions.SpawnVehicle(vehData["model"], function(veh)
        SetVehicleNumberPlateText(veh, vehData["plate"])
        SetEntityHeading(veh, Config.BuyVehicle.h)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        LSCore.Functions.Notify("Jouw voertuig is terug in ontvangst..")
        exports['fw-vehicles']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
        exports['fw-vehicles']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100, false)
        SetVehicleEngineOn(veh, true, true)
        Citizen.Wait(500)
        LSCore.Functions.SetVehicleProperties(veh, vehmods)
    end, Config.BuyVehicle, true)
    Citizen.Wait(500)
    DoScreenFadeIn(250)
    currentVehicle = nil
end)

RegisterNUICallback('sellVehicle', function(data)
    local vehicleData = {}
    local PlayerData = LSCore.Functions.GetPlayerData()
    vehicleData.ent = GetVehiclePedIsUsing(PlayerPedId())
    vehicleData.model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicleData.ent)):lower()
    vehicleData.plate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId()))
    vehicleData.mods = LSCore.Functions.GetVehicleProperties(vehicleData.ent)
    vehicleData.desc = data.desc
    TriggerServerEvent('framework-garages:server:set:vehicle:state', vehicleData.plate, 'autoscout')
    TriggerServerEvent('framework-occasions:server:sellVehicle', data.price, vehicleData)
    sellVehicleWait(data.price)
end)

function sellVehicleWait(price)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    LSCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
    Citizen.Wait(1500)
    DoScreenFadeIn(250)
    LSCore.Functions.Notify('Uw auto staat te koop voor, €'..price..',-', 'success')
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end

RegisterNetEvent('framework-occasion:client:refreshVehicles')
AddEventHandler('framework-occasion:client:refreshVehicles', function()
    if inRange then
        LSCore.Functions.TriggerCallback('framework-occasions:server:getVehicles', function(vehicles)
            occasionVehicles = vehicles
            despawnOccasionsVehicles()
            spawnOccasionsVehicles(vehicles)
        end)
    end
end)