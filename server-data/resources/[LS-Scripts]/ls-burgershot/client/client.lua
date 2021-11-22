local CurrentWorkObject, InRange, ShowingInteraction, AddedProps = {}, false, false, false
local LSCore, PlayerJob, LoggedIn = exports['ls-core']:GetCoreObject(), {}, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        PlayerJob = LSCore.Functions.GetPlayerData().job
        Citizen.Wait(1200)
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
	RemoveWorkObjects()
    LoggedIn, AddedProps = false, false
end)

RegisterNetEvent('LSCore:Client:OnJobUpdate')
AddEventHandler('LSCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('LSCore:Client:SetDuty')
AddEventHandler('LSCore:Client:SetDuty', function()
    PlayerJob = LSCore.Functions.GetPlayerData().job
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end)    
--         PlayerJob = LSCore.Functions.GetPlayerData().job
--         Citizen.Wait(1200)
--         LoggedIn = true
--     end)
-- end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearAnything = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            if PlayerJob.name == 'burger' and PlayerJob.onduty then
                local Distance = #(PlayerCoords - Config.Intercom['Worker'])
                if Distance < 1.5 then
                    NearAnything = true
                    if not ShowingInteraction then
                        ShowingInteraction = true
                        exports['ls-ui']:ShowInteraction('Drive Intercom', 'primary')
                        exports.tokovoip_script:addPlayerToRadio(878914, 'Telefoon')
                    end
                end
            end
            local Distance = #(PlayerCoords - Config.Intercom['Customer'])
            if Distance < 3.0 then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    TriggerServerEvent('ls-burgershot:server:alert:workers')
                    exports['ls-ui']:ShowInteraction('Drive Intercom', 'primary')
                    exports.tokovoip_script:addPlayerToRadio(878914, 'Telefoon')
                end
            end
            if not NearAnything then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['ls-ui']:HideInteraction()
                    exports.tokovoip_script:removePlayerFromRadio(878914)
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
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, -1193.70, -892.50, 13.99, true)
            InRange = false
            if Distance < 35.0 then
                InRange = true
                if not AddedProps then
                    AddedProps = true
                    SpawnWorkObjects()
                end
            end
            if not InRange then
                CheckDuty()
                if AddedProps then
                    AddedProps = false
                    RemoveWorkObjects()
                end
                Citizen.Wait(1500)
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-burgershot:client:give:payment')
AddEventHandler('ls-burgershot:client:give:payment', function()
    local PlayerContext = {['Title'] = 'Paypal ID?', ['Type'] = 'number', ['Logo'] = '<i class="fas fa-sort-numeric-up-alt"></i>'}
    LSCore.Functions.OpenInput(PlayerContext, function(PlayerId)
        if PlayerId ~= false then
            TriggerServerEvent('ls-burgershot:server:give:payment', tonumber(PlayerId))
        end
    end)
end)

RegisterNetEvent('ls-burgershot:client:call:intercom')
AddEventHandler('ls-burgershot:client:call:intercom', function()
    if LSCore.Functions.GetPlayerData().job.name =='burger' and LSCore.Functions.GetPlayerData().job.onduty then
        LSCore.Functions.Notify('Er staat iemand bij de drive..', 'info', 10000)
        PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
    end
end)

