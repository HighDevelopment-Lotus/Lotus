TryToFish = function()
    -- LSCore.Functions.TriggerCallback('framework-fishing:GetItemData', function(count)
        if IsPedSwimming(cachedData["ped"]) then return LSCore.Functions.Notify("Zwemmen en vissen tegelijk? Hmm interessant.", "error") end 
        if IsPedInAnyVehicle(cachedData["ped"]) then return LSCore.Functions.Notify("Je kunt niet vissen in een auto.", "error") end 
                local waterValidated, castLocation = IsInWater()
                if waterValidated then
                    local fishingRod = GenerateFishingRod(cachedData["ped"])

                    CastBait(fishingRod, castLocation)
                else
                    LSCore.Functions.Notify("Kijk naar 't water om te vissen", "primary")
                end
    -- end, Config.FishingItems["rod"]["name"], Config.FishingItems["bait"]["name"])
end

local isFishing = false
CastBait = function(rodHandle, castLocation)
    if isFishing then return end
    isFishing = true

    local startedCasting = GetGameTimer()

    -- if not HasFishingBait() then
    --     LSCore.Functions.Notify('Je hebt geen aas!', 'error')

    --     isFishing = false
    --     return DeleteEntity(rodHandle)
    -- end

    while not IsControlJustPressed(0, 38) do
        Citizen.Wait(5)

        ShowHelpNotification("Werp je hengel met ~INPUT_PICKUP~")

        if GetGameTimer() - startedCasting > 5000 then
            LSCore.Functions.Notify("Je moet het aas uitwerpen.", "primary")

            isFishing = false
            return DeleteEntity(rodHandle)
        end
    end

    PlayAnimation(cachedData["ped"], "mini@tennis", "forehand_ts_md_far", {
        ["flag"] = 48
    })

    while IsEntityPlayingAnim(cachedData["ped"], "mini@tennis", "forehand_ts_md_far", 3) do
        Citizen.Wait(0)
    end

    PlayAnimation(cachedData["ped"], "amb@world_human_stand_fishing@idle_a", "idle_c", {
        ["flag"] = 11
    })

    local startedBaiting = GetGameTimer()
    local randomBait = math.random(10000, 30000)
    LSCore.Functions.Notify("Wachten tot een vis bijt...", "primary", "10000")
    local interupted = false

    Citizen.Wait(1000)

    while GetGameTimer() - startedBaiting < randomBait do
        Citizen.Wait(2)

        if not IsEntityPlayingAnim(cachedData["ped"], "amb@world_human_stand_fishing@idle_a", "idle_c", 3) then
            interupted = true

            break
        end
    end

    RemoveLoadingPrompt()

    if interupted then
        ClearPedTasks(cachedData["ped"])

        isFishing = false
        CastBait(rodHandle, castLocation)
        return DeleteEntity(rodHandle)
    end
    
    local caughtFish = TryToCatchFish()

    ClearPedTasks(cachedData["ped"])

    if caughtFish then
        LSCore.Functions.TriggerCallback('framework-fishing:receiveFish', function()
        end)
        TriggerServerEvent('framework-ui:server:remove:stress', math.random(1, 3))
    else
        LSCore.Functions.Notify("De vis is losgeraakt verdikkeme", "error")
    end
    
    isFishing = false
    CastBait(rodHandle, castLocation)
    return DeleteEntity(rodHandle)
end

TryToCatchFish = function()
    local minigameSprites = {
        ["powerDict"] = "custom",
        ["powerName"] = "bar",
    
        ["tennisDict"] = "tennis",
        ["tennisName"] = "swingmetergrad"
    }

    while not HasStreamedTextureDictLoaded(minigameSprites["powerDict"]) and not HasStreamedTextureDictLoaded(minigameSprites["tennisDict"]) do
        RequestStreamedTextureDict(minigameSprites["powerDict"], false)
        RequestStreamedTextureDict(minigameSprites["tennisDict"], false)

        Citizen.Wait(1)
    end

    local swingOffset = 0.09
    local swingReversed = false

    local DrawObject = function(x, y, width, height, red, green, blue)
        DrawRect(x + (width / 2.0), y + (height / 2.0), width, height, red, green, blue, 150)
    end

    while true do
        Citizen.Wait(1)

        ShowHelpNotification("Druk ~INPUT_CONTEXT~ in het groene gedeelte.")

        DrawSprite(minigameSprites["powerDict"], minigameSprites["powerName"], 0.5, 0.4, 0.01, 0.2, 0.0, 255, 0, 0, 255)

        DrawObject(0.49453227, 0.3, 0.010449, 0.03, 0, 255, 0)

        DrawSprite(minigameSprites["tennisDict"], minigameSprites["tennisName"], 0.5, 0.4 + swingOffset, 0.018, 0.002, 0.0, 0, 0, 0, 255)

        if swingReversed then
            swingOffset = swingOffset - 0.005
        else
            swingOffset = swingOffset + 0.005
        end

        if swingOffset > 0.09 then
            swingReversed = true
        elseif swingOffset < -0.09 then
            swingReversed = false
        end

        if IsControlJustPressed(0, 38) then
            swingOffset = 0 - swingOffset

            extraPower = (swingOffset + 0.09) * 250 + 1.0

            --print(extraPower)
            if extraPower >= 30 then
                return true
            else
                return false
            end
        end
    end

    SetStreamedTextureDictAsNoLongerNeeded(minigameSprites["powerDict"])
    SetStreamedTextureDictAsNoLongerNeeded(minigameSprites["tennisDict"])
