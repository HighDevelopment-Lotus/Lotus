local ScannerOpen = false
LSCore, LoggedIn, Restarting = exports['ls-core']:GetCoreObject(), false, false
Hunger, Thirst, Stress, Timer = 100, 100, 0, 0
InVehicle, Seatbelt = false, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(3250, function()
        LSCore.Functions.GetPlayerData(function(PlayerData)
            if PlayerData.metadata['armor'] ~= 0 then
                SetPedArmour(GetPlayerPed(-1), tonumber(PlayerData.metadata['armor']))
            end
            if PlayerData.metadata['health'] ~= 0 then
                SetEntityHealth(GetPlayerPed(-1), tonumber(PlayerData.metadata["health"]))
            end
            Hunger, Thirst, Stress = PlayerData.metadata["hunger"], PlayerData.metadata["thirst"], PlayerData.metadata["stress"]
            Citizen.Wait(150)
            SendNUIMessage({action = 'SetMoney', amount = PlayerData.money['cash']})
            SendNUIMessage({action = 'Show'})
            LoggedIn = true
        end)
    end)
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         LSCore.Functions.GetPlayerData(function(PlayerData)
--             if PlayerData ~= nil then
--                 if PlayerData.metadata['armor'] ~= 0 then
--                     SetPedArmour(GetPlayerPed(-1), tonumber(PlayerData.metadata['armor']))
--                 end
--                 if PlayerData.metadata['health'] ~= 0 then
--                     SetEntityHealth(GetPlayerPed(-1), tonumber(PlayerData.metadata["health"]))
--                 end
--                 Hunger, Thirst, Stress = PlayerData.metadata["hunger"], PlayerData.metadata["thirst"], PlayerData.metadata["stress"]
--                 Citizen.Wait(150)
--                 SendNUIMessage({action = 'SetMoney', amount = PlayerData.money['cash']})
--             end
--             SendNUIMessage({action = 'Show'})
--             LoggedIn = true
--         end)
--     end)
-- end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    SendNUIMessage({action = 'Hide'})
    Hunger, Thirst, Stress = 100, 100, 0
    LoggedIn, InVehicle = false, false
end)

RegisterNetEvent('LSCore:Client:CloseNui')
AddEventHandler('LSCore:Client:CloseNui', function()
    SetNuiFocus(false, false)
end)

-- Code

-- // Events \\ --

RegisterNetEvent('ls-ui:client:open:newspaper')
AddEventHandler('ls-ui:client:open:newspaper', function()
    OpenNewsPaper()
end)

RegisterNetEvent('ls-ui:client:purchase:magazine')
AddEventHandler('ls-ui:client:purchase:magazine', function()
    LSCore.Functions.TriggerCallback('LSCore:RemoveCash', function(DidPay) 
        if DidPay then
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = 'OpenMagazine'
            })
        end
    end, 4)
end)

RegisterNetEvent('ls-ui:client:add:news:jail')
AddEventHandler('ls-ui:client:add:news:jail', function(data)
    SendNUIMessage({
        action = 'AddJail',
        name = data['Name'],
        jailtime = data['JailTime'],
    })
end)

RegisterNetEvent("ls-ui:client:update:needs")
AddEventHandler("ls-ui:client:update:needs", function(NewHunger, NewThirst)
    Hunger, Thirst = NewHunger, NewThirst
end)

RegisterNetEvent('ls-ui:client:update:stress')
AddEventHandler('ls-ui:client:update:stress', function(NewStress)
    Stress = NewStress
end)

RegisterNetEvent('ls-ui:client:set:timer')
AddEventHandler('ls-ui:client:set:timer', function(TimerAmount)
    Timer = TimerAmount
end)

RegisterNetEvent('ls-ui:client:show:cash')
AddEventHandler('ls-ui:client:show:cash', function()
    SendNUIMessage({action = 'ShowCash'})
end)

RegisterNetEvent("ls-ui:client:money:change")
AddEventHandler("ls-ui:client:money:change", function(Amount, Type)
    Citizen.SetTimeout(150, function()
        if Type == 'Plus' then
            SendNUIMessage({action = 'ChangeMoney', type = 'Add', amount = Amount})
        else
            SendNUIMessage({action = 'ChangeMoney', type = 'Remove', amount = Amount})
        end
        SendNUIMessage({action = 'SetMoney', amount = LSCore.Functions.GetPlayerData().money['cash']})
    end)
end)