RegisterNetEvent('ls-burgershot:client:open:payment')
AddEventHandler('ls-burgershot:client:open:payment', function()
    local MenuItems = {}
    for k, v in pairs(Config.ActivePayments) do
        if Config.ActivePayments[k] ~= nil then
          local NewData = {}
          NewData['Title'] = 'Bestelling: #'..k
          NewData['Desc'] = 'Kosten: €'..v['Price']..' <br>Notitie: '..v['Note']
          NewData['Data'] = {['Event'] = 'ls-burgershot:server:pay:receipt', ['Type'] = 'Server', ['BillId'] = k, ['Price'] = v['Price'], ['Note'] = v['Note']}
          table.insert(MenuItems, NewData)
        end
    end
    if #MenuItems > 0 then
        local Data = {['Title'] = 'Openstaande Bestellingen', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    else
        LSCore.Functions.Notify("Er zijn geen actieve bestellingen..", "error")
    end
end)

RegisterNetEvent('ls-burgershot:client:open:register')
AddEventHandler('ls-burgershot:client:open:register', function()
  local PrData = {['Title'] = 'Kosten?', ['Type'] = 'number', ['Logo'] = '<i class="fas fa-coins"></i>'}
  local TxData = {['Title'] = 'Bestelling?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-hamburger"></i>'}
  LSCore.Functions.OpenInput(PrData, function(PriceData)
      if PriceData ~= false then
        Citizen.Wait(250)
        LSCore.Functions.OpenInput(TxData, function(NoteData)
          if NoteData ~= false then
            TriggerServerEvent('ls-burgershot:server:add:to:register', PriceData, NoteData)
          end
        end)
      end
  end)
end)

RegisterNetEvent('ls-burgershot:client:sync:register')
AddEventHandler('ls-burgershot:client:sync:register', function(RegisterConfig)
    Config.ActivePayments = RegisterConfig
end)

RegisterNetEvent('ls-burgershot:client:open:box')
AddEventHandler('ls-burgershot:client:open:box', function(BoxId)
    if exports['ls-inventory-new']:CanOpenInventory() then
        TriggerServerEvent('ls-inventory-new:server:open:inventory:other', 'burgerbag_'..BoxId, 'Stash', 5, 5000, 'burger-box')
    end
end)

RegisterNetEvent('ls-burgershot:client:open:cold:storage')
AddEventHandler('ls-burgershot:client:open:cold:storage', function()
    if exports['ls-inventory-new']:CanOpenInventory() then
        TriggerServerEvent('ls-inventory-new:server:open:inventory:other', 'burger_storage', 'Stash', 15, 1000000)
    end
end)

RegisterNetEvent('ls-burgershot:client:open:hot:storage')
AddEventHandler('ls-burgershot:client:open:hot:storage', function()
    if exports['ls-inventory-new']:CanOpenInventory() then
        TriggerServerEvent('ls-inventory-new:server:open:inventory:other', 'warmtebak', 'Stash', 10, 1000000)
    end
end)

RegisterNetEvent('ls-burgershot:client:open:tray')
AddEventHandler('ls-burgershot:client:open:tray', function(Number)
    if exports['ls-inventory-new']:CanOpenInventory() then
        TriggerServerEvent('ls-inventory-new:server:open:inventory:other', "Foodtray: "..Number, 'TempStashes', 10, 100000)
    end
end)

RegisterNetEvent('ls-burgershot:client:create:burger')
AddEventHandler('ls-burgershot:client:create:burger', function(BurgerType)
    LSCore.Functions.TriggerCallback('ls-burgershot:server:has:burger:items', function(HasBurgerItems)
        if HasBurgerItems then
           MakeBurger(BurgerType)
        else
          LSCore.Functions.Notify("Je mist ingredienten om dit broodje te maken..", "error")
        end
    end)
end)

RegisterNetEvent('ls-burgershot:client:create:drink')
AddEventHandler('ls-burgershot:client:create:drink', function(DrinkType)
    MakeDrink(DrinkType)
end)

RegisterNetEvent('ls-burgershot:client:bake:fries')
AddEventHandler('ls-burgershot:client:bake:fries', function()
    LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
        if HasItem then
           MakeFries()
        else
          LSCore.Functions.Notify("Je mist pattatekes..", "error")
        end
    end, 'burger-potato')
end)

RegisterNetEvent('ls-burgershot:client:bake:meat')
AddEventHandler('ls-burgershot:client:bake:meat', function()
    LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
        if HasItem then
           MakePatty()
        else
          LSCore.Functions.Notify("Je mist vlees..", "error")
        end
    end, 'burger-raw')
end)

-- // Functions \\ --

