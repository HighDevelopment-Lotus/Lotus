local AdminMenus = {"AdminMenu", "AdminOptions", "PlayerManagment", "SelfOptions", "PlayerOptions", "PlayerOption", "AdminOption", "TeleportOptions", "ItemManagment"}
local CurrentPolyRadius, CurrentPolyLength, CurrentPolyWidth, CurrentPolyName, CurrentPolyType, CurrentJobName, CurrentJobGrade, CurrentItemName, CurrentItemAmount, CurrentPlayer, HasGodMode, IsInvisable, IsLogging, Debug = 1, 1, 1, 'None', 'None', 'Unemployed', 1, 'None', 0, {}, false, true, false, false
local CurrentItemName, CurrentItemAmount, CurrentPlayer, HasGodMode, HasCloakMode = 'None', 0, {}, false, false
local HasPlayerBlips, HasPlayerNames, AllPlayerBlips, Target = false, false, {}, nil
local LSCore, LoggedIn, AdminMenuOpen = exports['fw-base']:GetCoreObject(), false, false
IsInNoclip = false

-- Handle Events

RegisterNetEvent('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Threads

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and AdminMenuOpen then
            if Menu.IsMenuOpened('AdminMenu') then
                Menu.MenuButton('Admin Management', 'AdminOptions', false, false, true)
                Menu.MenuButton('Player Management', 'PlayerManagment', false, false, true)
                Menu.MenuButton('Item Management', 'ItemManagment', false, false, true)
                Menu.MenuButton('Job Management', 'JobManagment', false, false, true)
                Menu.MenuButton('Poly Management', 'PolyManagment', false, false, true)
                Menu.MenuButton('Lead Management', 'LeadManagement', false, false, true)
                Menu.Display()
            -- Self
            elseif Menu.IsMenuOpened('AdminOptions') then 
                Menu.MenuButton('Self Options', 'SelfOptions', false, false, true)
                Menu.CheckBox("Player Blips", HasPlayerBlips, function(checked) HasPlayerBlips = checked end)
                Menu.CheckBox("Player Names", HasPlayerNames, function(checked) HasPlayerNames = checked end)
                if Menu.MenuButton('Revive Players (Distance)', 'AdminOptions') then
                    local DistancePlayers = LSCore.Functions.GetPlayersFromCoords(nil, 10.0)
                    for k, v in pairs(DistancePlayers) do
                        local PlayerServerId = GetPlayerServerId(v)
                        TriggerServerEvent('framework-hospital:server:revive:player', PlayerServerId)
                    end
                end
                if Menu.MenuButton('Kill Players (Distance)', 'AdminOptions') then
                    local DistancePlayers = LSCore.Functions.GetPlayersFromCoords(nil, 10.0)
                    for k, v in pairs(DistancePlayers) do
                        local PlayerServerId = GetPlayerServerId(v)
                        TriggerServerEvent('framework-admin:server:slay:player', PlayerServerId)
                    end
                end
                Menu.Display()
            elseif Menu.IsMenuOpened('SelfOptions') then
                if Menu.CheckBox("Noclip", IsInNoclip, function(checked) IsInNoclip = checked end) then
                    if IsInNoclip then
                        ToggleNoclip()
                        CheckInputRotation()
                    end
                end 
                if Menu.CheckBox("Cloak", HasCloakMode, function(checked) HasCloakMode = checked end) then
                    local Target = GetPlayerServerId(PlayerId())
                    TriggerServerEvent('framework-admin:Server:ToggleVisibility', Target, HasCloakMode)
                end
                if Menu.MenuButton('Revive', 'PlayerOption') then
                    TriggerEvent('framework-hospital:client:revive', true)
                end
                if Menu.CheckBox("Godmode", HasGodMode, function(checked) HasGodMode = checked end) then
                    SetPlayerInvincible(PlayerPedId(), HasGodMode)
                end 
                Menu.Display()
            -- Player
            elseif Menu.IsMenuOpened('PlayerManagment') then
                local AllPlayers = LSCore.Functions.GetPlayers()
                for k, v in ipairs(AllPlayers) do 
                    local PlayerPed = GetPlayerPed(v)
                    local PlayerName = GetPlayerName(v)
                    local PlayerServerId = GetPlayerServerId(v)
                    if Menu.MenuButton('#'..PlayerServerId.." | "..PlayerName, 'PlayerOptions', false, {['Ped'] = PlayerPed, ['Name'] = PlayerName, ['ServerId'] = PlayerServerId}, true) then
                        local CurrentOption = Menu.GetCurrentButton()
                        CurrentPlayer = CurrentOption.meta
                        Menu.SetSubTitle("PlayerOptions", '#'..CurrentPlayer['ServerId'].." | "..CurrentPlayer['Name'])
                    end
                end
                Menu.Display()
            elseif Menu.IsMenuOpened('PlayerOptions') then
                if Menu.MenuButton('Player Options', 'PlayerOption', false, false, true) then
                    local CurrentOption = Menu.GetCurrentButton()
                    CurrentPlayer = CurrentOption.meta
                    Menu.SetSubTitle("PlayerOption", '#'..CurrentPlayer['ServerId'].." | "..CurrentPlayer['Name'])
                end
                if Menu.MenuButton('Admin Options', 'AdminOption', false, false, true) then
                    local CurrentOption = Menu.GetCurrentButton()
                    CurrentPlayer = CurrentOption.meta
                    Menu.SetSubTitle("AdminOption", '#'..CurrentPlayer['ServerId'].." | "..CurrentPlayer['Name'])
                end
                if Menu.MenuButton('Teleport Options', 'TeleportOptions', false, false, true) then
                    local CurrentOption = Menu.GetCurrentButton()
                    CurrentPlayer = CurrentOption.meta
                    Menu.SetSubTitle("TeleportOptions", '#'..CurrentPlayer['ServerId'].." | "..CurrentPlayer['Name'])
                end
                Menu.Display()
            elseif Menu.IsMenuOpened('PlayerOption') then
                if Menu.MenuButton('Revive Player', 'PlayerOptions') then
                    TriggerServerEvent('framework-hospital:server:revive:player', CurrentPlayer['ServerId'])
                end
                if Menu.MenuButton('Kill Player', 'PlayerOptions') then
                    TriggerServerEvent('framework-admin:server:slay:player', CurrentPlayer['ServerId'])
                end
                --if Menu.MenuButton('Spectate Player', 'PlayerOptions') then
                --    --
                --end
                if Menu.MenuButton('Open Inventaris', 'PlayerOptions') then
                    TriggerEvent("framework-inv:client:show:button:steal", CurrentPlayer['ServerId'])
                    TriggerServerEvent('framework-inv:server:open:inventory:other', CurrentPlayer['ServerId'], 'OtherPlayer', false, false)
                    Menu.CloseMenu()
                end
                if Menu.MenuButton('Give Appearance Menu', 'PlayerOptions') then
                    TriggerServerEvent('framework-admin:server:opem:skin:menu', CurrentPlayer['ServerId'])
                    Menu.CloseMenu()
                end
                Menu.Display()
            -- Moderation
            elseif Menu.IsMenuOpened('AdminOption') then
                if Menu.MenuButton('Kick Player', 'AdminOption') then
                    local Data = {['Title'] = 'Reason?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-crosshairs"></i>'}
                    LSCore.Functions.OpenInput(Data, function(ReturnData)
                        if ReturnData ~= false then
                            TriggerServerEvent('framework-admin:server:kick:chosen:player', CurrentPlayer['ServerId'], ReturnData)
                            Menu.CloseMenu()
                        end
                    end)
                end
                Menu.Display()
            -- Teleport
            elseif Menu.IsMenuOpened('TeleportOptions') then
                if Menu.MenuButton('Bring Player', 'TeleportOptions') then
                    TriggerServerEvent('framework-admin:server:bring:chosen:player', CurrentPlayer['ServerId'], GetEntityCoords(PlayerPedId()))
                end
                if Menu.MenuButton('Go To Player', 'TeleportOptions') then
                    local TargetCoords = GetEntityCoords(CurrentPlayer['Ped'])
                    SetEntityCoords(PlayerPedId(), TargetCoords)
                end
                Menu.Display()
            -- Items
            elseif Menu.IsMenuOpened('ItemManagment') then
                if Menu.MenuButton('Item: '..CurrentItemName, 'ItemManagment', false, false) then
                    local Data = {['Title'] = 'Item Name?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-crosshairs"></i>'}
                    LSCore.Functions.OpenInput(Data, function(ReturnData)
                        if ReturnData ~= false and ReturnData ~= '' then
                            CurrentItemName = ReturnData
                        end
                    end)
                end
                if Menu.MenuButton('Amount: '..CurrentItemAmount, 'ItemManagment', false, false) then
                    local Data = {['Title'] = 'Amount?', ['Type'] = 'number', ['Logo'] = '<i class="fas fa-crosshairs"></i>'}
                    LSCore.Functions.OpenInput(Data, function(ReturnData)
                        if ReturnData ~= false then
                            CurrentItemAmount = tonumber(ReturnData)
                        end
                    end)
                end
                if Menu.MenuButton('~b~Spawn Item', 'ItemManagment', false, false) then
                    if CurrentItemName ~= 'None' then
                        if CurrentItemAmount > 0 then
                            TriggerServerEvent('framework-admin:server:give:item', CurrentItemName, CurrentItemAmount)
                        else
                            LSCore.Functions.Notify('You want 0 of this seriously??', 'error', 4500)
                        end
                    else
                        LSCore.Functions.Notify('You have not entered an item name..', 'error', 4500)
                    end
                end
                Menu.Display()
            -- Job
            elseif Menu.IsMenuOpened('JobManagment') then
                if Menu.MenuButton('Name: '..CurrentJobName, 'JobManagment', false, false) then
                    local Data = {['Title'] = 'Job Name?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-crosshairs"></i>'}
                    LSCore.Functions.OpenInput(Data, function(ReturnData)
                        if ReturnData ~= false and ReturnData ~= '' then
                            CurrentJobName = ReturnData
                        end
                    end)
                end
                if Menu.MenuButton('Grade: '..CurrentJobGrade, 'JobManagment', false, false) then
                    local Data = {['Title'] = 'Grade?', ['Type'] = 'number', ['Logo'] = '<i class="fas fa-crosshairs"></i>'}
                    LSCore.Functions.OpenInput(Data, function(ReturnData)
                        if ReturnData ~= false then
                            CurrentJobGrade = tonumber(ReturnData)
                        end
                    end)
                end
                if Menu.MenuButton('~b~Set Job', 'JobManagment', false, false) then
                    if CurrentJobGrade > 0 then
                        CurrentJobName = CurrentJobName:lower()
                        if LSCore.Shared.Jobs[CurrentJobName].grades[CurrentJobGrade] ~= nil then
                            TriggerServerEvent('framework-admin:server:log:action', GetPlayerName(PlayerId())..' has the job '..LSCore.Shared.Jobs[CurrentJobName].label..' - '..LSCore.Shared.Jobs[CurrentJobName].grades[CurrentJobGrade].label..' given to themselves.' )
                            TriggerServerEvent('framework-admin:server:set:job', CurrentJobName, CurrentJobGrade)
                        else
                            LSCore.Functions.Notify('This grade does not exist..', 'error', 4500)
                        end
                    else
                        LSCore.Functions.Notify('Your grade must be higher then 0..', 'error', 4500)
                    end
                end
                Menu.Display()
            -- PolyZone
            elseif Menu.IsMenuOpened('PolyManagment') then
                Menu.MenuButton('PolyZone Creation', 'PolyCreation', false, false, true)
                Menu.MenuButton('PolyZone Editing', 'PolyEditing', false, false, true)
                if Menu.CheckBox("PolyZone Debug", PolyDebug, function(checked) PolyDebug = checked end) then
                    TriggerEvent('framework-polyzone:debug', PolyDebug)
                end 
                Menu.Display()
            elseif Menu.IsMenuOpened('PolyCreation') then
                if Menu.MenuButton('Type: '..CurrentPolyType, 'PolyManagment') then
                    local Data = {['Title'] = 'Type?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-crosshairs"></i>'}
                    LSCore.Functions.OpenInput(Data, function(ReturnData)
                        if ReturnData ~= false and ReturnData ~= '' then
                            CurrentPolyType = ReturnData
                        end
                    end)
                end
                if Menu.MenuButton('Name: '..CurrentPolyName, 'PolyManagment') then
                    local Data = {['Title'] = 'Name?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-crosshairs"></i>'}
                    LSCore.Functions.OpenInput(Data, function(ReturnData)
                        if ReturnData ~= false and ReturnData ~= '' then
                            CurrentPolyName = ReturnData
                        end
                    end)
                end
                if CurrentPolyType:lower() == 'box' then
                    if Menu.MenuButton('Length: '..CurrentPolyLength, 'PolyManagment') then
                        local Data = {['Title'] = 'Length?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-crosshairs"></i>'}
                        LSCore.Functions.OpenInput(Data, function(ReturnData)
                            if ReturnData ~= false and ReturnData ~= '' then
                                CurrentPolyLength = ReturnData
                            end
                        end)
                    end
                    if Menu.MenuButton('Width: '..CurrentPolyWidth, 'PolyManagment') then
                        local Data = {['Title'] = 'Width?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-crosshairs"></i>'}
                        LSCore.Functions.OpenInput(Data, function(ReturnData)
                            if ReturnData ~= false and ReturnData ~= '' then
                                CurrentPolyWidth = ReturnData
                            end
                        end)
                    end
                elseif CurrentPolyType:lower() == 'circle' then
                    if Menu.MenuButton('Radius: '..CurrentPolyRadius, 'PolyManagment') then
                        local Data = {['Title'] = 'Radius?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-crosshairs"></i>'}
                        LSCore.Functions.OpenInput(Data, function(ReturnData)
                            if ReturnData ~= false and ReturnData ~= '' then
                                CurrentPolyRadius = ReturnData
                            end
                        end)
                    end
                end
                if Menu.MenuButton('~y~Previous Zone', 'PolyManagment') then
                    if exports['PolyZone']:GetCreatedZone() == nil then
                        if exports['PolyZone']:GetLastCreatedZone() ~= nil then
                            if exports['PolyZone']:GetLastCreatedZoneType() ~= 'poly' then
                                if (CurrentPolyName ~= nil and CurrentPolyName ~= 'None') then                           
                                    TriggerEvent("polyzone:pzlast", CurrentPolyName)
                                    LSCore.Functions.Notify('Zone created successfully..', 'success', 4500)
                                else
                                    LSCore.Functions.Notify('Enter a zone name that you want to give to the zone..', 'error', 4500)
                                end
                            else
                                LSCore.Functions.Notify('This type of a zone cannot currently be reused..', 'error', 4500)
                            end
                        else
                            LSCore.Functions.Notify('No previous zone found..', 'error', 4500)
                        end
                    else
                        LSCore.Functions.Notify('You are already creating a zone..', 'error', 4500)
                    end
                end
                if Menu.MenuButton('~b~New Zone', 'PolyManagment') then
                    if exports['PolyZone']:GetCreatedZone() == nil then
                        if CurrentPolyName ~= 'None' then
                            local Data 
                            if CurrentPolyType:lower() == 'box' then
                                if (CurrentPolyWidth == nil and CurrentPolyWidth <= 0) and (CurrentPolyLength == nil and CurrentPolyLength <= 0) then
                                    LSCore.Functions.Notify('Your width and length must be greater than 0..', 'error', 4500)
                                else
                                    Data = {['width'] = CurrentPolyWidth, ['length'] = CurrentPolyLength}
                                end
                            elseif CurrentPolyType:lower() == 'circle' then
                                if (CurrentPolyRadius == nil and CurrentPolyRadius <= 0) then
                                    LSCore.Functions.Notify('Your radius must be greater than 0..', 'error', 4500)
                                else
                                    Data = {['radius'] = CurrentPolyRadius}
                                end
                            end
                            if CurrentPolyType:lower() == 'box' or CurrentPolyType:lower() == 'circle' or CurrentPolyType:lower() == 'poly' then
                                TriggerServerEvent('framework-admin:server:log:action', GetPlayerName(PlayerId())..' has a '..CurrentPolyType:lower()..' zone created.' )
                                TriggerEvent("polyzone:pzcreate", CurrentPolyType, CurrentPolyName, Data)
                            else
                                LSCore.Functions.Notify('You have not entered a valid type.. (box, circle, poly)', 'error', 4500)
                            end
                        else
                            LSCore.Functions.Notify('You have not entered a zone name..', 'error', 4500)
                        end
                    else
                        LSCore.Functions.Notify('A zone is already being created..', 'error', 4500)
                    end
                end
                if Menu.MenuButton('~r~Clear', 'PolyManagment') then
                    CurrentPolyName = 'None'
                    CurrentPolyType = 'None'
                    CurrentPolyRadius = 1
                    CurrentPolyWidth = 1
                    CurrentPolyLength = 1
                end
                Menu.Display()
            elseif Menu.IsMenuOpened('PolyEditing') then
                if Menu.MenuButton('Cancel Creation', 'PolyEditing') then
                    if exports['PolyZone']:GetCreatedZone() ~= nil then
                        TriggerEvent("polyzone:pzcancel")
                        LSCore.Functions.Notify('Zone creation cancelled..', 'error', 4500)
                    else
                        LSCore.Functions.Notify('No PolyZone found..', 'error', 4500)
                    end
                end
                if Menu.MenuButton('Finish Creation', 'PolyEditing') then
                    if exports['PolyZone']:GetCreatedZone() ~= nil then
                        TriggerEvent("polyzone:pzfinish")
                        LSCore.Functions.Notify('Zone created successfully..', 'success', 4500)
                    else
                        LSCore.Functions.Notify('No PolyZone found..', 'error', 4500)
                    end
                end
                Menu.Display()
            -- Management
            elseif Menu.IsMenuOpened('LeadManagement') then
                if Menu.CheckBox("Log Modus", IsLogging, function(checked) IsLogging = checked end) then end 
                if Menu.CheckBox("Debug", Debug, function(checked) Debug = checked end) then
                    TriggerEvent('framework-debug:toggle', Debug)
                end 
                Menu.Display()
            end
            if Menu.IsMenuAboutToBeClosed('AdminMenu') then
                AdminMenuOpen = false
                CurrentPlayer = {}
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and HasPlayerBlips then
            local AllPlayers = LSCore.Functions.GetPlayers()
            if AllPlayerBlips ~= nil then
                for k, v in pairs(AllPlayerBlips) do
                    RemoveBlip(v) 
                end
                AllPlayerBlips = {}
            end
            for k, v in pairs(AllPlayers) do
                local PlayerId, PlayerPed, PlayerName = GetPlayerServerId(v), GetPlayerPed(v), GetPlayerName(v)
                if PlayerPed ~= PlayerPedId() then
                    local PlayerBlip = AddBlipForEntity(PlayerPed) 
                    SetBlipSprite(PlayerBlip, 1)
                    SetBlipColour(PlayerBlip, 0)
                    SetBlipScale(PlayerBlip, 0.75)
                    SetBlipAsShortRange(PlayerBlip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString('['..PlayerId..'] '..PlayerName)
                    EndTextCommandSetBlipName(PlayerBlip)
                    table.insert(AllPlayerBlips, PlayerBlip)
                end
            end
            Citizen.Wait(20000)
        else
            if AllPlayerBlips ~= nil then
                for k, v in pairs(AllPlayerBlips) do
                    RemoveBlip(v) 
                end
                AllPlayerBlips = {}
            end
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and HasPlayerNames then
            local DistancePlayers = LSCore.Functions.GetPlayersFromCoords(nil, 25.0)
            for k, v in pairs(DistancePlayers) do
                local PlayerId, PlayerPed, PlayerName = GetPlayerServerId(v), GetPlayerPed(v), GetPlayerName(v)
                if PlayerPed ~= PlayerPedId() then
                    local PlayerCoords = GetEntityCoords(PlayerPed)
                    DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '[~r~'..PlayerId..'~s~] '..PlayerName)
                end
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- Events

RegisterNetEvent('framework-admin:client:SaveCar', function(target)
    local veh =  LSCore.Functions.GetClosestVehicle()

    -- if veh ~= nil and veh ~= 0 then
        local plate = GetVehicleNumberPlateText(veh)
        local props = LSCore.Functions.GetVehicleProperties(veh)
        local hash = props.model
        local vehname = GetDisplayNameFromVehicleModel(hash):lower()
        if LSCore.Shared.Vehicles[vehname] ~= nil and next(LSCore.Shared.Vehicles[vehname]) ~= nil then
            TriggerServerEvent('framework-admin:server:SaveCar', props, LSCore.Shared.Vehicles[vehname], plate, tonumber(target))
        else
            print(hash)
            print(LSCore.Shared.Vehicles[vehname])
            LSCore.Functions.Notify('Auto kan niet worden opgeslagen in je garage', 'error')
        end
    -- else
    --     LSCore.Functions.Notify('You are not in a vehicle..', 'error')
    -- end
end)

RegisterNetEvent('framework-admin:client:open:admin:menu', function()
    SetupMenus()
    AdminMenuOpen = true
    Menu.OpenMenu('AdminMenu')
end)

RegisterNetEvent('framework-admin:client:slay:player', function()
    SetEntityHealth(PlayerPedId(), 0.0)
end)

RegisterNetEvent('framework-admin:client:bring:chosen:player', function(Coords)
    SetEntityCoords(PlayerPedId(), Coords)
end)

RegisterNetEvent('framework-admin:client:send:report', function(Name, Source, Message)
    TriggerServerEvent('framework-admin:server:send:report', Name, Source, Message)
end)

RegisterNetEvent('framework-admin:client:staffchat:message', function(Name, Message)
    TriggerServerEvent('framework-admin:server:staffchat:message', Name, Message)
end)

RegisterNetEvent('framework-admin:client:openstash', function(StashID)
    if exports['fw-inv']:CanOpenInventory() then
        TriggerServerEvent('framework-inventory:server:open:inventory:other', StashID, 'Stash', 200, 5000000)
    end
end)

RegisterNetEvent('framework-admin:Client:ToggleVisibility', function(bool)
    if bool == nil then
        HasCloakMode = not HasCloakMode 
    else
        HasCloakMode = bool
    end

    if HasCloakMode then
        Citizen.CreateThread(function()
            while HasCloakMode do      
                if HasCloakMode then
                    NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
                    SetEntityVisible(PlayerPedId(), false, false)
                    SetEntityAlpha(PlayerPedId(), 155, false)
                    SetLocalPlayerVisibleLocally(true)
                end
                Citizen.Wait(0)
            end
        end)
    else
        NetworkSetEntityInvisibleToNetwork(PlayerPedId(),false)
        SetEntityVisible(PlayerPedId(), true, false)
        SetEntityAlpha(PlayerPedId(), 255, false)
        SetLocalPlayerVisibleLocally(false)
    end
end)

-- Functions

function SetupMenus()
    Menu.CreateMenu('AdminMenu', 'Lotus')
    
    Menu.SetMenuMaxOptionCountOnScreen("AdminMenu", 20)

    Menu.CreateSubMenu('AdminOptions', 'AdminMenu')

    Menu.CreateSubMenu('SelfOptions', 'AdminOptions')
    Menu.SetSubTitle("SelfOptions", "Self Options")

    Menu.CreateSubMenu('PlayerManagment', 'AdminMenu')
    Menu.SetSubTitle("PlayerManagment", "Online Players: "..#GetActivePlayers())
    Menu.CreateSubMenu('PlayerOptions', 'PlayerManagment')
    Menu.CreateSubMenu('PlayerOption', 'PlayerOptions')
    Menu.CreateSubMenu('AdminOption', 'PlayerOptions')
    Menu.CreateSubMenu('TeleportOptions', 'PlayerOptions')

    Menu.CreateSubMenu('ItemManagment', 'AdminMenu')
    Menu.CreateSubMenu('JobManagment', 'AdminMenu')
    Menu.CreateSubMenu('PolyManagment', 'AdminMenu')
    Menu.CreateSubMenu('PolyCreation', 'PolyManagment')
    Menu.CreateSubMenu('PolyEditing', 'PolyManagment')
    Menu.SetSubTitle("PolyEditing", "PolyZone Editing")
    Menu.SetSubTitle("PolyCreation", "PolyZone Creation")
    Menu.SetSubTitle("PolyManagment", "PolyZone Management")
    Menu.CreateSubMenu('LeadManagement', 'AdminMenu')

    ClearIdData()
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function ClearIdData()
    CurrentPlayer = {}
end

RegisterNetEvent("framework-admin:client:log:action")
AddEventHandler("framework-admin:client:log:action", function(text, group)
    if (group == 'admin' or group == 'god') and IsLogging then
        LogNotify(text)
    end
end)

function LogNotify(text)
    SendNUIMessage({
        action = 'showNotification',
        text = text
    })
end

function IsAdminMenuOpen()
    return AdminMenuOpen
end