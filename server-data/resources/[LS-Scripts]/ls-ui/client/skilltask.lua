local DoingTask = false

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if DoingTask then
                DisableAllControlActions(0)
            else
                Citizen.Wait(450)
            end
        end
    end
end)

-- // Functions \\ --

function ForceStopSkill()
    Config.DoingSkill = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({action = 'ForceStopSkill'})
    TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
end

function StartSkillTest(NeededStreak, Speed, Callback)
    if not Config.DoingSkill then
        Config.DoingSkill = true
        Citizen.SetTimeout(150, function()
            local NeededStreak = NeededStreak ~= nil and NeededStreak or 3 
            local Speed = Speed ~= nil and Speed or 'Normal'
            Citizen.SetTimeout(350, function()
                ReturnCallback = Callback
                SetNuiFocus(true, false)
                SetNuiFocusKeepInput(true)
                SendNUIMessage({action = "StartSkill", streak = NeededStreak, speed = Speed})
                TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
            end)
        end)
    end
end

RegisterNUICallback('FailedTask', function()
    SetNuiFocus(false, false)
    ReturnCallback(false)
    SetNuiFocusKeepInput(false)
    Config.DoingSkill = false
    Citizen.SetTimeout(450, function()
        TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
    end)
end)
  
RegisterNUICallback('SuccessTask', function()
    SetNuiFocus(false, false)
    ReturnCallback(true)
    SetNuiFocusKeepInput(false)
    Config.DoingSkill = false
    Citizen.SetTimeout(450, function()
        TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
    end)
end)