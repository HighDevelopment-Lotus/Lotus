local RecycleObjects, IsInside, ShowingInteraction, SecondInteraction = {}, false, false, false
local CurrentRandomBox, DoingJob, HoldingBox = nil, false, false

-- // Loops \\--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearAnything = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - Config.Recycle['Outside'])
            if not IsInside and Distance <= 2.0 then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['fw-ui']:ShowInteraction('[E] Recycle Centrum', 'primary')
                end
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('framework-materials:client:enter:recycle:center', PlayerCoords)
                end
            end
            local Distance = #(PlayerCoords - Config.Recycle['Inside'])
            if IsInside and Distance <= 2.0 then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['fw-ui']:ShowInteraction('[E] Naar Buiten', 'primary')
                end
                if IsControlJustReleased(0, 38) then
                    if not DoingJob then
                        TriggerEvent('framework-materials:client:leave:recycle:center', PlayerCoords)
                    else
                        LSCore.Functions.Notify("Misschien eerst uitklokken?", "error")
                    end
                end
            end
            if not NearAnything then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['fw-ui']:HideInteraction()
                end
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if DoingJob and not HoldingBox and CurrentRandomBox ~= nil then
                local NearAnything = false
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = #(PlayerCoords - Config.Recycle['Props'][CurrentRandomBox]['Coords'])
                DrawMarker(32, Config.Recycle['Props'][CurrentRandomBox]['Coords'].x, Config.Recycle['Props'][CurrentRandomBox]['Coords'].y, Config.Recycle['Props'][CurrentRandomBox]['Coords'].z + 1.75, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.75, 0.3, 250, 0, 50, 255, false, false, false, true, false, false, false)
                if Distance < 2.0 then
                    NearAnything = true
                    if not SecondInteraction then
                        SecondInteraction = true
                        exports['fw-ui']:ShowInteraction('[E] Iets met een doos?', 'primary')
                    end
                    if IsControlJustReleased(0, 38) then
                        TaskPlayAnim(PlayerPedId(), "mini@repair" ,"fixing_a_ped", 5.0, -1, -1, 16, 0, false, false, false)
                        exports['fw-ui']:StartSkillTest(2, 'Normal', function(OutCome)
                            if OutCome then
                                HoldingBox = true
                                ClearPedTasks(PlayerPedId())
                                exports['fw-assets']:AddProp("Box")
                                exports['fw-assets']:RequestAnimationDict("anim@heists@box_carry@")
                                TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 48, 0, false, false, false)
                            end
                        end)
                    end
                end
                if not NearAnything then
                    if SecondInteraction then
                        SecondInteraction = false
                        exports['fw-ui']:HideInteraction()
                    end
                end
            elseif DoingJob and HoldingBox then
                local NearAnything = false
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = #(PlayerCoords - Config.Recycle['Deliver'])
                DrawMarker(32, Config.Recycle['Deliver'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.15, 0.65, 0.15, 250, 0, 50, 255, false, false, false, true, false, false, false)
                if Distance <= 2.0 then
                    NearAnything = true
                    if not SecondInteraction then
                        SecondInteraction = true
                        exports['fw-ui']:ShowInteraction('[E] Inleveren', 'primary')
                    end
                    if IsControlJustReleased(0, 38) then
                        LSCore.Functions.Progressbar("pickup_reycle_package", "Inleveren..", 5000, false, true, {
                            disableMovement = true,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = false,
                        }, {}, {}, {}, function() -- Done
                            HoldingBox, CurrentRandomBox = false, GetRandomBox()
                            ClearPedTasks(PlayerPedId())
                            exports['fw-assets']:RemoveProp()
                            LSCore.Functions.TriggerCallback('framework-materials:server:recyclenew:reward', function()
                            end)
                        end, function()
                            exports['fw-assets']:AddProp("Box")
                            exports['fw-assets']:RequestAnimationDict("anim@heists@box_carry@")
                            TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 48, 0, false, false, false)
                            LSCore.Functions.Notify("Geannuleerd..", "error")
                        end)
                    end
                end
                if not NearAnything then
                    if SecondInteraction then
                        SecondInteraction = false
                        exports['fw-ui']:HideInteraction()
                    end
                end
            else
                Citizen.Wait(500)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-materials:client:enter:recycle:center')
