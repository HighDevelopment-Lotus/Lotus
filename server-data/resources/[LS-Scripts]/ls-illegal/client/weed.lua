local ActivePeds, NearDealer, DealerActive = {}, false, false

-- // Threads \\ --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and DealerActive then
            NearDealer = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = #(PlayerCoords - vector3(-1165.32, -1566.925, 3.45))
            if Distance < 3.0 then
                NearDealer = true
            end
            if not NearDealer then
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ -0
RegisterNetEvent('ls-illegal:client:set:seller:data')
AddEventHandler('ls-illegal:client:set:seller:data', function(Type)
    if Type == 'Set' then
        exports['ls-assets']:RequestModelHash('A_M_M_POLYNESIAN_01')
        local NpcPed = CreatePed(4, 'A_M_M_POLYNESIAN_01', -1165.32, -1566.925, 3.45, 304.502, false, false)
        FreezeEntityPosition(NpcPed, true)
        SetEntityInvincible(NpcPed, true)
        SetBlockingOfNonTemporaryEvents(NpcPed, true)
        TaskStartScenarioInPlace(NpcPed, 'WORLD_HUMAN_SMOKING', 0, true)
        table.insert(ActivePeds, NpcPed)
        DealerActive = true
    elseif Type == 'Delete' then
        for k, v in pairs(ActivePeds) do
            DeleteEntity(v)
        end
        ActivePeds = {}
        DealerActive = false
    end
end)

-- // Functions \\ --

function NearNpc()
    return NearDealer
end