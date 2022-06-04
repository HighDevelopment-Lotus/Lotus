local InCornerZone = false
local HasNpcFound = false
local WelPed = false
local CurrentNpc = nil
local LastPed = {}

local function HandleTalk(entity, Question, RandomPrice, DrugItemName, BagAmount)
    interactingWith = entity
    local ply = PlayerPedId()
    TaskTurnPedToFaceEntity(entity, ply, 0.0)
    TaskTurnPedToFaceEntity(ply, entity, 0.0)

    Wait(1000)
    FreezeEntityPosition(ply, true)
    FreezeEntityPosition(entity, true)

    local offsetCoords = GetOffsetFromEntityInWorldCoords(ply, 1.0, 0.0, 0.6) -- Put camera over the player's shoulder
    local currentRot = GetGameplayCamRot()
    currentCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", offsetCoords.x, offsetCoords.y, offsetCoords.z, currentRot.x, currentRot.y, currentRot.z, 60.00, false, 0)
    SetCamActive(currentCam, true)
    RenderScriptCams(1, true, 500, true, true)
    PointCamAtEntity(currentCam, entity, 1.0, 0.0, 0.6, true) -- Angle the camera at the target entity
    PlayFacialAnim(entity, "mic_chatter", "mp_facial")

    local title1 = Question
    local items1 = {
        {text = "Ja", value="yes"},
        {text = "Nee", value="no"}
    }
    SendNUIMessage({
        type = "newDialogue",
        title = title1,
        items = items1,
        drugtype = DrugItemName,
        zakjes = BagAmount,
        prijs = RandomPrice
    })
    SetNuiFocus(true, true)
end

function Talk2Npc(CurrentNpc, Question, RandomPrice, DrugItemName, BagAmount)
    HandleTalk(CurrentNpc, Question, RandomPrice, DrugItemName, BagAmount)
end

local function ExitDialogue()
    local Ped = interactingWith
    local ply = PlayerPedId()
    FreezeEntityPosition(ply, false)
    ClearPedTasks(ply)

    SetCamActive(currentCam, false)
    RenderScriptCams(0, true, 500, true, true)
    DestroyCam(currentCam)
    currentCam = nil

    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "close"
    })
    interactingWith = nil
end

RegisterCommand("exitdialogue", ExitDialogue)
RegisterKeyMapping("exitdialogue", "Exit current dialogue interaction", "keyboard", "BACK") -- Default key to exit as backspace

RegisterNUICallback('select', function(data, cb)
    local selection = data.option
    local Ped = interactingWith
    local luck = math.random(1, 100)
    if cb ~= nil then

    if selection == 'yes' then
        SellNowToPed(data.value.prijs, data.value.drugtype, data.value.zakjes)
        if luck <= 75 then
            local StreetLabel = LSCore.Functions.GetStreetLabel()
            TriggerServerEvent('framework-police:server:alert:cornerselling', GetEntityCoords(PlayerPedId()), StreetLabel)
        end
    else
        FreezeEntityPosition(Ped, false)
        ClearPedTasks(Ped)

        ExitDialogue() 
    end
end

    ExitDialogue()
    cb({})
end)

-- Threads

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if LoggedIn then
            if Config.IsCornerSelling then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.CornerSellingData['Coords']['X'], Config.CornerSellingData['Coords']['Y'], Config.CornerSellingData['Coords']['Z'], true)
                InCornerZone = false
                if Distance < 1250 then
                    InCornerZone = true
                    local ClosestNpcPed, ClosestNpcDistance = LSCore.Functions.GetClosestPed(PlayerCoords, GetActiveServerPlayers())
                    if ClosestNpcPed ~= 0 and ClosestNpcDistance < 3.0 then
                        WelPed = true
                        TryToSellToNpc(ClosestNpcPed, ClosestNpcDistance)
                        Citizen.Wait(45)
                    else
                        Citizen.Wait(450)
                    end
                end
                if not InCornerZone then
                    Citizen.Wait(1500)
                    if Config.IsCornerSelling then
                        Config.IsCornerSelling = false
                        CurrentNpc = nil
                        HasNpcFound = false
                        WelPed = false
                        LSCore.Functions.Notify('Drugs verkoop uitgezet. Je bent te ver uit de stad', 'error')
                    end
                end
            else
                Citizen.Wait(1500)
            end
        end
    end
