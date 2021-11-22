local LSCore, LoggedIn, Dancing = exports['ls-core']:GetCoreObject(), false, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(450, function()   
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
            if Dancing then
                if IsControlJustReleased(0, 73) then
                    TriggerEvent('ls-dances:client:clear:dance')
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

RegisterNetEvent('ls-dances:client:clear:dance')
AddEventHandler('ls-dances:client:clear:dance', function()
    ClearPedTasks(PlayerPedId())
    Dancing = false
end)

RegisterNetEvent('ls-dances:client:dance')
AddEventHandler('ls-dances:client:dance', function(DanceNumber)
    local TotalAnims = #Config.Dances
    if DanceNumber == -1 then
        DanceNumber = math.random(TotalAnims)
        print('Random Dance neef', DanceNumber)
    end
    if DanceNumber > TotalAnims or DanceNumber <= 0 then return end
    if not Config.Dances[DanceNumber]['Disabled'] then
        Dancing = true
        exports['ls-assets']:RequestAnimationDict(Config.Dances[DanceNumber]['Dict'])
        TaskPlayAnim(PlayerPedId(), Config.Dances[DanceNumber]['Dict'], Config.Dances[DanceNumber]['Anim'], 3.0, 3.0, -1, 1, 0, 0, 0, 0)
    end
end)
