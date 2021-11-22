RegisterNetEvent('ls-materials:client:search:trash')
AddEventHandler('ls-materials:client:search:trash', function(Nothing, Entity)
    if not Config.OpenedBins[Entity['Entity']] then
        LSCore.Functions.Progressbar("search-trash", "Graaien..", math.random(10000, 12500), false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'mini@repair',
            anim = 'fixing_a_ped',
            flags = 16,
        }, {}, {}, function() -- Done
            SetBinUsed(Entity['Entity'])
            TriggerServerEvent('ls-materials:server:get:reward')
            StopAnimTask(GetPlayerPed(-1), 'mini@repair', "fixing_a_ped", 1.0)
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), 'mini@repair', "fixing_a_ped", 1.0)
            LSCore.Functions.Notify("Mislukt!", "error")
        end)
    else
        LSCore.Functions.Notify("Je hebt hier al gegraait..", "error")
    end
end)

function SetBinUsed(BinNumber)
    Config.OpenedBins[BinNumber] = true
    Citizen.SetTimeout(50000, function()
        Config.OpenedBins[BinNumber] = false
    end)
end