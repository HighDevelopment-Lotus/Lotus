local InRange, ShowingInteraction = false, false
 
-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearAnything = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            if PlayerJob.name == 'burger' and PlayerJob.onduty then
                local Distance = #(PlayerCoords - Config.Intercom['Worker'])
                if Distance < 1.5 then
                    NearAnything = true
                    if not ShowingInteraction then
                        ShowingInteraction = true
                        exports['fw-ui']:ShowInteraction('Drive Intercom', 'primary')
                        exports["fw-voice"]:addPlayerToCall(878914)
                    end
                end
            end 
            local Distance = #(PlayerCoords - Config.Intercom['Customer'])
            if Distance < 3.0 then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    TriggerServerEvent('framework-jobmanager:server:alert:workers')
                    exports['fw-ui']:ShowInteraction('Drive Intercom', 'primary')
                    exports["fw-voice"]:addPlayerToCall(878914)
                end
            end
            if not NearAnything then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['fw-ui']:HideInteraction()
                    exports["fw-voice"]:removePlayerFromCall(878914)
                end
                Citizen.Wait(1000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, -1193.70, -892.50, 13.99, true)
            InRange = false
            if Distance < 35.0 then
                InRange = true
            end
            if not InRange then
                CheckDuty()
                Citizen.Wait(1500)
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-jobmanager:client:give:payment')
AddEventHandler('framework-jobmanager:client:give:payment', function()
    local PlayerContext = {['Title'] = 'Paypal ID?', ['Type'] = 'number', ['Logo'] = '<i class="fas fa-sort-numeric-up-alt"></i>'}
    LSCore.Functions.OpenInput(PlayerContext, function(PlayerId)
        if PlayerId ~= false then
            TriggerServerEvent('framework-jobmanager:server:give:payment', tonumber(PlayerId))
        end
    end)
end)

RegisterNetEvent('framework-jobmanager:client:call:intercom')
AddEventHandler('framework-jobmanager:client:call:intercom', function()
    if LSCore.Functions.GetPlayerData().job.name =='burger' and LSCore.Functions.GetPlayerData().job.onduty then
        LSCore.Functions.Notify('Er staat iemand bij de drive in', 'info', 10000)
        PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
    end
end)

RegisterNetEvent('framework-jobmanager:client:open:payment')
AddEventHandler('framework-jobmanager:client:open:payment', function()
    local MenuItems = {}
    for k, v in pairs(Config.ActivePayments) do
        if Config.ActivePayments[k] ~= nil then
          local NewData = {}
          NewData['Title'] = 'Bestelling: #'..k
          NewData['Desc'] = 'Kosten: $'..v['Price']..' <br>Notitie: '..v['Note']
          NewData['Data'] = {['Event'] = 'framework-jobmanager:server:pay:receipt', ['Type'] = 'Server', ['BillId'] = k, ['Price'] = v['Price'], ['Note'] = v['Note']}
          table.insert(MenuItems, NewData)
        end
    end
    if #MenuItems > 0 then
        local Data = {['Title'] = 'Open Orders', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    else
        LSCore.Functions.Notify("Er zijn geen orders", "error")
    end
end)

RegisterNetEvent('framework-jobmanager:client:open:register')
AddEventHandler('framework-jobmanager:client:open:register', function()
  local PrData = {['Title'] = 'Prijs?', ['Type'] = 'number', ['Logo'] = '<i class="fas fa-coins"></i>'}
  local TxData = {['Title'] = 'Bestelling?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-hamburger"></i>'}
  LSCore.Functions.OpenInput(PrData, function(PriceData)
      if PriceData ~= false then
        Citizen.Wait(250)
        LSCore.Functions.OpenInput(TxData, function(NoteData)
          if NoteData ~= false then
            TriggerServerEvent('framework-jobmanager:server:add:to:register', PriceData, NoteData)
          end
        end)
      end
  end)
end)

RegisterNetEvent('framework-jobmanager:client:sync:register')
AddEventHandler('framework-jobmanager:client:sync:register', function(RegisterConfig)
    Config.ActivePayments = RegisterConfig
end)

RegisterNetEvent('framework-jobmanager:client:open:box')
AddEventHandler('framework-jobmanager:client:open:box', function(BoxId)
    if exports['fw-inv']:CanOpenInventory() then
        TriggerServerEvent('framework-inv:server:open:inventory:other', 'burgerbag_'..BoxId, 'Stash', 5, 5000, 'burger-box')
    end
end)

RegisterNetEvent('framework-jobmanager:client:open:cold:storage')
AddEventHandler('framework-jobmanager:client:open:cold:storage', function()
    if exports['fw-inv']:CanOpenInventory() then
        TriggerServerEvent('framework-inv:server:open:inventory:other', 'burger_storage', 'Stash', 15, 1000000)
    end
end)

RegisterNetEvent('framework-jobmanager:client:open:hot:storage')
AddEventHandler('framework-jobmanager:client:open:hot:storage', function()
    if exports['fw-inv']:CanOpenInventory() then
        TriggerServerEvent('framework-inv:server:open:inventory:other', 'Heat Shelf', 'Stash', 10, 1000000)
    end
end)

RegisterNetEvent('framework-jobmanager:client:open:tray')
AddEventHandler('framework-jobmanager:client:open:tray', function(Number)
    if exports['fw-inv']:CanOpenInventory() then
        TriggerServerEvent('framework-inv:server:open:inventory:other', "Foodtray: "..Number, 'TempStashes', 10, 100000)
    end
end)

RegisterNetEvent('framework-jobmanager:client:create:burger')
AddEventHandler('framework-jobmanager:client:create:burger', function(BurgerType)
    LSCore.Functions.TriggerCallback('framework-jobmanager:server:has:burger:items', function(HasBurgerItems)
        if HasBurgerItems then
           MakeBurger(BurgerType)
        else
          LSCore.Functions.Notify("Je mist ingredienten om deze burger te maken", "error")
        end
    end)
end)

RegisterNetEvent('framework-jobmanager:client:create:drink')
AddEventHandler('framework-jobmanager:client:create:drink', function(DrinkType)
    MakeDrink(DrinkType)
end)

RegisterNetEvent('framework-jobmanager:client:bake:fries')
AddEventHandler('framework-jobmanager:client:bake:fries', function()
    LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
        if HasItem then
           MakeFries()
        else
          LSCore.Functions.Notify("Je mist aardappelen", "error")
        end
    end, 'burger-potato')
end)

