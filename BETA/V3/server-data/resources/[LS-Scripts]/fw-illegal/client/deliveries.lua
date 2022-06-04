currentDealer = nil
knockingDoor = false

local dealerIsHome = false

local waitingDelivery = nil
local activeDelivery = nil

local interacting = false

local deliveryTimeout = 0

local isHealingPerson = false
local healAnimDict = "mini@cpr@char_a@cpr_str"
local healAnim = "cpr_pumpchest"

CurrentCops = 0

RegisterNetEvent('framework-police:SetCopCount')
AddEventHandler('framework-police:SetCopCount', function(amount)
    CurrentCops = amount
end)

-- Code

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        nearDealer = false

        for id, dealer in pairs(Config.Dealers) do
            local dealerDist = GetDistanceBetweenCoords(pos, dealer["coords"]["x"], dealer["coords"]["y"], dealer["coords"]["z"])

            if dealerDist <= 2 then
                nearDealer = true

                if dealerDist <= 1.5 and not isHealingPerson then
                    if not interacting then
                        if not dealerIsHome then
                            if not ShowingInteraction2 then
                                ShowingInteraction2 = true
                                exports['fw-ui']:ShowInteraction('[E] Aankloppen', 'primary')
                            end
                            if IsControlJustPressed(0, 38) then
                                currentDealer = id
                                ShowingInteraction2 = false
                                exports['fw-ui']:HideInteraction()
                                knockDealerDoor()
                            end
                        elseif dealerIsHome then
                            if dealer["name"] == "Pogo" then
                                if not ShowingInteraction2 then
                                    ShowingInteraction2 = true
                                    exports['fw-ui']:ShowInteraction('[E] Winkel', 'primary')
                                end
                            else
                                if not ShowingInteraction2 then
                                    ShowingInteraction2 = true
                                    exports['fw-ui']:ShowInteraction('[E] Werken', 'primary')
                                end
                        end

                            if IsControlJustPressed(0, 38) then
                                if dealer['name'] == 'Pogo' then
                                    buyDealerStuff()
                                else
                                    if waitingDelivery == nil then
                                        TriggerEvent("chatMessage", "Dealer "..Config.Dealers[currentDealer]["name"], "normal", 'Hier heb je de producten wacht op de aflever locatie per mail')
                                        requestDelivery()
                                        interacting = false
                                        dealerIsHome = false
                                    else
                                        TriggerEvent("chatMessage", "Dealer "..Config.Dealers[currentDealer]["name"], "error", 'Je hebt nog een order open staan eh ?')
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if not nearDealer then
            if ShowingInteraction2 then
                ShowingInteraction2 = false
                exports['fw-ui']:HideInteraction()
            end
            dealerIsHome = false
            Citizen.Wait(2000)
        end

        Citizen.Wait(3)
    end
end)

function GetClosestPlayer()
    local closestPlayers = LSCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

knockDealerDoor = function()
    local hours = GetClockHours()
    local min = Config.Dealers[currentDealer]["time"]["min"]
    local max = Config.Dealers[currentDealer]["time"]["max"]

    if hours >= min and hours <= max then
        knockDoorAnim(true)
    else
        knockDoorAnim(false)
    end
end

function buyDealerStuff()
    LSCore.Functions.GetPlayerData(function(PlayerData)
    local repItems = {}
    local runslevel = PlayerData.metadata["runs"]
        for k, v in pairs(Config.DealerItems) do
            if runslevel >= Config.DealerItems[k].minrep then
                repItems[k] = Config.DealerItems[k]
            end
        end
        if exports['fw-inv']:CanOpenInventory() then
            local Shop = {['Type'] = 'Store', ['SubType'] = 'Dealer', ['InvName'] = 'Dealer2', ['Items'] = repItems}
            TriggerServerEvent('framework-inv:server:open:inventory:other', Shop, 'Store')
        end

    end)
end

