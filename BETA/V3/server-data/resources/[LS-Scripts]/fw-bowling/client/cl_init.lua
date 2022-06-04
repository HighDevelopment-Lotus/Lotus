local hasActivePins = false
local currentLane = 0
local totalThrown = 0
local totalDowned = 0
local lastBall = 0
local lanes = Config.BowlingLanes
local inBowlingZone = false
local function canUseLane(pLaneId)
    local shit = false

    LSCore.Functions.TriggerCallback('framework-bowling:getLaneAccess', function(response)
        if(response == true) then
            shit = true
        end
    end , pLaneId)
    Citizen.Wait(300)
    return shit

end

LSCore = exports['fw-base']:GetCoreObject()

Citizen.CreateThread(function()
    for k, v in pairs(lanes) do
        -- if (not v.enabled) then goto continueBox end
        exports["fw-polyzone"]:CreateBoxZone("framework-bowling:lane_"..k, v.pos, 1.8, 2.0, {
            heading=0,
            minZ=23.85,
            maxZ=27.85
        })

        -- ::continueBox::
    end
  
    exports["fw-polyzone"]:CreateBoxZone("bowling_alley", vector3(743.95, -774.54, 26.34), 16.8, 30.4, {
        heading=0.0,
        minZ=23.85,
        maxZ=28.85
    })

    local data = {
        id = 'bowling_npc_vendor',
        position = {
            coords = vector3(756.39, -774.74, 25.34),
            heading = 102.85,
        },
        pedType = 4,
        model = "a_m_o_salton_01",
        networked = false,
        distance = 25.0,
        settings = {
            { mode = 'invincible', active = true },
            { mode = 'ignore', active = true },
            { mode = 'freeze', active = true },
        },
        flags = {
            isNPC = true,
        },
    }
    RequestModel(GetHashKey(data.model))
	while not HasModelLoaded(GetHashKey(data.model)) do
		Citizen.Wait( 1 )
	end
    created_ped = CreatePed(data.pedType, data.model , data.position.coords.x,data.position.coords.y,data. position.coords.z, data.position.heading, data.networked, false)
	FreezeEntityPosition(created_ped, true)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
    local BowlingPed = {
        GetHashKey("a_m_o_salton_01"),
    }

    exports['fw-polyzone']:AddTargetModel(BowlingPed, {
        options = {
            {
                event = 'framework-bowling:client:openMenu',
                icon = 'fas fa-bowling-ball',
                label = 'Spelen'
            }
        },
        job = {"all"},
        distance = 2.5
    })
   

        ::continuePeak::
    


end)

local function drawStatusHUD(state, pValues)
    local title = "Bowling - Baan #" .. currentLane
    local values = {}
  
    table.insert(values, "Pogingen: " .. totalThrown)
    table.insert(values, "Punten: " .. totalDowned)

    if (pValues) then
        for k, v in pairs(pValues) do
        table.insert(values, v)
        end
    end
    
    SendNUIMessage({show = state , t = title , v = values})
end
RegisterNetEvent('framework-bowling:client:openMenu')
AddEventHandler('framework-bowling:client:openMenu' , function()
    local options = Config.BowlingVendor
    local data = {}
    local MenuItems = {}

    for itemId, item in pairs(options) do

        local TempData = {}
        TempData['Title'] = item.name
        TempData['Desc'] = 'Prijs '..item.price..''
        TempData['Data'] = {['Event'] = 'framework-bowling:openMenu2', ['Type'] = 'Client', ['args'] = itemId}
        table.insert(MenuItems, TempData)
    end
    local Data = {['Title'] = 'Bowlen', ['Desc'] = '', ['MainMenuItems'] = MenuItems}
    LSCore.Functions.OpenMenu(Data)
end)


