local LSCore = exports['fw-base']:GetCoreObject()
function SaveTrapHouseConfig(TraphouseId)
    LSCore.Functions.ExecuteSql(true, "UPDATE `traphouses` SET keyholders='"..json.encode(Config.TrapHouses[TraphouseId].keyholders).."',pincode='"..Config.TrapHouses[TraphouseId].pincode.."',money='"..Config.TrapHouses[TraphouseId].money.."' WHERE `id` = '"..TraphouseId.."'")
end
Citizen.CreateThread(function()
	LSCore.Functions.ExecuteSql(false, "SELECT * FROM `traphouses`", function(result)
		if result[1] ~= nil then
            for k, v in pairs(result) do
                local openeds = false
				if tonumber(v.opened) == 1 then
					openeds = true
                end
                local takingovers = false
                if tonumber(v.takingover) == 1 then
					takingovers = true
                end
				Config.TrapHouses[v.id] = {
                    coords = {    
                        ["enter"] = vector3(-1202.13, -1308.48, 4.91),
                        ["interaction"] = vector3(-1207.42, -1311.83, -27.00),
                    },
					keyholders = json.decode(v.keyholders),
					pincode = v.pincode,
					opened = openeds,
					takingover = takingovers,
					money = v.money,
				}
            end
		end
	end)
end)

RegisterServerEvent('framework-traphouse:server:TakeoverHouse')
AddEventHandler('framework-traphouse:server:TakeoverHouse', function(Traphouse)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid

    if not HasCitizenIdHasKey(CitizenId, Traphouse) then
        if Player.Functions.RemoveItem('cash', Config.TakeoverPrice) then
            TriggerClientEvent('framework-traphouse:client:TakeoverHouse', src, Traphouse)
        else
            TriggerClientEvent('LSCore:Notify', src, "Je hebt niet genoeg contant geld", 'error')
        end
    end
end)

RegisterServerEvent('framework-traphouse:server:AddHouseKeyHolder')
AddEventHandler('framework-traphouse:server:AddHouseKeyHolder', function(CitizenId, TraphouseId, IsOwner)
    print(CitizenId, 'is cheating on AddHouseKeyHolder')
end)

LSCore.Functions.CreateCallback('framework-traphouse:server:AddHouseKeyHolder', function(source, cb, CitizenId, TraphouseId, IsOwner)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)

    if Config.TrapHouses[TraphouseId] ~= nil then
        if IsOwner then
            Config.TrapHouses[TraphouseId].keyholders = {}
            Config.TrapHouses[TraphouseId].pincode = math.random(1111, 4444)
        end

        if Config.TrapHouses[TraphouseId].keyholders == nil then
            table.insert(Config.TrapHouses[TraphouseId].keyholders, {
                citizenid = CitizenId,
                owner = IsOwner,
            })
            SaveTrapHouseConfig(TraphouseId)
            TriggerClientEvent('framework-traphouse:client:SyncData', -1, TraphouseId, Config.TrapHouses[TraphouseId])
        else
            if #Config.TrapHouses[TraphouseId].keyholders + 1 <= 6 then
                if not HasCitizenIdHasKey(CitizenId, TraphouseId) then
                    table.insert(Config.TrapHouses[TraphouseId].keyholders, {
                        citizenid = CitizenId,
                        owner = IsOwner,
                    })
                    SaveTrapHouseConfig(TraphouseId)
                    TriggerClientEvent('framework-traphouse:client:SyncData', -1, TraphouseId, Config.TrapHouses[TraphouseId])
                end
            else
                TriggerClientEvent('LSCore:Notify', src, "Traphouse is over bezet")
            end
        end
    else
        TriggerClientEvent('LSCore:Notify', src, "Een error heeft zich voorgedaan")
    end
end)

function HasCitizenIdHasKey(CitizenId, Traphouse)
    local retval = false
    if Config.TrapHouses[Traphouse].keyholders ~= nil and next(Config.TrapHouses[Traphouse].keyholders) ~= nil then
        for _, data in pairs(Config.TrapHouses[Traphouse].keyholders) do
            if data.citizenid == CitizenId then
                retval = true
                break
            end
        end
    end
    return retval
end

function AddKeyHolder(CitizenId, Traphouse, IsOwner)
    if IsOwner then
        Config.TrapHouses[Traphouse].keyholders = {}
    end
    if #Config.TrapHouses[Traphouse].keyholders <= 6 then
        if not HasCitizenIdHasKey(CitizenId, Traphouse) then
            Config.TrapHouses[Traphouse].keyholders[#Config.TrapHouses[Traphouse].keyholders+1] = {
                citizenid = CitizenId,
                owner = IsOwner,
            }
        end
    end
end

function HasTraphouseAndOwner(CitizenId)
    local retval = nil
    for Traphouse,_ in pairs(Config.TrapHouses) do
        for k, v in pairs(Config.TrapHouses[Traphouse].keyholders) do
            if v.citizenid == CitizenId then
                if v.owner then
                    retval = Traphouse
                end
            end
        end
    end
    return retval
end

