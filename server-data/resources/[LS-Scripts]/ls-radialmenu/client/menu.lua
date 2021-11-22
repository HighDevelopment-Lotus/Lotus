LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false
local ShowMenu, MAX_MENU_ITEMS = false, 8

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
           if IsControlPressed(1, Config.Keys['F1']) and GetLastInputMethod(2) and ShowMenu then
               ShowMenu = false
               SetNuiFocus(false, false)
           end
           if IsControlPressed(1, Config.Keys['F1']) and GetLastInputMethod(2) then
                ShowMenu = true
                if ShowMenu == true then
                    DisableControlAction(0, 289, true)  
                    DisableControlAction(0, 288, true)  
                end
                local EnabledMenus = {}
                for _, menuConfig in ipairs(Config.Menu) do
                    if menuConfig:enableMenu() then
                        local DataElements = {}
                        local HasSubMenu = false
                        if menuConfig.subMenus ~= nil and #menuConfig.subMenus > 0 then
                            HasSubMenu = true
                            local PreviousMenu = DataElements
                            local CurrentElement = {}
                            for i = 1, #menuConfig.subMenus do
                                CurrentElement[#CurrentElement+1] = Config.SubMenus[menuConfig.subMenus[i]]
                                CurrentElement[#CurrentElement].id = menuConfig.subMenus[i]
                                CurrentElement[#CurrentElement].enableMenu = nil
                                if i % MAX_MENU_ITEMS == 0 and i < (#menuConfig.subMenus - 1) then
                                    PreviousMenu[MAX_MENU_ITEMS + 1] = {
                                        id = "_more",
                                        title = "Meer",
                                        icon = "#more",
                                        items = CurrentElement
                                    }
                                    PreviousMenu = CurrentElement
                                    CurrentElement = {}
                                end
                            end
                            if #CurrentElement > 0 then
                                PreviousMenu[MAX_MENU_ITEMS + 1] = {
                                    id = "_more",
                                    title = "Meer",
                                    icon = "#more",
                                    items = CurrentElement
                                }
                            end
                            DataElements = DataElements[MAX_MENU_ITEMS + 1].items
                        end
                        EnabledMenus[#EnabledMenus+1] = {
                            id = menuConfig.id,
                            title = menuConfig.displayName,
                            close = menuConfig.close,
                            functiontype = menuConfig.functiontype,
                            functionParameters = menuConfig.functionParameters,
                            functionName = menuConfig.functionName,
                            icon = menuConfig.icon,
                        }
                        if HasSubMenu then
                            EnabledMenus[#EnabledMenus].items = DataElements
                        end
                    end
                end
                SendNUIMessage({
                    state = "show",
                    data = EnabledMenus,
                    menuKeyBind = 'F1'
                })
                SetCursorLocation(0.5, 0.5)
                SetNuiFocus(true, true)
                PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
                while ShowMenu == true do Citizen.Wait(100) end
                Citizen.Wait(100)
                while IsControlPressed(1, Config.Keys['F1']) and GetLastInputMethod(2) do Citizen.Wait(100) end
            end
         else
            Citizen.Wait(150)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if LoggedIn then
            LSCore.Functions.TriggerCallback('ls-radialmenu:server:HasItem', function(HasItem)
                if HasItem then
                    Config.HasHandCuffs = true
                else
                    Config.HasHandCuffs = false
                end
            end, 'handcuffs')
            Citizen.Wait(250)
        else
            Citizen.Wait(250)
        end
    end
end)

RegisterNetEvent('ls-radialmenu:client:force:close')
AddEventHandler('ls-radialmenu:client:force:close', function()
    ShowMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        state = 'destroy'
    })
end)

RegisterNUICallback('closemenu', function(data, cb)
    ShowMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        state = 'destroy'
    })
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    cb('ok')
end)

RegisterNUICallback('triggerAction', function(data, cb)
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    if data.type == 'client' then
        TriggerEvent(data.action, data.parameters)
    elseif data.type == 'server' then 
        TriggerServerEvent(data.action, data.parameters)
    end
    cb('ok')
end)