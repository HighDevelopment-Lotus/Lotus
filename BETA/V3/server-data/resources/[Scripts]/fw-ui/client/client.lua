local ScannerOpen = false
LSCore, LoggedIn, Restarting = exports['fw-base']:GetCoreObject(), false, false
Hunger, Thirst, Stress, Timer = 100, 100, 0, 0
InVehicle, Seatbelt = false, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(2250, function()
        LSCore.Functions.GetPlayerData(function(PlayerData)
            if PlayerData.metadata['armor'] ~= 0 then
                SetPedArmour(PlayerPedId(), tonumber(PlayerData.metadata['armor']))
            end
            if PlayerData.metadata['health'] ~= 0 then
                SetEntityHealth(PlayerPedId(), tonumber(PlayerData.metadata["health"]))
            end
            Hunger, Thirst, Stress = PlayerData.metadata["hunger"], PlayerData.metadata["thirst"], PlayerData.metadata["stress"]
            Citizen.Wait(150)
            -- SendNUIMessage({action = 'SetMoney', amount = PlayerData.money['cash']})
            SendNUIMessage({action = 'Show'})
            LoggedIn = true
        end)
        
        LSCore.Functions.TriggerCallback('framework-board:server:GetConfig', function(config)
            Config.IllegalActions = config
        end)
    end)
end)


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

RegisterNetEvent('framework-ui:client:open:newspaper')
AddEventHandler('framework-ui:client:open:newspaper', function()
    OpenNewsPaper()
end)

RegisterNetEvent('framework-ui:client:purchase:magazine')
AddEventHandler('framework-ui:client:purchase:magazine', function()
    LSCore.Functions.TriggerCallback('LSCore:RemoveCash', function(DidPay) 
        if DidPay then
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = 'OpenMagazine'
            })
        end
    end, 4)
end)

RegisterNetEvent('framework-ui:client:add:news:jail')
AddEventHandler('framework-ui:client:add:news:jail', function(data)
    SendNUIMessage({
        action = 'AddJail',
        name = data['Name'],
        jailtime = data['JailTime'],
    })
end)

RegisterNetEvent("framework-ui:client:update:needs")
AddEventHandler("framework-ui:client:update:needs", function(NewHunger, NewThirst)
    Hunger, Thirst = NewHunger, NewThirst
end)

RegisterNetEvent('framework-ui:client:update:stress')
AddEventHandler('framework-ui:client:update:stress', function(NewStress)
    Stress = NewStress
end)

RegisterNetEvent('framework-ui:client:set:timer')
AddEventHandler('framework-ui:client:set:timer', function(TimerAmount)
    Timer = TimerAmount
end)

RegisterNetEvent('framework-ui:client:show:cash')
AddEventHandler('framework-ui:client:show:cash', function()
    SendNUIMessage({action = 'ShowCash'})
end)

RegisterNetEvent("framework-ui:client:money:change")
AddEventHandler("framework-ui:client:money:change", function(Amount, Type)
    Citizen.SetTimeout(150, function()
        if Type == 'Plus' then
            SendNUIMessage({action = 'ChangeMoney', type = 'Add', amount = Amount})
        else
            SendNUIMessage({action = 'ChangeMoney', type = 'Remove', amount = Amount})
        end
        SendNUIMessage({action = 'SetMoney', amount = LSCore.Functions.GetPlayerData().money['cash']})
    end)
end)

RegisterNetEvent('framework-ui:client:practice:game')
AddEventHandler('framework-ui:client:practice:game', function(Type)
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

RegisterNetEvent('framework-ui:client:show:police:id')
AddEventHandler('framework-ui:client:show:police:id', function(PassData)
    SendNuiMessage(json.encode({
        action = 'show-pass',
        data = PassData,
    }))
end)

RegisterNetEvent('framework-ui:client:show:current:players')
AddEventHandler('framework-ui:client:show:current:players', function()
    TriggerEvent('chatMessage', "SYSTEM", "cash", "Online Spelers: "..GetCurrentPlayers().."/64")
end)

RegisterNetEvent('framework-ui:client:scan:finger')
AddEventHandler('framework-ui:client:scan:finger', function(FingerCode)
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

function DoorInteraction(Text, Type)
    SendNUIMessage({
        action = 'doorinteraction',
        text = Text,
        type = Type,
    })
end

function EditDoorInteraction(Text, Type)
    SendNUIMessage({
        action = 'editdoorinteraction',
        text = Text,
        type = Type,
    })
end

function HideDoorInteraction()
    SendNUIMessage({
        action = 'hidedoorinteraction',
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

function ShowInfoLong(action, text)
	SendNUIMessage({
		action = action,
		text = text,
	})
end

function HideInfo()
	SendNUIMessage({
		action = 'hide'
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
    TriggerServerEvent('framework-ui:server:scan:finger')
end)

RegisterNUICallback('CloseMenuSecond', function(data)
    if data.clear then
        exports['fw-assets']:RemoveProp()
        ClearPedTasks(PlayerPedId())
    end
    ScannerOpen = false
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ClickSound', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)