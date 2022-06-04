local LSCore = exports['fw-base']:GetCoreObject()

local JobCooldown 		= {}
local ConvertTimer		= {}
local DrugEffectTimer	= {}
local soldAmount 		= {}
-- Code

LSCore.Functions.CreateCallback("framework-randomdealer:server:get:config", function(source, cb)
    cb(Config)
end)

Citizen.CreateThread(function()
    Config.Dealers[1]['Coords'] = {['X'] = 2415.61, ['Y'] = 5004.83,  ['Z'] = 46.68}
    Config.Dealers[2]['Coords'] = {['X'] = 967.20,  ['Y'] = -1858.47, ['Z'] = 31.16}
    Config.Dealers[3]['Coords'] = {['X'] = 734.38,  ['Y'] = -1294.98, ['Z'] = 27.03}
    Config.Dealers[4]['Coords'] = {['X'] = 712.41583, ['Y'] = -1253.486,   ['Z'] = 26.352397}
    Config.Dealers[5]['Coords'] = {['X'] = 2939.102, ['Y'] = 4624.3364,   ['Z'] = 48.720439}
    -- Config.Dealers[6]['Coords'] = {['X'] = 1135.9915, ['Y'] = -3031.666,   ['Z'] = 5.9010396}
    -- Config.Dealers[7]['Coords'] = {['X'] = 294.90875, ['Y'] = 2090.431,   ['Z'] = 20.804922}
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local TotalPlayer = GetNumPlayerIndices()
        if TotalPlayer >= 1 then
            local Hour = exports['fw-weathersync']:GetCurrentTime()
            if Hour >= 0 and Hour <= 6 then
                if not Config.DealerActive then
                        Config.DealerActive = true
                        local RandomDealer = Config.DealerLocations[math.random(1, #Config.DealerLocations)] 
                        local RandomMessage = RandomDealer['Hints'][math.random(1, #RandomDealer['Hints'])] 
                        Config.CurrentDealerData = RandomDealer
                        local TweetMessage = {firstName = 'Anoniem', lastName = '', message = "Ik ben in de stad met interessante spullen. Kom snel want OP=OP! ("..RandomMessage..")", time = os.date(), tweetId = 'TWEET-'..math.random(111,9999), picture = 'https://cdn.discordapp.com/attachments/569718394077839371/679746109748543545/non.png'}
                        TriggerEvent('framework-phone:server:add:tweet', TweetMessage)
                        TriggerClientEvent('framework-randomdealer:client:set:dealer:data', -1, Config.CurrentDealerData, 'Set')
                        SetupDealerWeapons()
                end
            elseif Hour >= 6 and Hour <= 23 then
                if Config.DealerActive then
                    Config.DealerActive = false
                    Config.CurrentDealerData = {}
                    TriggerClientEvent('framework-randomdealer:client:set:dealer:data', -1, Config.CurrentDealerData, 'Delete')
                end
            end
            Citizen.Wait(2000)
        else
            Citizen.Wait(450)
        end
    end
end)

LSCore.Functions.CreateCallback("framework-dealers:server:get:config", function(source, cb)
    cb(Config.Dealers)
end)

RegisterServerEvent('framework-oudeheer:server:open:menu')
AddEventHandler('framework-oudeheer:server:open:menu', function()
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("cash", 1500) then
        TriggerClientEvent('framework-oudeheer:client:openmenu', source)
    else
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet genoeg geld', 'error')
    end
end)
RegisterServerEvent('framework-dealers:server:update:dealer:items')
AddEventHandler('framework-dealers:server:update:dealer:items', function(Slot, Amount, Dealer)
    if Config.Dealers[Dealer]["Products"][Slot].amount - Amount > 0 then
        Config.Dealers[Dealer]["Products"][Slot].amount = Config.Dealers[Dealer]["Products"][Slot].amount - Amount
    else
        Config.Dealers[Dealer]["Products"][Slot].amount = 0
    end
    TriggerClientEvent('framework-dealers:client:set:dealer:items', -1, Config.Dealers)
end)

Citizen.CreateThread(function()
    Citizen.Wait((1000 * 60) * 60)
    while true do
        Citizen.Wait(4)
        Config.Dealers[2]['Products'][1].amount = Config.Dealers[2]['Products'][1].resetamount
        Config.Dealers[2]['Products'][2].amount = Config.Dealers[2]['Products'][2].resetamount
        Config.Dealers[3]['Products'][1].amount = Config.Dealers[3]['Products'][1].resetamount
        Config.Dealers[3]['Products'][2].amount = Config.Dealers[3]['Products'][2].resetamount
        Config.Dealers[4]['Products'][1].amount = Config.Dealers[4]['Products'][1].resetamount
        -- Config.Dealers[4]['Products'][2].amount = Config.Dealers[4]['Products'][2].resetamount
        Config.Dealers[5]['Products'][1].amount = Config.Dealers[5]['Products'][1].resetamount
        -- Config.Dealers[6]['Products'][1].amount = Config.Dealers[6]['Products'][1].resetamount
        -- Config.Dealers[7]['Products'][1].amount = Config.Dealers[7]['Products'][1].resetamount
        TriggerClientEvent('framework-dealers:client:set:dealer:items', -1, Config.Dealers)
        Citizen.Wait((1000 * 60) * 300)
    end
end)


RegisterServerEvent('framework-randomdealer:server:set:weapons')
AddEventHandler('framework-randomdealer:server:set:weapons', function(Type, ItemName, Amount)
    if Type == 'Minus' then
        for k, v in pairs(Config.CurrentDealerData['Inventory']) do 
            if v.name == ItemName then
                v.amount = v.amount - Amount
            end
        end
    end
    TriggerClientEvent('framework-randomdealer:client:sync:data', -1, Config.CurrentDealerData)
end)

function SetupDealerWeapons()
    local DealerWeapons = {}
    local TotalPlayer = GetNumPlayerIndices()
    for k, v in pairs(Config.DealerWeapons) do
        if TotalPlayer >= v['MinOnline'] then
            if math.random(1, 100) <= v['Chance'] then
                local TableIndex = #DealerWeapons + 1
                DealerWeapons[TableIndex] = {
                    name = v['WeaponId'],
                    price = math.random(v['Prices']['Min'], v['Prices']['Max']),
                    amount = 1,
                    info = {quality = 100.0, ammo = 5},
                    type = "weapon",
                    slot = TableIndex,
                }
            end
        end
    end
    Config.CurrentDealerData['Inventory'] = DealerWeapons
    TriggerClientEvent('framework-randomdealer:client:sync:data', -1, Config.CurrentDealerData)
end

-- Coke collection mission

RegisterServerEvent("t1ger_drugs:syncJobsData")
AddEventHandler("t1ger_drugs:syncJobsData",function(data)
	TriggerClientEvent("t1ger_drugs:syncJobsData",-1,data)
end)

-- Server side table, to store cooldown for players:
RegisterServerEvent("t1ger_drugs:addCooldownToSource")
AddEventHandler("t1ger_drugs:addCooldownToSource",function(source)
	table.insert(JobCooldown,{cooldown = GetPlayerIdentifier(source), time = (Config.CooldownTime * 60000)})
end)

-- Usable item to start drugs jobs:
LSCore.Functions.CreateUseableItem('burner-phone', function(source)
	local xPlayer = LSCore.Functions.GetPlayer(source)
		xPlayer.Functions.RemoveItem('burner-phone', 1)
		TriggerClientEvent("t1ger_drugs:UsableItem",source)
end)

-- Server Event for Buying Drug Job:
RegisterServerEvent("t1ger_drugs:GetSelectedJob")
AddEventHandler("t1ger_drugs:GetSelectedJob", function(drugType,BuyPrice,minReward,maxReward)
	local xPlayer = LSCore.Functions.GetPlayer(source)
	TriggerEvent("t1ger_drugs:addCooldownToSource",source)
	TriggerClientEvent("t1ger_drugs:BrowseAvailableJobs",source, 0, drugType, minReward, maxReward)
		if drugType == "coke" then
			label = "Coke"
		end
end)

-- Server Event for Job Reward:
RegisterServerEvent("t1ger_drugs:JobReward", function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local RandomValue = math.random(1,2)
    if RandomValue == 1 then
        Player.Functions.AddItem('meth-ingredient-2', math.random(1,9), false, false, true)
    elseif RandomValue == 2 then
        Player.Functions.AddItem('packed-coke-brick', math.random(1,8), false, false, true)
    end
end)

function RemoveCooldown(source)
	for k,v in pairs(JobCooldown) do
		if v.cooldown == source then
			table.remove(JobCooldown,k)
		end
	end
end
function GetCooldownTime(source)
	for k,v in pairs(JobCooldown) do
		if v.cooldown == source then
			return math.ceil(v.time/60000)
		end
	end
end
function HasCooldown(source)
	for k,v in pairs(JobCooldown) do
		if v.cooldown == source then
			return true
		end
	end
	return false
end