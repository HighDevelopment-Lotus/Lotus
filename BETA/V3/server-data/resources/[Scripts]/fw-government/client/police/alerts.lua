RegisterNetEvent('framework-police:client:send:officer:down')
AddEventHandler('framework-police:client:send:officer:down', function(Coords, StreetName, Info, Priority)
    local Title, Callsign, Type = 'Agent neer', '10-13B', 'Red'
    if Priority == 3 then
        Title, Callsign, Type = 'Agent neer (Urgent)', '10-13A', 'Danger'
    end
    local Data = {['Title'] = Title, ['Code'] = Callsign, ['Type'] = Type, ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-id-badge"></i> '..Info['Callsign']..' | '..Info['Firstname'].. ' ' ..Info['Lastname']..'<br><i class="fas fa-globe-europe"></i> '..StreetName}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert(Title, 306, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:alert:panic:button')
AddEventHandler('framework-police:client:send:alert:panic:button', function(Coords, StreetName, Info)
    local Data = {['Title'] = "Noodknop", ['Code'] = '10-13C', ['Type'] = 'Danger', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-id-badge"></i> '..Info['Callsign']..' | '..Info['Firstname'].. ' ' ..Info['Lastname']..'<br><i class="fas fa-globe-europe"></i> '..StreetName}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert('Noodknop', 487, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:alert:gunshots')
AddEventHandler('framework-police:client:send:alert:gunshots', function(Coords, GunType, StreetName, InVeh)
    local AlertMessage, CallSign = 'Schoten gelost', '10-47A'
    if InVeh then
        AlertMessage, CallSign = 'Schoten gelost uit voertuig', '10-47B'
    end
    local Data = {['Title'] = AlertMessage, ['Code'] = CallSign, ['Type'] = 'Almost', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="far fa-arrow-alt-circle-right"></i> '..GunType..'<br><i class="fas fa-globe-europe"></i> '..StreetName}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert(AlertMessage, 313, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:alert:dead')
AddEventHandler('framework-police:client:send:alert:dead', function(Coords, StreetName)
    local Data = {['Title'] = "Gewonde Burger", ['Code'] = '10-30B', ['Type'] = 'Almost', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> '..StreetName}
    exports['fw-alerts']:SendAlert(Data, true)
    AddAlert('Gewonde Burger', 480, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:bank:alert')
AddEventHandler('framework-police:client:send:bank:alert', function(Coords, StreetName, Name)
    local Data = {['Title'] = Name..' Alarm', ['Code'] = '10-42A', ['Type'] = 'Almost', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> '..StreetName}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert(Name, 108, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:alert:jewellery')
AddEventHandler('framework-police:client:send:alert:jewellery', function(Coords, StreetName)
    local Data = {['Title'] = "Juwelier Alarm", ['Code'] = '10-42C', ['Type'] = 'Almost', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> '..StreetName}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert('Vangelico Juwelier', 617, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:alert:store')
AddEventHandler('framework-police:client:send:alert:store', function(Coords, StreetName, StoreNumber)
    local Data = {['Title'] = "Winkel Alarm", ['Code'] = '10-98A', ['Type'] = 'Blue', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> '..StreetName..'<br><i class="fas fa-camera"></i> '..StoreNumber}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert('Winkel Alarm', 59, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:house:alert')
AddEventHandler('framework-police:client:send:house:alert', function(Coords, StreetName)
    local Data = {['Title'] = "Huis Alarm", ['Code'] = '10-63B', ['Type'] = 'Blue', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> '..StreetName}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert('Huis Alarm', 40, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:banktruck:alert')
AddEventHandler('framework-police:client:send:banktruck:alert', function(Coords, Plate, StreetName)
    local Data = {['Title'] = "Bank Truck Alarm", ['Code'] = '10-03A', ['Type'] = 'Almost', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> '..StreetName}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert('Bank Truck Alarm', 67, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:explosion:alert')
AddEventHandler('framework-police:client:send:explosion:alert', function(Coords, StreetName)
    local Data = {['Title'] = "Explosie", ['Code'] = '10-02C', ['Type'] = 'Red', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> '..StreetName}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert('Explosie', 630, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:humanelabs:alert')
AddEventHandler('framework-police:client:send:humanelabs:alert', function(Coords, StreetName)
    local Data = {['Title'] = "Humanelabs Alarm", ['Code'] = '10-92B', ['Type'] = 'Almost', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> '..StreetName}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert('Humanelabs Alarm', 499, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:bobcat:alert')
AddEventHandler('framework-police:client:send:bobcat:alert', function(Coords, StreetName)
    local Data = {['Title'] = "Bobcat Security Alarm", ['Code'] = '10-84A', ['Type'] = 'Almost', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> '..StreetName}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert('Bobcat Security Alarm', 106, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:prison:alert')
AddEventHandler('framework-police:client:send:prison:alert', function(Coords)
    local Data = {['Title'] = "Gevangenis Alarm", ['Code'] = '10-01C', ['Type'] = 'Almost', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = ''}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert('Gevangenis Alarm', 188, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:illegal:hunting:alert')
AddEventHandler('framework-police:client:send:illegal:hunting:alert', function(Coords)
    local Data = {['Title'] = "Illegaal Jagen", ['Code'] = '10-57A', ['Type'] = 'Red', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> Mount. Chiliad'}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert('Illegaal Jagen', 141, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:cornerselling:alert')
AddEventHandler('framework-police:client:send:cornerselling:alert', function(Coords, Street)
    local Data = {['Title'] = "Verdachte Situatie", ['Code'] = '10-18A', ['Type'] = 'Red', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> '..Street}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert('Verdachte Situatie', 514, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:weedbrick:alert')
AddEventHandler('framework-police:client:send:weedbrick:alert', function(Coords, Street)
    local Data = {['Title'] = "Verdachte Situatie", ['Code'] = '10-18A', ['Type'] = 'Red', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> '..Street}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert('Verdachte Situatie', 514, 250, Coords, false, true)
end)

RegisterNetEvent('framework-police:client:send:oxy:alert')
AddEventHandler('framework-police:client:send:oxy:alert', function(Coords, Street)
    local Data = {['Title'] = "Verdachte Situatie", ['Code'] = '10-18A', ['Type'] = 'Red', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> '..Street}
    exports['fw-alerts']:SendAlert(Data, false)
    AddAlert('Verdachte Situatie', 514, 250, Coords, false, true)
end)
RegisterNetEvent('framework-police:client:send:call:alert')
AddEventHandler('framework-police:client:send:call:alert', function(Coords, Name, Message)
    local Data = {['Title'] = "112 Melding", ['Code'] = '10-43A', ['Type'] = 'Blue', ['Coords'] = Coords, ['AlertId'] = math.random(111111,999999), ['Desc'] = '<i class="fas fa-globe-europe"></i> '..Name..'<br><i class="fas fa-comment"></i> '..Message}
    exports['fw-alerts']:SendAlert(Data, true)
    AddAlert('112', 66, 250, Coords)
end)

RegisterNetEvent('framework-police:client:send:tracker:alert')
AddEventHandler('framework-police:client:send:tracker:alert', function(Coords, Name)
    AddAlert('Enkelband Locatie: '..Name, 480, 250, Coords, true, true)
end)

-- // Funtions \\ --

function AddAlert(Text, Sprite, Transition, Coords, Tracker, Flashing)
    if Text == '112' or Text == 'Gewonde Burger' then
        if (LSCore.Functions.GetPlayerData().job.name == "police" or LSCore.Functions.GetPlayerData().job.name == "ambulance") and LSCore.Functions.GetPlayerData().job.onduty then
            local Transition = Transition
            local Blips = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
            SetBlipSprite(Blips, Sprite)
            SetBlipColour(Blips, 6)
            SetBlipDisplay(Blips, 4)
            SetBlipAlpha(Blips, transG)
            SetBlipScale(Blips, 1.0)
            SetBlipAsShortRange(Blips, false)
            if Flashing then
               SetBlipFlashes(Blips, true)
            end
            BeginTextCommandSetBlipName('STRING')
            if not Tracker then
               AddTextComponentString('Melding: '..Text)
            else
               AddTextComponentString(Text)
            end
            EndTextCommandSetBlipName(Blips)
            while Transition ~= 0 do
                Wait(180 * 4)
                Transition = Transition - 1
                SetBlipAlpha(Blips, Transition)
                if Transition == 0 then
                    SetBlipSprite(Blips, 2)
                    RemoveBlip(Blips)
                    return
                end
            end
        end
    else
        if (LSCore.Functions.GetPlayerData().job.name == "police") and LSCore.Functions.GetPlayerData().job.onduty then
            local Transition = Transition
            local Blips = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
            SetBlipSprite(Blips, Sprite)
            SetBlipColour(Blips, 6)
            SetBlipDisplay(Blips, 4)
            SetBlipAlpha(Blips, transG)
            SetBlipScale(Blips, 1.0)
            SetBlipAsShortRange(Blips, false)
            if Flashing then
               SetBlipFlashes(Blips, true)
            end
            BeginTextCommandSetBlipName('STRING')
            if not Tracker then
               AddTextComponentString('Melding: '..Text)
            else
               AddTextComponentString(Text)
            end
            EndTextCommandSetBlipName(Blips)
            while Transition ~= 0 do
                Wait(180 * 4)
                Transition = Transition - 1
                SetBlipAlpha(Blips, Transition)
                if Transition == 0 then
                    SetBlipSprite(Blips, 2)
                    RemoveBlip(Blips)
                    return
                end
            end
        end
    end
end