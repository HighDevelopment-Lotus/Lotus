LSCore = exports["fw-base"]:GetCoreObject()
Config = {}
local OwnedLockerBlips = {}
local currentLocker, lockerName

-- RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    TriggerEvent('framework-storagelockers:client:FetchConfig')
    TriggerEvent('framework-storagelockers:client:setupBlips')
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    for k, v in pairs(OwnedLockerBlips) do
        RemoveBlip(v)
    end
end)

RegisterNetEvent('framework-storagelockers:client:FetchConfig')
AddEventHandler('framework-storagelockers:client:FetchConfig', function()
    LSCore.Functions.TriggerCallback("framework-storagelockers:server:FetchConfig", function(lockers)
        Config.Lockers = lockers
    end)
end)

RegisterNetEvent('framework-storagelockers:client:setupBlips')
AddEventHandler('framework-storagelockers:client:setupBlips', function()
    for k, v in pairs(OwnedLockerBlips) do
        RemoveBlip(v)
    end
    LSCore.Functions.TriggerCallback('framework-storagelockers:server:getOwnedLockers', function(ownedLockers)
        if ownedLockers ~= nil then
            for k, v in pairs(ownedLockers) do
                local locker = Config.Lockers[v]['coords']
                local lockerBlip = AddBlipForCoord(locker.x, locker.y, locker.z)
                SetBlipSprite (lockerBlip, 50)
                SetBlipDisplay(lockerBlip, 4)
                SetBlipScale  (lockerBlip, 0.65)
                SetBlipAsShortRange(lockerBlip, true)
                SetBlipColour(lockerBlip, 3)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName("Storage Locker")
                EndTextCommandSetBlipName(lockerBlip)
                table.insert(OwnedLockerBlips, lockerBlip)
            end
        end
    end)
end)

Citizen.CreateThread(function() 
    while true do
        sleep = 1000
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            if Config.Lockers ~= nil then
                for k, v in pairs(Config.Lockers) do
                    local dist = #(pos - vector3(v["coords"].x, v["coords"].y, v["coords"].z))
                    if dist < 1.5 then
                        currentLocker = v
                        lockerName = k
                        sleep = 5
                        DrawText3D(v["coords"].x, v["coords"].y, v["coords"].z, "~g~E~w~ - Open Locker")
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("framework-storagelockers:client:interact", k, v)
                        end
                    end
                end
            end
    Wait(sleep)
    end
end)

RegisterNetEvent("framework-storagelockers:client:interact")
AddEventHandler("framework-storagelockers:client:interact", function(k, v)
    local lockername = k
    local lockertable = v
    local citizenid = LSCore.Functions.GetPlayerData().citizenid
    PlayerJob = LSCore.Functions.GetPlayerData().job

    if not lockertable["isOwned"] then 
    local MenuItems = {  
        [1] = {['Title'] = 'Kopen', ['Desc'] = 'Koop opslag voor € ' .. v.price, ['Data'] = { ['Event'] = 'framework-storagelockers:client:purchase', ['Type'] = 'Client', ['args'] = '1'} }, 
    }
    local Data = {['Title'] = 'Locker '..lockername, ['MainMenuItems'] = MenuItems}
        
    LSCore.Functions.OpenMenu(Data)
    elseif lockertable["isOwned"] then
    local MenuItems = {
        [1] = {['Title'] = 'Open Locker', ['Desc'] = 'Open Locker', ['Data'] = { ['Event'] = 'framework-storagelockers:client:openLocker', ['Type'] = 'Client', ['args'] = '1'} }, 
    }
    local Data = {['Title'] = 'Locker '..lockername, ['MainMenuItems'] = MenuItems}
        
    LSCore.Functions.OpenMenu(Data)
    end

    if lockertable["owner"] == citizenid then
    local MenuItems = {
        [1] = {['Title'] = 'Open Locker', ['Desc'] = 'Bekijk wat er in zit', ['Data'] = { ['Event'] = 'framework-storagelockers:client:openLocker', ['Type'] = 'Client', ['args'] = '1'} }, 
        [2] = {['Title'] = 'Verander Wachtwoord', ['Desc'] = 'Wachtwoord gelekt? verander hem snel!', ['Data'] = { ['Event'] = 'framework-activities:server:TrimWeed', ['Type'] = 'Server', ['args'] = '2'} }, 
    }
    local Data = {['Title'] = 'Locker '..lockername, ['MainMenuItems'] = MenuItems}
        
    LSCore.Functions.OpenMenu(Data)
    end
end)

