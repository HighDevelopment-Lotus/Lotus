local SeatbeltStatus, IsEjected, NewBodyHealth, NewEngineHealth = false, false, 0, 0
local CurrentVehicleHealth, CurrentBodyHealth, FrameBodyChange, FrameEngineChange = 0, 0, 0, 0
local LastFrameVehicleSpeed, SecondLastFrameVehicleSpeed, ThisFrameVehicleSpeed, Ticks = 0, 0, 0, 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if SeatbeltStatus and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                SeatbeltStatus = false
                exports['ls-ui']:SetSeatbelt(false)
            end
            if IsControlJustReleased(0, Config.Keys['G']) and IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 8 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 13 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 14 then
                    if SeatbeltStatus then
                        TriggerEvent("ls-sound:client:play", "car-unbuckle", 0.25)
                        exports['ls-ui']:SetSeatbelt(false)
                        SeatbeltStatus = false
                    else
                        TriggerEvent("ls-sound:client:play", "car-buckle", 0.25)
                        exports['ls-ui']:SetSeatbelt(true)
                        SeatbeltStatus = true
                    end
                end
            end
        else
            Citizen.Wait(450)
        end  
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        if LoggedIn then
            local PlayerPed = GetPlayerPed(-1)
            local CurrentVehicle = GetVehiclePedIsIn(PlayerPed, false)
            if CurrentVehicle ~= nil and CurrentVehicle ~= false and CurrentVehicle ~= 0 then
                SetPedHelmet(PlayerPed, false)
                LastVehicle = GetVehiclePedIsIn(PlayerPed, false)
                if GetVehicleEngineHealth(CurrentVehicle) < 0.0 then
                    SetVehicleEngineHealth(CurrentVehicle,0.0)
                end
                ThisFrameVehicleSpeed = GetEntitySpeed(CurrentVehicle) * 3.6
                CurrentBodyHealth = GetVehicleBodyHealth(CurrentVehicle)
                if CurrentBodyHealth == 1000 and FrameBodyChange ~= 0 then
                    FrameBodyChange = 0
                end
                if FrameBodyChange ~= 0 then
                    if LastFrameVehicleSpeed > math.random(185, 195) and ThisFrameVehicleSpeed < (LastFrameVehicleSpeed * 0.75) and not IsEjected then
                        if FrameBodyChange > 18.0 then
                            if not SeatbeltStatus and not IsThisModelABike(CurrentVehicle) then
                                if math.random(math.ceil(LastFrameVehicleSpeed)) > 60 then
                                    EjectFromVehicle(GetEntityVelocity(CurrentVehicle))
                                end
                            elseif (SeatbeltStatus or harnessOn) and not IsThisModelABike(CurrentVehicle) then
                                if LastFrameVehicleSpeed > 150 then
                                    if math.random(math.ceil(LastFrameVehicleSpeed)) > 150 then
                                        EjectFromVehicle(GetEntityVelocity(CurrentVehicle))                   
                                    end
                                end
                            end
                        else
                            if not SeatbeltStatus and not IsThisModelABike(CurrentVehicle) then
                                if math.random(math.ceil(LastFrameVehicleSpeed)) > 60 then
                                    EjectFromVehicle(GetEntityVelocity(CurrentVehicle))                      
                                end
                            elseif (SeatbeltStatus or harnessOn) and not IsThisModelABike(CurrentVehicle) then
                                if LastFrameVehicleSpeed > 120 then
                                    if math.random(math.ceil(LastFrameVehicleSpeed)) > 200 then
                                        EjectFromVehicle(GetEntityVelocity(CurrentVehicle))                   
                                    end
                                end
                            end
                        end
                        IsEjected = true
                        Citizen.Wait(15)
                        if LastFrameVehicleSpeed > math.random(200, 210) then
                            DoWheelDamage(CurrentVehicle)
                        end
                        SetVehicleEngineHealth(CurrentVehicle, 0)
                        SetVehicleEngineOn(CurrentVehicle, false, true, true)
                    end
                    if CurrentBodyHealth < 350.0 and not IsEjected then
                        IsEjected = true
                        Citizen.Wait(15)
                        if LastFrameVehicleSpeed > math.random(200, 210) then
                            DoWheelDamage(CurrentVehicle)
                        end
                        SetVehicleBodyHealth(CurrentVehicle, 945.0)
                        SetVehicleEngineHealth(CurrentVehicle, 0)
                        SetVehicleEngineOn(CurrentVehicle, false, true, true)
                        Citizen.Wait(1000)
                    end
                end
                if LastFrameVehicleSpeed < 100 then
                    Wait(100)
                    Ticks = 0
                end
                FrameBodyChange = NewBodyHealth - CurrentBodyHealth
                if Ticks > 0 then 
                    Ticks = Ticks - 1
                    if Ticks == 1 then
                        LastFrameVehicleSpeed = GetEntitySpeed(CurrentVehicle) * 3.6
                    end
                else
                    if IsEjected then
                        IsEjected = false
                        FrameBodyChange = 0
                        LastFrameVehicleSpeed = GetEntitySpeed(CurrentVehicle) * 3.6
                    end
                    SecondLastFrameVehicleSpeed = GetEntitySpeed(CurrentVehicle) * 3.6
                    if SecondLastFrameVehicleSpeed > LastFrameVehicleSpeed then
                        LastFrameVehicleSpeed = GetEntitySpeed(CurrentVehicle) * 3.6
                    end
                    if SecondLastFrameVehicleSpeed < LastFrameVehicleSpeed then
                        Ticks = 25
                    end
                end
                if Ticks < 0 then 
                    Ticks = 0
                end     
                NewBodyHealth = GetVehicleBodyHealth(CurrentVehicle)
            else
                if LastVehicle ~= nil then
                    SetPedHelmet(PlayerPed, true)
                    Citizen.Wait(200)
                    NewBodyHealth = GetVehicleBodyHealth(LastVehicle)
                    if not IsEjected and NewBodyHealth < CurrentBodyHealth then
                        IsEjected = true
                        SetVehicleEngineHealth(LastVehicle, 0)
                        SetVehicleEngineOn(LastVehicle, false, true, true)
                        Citizen.Wait(1000)
                    end
                    LastVehicle = nil
                end
                SecondLastFrameVehicleSpeed = 0
                LastFrameVehicleSpeed = 0
                NewBodyHealth = 0
                CurrentBodyHealth = 0
                FrameBodyChange = 0
                Citizen.Wait(2000)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Functions \\ --

function EjectFromVehicle(VehicleVelocity)
    local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),false)
    local Coords = GetOffsetFromEntityInWorldCoords(Vehicle, 1.0, 0.0, 1.0)
    local EjectSpeed = math.ceil(GetEntitySpeed(GetPlayerPed(-1)) * 8)
    SetEntityCoords(GetPlayerPed(-1), Coords)
    Citizen.Wait(1)
    SetPedToRagdoll(GetPlayerPed(-1), 5511, 5511, 0, 0, 0, 0)
    SetEntityVelocity(GetPlayerPed(-1), VehicleVelocity.x*4, VehicleVelocity.y*4, VehicleVelocity.z*4)
    SetEntityHealth( GetPlayerPed(-1), (GetEntityHealth(GetPlayerPed(-1)) - EjectSpeed))
    Citizen.SetTimeout(2500, function()
        IsEjected = false
    end)
end

function DoWheelDamage(Vehicle)
    local Wheels = {0,1,4,5}
    for i=1, math.random(4) do
        local Wheel = math.random(#Wheels)
        SetVehicleTyreBurst(Vehicle, Wheels[Wheel], true, 1000)
        table.remove(Wheels, Wheel)
    end
end