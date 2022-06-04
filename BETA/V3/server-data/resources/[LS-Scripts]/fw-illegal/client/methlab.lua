local NearAction = false
local Cooking = false
local MethCrafting = {['X'] = 1015.04, ['Y'] = -3194.87, ['Z'] = -38.99}
local MethTemps = {['X'] = 1014.6236, ['Y'] = -3198.332, ['Z'] = -38.99}
local minutes = 0
local seconds = 0

-- Threads

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearAction = false
            if InsideLab and Config.Labs[CurrentLab]['Name'] == 'Methlab' then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'], true)
                if Distance < 1.0 then
                    NearAction = true
                    if not Config.Labs[CurrentLab]['Cooking'] then
                        AmountMethItems()

                        if IsControlJustReleased(0, 38) then
                            AddIngredient()                             
                        end 
                    else
                        if Config.CookTimer > 0 then
                            displayTime()
                        else
                            if not ShowInteractions5 then
                                ShowInteractions5 = true
                                exports['fw-ui']:ShowInteraction('[E] Poeder Pakken', 'primary')
                            end

                            if IsControlJustReleased(0, 38) then
                                GetMeth()
                                exports['fw-ui']:HideInteraction()
                            end
                        end
                    end
                end

                local Distance2 = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, MethCrafting['X'], MethCrafting['Y'], MethCrafting['Z'], true)
                local HasItemData = {[1] = 'meth-powder', [2] = 'empty_weed_bag'}
                if Distance2 < 1.0 then
                    NearAction = true
                    if not ShowInteractions5 then
                        ShowInteractions5 = true
                        exports['fw-ui']:ShowInteraction('[E] Packing', 'primary')
                    end

                    if IsControlJustReleased(0, 38) then
                        local CraftingData = {['Type'] = 'Crafting', ['InvName'] = 'Meth', ['Items'] = Config.MethCrafting}
                        TriggerServerEvent('framework-inv:server:open:inventory:other', CraftingData, 'Crafting')
                        exports['fw-ui']:HideInteraction()
                    end
                end

                -- local Distance22 = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, MethTemps['X'], MethTemps['Y'], MethTemps['Z'], true)
                -- if Distance22 < 1.0 then
                --     NearAction = true
                --         if not ShowInteractions6 then
                --             ShowInteractions6 = true
                --             exports['fw-ui']:ShowInteraction('[E] Controleer Temperatuur', 'primary')
                --         end

                --         if IsControlJustReleased(0, 38) then
                --             exports['fw-ui']:HideInteraction()
                            
                --             if Config.CookTimer > 0 then
                                
                --             else
                --                 LSCore.Functions.Notify("Gooi eerst wat drugs in de pan natnek", "error")
                --             end
                --         end
                -- end

                if not NearAction then
                    if ShowInteractions5 then
                        ShowInteractions5 = false
                        exports['fw-ui']:HideInteraction()
                    end
                    
                    -- if ShowInteractions6 then
                    --     ShowInteractions6 = false
                    --     exports['fw-ui']:HideInteraction()
                    -- end
                    exports['fw-ui']:HideInfo('hide')
                    Citizen.Wait(1500)
                end
            end
        end
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(4)
--         if LoggedIn then
--             if InsideLab and Config.Labs[CurrentLab]['Name'] == 'Methlab' then
--                 local PlayerCoords = GetEntityCoords(PlayerPedId())
--                 local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, MethCrafting['X'], MethCrafting['Y'], MethCrafting['Z'], true)
--                 local HasItemData = {[1] = 'meth-powder', [2] = 'empty_weed_bag'}
--                 NearCraft = false
--                 if Distance < 1.2 then
--                     NearCraft = true
--                     if not ShowInteraction5 then
--                         ShowInteractions5 = true
--                         exports['fw-ui']:ShowInteraction('[E] Packing', 'primary')
--                     end
--                     if IsControlJustReleased(0, 38) then
--                         local CraftingData = {['Type'] = 'Crafting', ['InvName'] = 'Meth', ['Items'] = Config.MethCrafting}
--                         TriggerServerEvent('framework-inv:server:open:inventory:other', CraftingData, 'Crafting')
--                         exports['fw-ui']:HideInteraction()
--                     end
--                 end
--                 if not NearCraft then
--                     if ShowInteractions5 then
--                         ShowInteractions5 = false
--                         exports['fw-ui']:HideInteraction()
--                     end
--                     Citizen.Wait(1500)
--                 end
--             end
--         end
--     end
-- end)

RegisterNetEvent('framework-illegal:client:start:cooking', function()
    Cooking = true
    seconds = 1
    minutes = 5
    while Cooking do
        countTime()
        if Config.CookTimer > 0 then
            Config.CookTimer = Config.CookTimer - 1
        end
        if Config.CookTimer == 0 then
            -- local Random = math.random(1, 100)
            -- if Random <= Config.ExplosionChance then
            --     if CurrentLab ~= nil then
            --         TriggerServerEvent('framework-illegal:server:reset:meth', CurrentLab)
            --         ExplosionMethFail()
            --     end
            -- end
            exports['fw-ui']:HideInfo()
            Cooking = false
        end
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent('framework-illegal:client:sync:meth', function(ConfigData, LabId, Reset)
    Config.Labs[LabId] = ConfigData
    if Reset then
        Config.CookTimer = 250
    end
end)

-- Functions

function AddIngredient()
    if not Config.Labs[CurrentLab]['Ingredients']['meth-ingredient-1'] then
        LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
            if HasItem then
                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'meth-ingredient-1', 1, false)
                TriggerServerEvent('framework-illegal:server:add:ingredient', CurrentLab, 'meth-ingredient-1', true, 1)
            else
                LSCore.Functions.Notify('Je mist iets', 'error')
            end
        end, "meth-ingredient-1")
    elseif not Config.Labs[CurrentLab]['Ingredients']['meth-ingredient-2'] then
        LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
            if HasItem then
                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'meth-ingredient-2', 1, false)
                TriggerServerEvent('framework-illegal:server:add:ingredient', CurrentLab, 'meth-ingredient-2', true, 1)
            else
                LSCore.Functions.Notify('Je mist iets', 'error')
            end
        end, "meth-ingredient-2")
    end
end

function ExplosionMethFail()
    local Time = 3
    repeat
        Time = Time - 1
        AddExplosion(Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'], EXPLOSION_CAR, 4.0, true, false, 20.0)
        Citizen.Wait(5000)
    until Time == 0
end

function GetMeth()
    TriggerServerEvent('framework-illegal:server:get:meth', math.random(25, 30), CurrentLab)
end

function AmountMethItems()
    exports['fw-ui']:ShowInfoLong('show', '[E] Gebruiken</br> Ingredienten Nodig: '..Config.Labs[CurrentLab]['Ingredient-Count']..'/2')
end

function countTime()
    seconds = seconds - 1
    if seconds == 0 then
        seconds = 59
        minutes = minutes - 1
    end

    if minutes == -1 then
        minutes = 0
        seconds = 0
    end
end

function displayTime()
    exports['fw-ui']:ShowInfoLong('show', "Aan het koken</br> "..minutes..":"..seconds)
end