RegisterNetEvent('framework-bowling:openMenu2')
AddEventHandler('framework-bowling:openMenu2' , function(data)
    Citizen.SetTimeout(500, function()
    local MenuItems = {}
    if(data['args'] == 'bowlingreceipt') then
            for k, v in pairs(lanes) do
                local TempData = {}
                TempData['Title'] = 'Baan #'..k
                TempData['Desc'] = 'Baan #'..k
                TempData['Data'] = {['Event'] = 'framework-bowling:bowlingPurchase', ['Type'] = 'Client', ['args'] = k}
                table.insert(MenuItems, TempData)
            end
        if (#MenuItems > 0) then
            local Banen = {['Title'] = 'Kies een Baan', ['Desc'] = '', ['MainMenuItems'] = MenuItems}
            LSCore.Functions.OpenMenu(Banen)
        end
    else
        TriggerEvent("framework-bowling:bowlingPurchase" , 'd')
    end
end)
end)

local sheesh = false
function shit(k,v) 
    Citizen.CreateThread(function()
        while sheesh == true do
            exports['fw-polyzone']:AddBoxZone("framework-bowling:lane_"..k, v.pos, 1.8, 2.0, {
            
                name = "framework-bowling:lane_"..k,
                heading = 0.0,
                minZ=20.85,
                maxZ=28.85,
                debugPoly = false,
            }, {
                options = {
                    {
                        type = 'client', 
                        event = 'framework-bowling:setupPins',
                        icon = 'fas fa-arrow-circle-down',
                        label = 'Setup Pins',
                        action = function()
                            if IsPedAPlayer() then return false end
                            TriggerEvent('framework-bowling:setupPins', k)
                        end
                        -- parms = { v = k }
                    }
                },
                job = {"all"},
                distance = 2.5
            })
            sheesh = false
            Citizen.Wait(0)
        end
    end)

end

local lastlane = 0

RegisterNetEvent('framework-bowling:bowlingPurchase')
AddEventHandler("framework-bowling:bowlingPurchase", function(data)
    -- print(data['args'])
    local isLane = type(data['args']) == "number"
    LSCore.Functions.TriggerCallback('framework-bowling:purchaseItem', function(response)
        if response == true then
            if(isLane == true) then
                for k, v in ipairs(lanes) do
                    -- if(canUseLane(k) == true) then
                        sheesh = true
                        -- print(k)
                        -- print(v)
                        shit(k , v)
                       
                    -- end
                end
                lanes[data['args']].enabled = false
                lastlane = data['args']
                LSCore.Functions.Notify("Veel plezier! | Baan toegewezen: #"..data['args'].."")
            else
                LSCore.Functions.Notify("Je hebt een bowlingball gekocht")
            end
            return
        end
    
    end , data['args'] , isLane)

   
end)

AddEventHandler('framework-bowling:setupPins', function(pParameters)
    local lane = pParameters
    -- print(lane)
    -- print(pParameters)
    if (not lanes[lane]) then return end
    if (hasActivePins) then return end
    hasActivePins = true
    currentLane = lane
    drawStatusHUD(true)
    createPins(lanes[lane].pins)
end)



local function canUseBall()
    return (lastBall == 0 or lastBall + 6000 < GetGameTimer()) and (inBowlingZone)
end

local function resetBowling()
    removePins()
    hasActivePins = false
    drawStatusHUD(false)
end

local gameState = {}
gameState[1] = {
    onState = function()
        if (totalDowned >= 10) then
            LSCore.Functions.Notify("Strike!")

            drawStatusHUD(true, {"Strike!"})

            Citizen.Wait(1500)

            resetBowling()
            totalDowned = 0
            totalThrown = 0
        elseif (totalDowned < 10) then
            removeDownedPins()
            drawStatusHUD(true, {"Throw again!"})
        end
    end
}
gameState[2] = {
    onState = function()
        if (totalDowned >= 10) then
            drawStatusHUD(true, {"Spare!"})
            LSCore.Functions.Notify("Spare!")


            Citizen.Wait(500)

            resetBowling()
        elseif (totalDowned < 10) then
            LSCore.Functions.Notify("Je hebt " .. totalDowned .. " pionen neergehaald!")

            Citizen.Wait(1500)

            resetBowling()
        end

        totalDowned = 0
        totalThrown = 0
    end
}

RegisterNetEvent('framework-bowling:client:itemused')
AddEventHandler('framework-bowling:client:itemused' , function()
    if (IsPedInAnyVehicle(PlayerPedId(), true)) then return end

    -- Cooldown
    if not (canUseBall()) then return end
    startBowling(false, function(ballObject)
        lastBall = GetGameTimer()
        
        if (hasActivePins) then
            totalThrown = totalThrown + 1

            local isRolling = true
            local timeOut = false

            while (isRolling and not timeOut) do
                Citizen.Wait(100)

                local ballPos = GetEntityCoords(ballObject)
                
                if (lastBall == 0 or lastBall + 10000 < GetGameTimer()) then
                    timeOut = true
                end 

                if (ballPos.x < 730.0) then
                    -- Finish line baby
                    isRolling = false
                end
            end

            Citizen.Wait(5000)

            totalDowned = getPinsDownedCount()

            if (timeOut) then
                drawStatusHUD(true, {"Tijd is om!"})
                timeOut = false
            end

            if (gameState[totalThrown]) then
                gameState[totalThrown].onState()
            end

            removeBowlingBall()
            
        end
    end)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    drawStatusHUD(false)
end)

AddEventHandler("fw-polyzone:enter", function(zone, data)
    if zone ~= "bowling_alley" then return end
    inBowlingZone = true
end)

AddEventHandler("fw-polyzone:exit", function(zone, data)
    if zone ~= "bowling_alley" then return end

    inBowlingZone = false
    TriggerServerEvent("framework-bowling:RemoveItem")
    lanes[lastlane].enabled = true

    if (hasActivePins) then
        resetBowling()
        totalDowned = 0
        totalThrown = 0
    end
end)