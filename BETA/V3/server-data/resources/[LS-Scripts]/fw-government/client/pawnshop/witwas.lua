-- // Events \\ --

RegisterNetEvent('framework-materials:client:open:craft')
AddEventHandler('framework-materials:client:open:craft', function()
    if exports['fw-inv']:CanOpenInventory() then
        local CraftingData = {['Type'] = 'Crafting', ['InvName'] = 'Dealer', ['Items'] = Config.MaterialItems}
		TriggerServerEvent('framework-inv:server:open:inventory:other', CraftingData, 'Crafting')
    end
end)