RegisterNetEvent('framework-jobmanager:client:bake:meat')
AddEventHandler('framework-jobmanager:client:bake:meat', function()
    LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
        if HasItem then
           MakePatty()
        else
          LSCore.Functions.Notify("Je mist vlees", "error")
        end
    end, 'burger-raw')
end)

-- // Functions \\ --

function MakeBurger(BurgerName)
    Citizen.SetTimeout(750, function()
        TriggerEvent('framework-inv:client:set:inventory:state', false)
        exports['fw-assets']:RequestAnimationDict("mini@repair")
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped" ,3.0, 3.0, -1, 8, 0, false, false, false)
        LSCore.Functions.Progressbar("open-brick", "Burger maken", 7500, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerServerEvent('framework-jobmanager:server:finish:burger', BurgerName)
            TriggerEvent('framework-inv:client:set:inventory:state', true)
            StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
        end, function()
            TriggerEvent('framework-inv:client:set:inventory:state', true)
            LSCore.Functions.Notify("Geannuleerd", "error")
            StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
        end)
    end)
end

function MakeFries()
    TriggerEvent('framework-inv:client:set:inventory:state', false)
    TriggerEvent("framework-sound:client:play", "baking", 0.7)
    exports['fw-assets']:RequestAnimationDict("amb@prop_human_bbq@male@base")
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bbq@male@base", "base" ,3.0, 3.0, -1, 8, 0, false, false, false)
    LSCore.Functions.Progressbar("open-brick", "Patat bakken", 6500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {
        model = "prop_cs_fork",
        bone = 28422,
        coords = { x = -0.005, y = 0.00, z = 0.00 },
        rotation = { x = 175.0, y = 160.0, z = 0.0 },
    }, {}, function() -- Done
        TriggerServerEvent('framework-jobmanager:server:finish:fries')
        TriggerEvent('framework-inv:client:set:inventory:state', true)
        StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
    end, function()
        TriggerEvent('framework-inv:client:set:inventory:state', true)
        LSCore.Functions.Notify("Geannuleerd", "error")
        StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
    end)
end

function MakePatty()
    TriggerEvent('framework-inv:client:set:inventory:state', false)
    TriggerEvent("framework-sound:client:play", "baking", 0.7)
    exports['fw-assets']:RequestAnimationDict("amb@prop_human_bbq@male@base")
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bbq@male@base", "base" ,3.0, 3.0, -1, 8, 0, false, false, false)
    LSCore.Functions.Progressbar("open-brick", "Burger grillen", 6500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {
        model = "prop_cs_fork",
        bone = 28422,
        coords = { x = -0.005, y = 0.00, z = 0.00},
        rotation = { x = 175.0, y = 160.0, z = 0.0},
    }, {}, function() -- Done
        TriggerServerEvent('framework-jobmanager:server:finish:patty')
        TriggerEvent('framework-inv:client:set:inventory:state', true)
        StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
    end, function()
        TriggerEvent('framework-inv:client:set:inventory:state', true)
        LSCore.Functions.Notify("Geannuleerd", "error")
        StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
    end)
end

function MakeDrink(DrinkName)
    TriggerEvent('framework-inv:client:set:inventory:state', false)
    TriggerEvent("framework-sound:client:play", "pour-drink", 0.4)
    exports['fw-assets']:RequestAnimationDict("amb@world_human_hang_out_street@female_hold_arm@idle_a")
    TaskPlayAnim(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a" ,3.0, 3.0, -1, 8, 0, false, false, false)
    LSCore.Functions.Progressbar("open-brick", "Drinken Maken", 6500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        LSCore.Functions.TriggerCallback('framework-jobmanager:server:finish:drink', function() end, DrinkName)
        TriggerEvent('framework-inv:client:set:inventory:state', true)
        StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
    end, function()
        TriggerEvent('framework-inv:client:set:inventory:state', true)
        LSCore.Functions.Notify("Geannuleerd", "error")
        StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
    end)
end

function CheckDuty()
    if LSCore.Functions.GetPlayerData().job.name =='burger' and LSCore.Functions.GetPlayerData().job.onduty then
       TriggerServerEvent('LSCore:ToggleDuty')
       LSCore.Functions.Notify("Je bent tever van je baan vandaan", "error")
    end
end

function IsInsideBurgershot()
    return InRange
end