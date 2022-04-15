local AnimProps = {}
local BagProp, LaptopProp = nil, nil
CurrentCops, NearBank, CurrentBank = 0, false, nil

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            NearBank = false
            for k, v in pairs(Config.Banks) do
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                if v['Name'] == 'Pacific Bank' then
                    DistanceCheck = 20.0
                else
                    DistanceCheck = 9
                end
                if Distance < DistanceCheck then
                    NearBank = true
                    CurrentBank = k
                    CheckDoor(k)
                end
            end
            if not NearBank then
                Citizen.Wait(1000)
                CurrentBank = nil
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-bankrobbery:client:grab:option')
AddEventHandler('framework-bankrobbery:client:grab:option', function()
    if Config.BankBeingRobbed and CurrentBank ~= nil then
        if Config.Banks[CurrentBank]['BankOpen'] then
            if Config.Banks[CurrentBank]['Prop'][2]['Available'] then
                -- TriggerServerEvent('framework-bankrobbery:server:grab:box', CurrentBank)
                LSCore.Functions.TriggerCallback('framework-bankrobbery:server:grab:box', function() end, CurrentBank)  
            else
                LSCore.Functions.Notify("Deze is al gestolen..", "error")
            end
        else
            LSCore.Functions.Notify("Je kan dit nu niet stelen..", "error")
        end
    end
end)

RegisterNetEvent('framework-bankrobbery:client:use:option')
AddEventHandler('framework-bankrobbery:client:use:option', function()
    if CurrentCops >= Config.CopsNeeded then
        if not Config.BankBeingRobbed then
            if not Config.Banks[CurrentBank]['BankOpen'] then
                local MenuItems = {}
                for k, v in pairs(Config.Banks[CurrentBank]['Menus']) do
                    if v['Active'] then
                        local NewData = {}
                        NewData['Title'] = v['Name']
                        NewData['Desc'] = v['Desc']
                        NewData['Data'] = {['Event'] = v['Event'], ['Type'] = 'Client', ['BankId'] = CurrentBank}
                        table.insert(MenuItems, NewData)
                    end
                end
                local Data = {['Title'] = Config.Banks[CurrentBank]['Name'], ['MainMenuItems'] = MenuItems}
                LSCore.Functions.OpenMenu(Data)
            else
                LSCore.Functions.Notify("Er is al een overval bezig..", "error")
            end
        else
            LSCore.Functions.Notify("Er is al een overval bezig..", "error")
        end
    else
        LSCore.Functions.Notify("Niet genoeg agenten!", "info")
    end
end)

RegisterNetEvent('framework-bankrobbery:client:hack:card')
AddEventHandler('framework-bankrobbery:client:hack:card', function(data)
    LSCore.Functions.TriggerCallback('framework-bankrobbery:server:has:special:items', function(HasItem)
        if HasItem then
            exports['minigame-phone']:ShowHack()
            TriggerEvent('framework-inv:client:set:inventory:state', false)
            TriggerServerEvent('framework-police:server:send:bank:alert', GetEntityCoords(PlayerPedId()), LSCore.Functions.GetStreetLabel(), Config.Banks[data['BankId']]['Name'])
            exports['minigame-phone']:StartHack(math.random(7,10), math.random(9, 13), function(Success)
                if Success then
                    exports['minigame-phone']:HideHack()
                    TriggerEvent('framework-inv:client:set:inventory:state', true)
                    TriggerServerEvent('framework-bankrobbery:server:set:bank:card', data['BankId'], true)
                else
                    exports['minigame-phone']:HideHack()
                    LSCore.Functions.Notify("Je hebt gefaalt..", "error")
                    TriggerServerEvent('framework-jewellery:server:set:cooldown', false)
                    TriggerEvent('framework-inv:client:set:inventory:state', true)
                end
            end)
        end
    end, 'usb-device')
end)