RegisterNetEvent('framework-storagelockers:client:sellLocker')
AddEventHandler('framework-storagelockers:client:sellLocker', function(data)
    TriggerServerEvent('framework-storagelockers:server:sellLocker', data.lockername, data.lockertable)
end)

RegisterNetEvent('framework-storagelockers:client:changePasscode')
AddEventHandler('framework-storagelockers:client:changePasscode', function()
    SendNUIMessage({
        type = "changePasscode",
        action = "openKeypad",
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('framework-storagelockers:client:raidLocker')
AddEventHandler('framework-storagelockers:client:raidLocker', function(data)
    LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
        if HasItem then
            --add progressbar/animation
            if exports['fw-inv']:CanOpenInventory() then
                TriggerServerEvent('framework-inv:server:open:inventory:other', data.lockername, 'Stash', currentLocker.slots, currentLocker.capacity)
            end
        else
            LSCore.Functions.Notify("Je hebt geen stormram bij je..", "error")
        end
    end, 'police_stormram' )
end)

RegisterNetEvent('framework-storagelockers:client:purchase') --trigger event after nh-context purchase button. Set password which then starts the buying process
AddEventHandler('framework-storagelockers:client:purchase', function()
    --add the money check here instead
    LSCore.Functions.Notify("Please set a password")
    SendNUIMessage({
        type = "create",
        action = "openKeypad",
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('framework-storagelockers:client:openLocker') --trigger event after nh-context open locker button. Opens the password UI for the locker
AddEventHandler('framework-storagelockers:client:openLocker', function()
    SendNUIMessage({
        type = "attempt",
        action = "openKeypad",
    })
    SetNuiFocus(true, true)
end)

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
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end 

RegisterNUICallback('PadLockClose', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback("CombinationSound", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('UseCombination', function(data, cb)
    if data.type == 'attempt' then
        LSCore.Functions.TriggerCallback('framework-storagelockers:server:getData', function(combination)
            if tonumber(data.combination) ~= nil then
                if tonumber(data.combination) == tonumber(combination) then
                    SetNuiFocus(false, false)
                    SendNUIMessage({
                        action = "closeKeypad",
                        error = false,
                    })
                    -- TriggerServerEvent("framework-inventory:server:OpenInventory", "stash", lockerName, {
                    -- maxweight = currentLocker.capacity,
                    -- slots = currentLocker.slots,
                    -- })
                    -- TriggerEvent("framework-inventory:client:SetCurrentStash", lockerName)  
                    
            if exports['fw-inv']:CanOpenInventory() then
                TriggerServerEvent('framework-inv:server:open:inventory:other', lockerName, 'Stash', currentLocker.slots, currentLocker.capacity)
            end 
                    --takeAnim()
                else
                    LSCore.Functions.Notify("Verkeerd wachtwoord!", 'error')
                    SetNuiFocus(false, false)
                    SendNUIMessage({
                        action = "closeKeypad",
                        error = true,
                    })
                end
            end        
        end, lockerName, 'password') 
    elseif data.type == 'create' then
        SendNUIMessage({
            action = "closeKeypad",
            error = false,
        })
        if data.combination ~= nil then
            LSCore.Functions.TriggerCallback('framework-storagelockers:server:purchaselocker', function(bankmoney)
                if bankmoney >= currentLocker.price then
                    TriggerServerEvent("framework-storagelockers:server:createPassword", data.combination, lockerName)
                    TriggerEvent('framework-storagelockers:client:FetchConfig')
                    LSCore.Functions.Notify("You have purchased this locker","success")
                end
            end, currentLocker, lockerName)
        end
    elseif data.type == 'changePasscode' then
        SendNUIMessage({
            action = "closeKeypad",
            error = false,
        })
        if data.combination ~= nil then
            TriggerServerEvent("framework-storagelockers:server:changePasscode", data.combination, lockerName, currentLocker)
        end
    end
end)