RegisterNetEvent('ls-ui:client:practice:game')
AddEventHandler('ls-ui:client:practice:game', function(Type)
    if Type == 'Blocks' then
        LSCore.Functions.TriggerCallback('LSCore:RemoveCash', function(DidPayment) 
            if DidPayment then
                StartBlocksGame(function(Outcome)
                    if Outcome then
                        LSCore.Functions.Notify('Yeet het is je gelukt..', 'success')
                    else
                        LSCore.Functions.Notify('Je faalde..', 'error')
                    end
                end)
            else
                LSCore.Functions.Notify('Je hebt niet genoeg contant..', 'error')
            end
        end, 350)
    elseif Type == 'Shapes' then
        LSCore.Functions.TriggerCallback('LSCore:RemoveCash', function(DidPayment) 
            if DidPayment then
                exports['minigame-shape']:StartShapeGame(function(Outcome)
                    if Outcome then
                        LSCore.Functions.Notify('Yeet het is je gelukt..', 'success')
                    else
                        LSCore.Functions.Notify('Je faalde..', 'error')
                    end
                end)
            else
                LSCore.Functions.Notify('Je hebt niet genoeg contant..', 'error')
            end
        end, 500)
    end
end)

RegisterNetEvent('ls-ui:client:show:police:id')
AddEventHandler('ls-ui:client:show:police:id', function(PassData)
    SendNuiMessage(json.encode({
        action = 'show-pass',
        data = PassData,
    }))
end)

RegisterNetEvent('ls-ui:client:show:current:players')
AddEventHandler('ls-ui:client:show:current:players', function()
    TriggerEvent('chatMessage', "SYSTEM", "cash", "Online Spelers: "..GetCurrentPlayers().."/64")
end)

RegisterNetEvent('ls-ui:client:scan:finger')
AddEventHandler('ls-ui:client:scan:finger', function(FingerCode)
    if ScannerOpen then
        SendNuiMessage(json.encode({
            action = 'set-finger',
            finger = FingerCode,
        }))
    end
end)

-- // Functions \\ --

function OpenMenu(MenuData)
    SendNUIMessage({
        action = 'setup',
        menudata = MenuData,
    })
    SetNuiFocus(true, true)
    Citizen.InvokeNative(0xFC695459D4D0E219, 0.7, 0.25)
end

function OpenInput(InputData, CallBack)
    SendNUIMessage({
        action = 'input',
        Title = InputData['Title'],
        Type = InputData['Type'],
        Logo = InputData['Logo'],
    })
    SetNuiFocus(true, true)
    CallBackData = CallBack
    Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.5)
end

function ToggleScope(Bool)
    SendNUIMessage({
        action = 'scopetoggle',
        toggle = Bool,
    })
end

function ShowInteraction(Text, Type)
    SendNUIMessage({
        action = 'showinteraction',
        text = Text,
        type = Type,
    })
end

function EditInteraction(Text, Type)
    SendNUIMessage({
        action = 'editinteraction',
        text = Text,
        type = Type,
    })
end

function HideInteraction()
    SendNUIMessage({
        action = 'hideinteraction',
    })
end

function OpenNewsPaper()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'OpenPaper',
    })
end

function OpenPoliceTablet()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'OpenPoliceTablet',
    })
end

function OpenPoliceFinger()
    ScannerOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'OpenPoliceFinger',
    })
end

function ShowInfo(data)
    SendNUIMessage({
        action = 'ShowInfo',
        data = data
    })
end

function EditInfo(data)
    SendNUIMessage({
        action = 'EditInfo',
        data = data
    })
end

function RemoveInfo()
    SendNUIMessage({
        action = 'RemoveInfo'
    })
end

function AddNotify(data)
    SendNUIMessage({
        action = 'AddNotify',
        data = data
    })
end

function GetCurrentPlayers()
    local TotalPlayers = 0
    for k, v in pairs(GetActivePlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    return TotalPlayers
end

RegisterNUICallback('TriggerShit', function(data)
    if data.ShitData['Type'] == 'Client' then
        TriggerEvent(data.ShitData['Event'], data.ShitData)
    else
        TriggerServerEvent(data.ShitData['Event'], data.ShitData)
    end
end)

RegisterNUICallback('TriggerInput', function(data)
    CallBackData(data.Input)
end)

RegisterNUICallback('ScanFinger', function()
    TriggerServerEvent('ls-ui:server:scan:finger')
end)

RegisterNUICallback('CloseMenuSecond', function(data)
    if data.clear then
        exports['ls-assets']:RemoveProp()
        ClearPedTasks(GetPlayerPed(-1))
    end
    ScannerOpen = false
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ClickSound', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)