function knockDoorAnim(home)
    local knockAnimLib = "timetable@jimmy@doorknock@"
    local knockAnim = "knockdoor_idle"
    local PlayerPed = PlayerPedId()
    local myData = LSCore.Functions.GetPlayerData()

    if home then
        TriggerEvent('framework-sound:client:play', 'knock_door', 0.2) 
        Citizen.Wait(100)
        while (not HasAnimDictLoaded(knockAnimLib)) do
            RequestAnimDict(knockAnimLib)
            Citizen.Wait(100)
        end
        knockingDoor = true
        TaskPlayAnim(PlayerPed, knockAnimLib, knockAnim, 3.0, 3.0, -1, 1, 0, false, false, false )
        Citizen.Wait(3500)
        TaskPlayAnim(PlayerPed, knockAnimLib, "exit", 3.0, 3.0, -1, 1, 0, false, false, false)
        knockingDoor = false
        Citizen.Wait(1000)
        dealerIsHome = true
        if Config.Dealers[currentDealer]["name"] == "Ouweheer" then
            TriggerEvent("chatMessage", "Dealer "..Config.Dealers[currentDealer]["name"], "normal", 'Goeiedag wat kan ik voor je doen natnek')
       else
            TriggerEvent("chatMessage", "Dealer "..Config.Dealers[currentDealer]["name"], "normal", 'Yo '..myData.charinfo.firstname..', wat kan ik voor je betekenen?')
        end
        -- knockTimeout()
    else
        TriggerEvent('framework-sound:client:play', 'knock_door', 0.2)  
        Citizen.Wait(100)
        while (not HasAnimDictLoaded(knockAnimLib)) do
            RequestAnimDict(knockAnimLib)
            Citizen.Wait(100)
        end
        knockingDoor = true
        TaskPlayAnim(PlayerPed, knockAnimLib, knockAnim, 3.0, 3.0, -1, 1, 0, false, false, false )
        Citizen.Wait(3500)
        TaskPlayAnim(PlayerPed, knockAnimLib, "exit", 3.0, 3.0, -1, 1, 0, false, false, false)
        knockingDoor = false
        Citizen.Wait(1000)
        LSCore.Functions.Notify('Niemand is thuis', 'error', 3500)
    end
end

RegisterNetEvent('framework-knocky:client:updateDealerItems')
AddEventHandler('framework-knocky:client:updateDealerItems', function(itemData, amount)
    TriggerServerEvent('framework-knocky:server:updateDealerItems', itemData, amount, currentDealer)
end)

RegisterNetEvent('framework-knocky:client:setDealerItems')
AddEventHandler('framework-knocky:client:setDealerItems', function(itemData, amount, dealer)
    Config.Dealers[dealer]["products"][itemData.slot].amount = Config.Dealers[dealer]["products"][itemData.slot].amount - amount
end)

