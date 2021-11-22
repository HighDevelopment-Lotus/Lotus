
LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false
local JailTime, InJail, ShowingInteraction = 0, false, false

RegisterNetEvent("LSCore:Client:OnPlayerLoaded")
AddEventHandler("LSCore:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(1250, function()
        LoggedIn = true
    end) 
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    InJail, JailTime = false, 0
    LoggedIn = false
end)

TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end) 
LoggedIn = true

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if LoggedIn then
            if InJail then
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Prison"]['Coords']['X'], Config.Locations["Prison"]['Coords']['Y'], Config.Locations["Prison"]['Coords']['Z'], false) > 220.0 and InJail) then
                    JailTime, InJail = 0, false
                    TriggerServerEvent("ls-prison:server:set:jail:leave")
                    TriggerServerEvent('ls-prison:server:set:alarm', true)
                    TriggerServerEvent("LSCore:Server:SetMetaData", "jailitems", nil)
                    TriggerServerEvent('ls-police:server:alert:prison', GetEntityCoords(GetPlayerPed(-1)))
                    LSCore.Functions.Notify("Je bent de gevangenis ontsnapt.. Maak dat je weg komt!", "error")
                else
                    Citizen.Wait(5000)
                end
            else
                Citizen.Wait(5000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if InJail then
                InRange = false
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                for k, v in pairs(Config.Locations['Search']) do
                    local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                    if Distance < 2.5 then 
                        InRange = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['ls-ui']:ShowInteraction('[E] ??', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            SearchPlace(v['Reward'], v['Chance'])
                        end
                    end
                end
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Shop']['Coords']['X'], Config.Locations['Shop']['Coords']['Y'], Config.Locations['Shop']['Coords']['Z'], true)
                if Distance < 2.5 then
                    InRange = true
                    if not ShowingInteraction then
                        ShowingInteraction = true
                        exports['ls-ui']:ShowInteraction('[E] Winkel van sinkel', 'primary')
                    end
                    if IsControlJustReleased(0, 38) then
                         if exports['ls-inventory-new']:CanOpenInventory() then
                            local Shop = {['Type'] = 'Store', ['InvName'] = 'Winkel van sinkel', ['Items'] = Config.Items}
                            TriggerServerEvent('ls-inventory-new:server:open:inventory:other', Shop, 'Store')
                         end
                    end
                end
                if not InRange then
                    if ShowingInteraction then
                        ShowingInteraction = false
                        exports['ls-ui']:HideInteraction()
                    end
                    Citizen.Wait(450)
                end
            else
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-prison:client:spawn:prison')
AddEventHandler('ls-prison:client:spawn:prison', function()
    Citizen.SetTimeout(550, function()
        LSCore.Functions.GetPlayerData(function(PlayerData)
            local RandomStartPosition = Config.Locations['Spawns'][math.random(1, #Config.Locations['Spawns'])]
            TriggerEvent('ls-sound:client:play', 'jail-door', 0.5)
            Citizen.Wait(450)
            SetEntityCoords(GetPlayerPed(-1), RandomStartPosition['Coords']['X'], RandomStartPosition['Coords']['Y'], RandomStartPosition['Coords']['Z'] - 0.9, 0, 0, 0, false)
            SetEntityHeading(GetPlayerPed(-1), RandomStartPosition['Coords']['H'])
            Citizen.Wait(1000)
            TriggerEvent('animations:client:EmoteCommandStart', {RandomStartPosition['Animation']})
            Citizen.Wait(2000)
            InJail = true
            JailTime = PlayerData.metadata["jailtime"]
            LSCore.Functions.Notify("Je zit in de gevangenis voor "..JailTime.." maand(en)..", "error", 6500)
            DoScreenFadeIn(1000)
        end)
    end)
end)

RegisterNetEvent('ls-prison:client:enter:prison')
AddEventHandler('ls-prison:client:enter:prison', function(Time, bool)
    JailTime, InJail = Time, bool
end)

RegisterNetEvent('ls-prison::client:set:time')
AddEventHandler('ls-prison::client:set:time', function(Time)
    JailTime = Time
end)

RegisterNetEvent('ls-prison:client:set:alarm')
AddEventHandler('ls-prison:client:set:alarm', function(bool)
    if bool then
        while not PrepareAlarm("PRISON_ALARMS") do
            Citizen.Wait(10)
        end
        StartAlarm("PRISON_ALARMS", true)
        Citizen.Wait(60 * 1000)
        StopAllAlarms(true)
    else
        StopAllAlarms(true)
    end
end)

RegisterNetEvent('ls-prison:client:leave:prison')
AddEventHandler('ls-prison:client:leave:prison', function()
    local RandomSeat = Config.Locations['Leave-Spawn'][math.random(1, #Config.Locations['Leave-Spawn'])]
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    TriggerEvent('ls-sound:client:play', 'jail-cell', 0.2)
    SetEntityCoords(GetPlayerPed(-1), RandomSeat['Coords']['X'], RandomSeat['Coords']['Y'], RandomSeat['Coords']['Z'] - 0.9, 0, 0, 0, false)
    SetEntityHeading(GetPlayerPed(-1), RandomSeat['Coords']['H'])
    Citizen.Wait(250)
    TriggerEvent('animations:client:EmoteCommandStart', {RandomSeat['Animation']})
    Citizen.Wait(2000)
    DoScreenFadeIn(1000)
end)

RegisterNetEvent('ls-prison:client:check:time')
AddEventHandler('ls-prison:client:check:time', function()
    if InJail then
        if JailTime <= 0 then
            JailTime, InJail = 0, false
            TriggerServerEvent("ls-prison:server:get:items:back")
            TriggerServerEvent("ls-prison:server:set:jail:leave")
            TriggerEvent('ls-prison:client:leave:prison')
            LSCore.Functions.Notify("Je bent vrij!", "success")
        else
            LSCore.Functions.Notify("Je moet nog "..JailTime.." maand(en) zitten.", "error")
        end
    else
        LSCore.Functions.Notify("Je zit niet in de gevangenis..", "error")
    end
end)

RegisterNetEvent('ls-prison:client:remove:some:time')
AddEventHandler('ls-prison:client:remove:some:time', function(RemoveTime)
    if JailTime - RemoveTime <= 0 then
        JailTime = 0
        LSCore.Functions.Notify("Je bent vrij joh!", "error")
    elseif JailTime - RemoveTime > 0 then  
        JailTime = JailTime - RemoveTime
        LSCore.Functions.Notify("Je moet nog "..JailTime.." maand(en) zitten.", "error")
    end
    LSCore.Functions.Notify("Sow dat was me een roleplay zeg..", "success")
end)

-- // Functions \\ --

function SearchPlace(Reward, Chance)
    local Label = 'Zoeken..'
    if Reward == 'slushy' then
      Label = 'Slushy maken..'
    end
    LSCore.Functions.Progressbar("search-jail", Label, math.random(5000, 6500), false, true, {
        disableMovement = false,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        if math.random(1,100) < Chance then
            -- GiveItem Reward
            TriggerServerEvent('ls-prison:server:find:reward', Reward)
            LSCore.Functions.Notify("WOW Thats hot!", "success")
        else
            LSCore.Functions.Notify("Helemaal niks..", "error") 
        end
    end, function() -- Cancel
        LSCore.Functions.Notify("Geannuleerd..", "error") 
    end)
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

function GetInJailStatus()
    return InJail
end