local AnimSet = "default"

-- Code

RegisterNetEvent('AnimSet:default');
AddEventHandler('AnimSet:default', function()
    ResetPedMovementClipset(PlayerPedId(), 0)
    AnimSet = "default";
end)

RegisterNetEvent('AnimSet:Hurry');
AddEventHandler('AnimSet:Hurry', function()
    RequestAnimSet("move_m@hurry@a")
    while not HasAnimSetLoaded("move_m@hurry@a") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@hurry@a", true)
    AnimSet = "move_m@hurry@a";
end)

RegisterNetEvent('AnimSet:Business');
AddEventHandler('AnimSet:Business', function()
    RequestAnimSet("move_m@business@a")
    while not HasAnimSetLoaded("move_m@business@a") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@business@a", true)
    AnimSet = "move_m@business@a";
end)

RegisterNetEvent('AnimSet:Brave');
AddEventHandler('AnimSet:Brave', function()
    RequestAnimSet("move_m@brave")
    while not HasAnimSetLoaded("move_m@brave") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@brave", true)
    AnimSet = "move_m@brave";
end)

RegisterNetEvent('AnimSet:Tipsy');
AddEventHandler('AnimSet:Tipsy', function()
    RequestAnimSet("move_m@drunk@slightlydrunk")
    while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
        Citizen.Wait(0)
    end
    SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", true)
    AnimSet = "move_m@drunk@slightlydrunk";
end)

RegisterNetEvent('AnimSet:Injured');
AddEventHandler('AnimSet:Injured', function()
    RequestAnimSet("move_m@injured")
    while not HasAnimSetLoaded("move_m@injured") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@injured", true)
    AnimSet = "move_m@injured";
end)

RegisterNetEvent('AnimSet:ToughGuy');
AddEventHandler('AnimSet:ToughGuy', function()
    RequestAnimSet("move_m@tough_guy@")
    while not HasAnimSetLoaded("move_m@tough_guy@") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@tough_guy@", true)
    AnimSet = "move_m@tough_guy@";
end)

RegisterNetEvent('AnimSet:Sassy');
AddEventHandler('AnimSet:Sassy', function()
    RequestAnimSet("move_m@sassy")
    while not HasAnimSetLoaded("move_m@sassy") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@sassy", true)
    AnimSet = "move_m@sassy";
end)

RegisterNetEvent('AnimSet:Sad');
AddEventHandler('AnimSet:Sad', function()
    RequestAnimSet("move_m@sad@a")
    while not HasAnimSetLoaded("move_m@sad@a") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@sad@a", true)
    AnimSet = "move_m@sad@a";
end)

RegisterNetEvent('AnimSet:Posh');
AddEventHandler('AnimSet:Posh', function()
    RequestAnimSet("move_m@posh@")
    while not HasAnimSetLoaded("move_m@posh@") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@posh@", true)
    AnimSet = "move_m@posh@";
end)

RegisterNetEvent('AnimSet:Alien');
AddEventHandler('AnimSet:Alien', function()
    RequestAnimSet("move_m@alien")
    while not HasAnimSetLoaded("move_m@alien") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@alien", true)
    AnimSet = "move_m@alien";
end)

RegisterNetEvent('AnimSet:NonChalant');
AddEventHandler('AnimSet:NonChalant', function()
    RequestAnimSet("move_m@non_chalant")
    while not HasAnimSetLoaded("move_m@non_chalant") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@non_chalant", true)
    AnimSet = "move_m@non_chalant";
end)

RegisterNetEvent('AnimSet:Hobo');
AddEventHandler('AnimSet:Hobo', function()
    RequestAnimSet("move_m@hobo@a")
    while not HasAnimSetLoaded("move_m@hobo@a") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@hobo@a", true)
    AnimSet = "move_m@hobo@a";
end)

RegisterNetEvent('AnimSet:Money');
AddEventHandler('AnimSet:Money', function()
    RequestAnimSet("move_m@money")
    while not HasAnimSetLoaded("move_m@money") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@money", true)
    AnimSet = "move_m@money";
end)

RegisterNetEvent('AnimSet:Swagger');
AddEventHandler('AnimSet:Swagger', function()
    RequestAnimSet("move_m@swagger")
    while not HasAnimSetLoaded("move_m@swagger") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@swagger", true)
    AnimSet = "move_m@swagger";
end)

RegisterNetEvent('AnimSet:Joy');
AddEventHandler('AnimSet:Joy', function()
    RequestAnimSet("move_m@joy")
    while not HasAnimSetLoaded("move_m@joy") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@joy", true)
    AnimSet = "move_m@joy";
end)

RegisterNetEvent('AnimSet:Moon');
AddEventHandler('AnimSet:Moon', function()
    RequestAnimSet("move_m@powerwalk")
    while not HasAnimSetLoaded("move_m@powerwalk") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@powerwalk", true)
    AnimSet = "move_m@powerwalk";
end)

