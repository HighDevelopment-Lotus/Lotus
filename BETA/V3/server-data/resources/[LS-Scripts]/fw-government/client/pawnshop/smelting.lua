-- // Events \\ --

RegisterNetEvent('framework-pawnshop:client:smelter:inventory')
AddEventHandler('framework-pawnshop:client:smelter:inventory', function()
	local ClosestPlayer, Distance = LSCore.Functions.GetClosestPlayer()
	if ClosestPlayer ~= -1 and Distance < 4.0 then
		LSCore.Functions.Notify('Er staat iemand anders te dicht bij joh..', 'error')
	else
        LSCore.Functions.TriggerCallback('framework-pawnshop:server:is:smelting', function(IsSmelting)
            if not IsSmelting then
                if exports['fw-inv']:CanOpenInventory() then
                    TriggerServerEvent('framework-inv:server:open:inventory:other', "Smelter", 'TempStashes', 5, 1000000)
                end
            else
                LSCore.Functions.Notify('De smelter is actief..', 'error')
            end
        end)
	end
end)

RegisterNetEvent('framework-pawnshop:client:start:smelter')
AddEventHandler('framework-pawnshop:client:start:smelter', function()
    TriggerServerEvent('framework-pawnshop:server:try:start', "Smelter")
end)