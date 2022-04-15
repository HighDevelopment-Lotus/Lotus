local AdminMenus = {"AdminMenu", "AdminOptions", "PlayerManagment", "SelfOptions", "PlayerOptions", "PlayerOption", "AdminOption", "TeleportOpties", "ItemManagment"}
local CurrentItemName, CurrentItemAmount, CurrentPlayer, HasGodMode, IsInvisable = 'None', 0, {}, false, true
local HasPlayerBlips, HasPlayerNames, AllPlayerBlips = false, false, {}
local LSCore, LoggedIn, AdminMenuOpen = exports['fw-base']:GetCoreObject(), false, false
IsInNoclip = false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("chat:removeSuggestion", "/AdminPanelKick") 
        TriggerEvent("chat:removeSuggestion", "/AdminPanelAddItem") 
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and AdminMenuOpen then
            if Menu.IsMenuOpened('AdminMenu') then
                Menu.MenuButton('Admin Management', 'AdminOptions', false, false, true)
                Menu.MenuButton('Speler Management', 'PlayerManagment', false, false, true)
                Menu.MenuButton('Item Management', 'ItemManagment', false, false, true)
                Menu.Display()
            elseif Menu.IsMenuOpened('AdminOptions') then 
                Menu.MenuButton('Eigen Opties', 'SelfOptions', false, false, true)
                Menu.CheckBox("Speler Blips", HasPlayerBlips, function(checked) HasPlayerBlips = checked end)
                Menu.CheckBox("Speler Namen", HasPlayerNames, function(checked) HasPlayerNames = checked end)
                if Menu.MenuButton('Revive Spelers (Distance)', 'AdminOptions') then
                    local DistancePlayers = LSCore.Functions.GetPlayersFromCoords(nil, 10.0)
                    for k, v in pairs(DistancePlayers) do
                        local PlayerServerId = GetPlayerServerId(v)
                        TriggerServerEvent('framework-hospital:server:revive:player', PlayerServerId)
                    end
                end
                if Menu.MenuButton('Kill Spelers (Distance)', 'AdminOptions') then
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
                if Menu.MenuButton('Revive', 'PlayerOption') then
                    TriggerEvent('framework-hospital:client:revive', true)
                end
                if Menu.CheckBox("Godmode", HasGodMode, function(checked) HasGodMode = checked end) then
                    SetPlayerInvincible(PlayerPedId(), HasGodMode)
                end 
                if Menu.CheckBox("Zichtbaarheid", IsInvisable, function(checked) IsInvisable = checked end) then
                    SetEntityVisible(PlayerPedId(), IsInvisable)
                end 
                Menu.Display()
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
                if Menu.MenuButton('Speler Opties', 'PlayerOption', false, false, true) then
                    local CurrentOption = Menu.GetCurrentButton()
                    CurrentPlayer = CurrentOption.meta
                    Menu.SetSubTitle("PlayerOption", '#'..CurrentPlayer['ServerId'].." | "..CurrentPlayer['Name'])
                end
                if Menu.MenuButton('Admin Opties', 'AdminOption', false, false, true) then
                    local CurrentOption = Menu.GetCurrentButton()
                    CurrentPlayer = CurrentOption.meta
                    Menu.SetSubTitle("AdminOption", '#'..CurrentPlayer['ServerId'].." | "..CurrentPlayer['Name'])
                end
                if Menu.MenuButton('Teleporteer Opties', 'TeleportOpties', false, false, true) then
                    local CurrentOption = Menu.GetCurrentButton()
                    CurrentPlayer = CurrentOption.meta
                    Menu.SetSubTitle("TeleportOpties", '#'..CurrentPlayer['ServerId'].." | "..CurrentPlayer['Name'])
                end
                Menu.Display()
            elseif Menu.IsMenuOpened('PlayerOption') then
                if Menu.MenuButton('Revive Speler', 'PlayerOptions') then
                    TriggerServerEvent('framework-hospital:server:revive:player', CurrentPlayer['ServerId'])
                end
                if Menu.MenuButton('Dood Speler', 'PlayerOptions') then
                    TriggerServerEvent('framework-admin:server:slay:player', CurrentPlayer['ServerId'])
                end
                --if Menu.MenuButton('Spectate Speler', 'PlayerOptions') then
                --    --
                --end
                if Menu.MenuButton('Open Inventaris', 'PlayerOptions') then
                    TriggerEvent("framework-inv:client:show:button:steal", CurrentPlayer['ServerId'])
                    TriggerServerEvent('framework-inv:server:open:inventory:other', CurrentPlayer['ServerId'], 'OtherPlayer', false, false)
                    Menu.CloseMenu()
                end
                if Menu.MenuButton('Geef Kleding Menu', 'PlayerOptions') then
                    TriggerServerEvent('framework-admin:server:opem:skin:menu', CurrentPlayer['ServerId'])
                    Menu.CloseMenu()
                end
                Menu.Display()
            elseif Menu.IsMenuOpened('AdminOption') then
                if Menu.MenuButton('Kick Speler', 'AdminOption') then
                    local Data = {['Title'] = 'Reden?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-crosshairs"></i>'}
                    LSCore.Functions.OpenInput(Data, function(ReturnData)
                        if ReturnData ~= false then
                            TriggerServerEvent('framework-admin:server:kick:chosen:player', CurrentPlayer['ServerId'], ReturnData)
                            Menu.CloseMenu()
                        end
                    end)
                end
                Menu.Display()
            elseif Menu.IsMenuOpened('TeleportOpties') then
                if Menu.MenuButton('Breng Speler', 'TeleportOpties') then
                    TriggerServerEvent('framework-admin:server:bring:chosen:player', CurrentPlayer['ServerId'], GetEntityCoords(PlayerPedId()))
                end
                if Menu.MenuButton('Ga Naar Speler', 'TeleportOpties') then
                    local TargetCoords = GetEntityCoords(CurrentPlayer['Ped'])
                    SetEntityCoords(PlayerPedId(), TargetCoords)
                end
                Menu.Display()
            elseif Menu.IsMenuOpened('ItemManagment') then
                if Menu.MenuButton('Item: '..CurrentItemName, 'ItemManagment', false, false) then
                    local Data = {['Title'] = 'Item Naam?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-crosshairs"></i>'}
                    LSCore.Functions.OpenInput(Data, function(ReturnData)
                        if ReturnData ~= false and ReturnData ~= '' then
                            CurrentItemName = ReturnData
                        end
                    end)
                end
                if Menu.MenuButton('Hoeveel: '..CurrentItemAmount, 'ItemManagment', false, false) then
                    local Data = {['Title'] = 'Hoeveel?', ['Type'] = 'number', ['Logo'] = '<i class="fas fa-crosshairs"></i>'}
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
                            LSCore.Functions.Notify('Je wilt hier serrieus 0 van hebben??', 'error', 4500)
                        end
                    else
                        LSCore.Functions.Notify('Je hebt geen item naam ingevuld..', 'error', 4500)
                    end
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

