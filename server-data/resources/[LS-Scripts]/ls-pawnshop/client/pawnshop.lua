-- // Events \\ --

RegisterNetEvent('ls-pawnshop:client:open:selling')
AddEventHandler('ls-pawnshop:client:open:selling', function(Type)
    if Type == 'BarsItem' then
        if exports['ls-inventory-new']:CanOpenInventory() then
            TriggerServerEvent('ls-inventory-new:server:open:inventory:other', "Inkoper: 1", 'TempStashes', 5, 1000000)
        end
    end
end)

RegisterNetEvent('ls-pawnshop:client:try:sell')
AddEventHandler('ls-pawnshop:client:try:sell', function(Type)
    if Type == 'BarsItem' then
        TriggerServerEvent('ls-pawnshop:server:try:sell', "Inkoper: 1", "BarsItem")
    end
end)