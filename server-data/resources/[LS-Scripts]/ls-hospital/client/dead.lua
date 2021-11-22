-- // Loops \\ --

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        if NetworkIsPlayerActive(PlayerId()) then  
            if LoggedIn then    
                if IsEntityDead(PlayerPedId()) and not Config.IsDeath then
                    SetState('death', true)
                else
                    Citizen.Wait(100)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(4)
        if Config.IsDeath then
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            DisableControlAction(0, 137, true)
            EnableControlAction(0, 243, true)
            EnableControlAction(0, 172, true)
            EnableControlAction(0, 173, true)
            EnableControlAction(0, 174, true)
            EnableControlAction(0, 175, true)
            EnableControlAction(0, 176, true)
            EnableControlAction(0, 177, true)
            EnableControlAction(0, Config.Keys['T'], true)
            EnableControlAction(0, Config.Keys['E'], true)
            EnableControlAction(0, Config.Keys['ESC'], true)
            EnableControlAction(0, Config.Keys['F1'], true)
            EnableControlAction(0, Config.Keys['HOME'], true)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        if Config.IsDeath then
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                exports['ls-assets']:RequestAnimationDict("veh@low@front_ps@idle_duck")
                if not IsEntityPlayingAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 3) then
                    TaskPlayAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                else
                    Citizen.Wait(100)
                end
            else
                if Config.IsInBed then
                    if not IsEntityPlayingAnim(PlayerPedId(), "misslamar1dead_body", "dead_idle", 3) then
                        exports['ls-assets']:RequestAnimationDict("misslamar1dead_body")
                        TaskPlayAnim(PlayerPedId(), "misslamar1dead_body", "dead_idle", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                    else
                        Citizen.Wait(100)
                    end
                else
                    if not IsEntityPlayingAnim(PlayerPedId(), "dead", "dead_a", 3) then
                        TaskPlayAnim(PlayerPedId(), "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                    else
                        Citizen.Wait(100)
                    end
                end
            end
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        else
            Citizen.Wait(2500)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
        if Config.IsDeath then
            if Config.Timer > 0 then
                DrawTxt(0.93, 1.44, 1.0,1.0,0.6, "RESPAWN OVER: ~r~" .. math.ceil(Config.Timer) .. "~w~ SECONDEN", 255, 255, 255, 255)
            else
                DrawTxt(0.865, 1.44, 1.0, 1.0, 0.6, "~r~[F1]~w~ OM TE RESPAWNEN ~r~(€2000)~w~", 255, 255, 255, 255)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if Config.IsDeath then
                if Config.Timer > 0 then
                    Config.Timer = Config.Timer - 1
                    if Config.Timer == 0 and not CanPersonRespawn then
                        CanPersonRespawn = true
                    end
                end
                Citizen.Wait(1000)
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-hospital:call:ai')
AddEventHandler('ls-hospital:call:ai', function()
    local PlayerPeds = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert(PlayerPeds, ped)
    end
    local ClosestPed, ClosestDistance = LSCore.Functions.GetClosestPed(GetEntityCoords(GetPlayerPed(-1)), PlayerPeds)
    print(GetPedType(ClosestPed))
    if ClosestDistance < 50.0 and ClosestPed ~= 0 then
        local Rand = (math.random(6,9) / 100) + 0.3
        local Rand2 = (math.random(6,9) / 100) + 0.3
        if math.random(10) > 5 then
            Rand = 0.0 - Rand
        end
        if math.random(10) > 5 then
            Rand2 = 0.0 - Rand2
        end
        local MoveTo = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), Rand, Rand2, 0.0)
        TaskGoStraightToCoord(ClosestPed, MoveTo, 2.5, -1, 0.0, 0.0)
        SetPedKeepTask(ClosestPed, true) 
        local Dist = GetDistanceBetweenCoords(MoveTo, GetEntityCoords(ClosestPed), false)
        while Dist > 3.5 and Config.IsDeath do
            TaskGoStraightToCoord(ClosestPed, MoveTo, 2.5, -1, 0.0, 0.0)
            Dist = GetDistanceBetweenCoords(MoveTo, GetEntityCoords(ClosestPed), false)
            Citizen.Wait(100)
        end
        ClearPedTasksImmediately(ClosestPed)
        TaskLookAtEntity(ClosestPed, GetPlayerPed(-1), 5500.0, 2048, 3)
        TaskTurnPedToFaceEntity(ClosestPed, GetPlayerPed(-1), 5500)
        Citizen.Wait(3000)
        exports['ls-assets']:RequestAnimationDict("cellphone@")
        TaskPlayAnim(ClosestPed, "cellphone@", "cellphone_call_listen_base", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
        SetPedKeepTask(ClosestPed, true) 
        Citizen.Wait(5000)
        TriggerServerEvent("ls-police:server:send:alert:dead", GetEntityCoords(GetPlayerPed(-1)), LSCore.Functions.GetStreetLabel())
        SetEntityAsNoLongerNeeded(ClosestPed)
        ClearPedTasks(ClosestPed)
    end
end)

RegisterNetEvent('ls-hospital:client:try:repsawn')
AddEventHandler('ls-hospital:client:try:repsawn', function()
    local BedSomething = GetAvailableBed()
    if BedSomething ~= nil and BedSomething ~= false then
        TriggerServerEvent('ls-hospital:server:dead:respawn')
        TriggerEvent('ls-hospital:client:send:to:bed', BedSomething)
    else
        LSCore.Functions.Notify("Bedden zijn bezet even wachten..", 'error')
    end
end)

-- // Functions \\ --

function SetState(Type, bool)
    if Type ~= nil then
        if Type == 'death' then
            Config.IsDeath = bool
            Config.Timer = 300
            TriggerServerEvent("ls-hospital:server:set:state", 'isdead', bool)
            if bool then
                DoDeathOnPlayer()
            end
        end
    end
end

function DoDeathOnPlayer()
    TriggerServerEvent("ls-sound:server:play:source", "death", 0.1)
    TriggerEvent('ls-inventory-new:client:force:close')
    TriggerEvent('ls-radialmenu:client:force:close')
    while GetEntitySpeed(GetPlayerPed(-1)) > 0.5 do
        Citizen.Wait(10)
    end
    if Config.IsDeath then
        NetworkResurrectLocalPlayer(GetEntityCoords(GetPlayerPed(-1)).x, GetEntityCoords(GetPlayerPed(-1)).y, GetEntityCoords(GetPlayerPed(-1)).z + 0.5, GetEntityHeading(GetPlayerPed(-1)), true, false)
        SetEntityInvincible(GetPlayerPed(-1), true)
        SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
        TriggerEvent('ls-inventory-new:client:reset:weapon')
        TriggerEvent('ls-weapons:client:remove:dot')
        Citizen.Wait(450)
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            exports['ls-assets']:RequestAnimationDict("veh@low@front_ps@idle_duck")
            TaskPlayAnim(GetPlayerPed(-1), "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        else
            exports['ls-assets']:RequestAnimationDict("dead")
            TaskPlayAnim(GetPlayerPed(-1), "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        end
        TriggerEvent('ls-hospital:call:ai')
    end
end

function GetDeathStatus()
    return Config.IsDeath
end

function CanRespawn()
    return CanPersonRespawn
end

function DrawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end