LSCore.Commands.Add("trapsleutel", "Geef trap sleutels", {{name = "id", help = "Speler id"}}, true, function(source, args)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local TargetId = tonumber(args[1])
    local TargetData = LSCore.Functions.GetPlayer(TargetId)
    local IsOwner = false
    local Traphouse = HasTraphouseAndOwner(Player.PlayerData.citizenid)

    if TargetData ~= nil then
        if Traphouse ~= nil then
            if not HasCitizenIdHasKey(TargetData.PlayerData.citizenid, Traphouse) then
                if Config.TrapHouses[Traphouse] ~= nil then
                    if IsOwner then
                        Config.TrapHouses[Traphouse].keyholders = {}
                        Config.TrapHouses[Traphouse].pincode = math.random(1111, 4444)
                    end

                    if Config.TrapHouses[Traphouse].keyholders == nil then
                        table.insert(Config.TrapHouses[Traphouse].keyholders, {
                            citizenid = TargetData.PlayerData.citizenid,
                            owner = IsOwner,
                        })
                        SaveTrapHouseConfig(Traphouse)
                        TriggerClientEvent('framework-traphouse:client:SyncData', -1, Traphouse, Config.TrapHouses[Traphouse])
                    else
                        if #Config.TrapHouses[Traphouse].keyholders + 1 <= 6 then
                            if not HasCitizenIdHasKey(TargetData.PlayerData.citizenid, Traphouse) then
                                table.insert(Config.TrapHouses[Traphouse].keyholders, {
                                    citizenid = TargetData.PlayerData.citizenid,
                                    owner = IsOwner,
                                })
                                SaveTrapHouseConfig(Traphouse)
                                TriggerClientEvent('framework-traphouse:client:SyncData', -1, Traphouse, Config.TrapHouses[Traphouse])
                            end
                        else
                            TriggerClientEvent('LSCore:Notify', src, "Er zijn geen lege sloten over")
                        end
                    end
                else
                    TriggerClientEvent('LSCore:Notify', src, "Error")
                end
            else
                TriggerClientEvent('LSCore:Notify', src, "Deze persoon heeft al sleutels", 'error')
            end
        else
            TriggerClientEvent('LSCore:Notify', src, "Je bent niet de eigenaar van de traphouse", 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', src, "Deze persoon is niet in de stad", 'error')
    end
end)

RegisterServerEvent('framework-traphouse:server:TakeMoney')
AddEventHandler('framework-traphouse:server:TakeMoney', function(data)
    local src = source
    local CurrentTraphouse = data['args']
    print(CurrentTraphouse)
    local Player = LSCore.Functions.GetPlayer(src)
    if Config.TrapHouses[CurrentTraphouse].money ~= 0 then
        Player.Functions.AddMoney('cash', Config.TrapHouses[CurrentTraphouse].money)
        Config.TrapHouses[CurrentTraphouse].money = 0
        TriggerClientEvent('framework-traphouse:client:SyncData', -1, CurrentTraphouse, Config.TrapHouses[TraphouseId])
    else
        TriggerClientEvent('LSCore:Notify', src, "Er zit geen geld in de kluis", 'error')
    end
end)

function SellTimeout(traphouseId, slot, itemName, amount, info)
    Citizen.CreateThread(function()
        if itemName == "markedbills" then
            SetTimeout(math.random(1000, 5000), function()
                if Config.TrapHouses[traphouseId].inventory[slot] ~= nil then
                    RemoveHouseItem(traphouseId, slot, itemName, 1)
                    Config.TrapHouses[traphouseId].money = Config.TrapHouses[traphouseId].money + math.ceil(info.worth / 100 * 80)
                    TriggerClientEvent('framework-traphouse:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
                end
            end)
        else
            for i = 1, amount, 1 do
                local SellData = Config.AllowedItems[itemName]
                SetTimeout(SellData.wait, function()
                    if Config.TrapHouses[traphouseId].inventory[slot] ~= nil then
                        RemoveHouseItem(traphouseId, slot, itemName, 1)
                        Config.TrapHouses[traphouseId].money = Config.TrapHouses[traphouseId].money + SellData.reward
                        TriggerClientEvent('framework-traphouse:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
                    end
                end)
                if amount > 1 then
                    Citizen.Wait(SellData.wait)
                end
            end
        end
    end)
end

LSCore.Functions.CreateCallback('framework-traphouse:server:RobNpc', function(source, cb, Traphouse)
	local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local Chance = math.random(1, 500)
    if Chance == 17 then
        local info = {
            label = "Traphouse Pincode: "..Config.TrapHouses[Traphouse].pincode
        }
        Player.Functions.AddItem("stickynote", 1, false, info, true)
    else
        local amount = math.random(3, 15)
        Player.Functions.AddMoney('cash', amount)
    end
end)

LSCore.Functions.CreateCallback('framework-traphouse:server:GetTraphousesData', function(source, cb)
    cb(Config.TrapHouses)
end)

LSCore.Functions.CreateCallback('framework-traphouse:server:GetPlayerName', function(citizenid)
    print(citizenid)
    return LSCore.Functions.GetPlayerCharName(citizenid)
end)