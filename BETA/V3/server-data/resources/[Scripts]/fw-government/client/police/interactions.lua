
-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(4)
        if LoggedIn then
            if Config.IsEscorted then
                DisableAllControlActions(0)
                EnableControlAction(0, 1, true)
		    	EnableControlAction(0, 2, true)
                EnableControlAction(0, 245, true)
                EnableControlAction(0, 38, true)
                EnableControlAction(0, 322, true)
                EnableControlAction(0, 249, true)
            end
            if Config.IsHandCuffed then
                DisableControlAction(0, 24, true) 
		    	DisableControlAction(0, 257, true)
		    	DisableControlAction(0, 25, true) 
		    	DisableControlAction(0, 263, true)
		    	DisableControlAction(0, 45, true)
		    	DisableControlAction(0, 22, true)
		    	DisableControlAction(0, 44, true)
		    	DisableControlAction(1, 37, true)
		    	DisableControlAction(0, 23, true)
		    	DisableControlAction(0, 288, true)
                DisableControlAction(2, 199, true)
                DisableControlAction(2, 244, true)
                DisableControlAction(0, 137, true)
		    	DisableControlAction(0, 59, true) 
		    	DisableControlAction(0, 71, true) 
		    	DisableControlAction(0, 72, true) 
		    	DisableControlAction(0, 73, true) 
		    	DisableControlAction(2, 36, true) 
		    	DisableControlAction(0, 264, true)
		    	DisableControlAction(0, 257, true)
		    	DisableControlAction(0, 140, true)
		    	DisableControlAction(0, 141, true)
		    	DisableControlAction(0, 142, true)
		    	DisableControlAction(0, 143, true)
		    	DisableControlAction(0, 75, true) 
                DisableControlAction(27, 75, true)
                DisableControlAction(0, 245, true)
                EnableControlAction(0, 249, true)
                if (not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3)) and not LSCore.Functions.GetPlayerData().metadata["isdead"] then
                    exports['fw-assets']:RequestAnimationDict("mp_arresting")
                    TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
                end
            end
            if not Config.IsEscorted and not Config.IsHandCuffed then
                Citizen.Wait(2000)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-police:client:cuff:closest')
AddEventHandler('framework-police:client:cuff:closest', function()
    if not IsPedRagdoll(PlayerPedId()) then
        local Player, Distance = LSCore.Functions.GetClosestPlayer()
        if Player ~= -1 and Distance < 1.5 then
            local ServerId = GetPlayerServerId(Player)
            if not IsPedInAnyVehicle(GetPlayerPed(Player)) and not IsPedInAnyVehicle(PlayerPedId(), false) then
                TriggerServerEvent("framework-police:server:cuff:closest", ServerId, true)
                TriggerEvent('framework-police:client:cuff:anim')
            else
                LSCore.Functions.Notify("Je kunt niet boeien in een voertuig", "error")
            end
        else
            LSCore.Functions.Notify("Niemand in de buurt", "error")
        end
    end
end)

RegisterNetEvent('framework-police:client:cuff:anim')
AddEventHandler('framework-police:client:cuff:anim', function()
    exports['fw-assets']:RequestAnimationDict("mp_arrest_paired")
    Citizen.Wait(100)
    TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "cop_p2_back_right", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
    Citizen.Wait(3500)
    TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "exit", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
end)

RegisterNetEvent('framework-police:client:get:cuffed:anim')
AddEventHandler('framework-police:client:get:cuffed:anim', function(PlayerId)
    local Cuffer = GetPlayerPed(GetPlayerFromServerId(PlayerId))
    local Heading = GetEntityHeading(Cuffer)
    exports['fw-assets']:RequestAnimationDict("mp_arrest_paired")
    TriggerServerEvent('framework-sound:server:play:distance', 2.0, 'handcuff', 0.2)
    SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(Cuffer, 0.0, 0.45, 0.0))
    Citizen.Wait(100)
    SetEntityHeading(PlayerPedId(), Heading)
    TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3.0, 3.0, -1, 32, 0, 0, 0, 0)
    Citizen.Wait(2500)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('framework-police:client:get:cuffed')
AddEventHandler('framework-police:client:get:cuffed', function()
    if not Config.IsHandCuffed then
        if math.random(1,3) == 2 then
            exports['fw-ui']:StartSkillTest(1, 'Fast', function(Outcome)
                if not Outcome then
                    Config.IsHandCuffed = true
                    TriggerServerEvent("framework-police:server:set:handcuff:status", true)
                    TriggerEvent('framework-inv:client:reset:weapon')
                    ClearPedTasksImmediately(PlayerPedId())
                    LSCore.Functions.Notify("Je bent geboeid, maar je kan lopen")
                end
            end)
        else
            Config.IsHandCuffed = true
            LSCore.Functions.Notify("Je bent geboeid, maar je kan lopen")
            TriggerServerEvent("framework-police:server:set:handcuff:status", true)
            TriggerEvent('framework-inv:client:reset:weapon')
            ClearPedTasksImmediately(PlayerPedId())
        end
    else
        Config.IsEscorted = false
        Config.IsHandCuffed = false
        DetachEntity(PlayerPedId(), true, false)
        TriggerServerEvent("framework-police:server:set:handcuff:status", false)
        ClearPedTasksImmediately(PlayerPedId())
        LSCore.Functions.Notify("Je bent ontboeid!")
    end
end)

