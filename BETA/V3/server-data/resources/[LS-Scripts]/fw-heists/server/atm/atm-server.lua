local Cooldown = false
-- Recompensa
RegisterServerEvent("fw-heist:atm:success")
AddEventHandler("fw-heist:atm:success",function()
    local src = source
	local Player =  LSCore.Functions.GetPlayer(source)
    local bags = 1
	local info = {
		worth = math.random(350, 1150)
	}
	Player.Functions.AddItem('markedbills', bags, false, info)
    Player.Functions.RemoveItem("thermite", 1, false, false, true)
end)

-- Cooldown
RegisterServerEvent('fw-heist:atm:Server:BeginCooldown')
AddEventHandler('fw-heist:atm:Server:BeginCooldown', function()
    Cooldown = true
    local timer = 60000 * 60000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            Cooldown = false
        end
    end
end)

LSCore.Functions.CreateCallback("fw-heist:atm:Cooldown",function(source, cb)
    if Cooldown then
        cb(true)
    else
        cb(false)
        
    end
end)