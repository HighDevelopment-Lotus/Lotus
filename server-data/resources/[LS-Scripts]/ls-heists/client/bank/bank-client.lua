local AnimProps = {}
local BagProp, LaptopProp = nil, nil
CurrentCops, NearBank, CurrentBank = 0, false, nil

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            NearBank = false
            for k, v in pairs(Config.Banks) do
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                if Distance < 9.0 then
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

RegisterNetEvent('ls-bankrobbery:client:grab:option')
AddEventHandler('ls-bankrobbery:client:grab:option', function()
    if Config.BankBeingRobbed and CurrentBank ~= nil then
        if Config.Banks[CurrentBank]['BankOpen'] then
            if Config.Banks[CurrentBank]['Prop'][2]['Available'] then
                TriggerServerEvent('ls-bankrobbery:server:grab:box', CurrentBank)
            else
                LSCore.Functions.Notify("Deze is al gestolen..", "error")
            end
        else
            LSCore.Functions.Notify("Je kan dit nu niet stelen..", "error")
        end
    end
end)

RegisterNetEvent('ls-bankrobbery:client:use:option')
AddEventHandler('ls-bankrobbery:client:use:option', function()
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

RegisterNetEvent('ls-bankrobbery:client:hack:card')
AddEventHandler('ls-bankrobbery:client:hack:card', function(data)
    LSCore.Functions.TriggerCallback('ls-bankrobbery:server:has:special:items', function(HasItem)
        if HasItem then
            exports['minigame-phone']:ShowHack()
            TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
            TriggerServerEvent('ls-police:server:send:bank:alert', GetEntityCoords(GetPlayerPed(-1)), LSCore.Functions.GetStreetLabel(), Config.Banks[data['BankId']]['Name'])
            exports['minigame-phone']:StartHack(math.random(1,3), math.random(9, 13), function(Success)
                if Success then
                    exports['minigame-phone']:HideHack()
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                    TriggerServerEvent('ls-bankrobbery:server:set:bank:card', data['BankId'], true)
                else
                    exports['minigame-phone']:HideHack()
                    LSCore.Functions.Notify("Je hebt gefaalt..", "error")
                    TriggerServerEvent('ls-jewellery:server:set:cooldown', false)
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                end
            end)
        end
    end, 'usb-device')
end)

RegisterNetEvent('ls-bankrobbery:client:hack:door')
AddEventHandler('ls-bankrobbery:client:hack:door', function(data)
    if CurrentCops >= Config.CopsNeeded then
        LSCore.Functions.TriggerCallback('ls-bankrobbery:has:bank:items', function(HasItem)
            if HasItem then
                TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
                TriggerEvent('ls-bankrobbery:client:start:bank:anim', data['BankId'])
                TriggerServerEvent('ls-police:server:send:bank:alert', GetEntityCoords(GetPlayerPed(-1)), LSCore.Functions.GetStreetLabel(), Config.Banks[data['BankId']]['Name'])
                Citizen.SetTimeout(7000, function()
                    exports["minigame-datacrack"]:Start(5, function(Success)
                        if Success then
                            Citizen.SetTimeout(450, function()
                                exports['minigame-shape']:StartShapeGame(function(Outcome)
                                    if Outcome then
                                        LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, Config.Banks[CurrentBank]['Menus'][1]['Card'], 1, false)
                                        TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                                        TriggerEvent('ls-bankrobbery:client:end:bank:anim')
                                        TriggerServerEvent('ls-bankrobbery:server:set:bank', data['BankId'])
                                        LSCore.Functions.Notify("Wacht tot de deur open is..", "success", 7500)
                                    else
                                        TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                                        LSCore.Functions.Notify('Je faalde..', 'error')
                                        TriggerEvent('ls-bankrobbery:client:end:bank:anim')
                                    end
                                end)
                            end)
                        else
                            TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                            LSCore.Functions.Notify('Je faalde..', 'error')
                            TriggerEvent('ls-bankrobbery:client:end:bank:anim')
                        end
                    end)
                end)
            end
        end, Config.Banks[CurrentBank]['Menus'][1]['Card'])  
    else
        LSCore.Functions.Notify("Niet genoeg agenten!", "info")
    end
end)

