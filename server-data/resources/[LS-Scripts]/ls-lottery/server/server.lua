local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateUseableItem("lotto-card", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, false, true) then
		local RandomNum = math.random(1,200)
		local Prijs = 0
		if RandomNum <= 10 then
			Prijs = 400
		elseif RandomNum >= 139 and RandomNum <= 161 then
			Prijs = 200
		elseif RandomNum >= 115 and RandomNum <= 119 then
			Prijs = 2000
		elseif RandomNum >= 71 and RandomNum <= 76 then
			Prijs = 1000
		elseif RandomNum >= 43 and RandomNum <= 51 then
			Prijs = 100
		elseif RandomNum == 56 then
			Prijs = 20000
		else
			Prijs = 0
		end
		if Prijs ~= 0 then
			Player.Functions.AddItem("used-card", 1, false, {card = Prijs}, false)
		end
		TriggerClientEvent("ls-lottery:client:open:card", source, math.random(11,99), Prijs) 
    end
end)

RegisterServerEvent('ls-lottery:server:sell:card')
AddEventHandler('ls-lottery:server:sell:card', function()
    local Player = LSCore.Functions.GetPlayer(source)
	for k, v in pairs(Player.PlayerData.inventory) do
		if v.name == 'used-card' then
			if Player.Functions.RemoveItem('used-card', 1, v.slot, true) then
				Player.Functions.AddMoney('cash', v.info.card, "used-card")
			end
		end
	end
end)