function MakeBurger(BurgerName)
    Citizen.SetTimeout(750, function()
        TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
        exports['ls-assets']:RequestAnimationDict("mini@repair")
        TaskPlayAnim(GetPlayerPed(-1), "mini@repair", "fixing_a_ped" ,3.0, 3.0, -1, 8, 0, false, false, false)
        LSCore.Functions.Progressbar("open-brick", "Hamburger Maken..", 7500, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerServerEvent('ls-burgershot:server:finish:burger', BurgerName)
            TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
            StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        end, function()
            TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
            LSCore.Functions.Notify("Geannuleerd..", "error")
            StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        end)
    end)
end

function MakeFries()
    TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
    TriggerEvent("ls-sound:client:play", "baking", 0.7)
    exports['ls-assets']:RequestAnimationDict("amb@prop_human_bbq@male@base")
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bbq@male@base", "base" ,3.0, 3.0, -1, 8, 0, false, false, false)
    LSCore.Functions.Progressbar("open-brick", "Frietjes Bakken..", 6500, false, true, {
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
        TriggerServerEvent('ls-burgershot:server:finish:fries')
        TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
        StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bbq@male@base", "base", 1.0)
    end, function()
        TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
        LSCore.Functions.Notify("Geannuleerd..", "error")
        StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bbq@male@base", "base", 1.0)
    end)
end

function MakePatty()
    TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
    TriggerEvent("ls-sound:client:play", "baking", 0.7)
    exports['ls-assets']:RequestAnimationDict("amb@prop_human_bbq@male@base")
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bbq@male@base", "base" ,3.0, 3.0, -1, 8, 0, false, false, false)
    LSCore.Functions.Progressbar("open-brick", "Burger Bakken..", 6500, false, true, {
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
        TriggerServerEvent('ls-burgershot:server:finish:patty')
        TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
        StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bbq@male@base", "base", 1.0)
    end, function()
        TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
        LSCore.Functions.Notify("Geannuleerd..", "error")
        StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bbq@male@base", "base", 1.0)
    end)
end

function MakeDrink(DrinkName)
    TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
    TriggerEvent("ls-sound:client:play", "pour-drink", 0.4)
    exports['ls-assets']:RequestAnimationDict("amb@world_human_hang_out_street@female_hold_arm@idle_a")
    TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a" ,3.0, 3.0, -1, 8, 0, false, false, false)
    LSCore.Functions.Progressbar("open-brick", "Drinken Tappen..", 6500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('ls-burgershot:server:finish:drink', DrinkName)
        TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
        StopAnimTask(GetPlayerPed(-1), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
    end, function()
        TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
        LSCore.Functions.Notify("Geannuleerd..", "error")
        StopAnimTask(GetPlayerPed(-1), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
    end)
end

function CheckDuty()
    if LSCore.Functions.GetPlayerData().job.name =='burger' and LSCore.Functions.GetPlayerData().job.onduty then
       TriggerServerEvent('LSCore:ToggleDuty')
       LSCore.Functions.Notify("Je bent tever van je werk!", "error")
    end
end

function SpawnWorkObjects()
    for k, v in pairs(Config.WorkProps) do
        exports['ls-assets']:RequestModelHash(v['Prop'])
        WorkObject = CreateObject(GetHashKey(v['Prop']), v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], false, true, false)
        SetEntityHeading(WorkObject, v['Coords']['H'])
        if v['PlaceOnGround'] then
        	PlaceObjectOnGroundProperly(WorkObject)
        end
        if not v['ShowItem'] then
        	SetEntityVisible(WorkObject, false)
        end
        FreezeEntityPosition(WorkObject, true)
        SetEntityInvincible(WorkObject, true)
        table.insert(CurrentWorkObject, WorkObject)
    end
end

function RemoveWorkObjects()
    for k, v in pairs(CurrentWorkObject) do
       NetworkRequestControlOfEntity(v)
    	 DeleteEntity(v)
    end
end

function IsInsideBurgershot()
    return InRange
end