RegisterNetEvent('ls-bankrobbery:client:sync:bank:config')
AddEventHandler('ls-bankrobbery:client:sync:bank:config', function(ConfigData)
    Config.Banks = ConfigData
end)

RegisterNetEvent('ls-bankrobbery:client:set:robbed')
AddEventHandler('ls-bankrobbery:client:set:robbed', function(Bool)
    Config.BankBeingRobbed = Bool
end)

RegisterNetEvent('ls-bankrobbery:client:start:bank:anim')
AddEventHandler('ls-bankrobbery:client:start:bank:anim', function(BankId)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    local AnimModels = {[1] = GetHashKey("hei_p_m_bag_var22_arm_s"), [2] = GetHashKey("hei_prop_hst_laptop")}
    exports['ls-assets']:RequestAnimationDict("anim@heists@ornate_bank@hack")
    exports['ls-assets']:RequestModelHash("hei_p_m_bag_var22_arm_s")
    exports['ls-assets']:RequestModelHash("hei_prop_hst_laptop")
    local NetSceneOne = NetworkCreateSynchronisedScene(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.6, GetEntityRotation(GetPlayerPed(-1)), 2, false, false, 1065353216, 0, 1.3)
    BagProp = CreateObject(AnimModels[1], GetEntityCoords(GetPlayerPed(-1)), 1, 1, 0)
    LaptopProp = CreateObject(AnimModels[2], GetEntityCoords(GetPlayerPed(-1)), 1, 1, 0)
    table.insert(AnimProps, BagProp)
    table.insert(AnimProps, LaptopProp)
    NetworkAddPedToSynchronisedScene(GetPlayerPed(-1), NetSceneOne, "anim@heists@ornate_bank@hack", "hack_enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(BagProp, NetSceneOne, "anim@heists@ornate_bank@hack", "hack_enter_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(LaptopProp, NetSceneOne, "anim@heists@ornate_bank@hack", "hack_enter_laptop", 4.0, -8.0, 1)
    local NetSceneTwo = NetworkCreateSynchronisedScene(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.6, GetEntityRotation(GetPlayerPed(-1)), 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(GetPlayerPed(-1), NetSceneTwo, "anim@heists@ornate_bank@hack", "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(BagProp, NetSceneTwo, "anim@heists@ornate_bank@hack", "hack_loop_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(LaptopProp, NetSceneTwo, "anim@heists@ornate_bank@hack", "hack_loop_laptop", 4.0, -8.0, 1)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    Citizen.Wait(200)
    NetworkStartSynchronisedScene(NetSceneOne)
    Citizen.Wait(6300)
    NetworkStartSynchronisedScene(NetSceneTwo)
end)

RegisterNetEvent('ls-bankrobbery:client:end:bank:anim')
AddEventHandler('ls-bankrobbery:client:end:bank:anim', function()
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    Citizen.SetTimeout(1500, function()
        local NetScene = NetworkCreateSynchronisedScene(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.6, GetEntityRotation(GetPlayerPed(-1)), 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(GetPlayerPed(-1), NetScene, "anim@heists@ornate_bank@hack", "hack_exit", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(BagProp, NetScene, "anim@heists@ornate_bank@hack", "hack_exit_bag", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(LaptopProp, NetScene, "anim@heists@ornate_bank@hack", "hack_exit_laptop", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(NetScene)
        Citizen.Wait(4600)
        NetworkStopSynchronisedScene(NetScene)
        ClearPedTasks(GetPlayerPed(-1))
        FreezeEntityPosition(GetPlayerPed(-1), false)
        for k, v in pairs(AnimProps) do
            NetworkRequestControlOfEntity(v)
            DeleteEntity(v)
        end
        BagProp, LaptopProp, AnimProps = nil, nil, {}
    end)
end)