Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearAnything = false
            local NearCityH = false
            for k, v in pairs(Config.MetalDetector['Coords']) do
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                if Distance < 1.2 then
                    NearAnything = true
                    if not Config.MetalDetector['Scanned'] then
                        local PlayerData = LSCore.Functions.GetPlayerData()
                        Config.MetalDetector['Scanned'] = true
                        if PlayerData.job.name == 'police' and PlayerData.job.onduty or PlayerData.job.name == 'ambulance' and PlayerData.job.onduty then
                            TriggerEvent("framework-sound:client:play", "metal-detector", 0.1)
                            Citizen.SetTimeout(10000, function()
                              Config.MetalDetector['Scanned'] = false
                            end)
                        else
                            TriggerServerEvent('framework-cityhall:server:scan:metal')
                            TriggerEvent("framework-sound:client:play", "metal-detector", 0.1)
                            Citizen.SetTimeout(10000, function()
                              Config.MetalDetector['Scanned'] = false
                            end)
                        end
                    end
                end
            end
            if not NearAnything then
                Citizen.Wait(350)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-cityhall:client:request:items')
AddEventHandler('framework-cityhall:client:request:items', function()
    if CanRecieve then
        CanRecieve = false
        TriggerServerEvent('framework-cityhall:server:recieve:metal:objects')
        Citizen.SetTimeout(7500, function()
            CanRecieve = true
        end)
    end
end)

RegisterNetEvent('framework-cityhall:client:open:menu')
AddEventHandler('framework-cityhall:client:open:menu', function(MenuType)
    local MenuItems = {}
    for k, v in pairs(Config.Menus[MenuType]) do
        local NewData = {}
        NewData['Title'] = v['Name']
        NewData['Desc'] = v['Desc']
        NewData['Data'] = {['Event'] = v['Event'], ['Type'] = v['EventType'], ['Id'] = v['Type']}
        table.insert(MenuItems, NewData)
    end
    if (#MenuItems > 0) then
        local Data = {['Title'] = 'QuackCity Stadhuis', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end
end)