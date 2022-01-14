local LSCore = exports['ls-core']:GetCoreObject()
local NeededAttempts, SucceededAttempts, FailedAttemps = 0, 0, 0
local Table = {}

-- Events
RegisterNetEvent('ls-tables:client:process:table')
AddEventHandler('ls-tables:client:process:table', function(Type)
    if Type.eventparameter ~= nil then
        Type = Type.eventparameter
    end

    local Item = Config.Tables[Type]['ItemRequired']

    LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
        if HasItem then
            LSCore.Functions.TriggerCallback('ls-tables:server:get:item:amount', function(HasAmount)
                if HasAmount then
                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, Item, 1, false)
                    ProcessMinigame(Type)
                else
                    LSCore.Functions.Notify('Je hebt niet genoeg spullen bij je...', 'error')
                end
            end, Item, 3)
        else
            LSCore.Functions.Notify('Je hebt niet de juiste spullen bij je..', 'error')
        end
    end, Item)
end)

RegisterNetEvent('ls-tables:client:place:table')
AddEventHandler('ls-tables:client:place:table', function(Type)
    local Player = PlayerPedId()
    local PlayerCoords = GetOffsetFromEntityInWorldCoords(Player, 0.0, 2.0, -1.0)
    local Item = Config.Tables[Type]['ItemAfterProcess']
    local TableProp = Config.Tables[Type]['TableProp']

    exports['ls-assets']:RequestAnimationDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
    TaskPlayAnim(Player, 'anim@amb@business@weed@weed_inspecting_lo_med_hi@' ,'weed_crouch_checkingleaves_idle_01_inspector' ,8.0, -8.0, -1, 48, 0, false, false, false)
    LSCore.Functions.Progressbar("", "Tafel plaatsen...", math.random(5000, 10000), false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "random@mugging4",
        anim = "struggle_loop_b_thief",
        flags = 49,
    }, {}, {}, function() -- Done
        ClearPedTasks(Player)
        Table = CreateObject(GetHashKey(TableProp), PlayerCoords, true, true, true)
        LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, Item, 1, false)

    end, function()
        LSCore.Functions.Notify("Geannuleerd..", "error")
    end)
end)

RegisterNetEvent('ls-tables:client:pickup:table')
AddEventHandler('ls-tables:client:pickup:table', function()
    LSCore.Functions.Notify('De tafel is succesvol verwijderd...', 'error')
    DeleteObject(Table)
end)

-- Functions
function Process(Type)
    local Player = PlayerPedId()
    local ProgressbarTime = Config.Tables[Type]['ProcessTime']

    exports['ls-assets']:RequestAnimationDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
    TaskPlayAnim(Player, 'anim@amb@business@weed@weed_inspecting_lo_med_hi@' ,'weed_crouch_checkingleaves_idle_01_inspector' ,8.0, -8.0, -1, 48, 0, false, false, false)
    
    LSCore.Functions.Progressbar("processing-crack", "Verwerking Crack..", ProgressbarTime, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "random@mugging4",
        anim = "struggle_loop_b_thief",
        flags = 49,
    }, {}, {}, function() -- Done
        ClearPedTasks(Player)
        LSCore.Functions.TriggerCallback('ls-tables:server:finish', function() end)

    end, function()
        LSCore.Functions.Notify("Geannuleerd..", "error")
    end)
end


function ProcessMinigame(Type)
    local Skillbar = exports['ls-skillbar']:GetSkillbarObject()
    local Data = Data

    if NeededAttempts == 0 then
        NeededAttempts = math.random(1, 3)
    end
    local maxwidth = 30
    local maxduration = 3500
    Skillbar.Start({
        duration = math.random(2000, 3000),
        pos = math.random(10, 30),
        width = math.random(20, 30),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            Process(Type)
            LSCore.Functions.Notify('Je hebt wat '..Type..'!', "primary")
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(2000, 3000),
                pos = math.random(10, 30),
                width = math.random(20, 30),
            })
        end    
    end, function()
        LSCore.Functions.Notify("Nou... Je hebt het proces verknoeid!", "error")
        FailedAttemps = 0
        SucceededAttempts = 0
        NeededAttempts = 0
    end)
end