local InRange, AddedProps, SmeltingProps = false, false, {}
-- LSCore, LoggedIn = exports['fw-base']:GetCoreObject(), false

-- RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
-- AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
--     Citizen.SetTimeout(750, function()
--         LoggedIn = true
--     end)
-- end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    if InRange and AddedProps then
        AddedProps = false
        DespawnSmeltingProps()
    end
    LoggedIn = false
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end) 
--         Citizen.Wait(150)   
--         LoggedIn = true
--     end)
-- end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - vector3(1088.03, -2001.82, 30.88))
            if Distance < 1.5 then
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['fw-ui']:ShowInteraction('[<i class="far fa-eye"></i>] Smelter', 'primary')
                end
            else
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['fw-ui']:HideInteraction()
                end
                Citizen.Wait(450)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Interior = GetInteriorAtCoords(PlayerCoords)
            if Interior == 250625 then
                InRange = true
                if not AddedProps then
                    AddedProps = true
                    SpawnSmeltingProps()
                end
            else
                InRange = false
                if AddedProps then
                    AddedProps = false
                    DespawnSmeltingProps()
                end
            end
            Citizen.Wait(400)
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Functions \\ --

function SpawnSmeltingProps()
    for k, v in pairs(Config.SmeltingProps) do
        exports['fw-assets']:RequestModelHash(v['Prop'])
        local WorkObject = CreateObject(GetHashKey(v['Prop']), v["Coords"].x, v["Coords"].y, v["Coords"].z, false, true, false)
        SetEntityHeading(WorkObject, v['Coords'].w)
        SetEntityVisible(WorkObject, false)
        FreezeEntityPosition(WorkObject, true)
        SetEntityInvincible(WorkObject, true)
        table.insert(SmeltingProps, WorkObject)
    end
end

function DespawnSmeltingProps()
    for k, v in pairs(SmeltingProps) do
        NetworkRequestControlOfEntity(v)
        DeleteEntity(v)
    end
end

function NearSmelter()
    return InRange
end