end)

-- Events

function NearNpcSell()
    return WelPed
end

RegisterNetEvent('framework-illegal:client:toggle:corner:selling', function()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.CornerSellingData['Coords']['X'], Config.CornerSellingData['Coords']['Y'], Config.CornerSellingData['Coords']['Z'], true)
    if Distance < 1250 then
        LSCore.Functions.TriggerCallback('framework-illegal:server:has:drugs', function(HasDrugs)
            if HasDrugs then
                if Config.IsCornerSelling then
                    CurrentNpc = nil
                    HasNpcFound = false
                    Config.IsCornerSelling = false
                    LSCore.Functions.Notify('Drugsverkoop is uit gezet', 'error')
                elseif not Config.IsCornerSelling then
                    Config.IsCornerSelling = true
                    LSCore.Functions.Notify('Drugsverkoop is aan gezet', 'success')
                end
            else
                CurrentNpc = nil
                HasNpcFound = false
                Config.IsCornerSelling = false
                LSCore.Functions.Notify('Je hebt geen drugs op zak', 'error')
            end
        end)
    else
        CurrentNpc = nil
        HasNpcFound = false
        Config.IsCornerSelling = false
        LSCore.Functions.Notify('Je bent niet in de stad', 'error')
    end
end)

RegisterNetEvent('framework-illegal:client:sell:to:ped', function()
    if CurrentNpc ~= nil and Config.IsCornerSelling then
        LSCore.Functions.TriggerCallback('framework-illegal:server:get:drugs:items', function(DrugsResult)
            local DrugItem = math.random(1, #DrugsResult)
            local DrugItemName = DrugsResult[DrugItem]['Item']
            local BagAmount = math.random(1, DrugsResult[DrugItem]['Amount'])
            local SuccesChance = math.random(1, 35)
            local ScamChance = math.random(1, 5)
            if BagAmount > 15 then
                BagAmount = math.random(9, 15)
            end
            local RandomPrice = BagAmount * Config.SellDrugs[DrugItemName]['SellAMount'] + 50
            if ScamChance == 5 then
                RandomPrice = math.random(3, 10) * BagAmount
            end
            if SuccesChance <= 30 then
                PlayAmbientSpeech1(CurrentNpc, "GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL")
                TaskStartScenarioInPlace(CurrentNpc, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, false)
                HasOffer = true
                Handled = false
                while HasOffer do
                    Citizen.Wait(0)
                    local PlayerCoords = GetEntityCoords(PlayerPedId())
                    local NpcPedCoords = GetEntityCoords(CurrentNpc)
                    local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, NpcPedCoords.x, NpcPedCoords.y, NpcPedCoords.z, true)
                    if Distance < 2.0 then
                        if not Handled then
                            Handled = true
                            exports['fw-illegal']:Talk2Npc(CurrentNpc, 'Wil je '..BagAmount..' x '..DrugItemName..' voor € '..RandomPrice..' verkopen ?', RandomPrice, DrugItemName, BagAmount)
                        end
                        -- DrawText3D(NpcPedCoords.x, NpcPedCoords.y, NpcPedCoords.z, '[~g~E~s~] '..BagAmount..'x '..DrugItemName..' for ~g~$'..RandomPrice..'~s~? / [~r~H~w~] Reject Offer')
                    else
                        SetEveryoneIgnorePlayer(PlayerId(), false)
                        Citizen.Wait(250)
                        ClearPedTasksImmediately(CurrentNpc)
                        TaskSmartFleePed(CurrentNpc, PlayerPedId(), 100.0, 15000)
                        table.insert(LastPed, CurrentNpc) 
                        HasNpcFound = false
                        HasOffer = false
                        CurrentNpc = nil
                    end
                    if IsControlJustReleased(0, 74) then
                        SetEveryoneIgnorePlayer(PlayerId(), false)
                        Citizen.Wait(250)
                        TaskSmartFleePed(CurrentNpc, PlayerPedId(), 100.0, 15000)
                        table.insert(LastPed, CurrentNpc)
                        HasNpcFound = false
                        HasOffer = false
                        CurrentNpc = nil
                    end
                    if IsControlJustReleased(0, 38) then
                        HasOffer = false
                        SellNowToPed(RandomPrice, DrugItemName, BagAmount)
                    end
                end
            else
                HasOffer = false
                HasNpcFound = false
                TriggerServerEvent('framework-police:server:alert:cornerselling', GetEntityCoords(CurrentNpc), LSCore.Functions.GetStreetLabel())
                SetEveryoneIgnorePlayer(PlayerId(), false)
                Citizen.Wait(150)
                TaskSmartFleePed(CurrentNpc, PlayerPedId(), 100.0, 15000)
                table.insert(LastPed, CurrentNpc) 
                CurrentNpc = nil
            end
        end)
    else
        LSCore.Functions.Notify('Je bent niet aan het drugs verkopen', 'error')
    end
end)

