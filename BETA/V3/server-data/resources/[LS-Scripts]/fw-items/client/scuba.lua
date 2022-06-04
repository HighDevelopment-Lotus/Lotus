local MaskModel = GetHashKey("p_d_scuba_mask_s")
local TankModel = GetHashKey("p_s_scuba_tank_s")
local ScubaProps = {}
local HasScubaOn = false
local CurrentAir = nil

LoggedIn = true

RegisterNetEvent('framework-items:client:put:scuba:on')
AddEventHandler('framework-items:client:put:scuba:on', function(AirAmount)
    if not HasScubaOn and AirAmount > 10 then
        if not exports['fw-progressbar']:GetTaskBarStatus() then
            if not DoingSomething then
                DoingSomething = true
                TriggerEvent('framework-inv:client:set:inventory:state', false)
                LSCore.Functions.Progressbar("equip_gear", "Duikpak aantrekken..", 5000, false, true, {}, {}, {}, {}, function() -- Done
                    CurrentAir = AirAmount
                    HasScubaOn = true
                    exports['fw-assets']:RequestModelHash(TankModel)
                    exports['fw-assets']:RequestModelHash(MaskModel)
                    local TankObject = CreateObject(TankModel, 1.0, 1.0, 1.0, 1, 1, 0)
                    AttachEntityToEntity(TankObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24818), -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
                    table.insert(ScubaProps, TankObject)
                    local MaskObject = CreateObject(MaskModel, 1.0, 1.0, 1.0, 1, 1, 0)
                    AttachEntityToEntity(MaskObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 12844), 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
                    table.insert(ScubaProps, MaskObject)
                    SetPedDiesInWater(PlayerPedId(), false)
                    SetEnableScuba(PlayerPedId(), true)
                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'scuba-gear', 1, false)
                    TriggerEvent('framework-inv:client:set:inventory:state', true)
                    LSCore.Functions.Notify("Doe /duikpakuit om je duikpak uit tte doen", "error")
                    DoingSomething = false
                end)
            end
        end
    else
        LSCore.Functions.Notify("Actie niet mogelijk..", "error")
    end
end)

RegisterNetEvent('framework-items:client:takeoff:scuba')
AddEventHandler('framework-items:client:takeoff:scuba', function()
    if HasScubaOn then
        LSCore.Functions.Progressbar("remove_gear", "Duikpak uittrekken..", 5000, false, true, {}, {}, {}, {}, function() -- Done
            for k, v in pairs(ScubaProps) do
                NetworkRequestControlOfEntity(v)
                SetEntityAsMissionEntity(v, true, true)
                DetachEntity(v, 1, 1)
                DeleteEntity(v)
                DeleteObject(v)
            end
            SetPedDiesInWater(PlayerPedId(), true)
            SetEnableScuba(PlayerPedId(), false)
            TriggerServerEvent('framework-items:server:resturn:scuba', CurrentAir)
            CurrentAir, HasScubaOn = nil, false
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if HasScubaOn then
                if CurrentAir > 10 then
                    CurrentAir = CurrentAir - 10
                    Citizen.Wait(30000)
                    if HasScubaOn then
                        if CurrentAir < 10 then
                            SetPedDiesInWater(PlayerPedId(), true)
                            SetEnableScuba(PlayerPedId(), false)
                            LSCore.Functions.Notify("Je lucht tank is leeg je verdrinkt..", "error")
                        end
                    end
                end
            end
        else
            Citizen.Wait(1500)
        end
    end
end)