RegisterNetEvent('AnimSet:Shady');
AddEventHandler('AnimSet:Shady', function()
    RequestAnimSet("move_m@shadyped@a")
    while not HasAnimSetLoaded("move_m@shadyped@a") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@shadyped@a", true)
    AnimSet = "move_m@shadyped@a";
end)

RegisterNetEvent('AnimSet:Tired');
AddEventHandler('AnimSet:Tired', function()
    RequestAnimSet("move_m@tired")
    while not HasAnimSetLoaded("move_m@tired") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@tired", true)
    AnimSet = "move_m@tired";
end)

RegisterNetEvent('AnimSet:Sexy');
AddEventHandler('AnimSet:Sexy', function()
    RequestAnimSet("move_f@sexy")
    while not HasAnimSetLoaded("move_f@sexy") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_f@sexy", true)
    AnimSet = "move_f@sexy";
end)

RegisterNetEvent('AnimSet:ManEater');
AddEventHandler('AnimSet:ManEater', function()
    RequestAnimSet("move_f@maneater")
    while not HasAnimSetLoaded("move_f@maneater") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_f@maneater", true)
    AnimSet = "move_f@maneater";
end)

RegisterNetEvent('AnimSet:ChiChi');
AddEventHandler('AnimSet:ChiChi', function()
    RequestAnimSet("move_f@chichi")
    while not HasAnimSetLoaded("move_f@chichi") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_f@chichi", true)
    AnimSet = "move_f@chichi";
end)

RegisterNetEvent("expressions")
AddEventHandler("expressions", function(pArgs)
    if #pArgs ~= 1 then return end
    local expressionName = pArgs[1]
    SetFacialIdleAnimOverride(PlayerPedId(), expressionName, 0)
    return
end)

RegisterNetEvent("expressions:clear")
AddEventHandler("expressions:clear",function() 
    ClearFacialIdleAnimOverride(PlayerPedId()) 
end)

--  // Main Functions \\ --

RegisterNetEvent('framework-radialmenu:client:flip:vehicle')
AddEventHandler('framework-radialmenu:client:flip:vehicle', function()
    local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
    if Vehicle ~= 0 and Distance < 1.7 then
        LSCore.Functions.Progressbar("flip-vehicle", "Voertuig omduwen..", math.random(10000, 15000), false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "random@mugging4",
            anim = "struggle_loop_b_thief",
            flags = 49,
        }, {}, {}, function() -- Done
             SetVehicleOnGroundProperly(Vehicle)
             LSCore.Functions.Notify("Gelukt", "success")
        end, function()
            LSCore.Functions.Notify("Geannuleerd..", "error")
        end)
    else
        LSCore.Functions.Notify("Geen voertuig gevonden..", "error")
    end
end)

RegisterNetEvent("framework-radialmenu:client:send:panic:button")
AddEventHandler("framework-radialmenu:client:send:panic:button",function()
    local Player = LSCore.Functions.GetPlayerData()
    if Player.job == "police" then
        LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
            if HasItem then
                local Info = {['Firstname'] = Player.charinfo.firstname, ['Lastname'] = Player.charinfo.lastname, ['Callsign'] = Player.metadata['callsign']}
                local StreetLabel = LSCore.Functions.GetStreetLabel()
                TriggerServerEvent('framework-sound:server:play:distance', 2.0, 'short-beep', 0.2)
                TriggerServerEvent('framework-police:server:send:alert:panic:button', GetEntityCoords(PlayerPedId()), StreetLabel, Info)
            else
                LSCore.Functions.Notify("Je hebt geen porto..", "error")
            end
        end, "radio")
    end
end)

RegisterNetEvent("framework-radialmenu:client:send:down")
AddEventHandler("framework-radialmenu:client:send:down",function(Type)
    local Player = LSCore.Functions.GetPlayerData()
    local Info = {['Firstname'] = Player.charinfo.firstname, ['Lastname'] = Player.charinfo.lastname, ['Callsign'] = Player.metadata['callsign']}
    local StreetLabel = LSCore.Functions.GetStreetLabel()
    local Priority = 2
    if Type == 'Urgent' then
        Priority = 3
    end
    TriggerServerEvent('framework-police:server:send:alert:officer:down', GetEntityCoords(PlayerPedId()), StreetLabel, Info, Priority)
end)

RegisterNetEvent("framework-radialmenu:client:open:door")
AddEventHandler("framework-radialmenu:client:open:door",function(DoorNumber)
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    if GetVehicleDoorAngleRatio(Vehicle, DoorNumber) > 0.0 then
        SetVehicleDoorShut(Vehicle, DoorNumber, false)
    else
        SetVehicleDoorOpen(Vehicle, DoorNumber, false, false)
    end
end)

RegisterNetEvent("framework-radialmenu:client:enter:radio")
AddEventHandler("framework-radialmenu:client:enter:radio",function(RadioNumber)
    LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
        if HasItem then
            exports['fw-radio']:SetRadioState(true)
            exports['fw-radio']:JoinRadio(RadioNumber, 1)
        else
            LSCore.Functions.Notify("Je hebt geen radio..", "error", 4500)
        end
    end, "radio")
end)