-- Functions

function TryToSellToNpc(NpcPed, NpcPedDistance)
    if not HasNpcFound then
        HasNpcFound = true
        for k, v in pairs(LastPed) do
            if v == NpcPed then
                HasNpcFound = false
                CurrentNpc = nil
                return
            end
        end
        while HasNpcFound do  
            Citizen.Wait(4)
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local NpcPedCoords = GetEntityCoords(NpcPed)    
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, NpcPedCoords.x, NpcPedCoords.y, NpcPedCoords.z, true)    
            if Distance < 5.0 then
                SetEveryoneIgnorePlayer(PlayerId(), true)
                TaskGoStraightToCoord(NpcPed, PlayerCoords, 1.2, -1, 0.0, 0.0)
                TaskLookAtEntity(NpcPed, PlayerPedId(), 5500.0, 2048, 3)
                TaskTurnPedToFaceEntity(NpcPed, PlayerPedId(), 5500)
                CurrentNpc = NpcPed
                Citizen.Wait(50)
            else
                SetEveryoneIgnorePlayer(PlayerId(), false)
                Citizen.Wait(250)
                TaskSmartFleePed(NpcPed, PlayerPedId(), 100.0, 15000)
                table.insert(LastPed, NpcPed) 
                CurrentNpc = nil
                HasNpcFound = false
                Citizen.Wait(4)
            end
        end  
    end
end

function SellNowToPed(Price, Item, Amount)
    FreezeEntityPosition(CurrentNpc, true)
    SetEveryoneIgnorePlayer(PlayerId(), true)
    TriggerEvent('framework-inv:client:set:busy', true)
    LSCore.Functions.Progressbar("open-brick", "Verkopen..", 7500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "oddjobs@assassinate@vice@hooker",
        anim = "argue_a",
        flags = 49,
    }, {}, {}, function() -- Done
        table.insert(LastPed, CurrentNpc)
        ClearPedTasksImmediately(CurrentNpc)
        FreezeEntityPosition(CurrentNpc, false)
        SetEveryoneIgnorePlayer(PlayerId(), false)
        TriggerEvent('framework-inv:client:set:busy', false)
            -- TriggerServerEvent('framework-illegal:server:finish:corner:selling', Price, Item, Amount)
            LSCore.Functions.TriggerCallback('framework-illegal:server:finish:corner:selling', function() end, Price, Item, Amount)

        StopAnimTask(PlayerPedId(), "oddjobs@assassinate@vice@hooker", "argue_a", 1.0)
        LSCore.Functions.TriggerCallback('framework-illegal:server:has:drugs', function(HasDrugs)
            if not HasDrugs then
                Config.IsCornerSelling = false
                LSCore.Functions.Notify('You have no more stuff..', 'error')
            end
        end)
        HasNpcFound = false
        CurrentNpc = nil
    end, function()
        table.insert(LastPed, CurrentNpc) 
        ClearPedTasksImmediately(CurrentNpc)
        FreezeEntityPosition(CurrentNpc, false)
        SetEveryoneIgnorePlayer(PlayerId(), false)
        TriggerEvent('framework-inv:client:set:busy', false)
        LSCore.Functions.Notify("Cancelled..", "error")
        StopAnimTask(PlayerPedId(), "oddjobs@assassinate@vice@hooker", "argue_a", 1.0)
        CurrentNpc = nil
        HasNpcFound = false
    end)
end

function ResetCornerSelling()
    LastPed = {}
    CurrentNpc = nil
    HasNpcFound = false
    Config.IsCornerSelling = false
end

function IsDealing()
    return Config.IsCornerSelling
end