end



IsInWater = function()
    local startedCheck = GetGameTimer()

    local ped = cachedData["ped"]
    local pedPos = GetEntityCoords(ped)

    local forwardVector = GetEntityForwardVector(ped)
    local forwardPos = vector3(pedPos["x"] + forwardVector["x"] * 10, pedPos["y"] + forwardVector["y"] * 10, pedPos["z"])

    local fishHash = `a_c_fish`

    WaitForModel(fishHash)

    local waterHeight = GetWaterHeight(forwardPos["x"], forwardPos["y"], forwardPos["z"])

    local fishHandle = CreatePed(1, fishHash, forwardPos, 0.0, false)
    
    SetEntityAlpha(fishHandle, 0, true) -- makes the fish invisible.

    -- DrawBusySpinner("Checking fishing location...")
    LSCore.Functions.Notify("Vislocatie controleren...", "success", "3000")

    while GetGameTimer() - startedCheck < 3000 do
        Citizen.Wait(0)
    end

    RemoveLoadingPrompt()

    local fishInWater = IsEntityInWater(fishHandle)

    DeleteEntity(fishHandle)

    SetModelAsNoLongerNeeded(fishHash)

    return fishInWater, fishInWater and vector3(forwardPos["x"], forwardPos["y"], waterHeight) or false
end

GenerateFishingRod = function(ped)
    local pedPos = GetEntityCoords(ped)
    
    local fishingRodHash = `prop_fishing_rod_01`

    WaitForModel(fishingRodHash)

    local rodHandle = CreateObject(fishingRodHash, pedPos, true)

    AttachEntityToEntity(rodHandle, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)

    SetModelAsNoLongerNeeded(fishingRodHash)

    return rodHandle
end

-- HandleStore = function()
--     local storeData = Config.FishingRestaurant

--     WaitForModel(storeData["ped"]["model"])

--     local pedHandle = CreatePed(5, storeData["ped"]["model"], storeData["ped"]["position"], storeData["ped"]["heading"], false)

--     SetEntityInvincible(pedHandle, true)
--     SetEntityAsMissionEntity(pedHandle, true, true)
--     SetBlockingOfNonTemporaryEvents(pedHandle, true)

--     cachedData["storeOwner"] = pedHandle

--     SetModelAsNoLongerNeeded(storeData["ped"]["model"])

--     local storeBlip = AddBlipForCoord(storeData["ped"]["position"])
	
--     SetBlipSprite(storeBlip, storeData["blip"]["sprite"])
--     SetBlipScale(storeBlip, 0.65)
--     SetBlipColour(storeBlip, storeData["blip"]["color"])
--     SetBlipAsShortRange(storeBlip, true)
--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentString(storeData["name"])
--     EndTextCommandSetBlipName(storeBlip)
-- end


-- SellFish = function()
--     LSCore.Functions.TriggerCallback('framework-fishing:GetItemData', function(count)
--         TaskTurnPedToFaceEntity(cachedData["storeOwner"], cachedData["ped"], 1000)
--         TaskTurnPedToFaceEntity(cachedData["ped"], cachedData["storeOwner"], 1000)

--         TriggerServerEvent("framework-fishing:sellFish", function(sold, fishesSold) end)
--     end)
-- end



PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
      
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

FadeOut = function(duration)
    DoScreenFadeOut(duration)
    
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
end

FadeIn = function(duration)
    DoScreenFadeIn(500)

    while not IsScreenFadedIn() do
        Citizen.Wait(0)
    end
end

WaitForModel = function(model)
    if not IsModelValid(model) then
        return
    end

	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
end

DrawBusySpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(3)
end

ShowHelpNotification = function(msg, thisFrame, beep, duration)
	AddTextEntry('qbHelpNotification', msg)

	if thisFrame then
		DisplayHelpTextThisFrame('qbHelpNotification', false)
	else
		if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('qbHelpNotification')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end

-- function HasFishingBait()
--     local rtval = false
--     LSCore.Functions.TriggerCallback('Framework:HasItem', function(amount)
--         if amount then
--             rtval = true
--         end
--     end, "fishbait")
--     Wait(1000)
--     return rtval
-- end