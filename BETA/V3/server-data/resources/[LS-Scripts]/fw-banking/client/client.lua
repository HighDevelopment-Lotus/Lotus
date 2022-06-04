local LSCore, LoggedIn = exports['fw-base']:GetCoreObject(), false
local CanOpenBank, CurrentType, ShowingInteraction = false, nil, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function() 
        Citizen.Wait(250)
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(4)
--         if LoggedIn then
--             CanOpenBank = false
--             local PlayerCoords = GetEntityCoords(PlayerPedId())
--             for k, v in pairs(Config.Banks) do
--                 local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
--                 if Distance < 2.5 then
--                     CanOpenBank = true
--                     if not ShowingInteraction then
--                         ShowingInteraction = true
--                         exports['fw-ui']:ShowInteraction('[F1] Bank', 'primary')
--                     end
--                 end
--             end
--             if not CanOpenBank then
--                 if ShowingInteraction then
--                     ShowingInteraction = false
--                     exports['fw-ui']:HideInteraction()
--                 end
--                 Citizen.Wait(1000)
--                 CanOpenBank = false
--             end
--         end
--     end
-- end)

-- // Events \\ --

RegisterNetEvent('framework-banking:client:open:bank')
AddEventHandler('framework-banking:client:open:bank', function()
    Citizen.SetTimeout(450, function()
        local Player = LSCore.Functions.GetPlayerData()
        CurrentType = 'bank'
        SendNUIMessage({action = 'OpenBank', cash = Player.money['cash'], type = 'bank'})
        SetNuiFocus(true, true)
    end)
end)

RegisterNetEvent('framework-banking:client:open:atm')
AddEventHandler('framework-banking:client:open:atm', function()
    Citizen.SetTimeout(450, function()
        exports['fw-assets']:RequestAnimationDict('amb@prop_human_atm@male@idle_a')
        exports['fw-assets']:RequestAnimationDict('amb@prop_human_atm@male@exit')
        TaskPlayAnim(PlayerPedId(), "amb@prop_human_atm@male@idle_a", "idle_b", 1.0, 1.0, -1, 49, 0, 0, 0, 0 )
        LSCore.Functions.Progressbar("bank", "Pinpas Invoeren..", 4500, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            local Player = LSCore.Functions.GetPlayerData()
            CurrentType = 'atm'
            SendNUIMessage({action = 'OpenBank', cash = Player.money['cash'], type = 'atm'})
            SetNuiFocus(true, true)
        end, function()
            LSCore.Functions.Notify("Geannuleerd..", "error")
        end)
    end)
end)

RegisterNetEvent('framework-banking:client:check:players:near')
AddEventHandler('framework-banking:client:check:players:near', function(TargetPlayer, Amount)
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 3.0 then
        if GetPlayerServerId(Player) == TargetPlayer then
            exports['fw-assets']:RequestAnimationDict('friends@laf@ig_5')
            TaskPlayAnim(PlayerPedId(), 'friends@laf@ig_5', 'nephew', 5.0, 1.0, 5.0,48, 0.0, 0, 0, 0)
            TriggerServerEvent('framework-banking:server:give:cash', TargetPlayer, Amount) 
        else
            LSCore.Functions.Notify("Dit is niet de juiste burger..", "error")
        end
    else
        LSCore.Functions.Notify("Geen burger gevonden..", "error")
    end
end)

-- // Functions \\ --

RegisterNUICallback('CloseUi', function()
    SetNuiFocus(false, false)
    if CurrentType == 'atm' then
        TaskPlayAnim(PlayerPedId(), "amb@prop_human_atm@male@exit", "exit", 1.0, 1.0, -1, 49, 0, 0, 0, 0 )
        LSCore.Functions.Progressbar("bank", "Pinpas Uitnemen..", 5000, false, false, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            CurrentType = nil
            ClearPedTasks(PlayerPedId())
        end, function()
            LSCore.Functions.Notify("Geannuleerd..", "error")
        end)
    end
end)

RegisterNUICallback('ClickSound', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('ErrorSound', function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('GetAccounts', function(data, cb)
    LSCore.Functions.TriggerCallback("framework-bank:server:get:accounts", function(Accounts)
        cb(Accounts)
    end)  
end)

RegisterNUICallback('GetSharedAccounts', function(data, cb)
    LSCore.Functions.TriggerCallback("framework-bank:server:get:shared:accounts", function(Accounts)
        cb(Accounts)
    end)  
end)

RegisterNUICallback('GetBusinessdAccounts', function(data, cb)
    LSCore.Functions.TriggerCallback("framework-bank:server:get:business:accounts", function(Accounts)
        cb(Accounts)
    end)  
end)

RegisterNUICallback('GetMyAccount', function(data, cb)
    local Player = LSCore.Functions.GetPlayerData()
    local Data = {['BankId'] = Player.charinfo.account, ['Balance'] = Player.money['bank'], ['PersonalName'] = Player.charinfo.firstname..' '..Player.charinfo.lastname, ['Type'] = 'standard'}
    cb(Data)
end)

RegisterNUICallback('WithdrawMoney', function(data, cb)
    local Data = {['Type'] = data.Type, ['BankId'] = data.AccountNumber, ['WithdrawAmount'] = data.WithdrawAmount, ['WithdrawReason'] = data.WithdrawReason}
    LSCore.Functions.TriggerCallback("framework-bank:server:withdraw:money", function(IsDone)
        cb(IsDone)
    end, Data) 
end)

RegisterNUICallback('DepositMoney', function(data, cb)
    local Data = {['Type'] = data.Type, ['BankId'] = data.AccountNumber, ['DepositAmount'] = data.DepositAmount, ['DepositReason'] = data.DepositReason}
    LSCore.Functions.TriggerCallback("framework-bank:server:deposit:money", function(IsDone)
        cb(IsDone)
    end, Data) 
end)

RegisterNUICallback('TransferMoney', function(data, cb)
    local Data = {['Type'] = data.Type, ['TBankId'] = data.TargetNumber, ['MBankId'] = data.AccountNumber, ['TransferAmount'] = data.TransferAmount, ['TransferReason'] = data.TransferReason}
    LSCore.Functions.TriggerCallback("framework-bank:server:transfer:money", function(IsDone)
        cb(IsDone)
    end, Data) 
end)

RegisterNUICallback('DeleteAccount', function(data, cb)
    LSCore.Functions.TriggerCallback("framework-bank:server:delete:account", function(IsDone)
        cb(IsDone)
    end, data.BankId) 
end)

RegisterNUICallback('CreateAccount', function(data, cb)
    local Data = {['Type'] = data.Type, ['Name'] = data.Name}
    LSCore.Functions.TriggerCallback("framework-bank:server:create:account", function(IsDone)
        cb(IsDone)
    end, Data) 
end)

RegisterNUICallback('DeletePlayer', function(data, cb)
    local Data = {['BankId'] = data.BankId, ['CitizenId'] = data.CitizenId}
    LSCore.Functions.TriggerCallback("framework-bank:server:delete:player", function(IsDone)
        cb(IsDone)
    end, Data) 
end)

RegisterNUICallback('AddPlayer', function(data, cb)
    local Data = {['BankId'] = data.BankId, ['CitizenId'] = data.CitizenId}
    LSCore.Functions.TriggerCallback("framework-bank:server:add:player", function(IsDone)
        cb(IsDone)
    end, Data) 
end)

RegisterNUICallback('GetCash', function(data, cb)
    local Player = LSCore.Functions.GetPlayerData()
    cb(Player.money['cash'])
end)

function IsNearAnyBank()
    return CanOpenBank
end