RegisterNetEvent('framework-bankrobbery:client:hack:door')
AddEventHandler('framework-bankrobbery:client:hack:door', function(data)
    if CurrentCops >= Config.CopsNeeded then
        LSCore.Functions.TriggerCallback('framework-bankrobbery:has:bank:items', function(HasItem)
            if HasItem then
                TriggerEvent('framework-inv:client:set:inventory:state', false)
                TriggerEvent('framework-bankrobbery:client:start:bank:anim', data['BankId'])
                TriggerServerEvent('framework-police:server:send:bank:alert', GetEntityCoords(PlayerPedId()), LSCore.Functions.GetStreetLabel(), Config.Banks[data['BankId']]['Name'])
                Citizen.SetTimeout(7000, function()
                    exports["minigame-datacrack"]:Start(5, function(Success)
                        if Success then
                            Citizen.SetTimeout(450, function()
                                -- exports['minigame-shape']:StartShapeGame(function(Outcome)
                                --     if Outcome then
                                        LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, Config.Banks[CurrentBank]['Menus'][1]['Card'], 1, false)
                                        TriggerEvent('framework-inv:client:set:inventory:state', true)
                                        TriggerEvent('framework-bankrobbery:client:end:bank:anim')
                                        TriggerServerEvent('framework-bankrobbery:server:set:bank', data['BankId'])
                                        LSCore.Functions.Notify("Wacht tot de deur open is..", "success", 7500)
                                --     else
                                --         TriggerEvent('framework-inv:client:set:inventory:state', true)
                                --         LSCore.Functions.Notify('Je faalde..', 'error')
                                --         TriggerEvent('framework-bankrobbery:client:end:bank:anim')
                                --     end
                                -- end)
                            end)
                        else
                            TriggerEvent('framework-inv:client:set:inventory:state', true)
                            LSCore.Functions.Notify('Je faalde..', 'error')
                            TriggerEvent('framework-bankrobbery:client:end:bank:anim')
                        end
                    end)
                end)
            end
        end, Config.Banks[CurrentBank]['Menus'][1]['Card'])  
    else
        LSCore.Functions.Notify("Niet genoeg agenten!", "info")
    end
end)

RegisterNetEvent('framework-bankrobbery:client:sync:bank:config')
AddEventHandler('framework-bankrobbery:client:sync:bank:config', function(ConfigData)
    Config.Banks = ConfigData
end)

RegisterNetEvent('framework-bankrobbery:client:set:robbed')
AddEventHandler('framework-bankrobbery:client:set:robbed', function(Bool)
    Config.BankBeingRobbed = Bool
end)

RegisterNetEvent('framework-bankrobbery:client:start:bank:anim')
AddEventHandler('framework-bankrobbery:client:start:bank:anim', function(BankId)
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local AnimModels = {[1] = GetHashKey("hei_p_m_bag_var22_arm_s"), [2] = GetHashKey("hei_prop_hst_laptop")}
    exports['fw-assets']:RequestAnimationDict("anim@heists@ornate_bank@hack")
    exports['fw-assets']:RequestModelHash("hei_p_m_bag_var22_arm_s")
    exports['fw-assets']:RequestModelHash("hei_prop_hst_laptop")
    local NetSceneOne = NetworkCreateSynchronisedScene(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.6, GetEntityRotation(PlayerPedId()), 2, false, false, 1065353216, 0, 1.3)
    BagProp = CreateObject(AnimModels[1], GetEntityCoords(PlayerPedId()), 1, 1, 0)
    LaptopProp = CreateObject(AnimModels[2], GetEntityCoords(PlayerPedId()), 1, 1, 0)
    table.insert(AnimProps, BagProp)
    table.insert(AnimProps, LaptopProp)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), NetSceneOne, "anim@heists@ornate_bank@hack", "hack_enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(BagProp, NetSceneOne, "anim@heists@ornate_bank@hack", "hack_enter_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(LaptopProp, NetSceneOne, "anim@heists@ornate_bank@hack", "hack_enter_laptop", 4.0, -8.0, 1)
    local NetSceneTwo = NetworkCreateSynchronisedScene(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.6, GetEntityRotation(PlayerPedId()), 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), NetSceneTwo, "anim@heists@ornate_bank@hack", "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(BagProp, NetSceneTwo, "anim@heists@ornate_bank@hack", "hack_loop_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(LaptopProp, NetSceneTwo, "anim@heists@ornate_bank@hack", "hack_loop_laptop", 4.0, -8.0, 1)
    FreezeEntityPosition(PlayerPedId(), true)
    Citizen.Wait(200)
    NetworkStartSynchronisedScene(NetSceneOne)
    Citizen.Wait(6300)
    NetworkStartSynchronisedScene(NetSceneTwo)
end)

RegisterNetEvent('framework-bankrobbery:client:end:bank:anim')
AddEventHandler('framework-bankrobbery:client:end:bank:anim', function()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    Citizen.SetTimeout(1500, function()
        local NetScene = NetworkCreateSynchronisedScene(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.6, GetEntityRotation(PlayerPedId()), 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(PlayerPedId(), NetScene, "anim@heists@ornate_bank@hack", "hack_exit", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(BagProp, NetScene, "anim@heists@ornate_bank@hack", "hack_exit_bag", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(LaptopProp, NetScene, "anim@heists@ornate_bank@hack", "hack_exit_laptop", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(NetScene)
        Citizen.Wait(4600)
        NetworkStopSynchronisedScene(NetScene)
        ClearPedTasks(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
        for k, v in pairs(AnimProps) do
            NetworkRequestControlOfEntity(v)
            DeleteEntity(v)
        end
        BagProp, LaptopProp, AnimProps = nil, nil, {}
    end)
end)