RegisterNetEvent('framework-police:client:escort:closest')
AddEventHandler('framework-police:client:escort:closest', function()
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted then
            if not IsPedInAnyVehicle(PlayerPedId()) then
                TriggerServerEvent("framework-police:server:escort:closest", ServerId)
            else
                LSCore.Functions.Notify("Je kan niet iemand escorteren in een auto..", "error")
            end
        end
    else
        LSCore.Functions.Notify("Niemand in de buurt", "error")
    end
end)

RegisterNetEvent('framework-police:client:get:escorted')
AddEventHandler('framework-police:client:get:escorted', function(PlayerId)
    if not Config.IsEscorted then
        Config.IsEscorted = true
        local Dragger = GetPlayerPed(GetPlayerFromServerId(PlayerId))
        SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(Dragger, 0.0, 0.45, 0.0))
        AttachEntityToEntity(PlayerPedId(), Dragger, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    else
        Config.IsEscorted = false
        DetachEntity(PlayerPedId(), true, false)
    end
end)

RegisterNetEvent('framework-police:client:set:in:vehicle:closest')
AddEventHandler('framework-police:client:set:in:vehicle:closest', function()
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted  then
            TriggerServerEvent("framework-police:server:set:in:vehicle", ServerId)
        end
    else
        LSCore.Functions.Notify("Niemand in de buurt..", "error")
    end
end)

RegisterNetEvent('framework-police:client:set:out:vehicle:closest')
AddEventHandler('framework-police:client:set:out:vehicle:closest', function()
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted then
            TriggerServerEvent("framework-police:server:set:out:vehicle", ServerId)
        end
    else
        LSCore.Functions.Notify("Niemand in de buurt..", "error")
    end
end)

RegisterNetEvent('framework-police:client:set:out:veh')
AddEventHandler('framework-police:client:set:out:veh', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        TaskLeaveVehicle(PlayerPedId(), vehicle, 16)
    end
end)

RegisterNetEvent('framework-police:client:set:in:veh')
AddEventHandler('framework-police:client:set:in:veh', function()
    if Config.IsHandCuffed or Config.IsEscorted then
        local vehicle = LSCore.Functions.GetClosestVehicle()
        if DoesEntityExist(vehicle) then
			for i = GetVehicleMaxNumberOfPassengers(vehicle), -1, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    Config.IsEscorted = false
                    ClearPedTasks(PlayerPedId())
                    DetachEntity(PlayerPedId(), true, false)
                    Citizen.Wait(100)
                    SetPedIntoVehicle(PlayerPedId(), vehicle, i)
                    return
                end
            end
		end
    end
end)

RegisterNetEvent('framework-police:client:steal:closest')
AddEventHandler('framework-police:client:steal:closest', function()
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    local ServerId = GetPlayerServerId(Player)
    local PlayerPed = GetPlayerPed(Player)
    if Player ~= -1 and Distance < 2.5 then
        if IsEntityPlayingAnim(PlayerPed, "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(PlayerPed, "mp_arresting", "idle", 3) or IsTargetDead(ServerId) then
            LSCore.Functions.TriggerCallback('framework-inv:server:is:player:crafting', function(IsCrafting)
                if not IsCrafting then
                    TriggerServerEvent('framework-inv:server:disable:other', ServerId, false)
                    LSCore.Functions.Progressbar("robbing_player", "Spullen stelen..", math.random(5000, 7000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "random@shop_robbery",
                        anim = "robbery_action_b",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                        TriggerEvent("framework-inv:client:show:button:steal", ServerId)
                        TriggerServerEvent('framework-inv:server:open:inventory:other', ServerId, 'OtherPlayer', false, false)
                    end, function() -- Cancel
                        TriggerServerEvent('framework-inv:server:disable:other', ServerId, true)
                        StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                        LSCore.Functions.Notify("Geannuleerd..", "error")
                    end)
                end
            end, ServerId)  
        end
    else
        LSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('framework-police:client:search:closest')
AddEventHandler('framework-police:client:search:closest', function()
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        TriggerServerEvent("framework-police:server:search:player", ServerId)
        TriggerEvent("framework-inv:client:show:button:steal", ServerId)
        TriggerServerEvent('framework-inv:server:disable:other', ServerId, false)
        TriggerServerEvent('framework-inv:server:open:inventory:other', ServerId, 'OtherPlayer', false, false)
    else
        LSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('framework-police:client:check:cuffed')
AddEventHandler('framework-police:client:check:cuffed', function()
    if Config.IsHandCuffed then
        Config.IsEscorted = false
        Config.IsHandCuffed = false
        DetachEntity(PlayerPedId(), true, false)
        ClearPedTasksImmediately(PlayerPedId())
        LSCore.Functions.Notify("Je bent ontboeid!")
        TriggerServerEvent("framework-police:server:set:handcuff:status", false)
    end
end)

RegisterNetEvent('framework-police:client:check:escort')
AddEventHandler('framework-police:client:check:escort', function()
    if Config.IsEscorted then
        Config.IsEscorted = false
        DetachEntity(PlayerPedId(), true, false)
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent('framework-police:client:show:closest:id')
AddEventHandler('framework-police:client:show:closest:id', function(ItemInfo)
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        exports['fw-assets']:RequestAnimationDict('missfbi_s4mop')
        TaskPlayAnim(PlayerPedId(), "missfbi_s4mop", "swipe_card", 1.0, 1.0, -1, 8, 0, 0, 0, 0)
        Citizen.Wait(1000)
        exports['fw-assets']:AddProp('PBadge')
        TriggerServerEvent('framework-ui:server:show:police:id', ServerId, ItemInfo)
        Citizen.SetTimeout(2700, function()
            exports['fw-assets']:RemoveProp()
            ClearPedTasks(PlayerPedId())
        end)
    else
        LSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)