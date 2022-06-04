-- // Events \\ --

RegisterNetEvent('framework-pawnshop:client:open:selling')
AddEventHandler('framework-pawnshop:client:open:selling', function(Type)
    if Type == 'BarsItem' then
        if exports['fw-inv']:CanOpenInventory() then
            TriggerServerEvent('framework-inv:server:open:inventory:other', "Inkoper: 1", 'TempStashes', 5, 1000000)
        end
    elseif Type == 'Wood' then
        if exports['fw-inv']:CanOpenInventory() then
            TriggerServerEvent('framework-inv:server:open:inventory:other', "Inkoper: 3", 'TempStashes', 5, 1000000)
        end
    end
end)

RegisterNetEvent('framework-pawnshop:client:try:sell')
AddEventHandler('framework-pawnshop:client:try:sell', function(Type)
    if Type == 'BarsItem' then
        TriggerServerEvent('framework-pawnshop:server:try:sell', "Inkoper: 1", "BarsItem")
    elseif Type == 'WoodSell' then
            TriggerServerEvent('framework-pawnshop:server:try:sell', "Inkoper: 3", "WoodSell")
    end
end)