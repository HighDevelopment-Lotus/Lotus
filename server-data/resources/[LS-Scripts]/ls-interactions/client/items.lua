local HasItem, AddedProp = false, false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            LSCore.Functions.TriggerCallback('ls-interactions:server:has:robbery:item', function(HoldItem)
                if HoldItem then
                    if not AddedProp then
                        AddedProp = true
                        AddPropToHands(HoldItem)
                    end
                else
                    if AddedProp then
                        AddedProp = false
                        RemovePropFromHands()
                    end
                end
            end)
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if AddedProp then
                DisableControlAction(0, 21, true)
                DisableControlAction(0, 22, true)
                DisableControlAction(0, 23, true)
                DisableControlAction(0, 75, true)
                DisableControlAction(27, 23, true)
                DisableControlAction(27, 22, true)
                DisableControlAction(27, 75, true)
            else
                Citizen.Wait(100)
            end
        end
    end
end)

-- // Functions \\ --

function AddPropToHands(PropName)
    HasItem = true
    exports['ls-assets']:AddProp(PropName)
    if PropName ~= 'Duffel' then
        while HasItem do
            Citizen.Wait(4)
            if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
                exports['ls-assets']:RequestAnimationDict("anim@heists@box_carry@")
                TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
            else
                Citizen.Wait(100)
            end
        end
    end
end

function RemovePropFromHands()
    HasItem = false
    exports['ls-assets']:RemoveProp()
    StopAnimTask(GetPlayerPed(-1), 'anim@heists@narcotics@trash', 'drop_side', 1.0)
    StopAnimTask(GetPlayerPed(-1), 'anim@heists@box_carry@', 'idle', 1.0)
end