function requestDelivery()
    local location = math.random(1, #Config.DeliveryLocations)
    local amount = math.random(1, 3)
    local item = randomDeliveryItemOnRep()
    waitingDelivery = {
        ["coords"] = Config.DeliveryLocations[location]["coords"],
        ["locationLabel"] = Config.DeliveryLocations[location]["label"],
        ["amount"] = amount,
        ["dealer"] = currentDealer,
        ["itemData"] = Config.DeliveryItems[item]
    }
    TriggerServerEvent('framework-knocky:server:giveDeliveryItems', amount)
    SetTimeout(2000, function()
        TriggerServerEvent('framework-phone:server:sendNewMail', {
            sender = Config.Dealers[currentDealer]["name"],
            subject = "Aflever Locatie",
            message = "De bezorg locatie staat gemarkeerd op je GPS. Zorg dat je optijd bent.<br><br>Levering: "..amount.."x Wiet",
            -- button = {
            --     enabled = true,
            --     buttonEvent = "framework-knocky:client:setLocation",
            --     buttonData = waitingDelivery
            -- }
        })
    end)
    SetTimeout(2500, function()
        TriggerEvent('framework-knocky:client:setLocation', waitingDelivery)
    end)
end

function randomDeliveryItemOnRep()
    local ped = PlayerPedId()
    local myRep = LSCore.Functions.GetPlayerData().metadata["runs"]

    retval = nil

    for k, v in pairs(Config.DeliveryItems) do
        if Config.DeliveryItems[k]["minrep"] <= myRep then
            local availableItems = {}
            table.insert(availableItems, k)

            local item = math.random(1, #availableItems)

            retval = item
        end
    end
    return retval
end

function setMapBlip(x, y)
    SetNewWaypoint(x, y)
    LSCore.Functions.Notify('De route staat op je GPS aangegeven', 'success');
end

RegisterNetEvent('framework-knocky:client:setLocation')
AddEventHandler('framework-knocky:client:setLocation', function(locationData)
    if activeDelivery == nil then
        activeDelivery = locationData
    else
        setMapBlip(activeDelivery["coords"]["x"], activeDelivery["coords"]["y"])
        LSCore.Functions.Notify('Je hebt nog een levering open staan')
        return
    end

    deliveryTimeout = 300

    deliveryTimer()

    setMapBlip(activeDelivery["coords"]["x"], activeDelivery["coords"]["y"])

    Citizen.CreateThread(function()
        while true do

            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local inDeliveryRange = false
            if activeDelivery ~= nil then
                local dist = GetDistanceBetweenCoords(pos, activeDelivery["coords"]["x"], activeDelivery["coords"]["y"], activeDelivery["coords"]["z"])

                if dist < 15 then
                    inDeliveryRange = true
                    if dist < 1.5 then
                        
                        if not ShowingInteraction3 then
                            ShowingInteraction3 = true
                            exports['fw-ui']:ShowInteraction('[E] Afleveren', 'primary')
                        end

                        if IsControlJustPressed(0, 38) then
                            deliverStuff(activeDelivery)
                            activeDelivery = nil
                            waitingDelivery = nil
                            break
                        end
                    end
                end

                if not inDeliveryRange then
                    if ShowingInteraction3 then
                        ShowingInteraction3 = false
                        exports['fw-ui']:HideInteraction()
                    end
                    Citizen.Wait(1500)
                end
            else
                break
            end

            Citizen.Wait(3)
        end
    end)
end)

function deliveryTimer()
    Citizen.CreateThread(function()
        while true do

            if deliveryTimeout - 1 > 0 then
                deliveryTimeout = deliveryTimeout - 1
            else
                deliveryTimeout = 0
                break
            end

            Citizen.Wait(1000)
        end
    end)
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

function deliverStuff(activeDelivery)
    if deliveryTimeout > 0 then
        -- exports['fw-anims']:Cancel()
            local StreetLabel = LSCore.Functions.GetStreetLabel()
            TriggerServerEvent('framework-police:server:alert:weedbrick', GetEntityCoords(PlayerPedId()), StreetLabel)
        Citizen.Wait(500)
        -- exports['fw-anims']:PlayEmote("bumbin")
        checkPedDistance()
        LSCore.Functions.Progressbar("work_dropbox", "Afleveren", 9500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerServerEvent('framework-knocky:server:succesDelivery', activeDelivery, true)
        end, function() -- Cancel
            ClearPedTasks(PlayerPedId())
            LSCore.Functions.Notify("Geannuleerd", "error")
        end)
    else
        TriggerServerEvent('framework-knocky:server:succesDelivery', activeDelivery, false)
    end
    deliveryTimeout = 0
end

function checkPedDistance()
    local PlayerPeds = {}
    if next(PlayerPeds) == nil then
        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            table.insert(PlayerPeds, ped)
        end
    end
    
    local closestPed, closestDistance = LSCore.Functions.GetClosestPed(coords, PlayerPeds)

    if closestDistance < 40 and closestPed ~= 0 then
        local callChance = math.random(1, 100)

        if callChance < 40 then
            doPoliceAlert()
        end
    end
end

function doPoliceAlert()
    local StreetLabel = LSCore.Functions.GetStreetLabel()
    TriggerServerEvent('framework-police:server:send:drugs:alert', GetEntityCoords(PlayerPedId()), StreetLabel)
end


RegisterNetEvent('framework-knocky:client:sendDeliveryMail')
AddEventHandler('framework-knocky:client:sendDeliveryMail', function(type, deliveryData)
    if type == 'perfect' then
        TriggerServerEvent('framework-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Aflevering",
            message = "Topper thanks! Heerlijk gedaan we zien elkaar snel.<br><br>Groetjes, <br>"..Config.Dealers[deliveryData["dealer"]]["name"]
        })
    elseif type == 'bad' then
        TriggerServerEvent('framework-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Aflevering",
            message = "Ik krijg klachten over je leveringen raap jezelf bij elkaar"
        })
    elseif type == 'late' then
        TriggerServerEvent('framework-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Aflevering",
            message = "Je was niet op tijd wat is dit ?!"
        })
    end
end)

RegisterNetEvent('framework-knocky:client:CreateDealer')
AddEventHandler('framework-knocky:client:CreateDealer', function(dealerName, minTime, maxTime)
    local ped = PlayerPedId()
    local loc = GetEntityCoords(ped)
    local DealerData = {
        name = dealerName,
        time = {
            min = minTime,
            max = maxTime,
        },
        pos = {
            x = loc.x,
            y = loc.y,
            z = loc.z,
        }
    }

    TriggerServerEvent('framework-knocky:server:CreateDealer', DealerData)
end)

RegisterNetEvent('framework-knocky:client:RefreshDealers')
AddEventHandler('framework-knocky:client:RefreshDealers', function(DealerData)
    Config.Dealers = DealerData
end)

RegisterNetEvent('framework-knocky:client:GotoDealer')
AddEventHandler('framework-knocky:client:GotoDealer', function(DealerData)
    local ped = PlayerPedId()

    SetEntityCoords(ped, DealerData["coords"]["x"], DealerData["coords"]["y"], DealerData["coords"]["z"])
    LSCore.Functions.Notify('Je teleporteerde naar: '.. DealerData["name"] .. ' !', 'success')
end)