local CurrentNpc, CurrentPedsSaved, SpawnedNpc = nil, {}, false

-- // Peds \\ --
-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearNpc = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(Config.PedInteraction) do
                local Distance = #(PlayerCoords - v['Coords'])
                if Distance < 30.0 then
                    NearNpc = true
                    if not SpawnedNpc then
                        SpawnedNpc = true
                        SpawnNpcs(k)
                    end
                    if Distance < 5.0 then
                        CurrentNpc = k
                    end
                end
            end
            if not NearNpc then
                if SpawnedNpc then
                    DespawnNpcs()
                    SpawnedNpc = false
                end
                CurrentNpc = nil
                Citizen.Wait(1500)
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-interactions:client:talk:to:npc')
AddEventHandler('framework-interactions:client:talk:to:npc', function()
    local Type = Config.PedInteraction[CurrentNpc]['Type']
    Citizen.SetTimeout(150, function()
        PlayAmbientSpeech1(Config.PedInteraction[CurrentNpc]['CurrentPedNumber'], "GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL")
        if Type == 'Toolshop' or Type == 'Fisher' or Type == 'Pickaxe' or Type == 'Bajes' or Type == 'Weed' then
            TriggerEvent('framework-stores:server:open:shop')
        elseif Type == 'Rental' then
            TriggerEvent('framework-vehicles:client:open:rental')
        elseif Type == 'Electronics' then
            TriggerServerEvent('framework-illegal:server:sell:electrnoics')
        elseif Type == 'Secret-Sell' then
            TriggerServerEvent('framework-fishing:server:sell:gold-fish')
        elseif Type == 'SellWeed' then
            TriggerServerEvent('framework-illegal:server:sell:weed')
        elseif Type == 'BarsSell' then
            TriggerEvent('framework-pawnshop:client:open:selling', 'BarsItem')
        elseif Type == 'OtherSell' then
            TriggerEvent('framework-illegal:client:open:selling:other')
        elseif Type == 'WoodSell' then
            TriggerEvent('framework-pawnshop:client:open:selling', 'Wood')
        elseif Type == 'VehicleSell' then
            TriggerEvent('framework-occasions:client:openmenu')
        end
    end) 
end)

-- // Functions \\ --

function NearInteractNpc()
    if CurrentNpc ~= nil then
        return true
    end
end

function SpawnNpcs(PedNumber)
    local PedData = Config.PedInteraction[PedNumber]
    if PedData ~= nil then
        exports['fw-assets']:RequestModelHash(PedData['Model'])
        NpcPed = CreatePed(4, PedData['Model'], PedData['Coords'].x, PedData['Coords'].y, PedData['Coords'].z - 0.95, PedData['Heading'], false, false)
        FreezeEntityPosition(NpcPed, true)
        SetEntityInvincible(NpcPed, true)
        SetBlockingOfNonTemporaryEvents(NpcPed, true)
        if PedData['Animation'] ~= nil then
            TaskStartScenarioInPlace(NpcPed, PedData['Animation'], 0, true)
        end
        table.insert(CurrentPedsSaved, NpcPed)
    end
end

function DespawnNpcs()
    for k, v in pairs(CurrentPedsSaved) do
        DeleteEntity(v)
    end
end