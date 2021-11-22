-- // Events \\ --

RegisterNetEvent('ls-pawnshop:client:smelter:inventory')
AddEventHandler('ls-pawnshop:client:smelter:inventory', function()
	local ClosestPlayer, Distance = LSCore.Functions.GetClosestPlayer()
	if ClosestPlayer ~= -1 and Distance < 4.0 then
		LSCore.Functions.Notify('Er staat iemand anders te dicht bij joh..', 'error')
	else
        LSCore.Functions.TriggerCallback('ls-pawnshop:server:is:smelting', function(IsSmelting)
            if not IsSmelting then
                if exports['ls-inventory-new']:CanOpenInventory() then
                    TriggerServerEvent('ls-inventory-new:server:open:inventory:other', "Smelter", 'TempStashes', 5, 1000000)
                end
            else
                LSCore.Functions.Notify('De smelter is actief..', 'error')
            end
        end)
	end
end)

RegisterNetEvent('ls-pawnshop:client:start:smelter')
AddEventHandler('ls-pawnshop:client:start:smelter', function()
    TriggerServerEvent('ls-pawnshop:server:try:start', "Smelter")
end)