AddEventHandler('framework-materials:client:enter:recycle:center', function(PlayerCoords)
    TriggerEvent("framework-sound:client:play", "house-door-open", 0.7)
    OpenDoorAnim()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    SetEntityVisible(PlayerPedId(), false)
    SetEntityCoords(PlayerPedId(), PlayerCoords.x, PlayerCoords.y, PlayerCoords.z - 10.0)
    Citizen.Wait(5500)
    SetEntityCoords(PlayerPedId(), Config.Recycle['Inside'])
    TriggerEvent("framework-sound:client:play", "house-door-close", 0.1)
    SetEntityVisible(PlayerPedId(), true)
    DoScreenFadeIn(500)
    SpawnRecycleProps()
    IsInside = true
end)

RegisterNetEvent('framework-materials:client:leave:recycle:center')
AddEventHandler('framework-materials:client:leave:recycle:center', function(PlayerCoords)
    IsInside = false
    TriggerEvent("framework-sound:client:play", "house-door-open", 0.7)
    OpenDoorAnim()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    SetEntityVisible(PlayerPedId(), false)
    SetEntityCoords(PlayerPedId(), PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 10.0)
    Citizen.Wait(5500)
    SetEntityCoords(PlayerPedId(), Config.Recycle['Outside'])
    TriggerEvent("framework-sound:client:play", "house-door-close", 0.1)
    SetEntityVisible(PlayerPedId(), true)
    DoScreenFadeIn(500)
    RemoveRecycleProps()
end)

RegisterNetEvent('framework-materials:client:open:recycle:crafting')
AddEventHandler('framework-materials:client:open:recycle:crafting', function()
    if exports['fw-inv']:CanOpenInventory() then
        local CraftingData = {['Type'] = 'Crafting', ['InvName'] = 'Recycle Workbench', ['Items'] = Config.RecycleCrafting}
        TriggerServerEvent('framework-inv:server:open:inventory:other', CraftingData, 'Crafting')
    end
end)

RegisterNetEvent('framework-materials:client:recycle:toggle:duty')
AddEventHandler('framework-materials:client:recycle:toggle:duty', function()
    if DoingJob then
        DoingJob = false
        CurrentRandomBox = nil
        LSCore.Functions.Notify("Gestopt met vrijwilligers werk!", "error")
    else
        DoingJob = true
        CurrentRandomBox = GetRandomBox()
        LSCore.Functions.Notify("Begonnen met vrijwilligers werk!", "success")
    end
end)

-- // Functions \\ --

function SpawnRecycleProps()
    for k,v in pairs(Config.Recycle['Props']) do
        local Prop = v['Prop']
        if v['Prop'] == nil then
            Prop = Config.RecycleProps[math.random(1, #Config.RecycleProps)]
        end
        exports['fw-assets']:RequestModelHash(Prop)
        Citizen.Wait(20)
        RecyleObject = CreateObject(GetHashKey(Prop), v["Coords"], false, true, false)
        SetEntityHeading(RecyleObject, v['Heading'])
        FreezeEntityPosition(RecyleObject, true)
        SetEntityInvincible(RecyleObject, true)
        if v['FixGround'] then
            PlaceObjectOnGroundProperly(RecyleObject)
        end
        if not v['Visible'] then
            SetEntityVisible(RecyleObject, false)
        end
        table.insert(RecycleObjects, RecyleObject)
    end
end

function RemoveRecycleProps()
    for k,v in pairs(RecycleObjects) do
        NetworkRequestControlOfEntity(v)
        DeleteEntity(v)
    end
end

function OpenDoorAnim()
    exports['fw-assets']:RequestAnimationDict('anim@heists@keycard@')
    TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(PlayerPedId())
end

function GetRandomBox()
    local Found = false
    local RandomBox = nil
    while not Found do
        RandomBox = math.random(3, #Config.Recycle['Props'])
        if Config.Recycle['Props'][RandomBox]['IsBox'] then
            Found = true
        end
    end
    return RandomBox
end

function InsideRecycle()
    return IsInside
end