-- // Events \\ --

RegisterNetEvent('framework-admin:client:open:admin:menu')
AddEventHandler('framework-admin:client:open:admin:menu', function()
    SetupMenus()
    AdminMenuOpen = true
    Menu.OpenMenu('AdminMenu')
end)

RegisterNetEvent('framework-admin:client:slay:player')
AddEventHandler('framework-admin:client:slay:player', function()
    SetEntityHealth(PlayerPedId(), 0.0)
end)

RegisterNetEvent('framework-admin:client:bring:chosen:player')
AddEventHandler('framework-admin:client:bring:chosen:player', function(Coords)
    SetEntityCoords(PlayerPedId(), Coords)
end)

RegisterNetEvent('framework-admin:client:send:report')
AddEventHandler('framework-admin:client:send:report', function(Name, Source, Message)
    TriggerServerEvent('framework-admin:server:send:report', Name, Source, Message)
end)

RegisterNetEvent('framework-admin:client:staffchat:message')
AddEventHandler('framework-admin:client:staffchat:message', function(Name, Message)
    TriggerServerEvent('framework-admin:server:staffchat:message', Name, Message)
end)

RegisterNetEvent('framework-admin:client:openstash')
AddEventHandler('framework-admin:client:openstash', function(StashID)
    if exports['fw-inv']:CanOpenInventory() then
        TriggerServerEvent('framework-inv:server:open:inventory:other', StashID, 'Stash', 200, 5000000)
    end
end)

-- // Functions \\ --

function SetupMenus()
    Menu.CreateMenu('AdminMenu', '~b~Admin Menu')
    Menu.SetSubTitle("AdminMenu", "Admin Menu")
    
    Menu.SetMenuMaxOptionCountOnScreen("AdminMenu", 20)

    Menu.CreateSubMenu('AdminOptions', 'AdminMenu')
    Menu.SetSubTitle("AdminOptions", "Admin Menu")

    Menu.CreateSubMenu('ItemManagment', 'AdminMenu')

    Menu.CreateSubMenu('PlayerManagment', 'AdminMenu')
    Menu.SetSubTitle("PlayerManagment", "Online Spelers: "..#GetActivePlayers())
    Menu.CreateSubMenu('PlayerOptions', 'PlayerManagment')
    Menu.CreateSubMenu('PlayerOption', 'PlayerOptions')
    Menu.CreateSubMenu('AdminOption', 'PlayerOptions')
    Menu.CreateSubMenu('TeleportOpties', 'PlayerOptions')

    Menu.CreateSubMenu('SelfOptions', 'AdminOptions')
    Menu.SetSubTitle("SelfOptions", "Eigen Opties")

    for k, v in pairs(AdminMenus) do
        Menu.SetMenuX(v, 0.71)
        Menu.SetMenuY(v, 0.15)
        Menu.SetMenuWidth(v, 0.23)
        Menu.SetTitleColor(v, 135, 206, 250, 255)
        Menu.SetTitleBackgroundColor(v, 0 , 0, 0, 150)
        Menu.SetMenuBackgroundColor(v, 0, 0, 0, 100)
        Menu.SetMenuSubTextColor(v, 255, 255, 255, 255)
    end
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
