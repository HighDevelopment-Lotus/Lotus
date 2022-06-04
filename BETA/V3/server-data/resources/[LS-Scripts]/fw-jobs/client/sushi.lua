local LoggedIn, NearRestaurant, CurrentWorkObject = false, false, {}

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
	    LSCore.Functions.TriggerCallback("framework-sushi:server:get:config", function(config)
            Config = config
        end)
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
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Interior = GetInteriorAtCoords(PlayerCoords)
            if Interior == Config.InteriorId then
                NearRestaurant = true
                if not AddedProps then
                    AddedProps = true
                    SpawnWorkObjects()
                end
            else
                if AddedProps then
                    AddedProps = false
                    RemoveWorkObjects()
                end
                NearRestaurant = false
                CheckDuty()
            end
            Citizen.Wait(450)
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-sushi:client:open:cooker')
AddEventHandler('framework-sushi:client:open:cooker', function()
    local MenuItems = {}
    for k, v in pairs(Config.FoodCooker) do
        local NewData = {}
        NewData['Title'] = v['FoodName']
        NewData['Desc'] = v['Desc']
        NewData['Data'] = {['Event'] = 'framework-sushi:client:try:cook', ['Type'] = 'Client', ['FoodName'] = v['FoodName'], ['ItemName'] = v['Food']}
        table.insert(MenuItems, NewData)
    end
    if #MenuItems > 0 then
        local Data = {['Title'] = 'Yuki\'s Menu', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    else
        LSCore.Functions.Notify("Er zijn geen actieve bestellingen..", "error")
    end
end)

RegisterNetEvent('framework-sushi:client:try:cook')
AddEventHandler('framework-sushi:client:try:cook', function(MenuData)
    if MenuData['ItemName'] == 'sushi-beef' then
        local HasRawBeef = exports['fw-inv']:HasEnoughOfItem('hunting-meat', 1)
        local HasNoodle = exports['fw-inv']:HasEnoughOfItem('sushi-noodle', 1)
        if HasRawBeef and HasNoodle then
            Citizen.SetTimeout(500, function()
                exports['fw-assets']:RequestAnimationDict("mini@repair")
                TaskPlayAnim(GetPlayerPed(-1), "mini@repair", "fixing_a_ped" ,3.0, 3.0, -1, 8, 0, false, false, false)
                exports['fw-ui']:StartSkillTest(2, 'Normal', function(Outcome)
                    if Outcome then
                        TriggerServerEvent('framework-sushi:server:create:food', 'sushi-beef')
                        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                    else
                        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                    end
                end)
            end)
        else
            LSCore.Functions.Notify("Je mist ingrediënten..", "error")
        end
    elseif MenuData['ItemName'] == 'sushi' then
        local HasWater = exports['fw-inv']:HasEnoughOfItem('water_bottle', 1)
        local HasRice = exports['fw-inv']:HasEnoughOfItem('sushi-rice', 1)
        if HasRice and HasWater then
            Citizen.SetTimeout(500, function()
                exports['fw-assets']:RequestAnimationDict("mini@repair")
                TaskPlayAnim(GetPlayerPed(-1), "mini@repair", "fixing_a_ped" ,3.0, 3.0, -1, 8, 0, false, false, false)
                exports['fw-ui']:StartSkillTest(2, 'Normal', function(Outcome)
                    if Outcome then
                        TriggerServerEvent('framework-sushi:server:create:food', 'sushi')
                        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                    else
                        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                    end
                end)
            end)
        else
            LSCore.Functions.Notify("Je mist ingrediënten..", "error")
        end
    elseif MenuData['ItemName'] == 'sushi-ramen' then
        local HasRawBeef = exports['fw-inv']:HasEnoughOfItem('hunting-meat', 1)
        local HasWater = exports['fw-inv']:HasEnoughOfItem('water_bottle', 1)
        local HasNoodle = exports['fw-inv']:HasEnoughOfItem('sushi-noodle', 1)
        if HasRawBeef and HasNoodle and HasWater then
            Citizen.SetTimeout(500, function()
                exports['fw-assets']:RequestAnimationDict("mini@repair")
                TaskPlayAnim(GetPlayerPed(-1), "mini@repair", "fixing_a_ped" ,3.0, 3.0, -1, 8, 0, false, false, false)
                exports['fw-ui']:StartSkillTest(2, 'Normal', function(Outcome)
                    if Outcome then
                        TriggerServerEvent('framework-sushi:server:create:food', 'sushi-ramen')
                        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                    else
                        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                    end
                end)
            end)
        else
            LSCore.Functions.Notify("Je mist ingrediënten..", "error")
        end
    end
end)

RegisterNetEvent('framework-sushi:client:make:tea')
AddEventHandler('framework-sushi:client:make:tea', function()
    exports['framework-ui']:StartSkillTest(2, 'Normal', function(Outcome)
        if Outcome then
            TriggerServerEvent('framework-sushi:server:create:tea')
        end
    end)
end)

RegisterNetEvent('framework-sushi:client:open:payment')
AddEventHandler('framework-sushi:client:open:payment', function()
    local MenuItems = {}
    for k, v in pairs(Config.RegisterData) do
        if Config.RegisterData[k] ~= nil then
            local NewData = {}
            NewData['Title'] = 'Bestelling: #'..k
            NewData['Desc'] = 'Kosten: €'..v['Price']..' <br>Notitie: '..v['Note']
            NewData['Data'] = {['Event'] = 'framework-sushi:server:pay:receipt', ['Type'] = 'Server', ['BillId'] = k, ['Price'] = v['Price'], ['Note'] = v['Note']}
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

RegisterNetEvent('framework-sushi:client:open:register')
AddEventHandler('framework-sushi:client:open:register', function()
    local PrData = {['Title'] = 'Kosten?', ['Type'] = 'number', ['Logo'] = '<i class="fas fa-coins"></i>'}
    local TxData = {['Title'] = 'Bestelling?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-hamburger"></i>'}
    LSCore.Functions.OpenInput(PrData, function(PriceData)
        if PriceData ~= false then
            Citizen.Wait(250)
            LSCore.Functions.OpenInput(TxData, function(NoteData)
                if NoteData ~= false then
                  TriggerServerEvent('framework-sushi:server:add:to:register', PriceData, NoteData)
                end
            end)
        end
    end)
end)

RegisterNetEvent('framework-sushi:client:open:storage')
AddEventHandler('framework-sushi:client:open:storage', function(Type)
    if Type == 'Tray' then
        if exports['fw-inv']:CanOpenInventory() then
            TriggerServerEvent('framework-inv:server:open:inventory:other', "Foodtray: Sushi", 'TempStashes', 10, 100000)
        end
    else
        if exports['fw-inv']:CanOpenInventory() then
            TriggerServerEvent('framework-inv:server:open:inventory:other', "Sushi Opslag", 'Stash', 10, 500000)
        end 
    end
end)

RegisterNetEvent('framework-sushi:client:sync:register')
AddEventHandler('framework-sushi:client:sync:register', function(TicketId, TicktetData)
    Config.RegisterData[TicketId] = TicktetData
end)

-- // Functions \\ --

function SpawnWorkObjects()
    for k, v in pairs(Config.WorkProps) do
        exports['fw-assets']:RequestModelHash(v['Prop'])
        WorkObject = CreateObject(GetHashKey(v['Prop']), v["Coords"].x, v["Coords"].y, v["Coords"].z, false, true, false)
        SetEntityHeading(WorkObject, v['Coords'].w)
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

function CheckDuty()
    if LSCore.Functions.GetPlayerData().job.name =='sushi' and LSCore.Functions.GetPlayerData().job.onduty then
        TriggerServerEvent('LSCore:ToggleDuty')
        LSCore.Functions.Notify("Je bent tever van je werk!", "error")
     end
end

function IsNearRestaurant()
    return NearRestaurant
end