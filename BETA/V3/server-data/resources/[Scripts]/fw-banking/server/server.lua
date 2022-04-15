local LSCore = exports['fw-base']:GetCoreObject()

-- Code

LSCore.Commands.Add("geefcontant", "Geef contant geld aan een persoon", {{name="id", help="Speler ID"},{name="bedrag", help="Hoeveel geld"}}, true, function(source, args)
    local SelfPlayer = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    local Amount = tonumber(args[2])
    if TargetPlayer ~= nil then
        if TargetPlayer.PlayerData.source ~= SelfPlayer.PlayerData.source then
            if Amount ~= nil and Amount > 0 then
                local cashBalance = SelfPlayer.Functions.GetItemByName('cash')
                if cashBalance == nil then return false end
                    if cashBalance.amount > Amount then
                -- if SelfPlayer.PlayerData.money['cash'] >= Amount then
                    TriggerClientEvent('framework-banking:client:check:players:near', SelfPlayer.PlayerData.source, TargetPlayer.PlayerData.source, math.ceil(Amount))
                else
                    TriggerClientEvent('LSCore:Notify', source, "Je hebt niet genoeg contant..", "error", 4500)
                end
            end
        else
            TriggerClientEvent('LSCore:Notify', source, "Hoe dan?", "error", 4500)
        end
    else
        TriggerClientEvent('LSCore:Notify', source, "Geen burger gevonden..", "error", 4500)
    end
end)

RegisterNetEvent('framework-banking:server:give:cash')
AddEventHandler('framework-banking:server:give:cash', function(TargetPlayer, Amount)
    local SelfPlayer = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(TargetPlayer)
    SelfPlayer.Functions.RemoveMoney('cash', Amount, 'Contant Geven')
    TargetPlayer.Functions.AddMoney('cash', Amount, 'Contant Geven')
    TriggerClientEvent('LSCore:Notify', SelfPlayer.PlayerData.source, "Je hebt €"..Amount.. " gegeven", "success", 4500)
    TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, "Je ontving €"..Amount.. " van "..SelfPlayer.PlayerData.charinfo.firstname, "success", 4500)
end)

RegisterServerEvent('framework-banking:server:set:business:accounts')
AddEventHandler('framework-banking:server:set:business:accounts', function(Type, Amount, BankId, Reason, Source)
    local HasSource = Source ~= nil and Source or source
    local Player = LSCore.Functions.GetPlayer(HasSource)
    local CurrentBalance = GetCurrentAccountBalance(BankId)
    if Type == 'Add' then
        local NewBalance = CurrentBalance + tonumber(Amount)
        LSCore.Functions.ExecuteSql(false, "UPDATE player_accounts SET `balance` = '" .. NewBalance .. "' WHERE `bankid` = '" ..BankId.. "'")
        AddTransactionCard({['Message'] = 'Betaling door '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname, ['BankId'] = BankId, ['Amount'] = '+ €'..Amount, ['Reason'] = Reason, ['Type'] = 'deposit'})
    elseif Type == 'Remove' then
        -- Nog niet nodig..
    end
end)

LSCore.Functions.CreateCallback("framework-bank:server:get:accounts", function(source, cb)
    local AccountTable = {}
    local Player = LSCore.Functions.GetPlayer(source)
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM player_accounts WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `type` = 'private'", function(result) 
        if result[1] ~= nil then
            for k, v in pairs(result) do
                local AccountData = {}
                AccountData['PersonalName'] = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
                AccountData['Name'] = v.name
                AccountData['BankId'] = v.bankid
                AccountData['Balance'] = v.balance
                AccountData['Type'] = 'private'
                AccountData['Transactions'] = json.decode(v.transactions)
                table.insert(AccountTable, AccountData)
            end
            cb(AccountTable)
        end
    end)  
end)

LSCore.Functions.CreateCallback("framework-bank:server:get:shared:accounts", function(source, cb)
    local AccountTable = {}
    local Player = LSCore.Functions.GetPlayer(source)
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM player_accounts WHERE `type` = 'shared'", function(result) 
        if result[1] ~= nil then
            for k, v in pairs(result) do
                local AccountHolders = json.decode(v.authorized)
                for Auth, Authorized in pairs(AccountHolders) do
                    if Authorized == Player.PlayerData.citizenid then
                        local AccountData = {}
                        AccountData['IsOwner'] = false
                        if Player.PlayerData.citizenid == v.citizenid then
                            AccountData['IsOwner'] = true 
                        end
                        AccountData['OwnerName'] = GetOwnerDbName(v.citizenid)
                        AccountData['Owner'] = v.citizenid
                        AccountData['Name'] = v.name
                        AccountData['BankId'] = v.bankid
                        AccountData['Balance'] = v.balance
                        AccountData['Type'] = 'shared'
                        AccountData['Transactions'] = json.decode(v.transactions)
                        local AccountPlayers = {}
                        for k, v in pairs(json.decode(v.authorized)) do
                           local PlayerData = {}
                           PlayerData['CitizenId'] = v
                           PlayerData['Name'] = GetOwnerDbName(v)
                           table.insert(AccountPlayers, PlayerData)
                        end
                        AccountData['Authorized'] = AccountPlayers
                        table.insert(AccountTable, AccountData)
                    end
                end
            end
            cb(AccountTable)
        end
    end)
end)

LSCore.Functions.CreateCallback("framework-bank:server:get:business:accounts", function(source, cb)
    local AccountTable = {}
    local Player = LSCore.Functions.GetPlayer(source)
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM player_accounts WHERE `type` = 'business'", function(result) 
        if result[1] ~= nil then
            for k, v in pairs(result) do
                local AccountHolders = json.decode(v.authorized)
                if AccountHolders ~= nil then
                    for Auth, Authorized in pairs(AccountHolders) do
                        if Authorized == Player.PlayerData.citizenid then
                            local AccountData = {}
                            AccountData['IsOwner'] = false
                            if Player.PlayerData.citizenid == v.citizenid then
                                AccountData['IsOwner'] = true 
                            end
                            AccountData['OwnerName'] = GetOwnerDbName(v.citizenid)
                            AccountData['Owner'] = v.citizenid
                            AccountData['Name'] = v.name
                            AccountData['BankId'] = v.bankid
                            AccountData['Balance'] = v.balance
                            AccountData['Type'] = 'shared'
                            AccountData['Transactions'] = json.decode(v.transactions)
                            local AccountPlayers = {}
                            for k, v in pairs(json.decode(v.authorized)) do
                               local PlayerData = {}
                               PlayerData['CitizenId'] = v
                               PlayerData['Name'] = GetOwnerDbName(v)
                               table.insert(AccountPlayers, PlayerData)
                            end
                            AccountData['Authorized'] = AccountPlayers
                            table.insert(AccountTable, AccountData)
                        end
                    end
                end
            end
            cb(AccountTable)
        end
    end)
end)

LSCore.Functions.CreateCallback("framework-bank:server:withdraw:money", function(source, cb, data)
    local Player = LSCore.Functions.GetPlayer(source)
    if data['Type'] == 'standard' then
        if Player.PlayerData.money['bank'] >= tonumber(data['WithdrawAmount']) then
            Player.Functions.RemoveMoney('bank', tonumber(data['WithdrawAmount']))
            Player.Functions.AddMoney('cash', tonumber(data['WithdrawAmount']))
            cb(true)
        else
            cb(false)
        end
    elseif data['Type'] == 'private' or data['Type'] == 'shared' or data['Type'] == 'business' then
        local CurrentBalance = GetCurrentAccountBalance(data['BankId'])
        if CurrentBalance >= tonumber(data['WithdrawAmount']) then
            local NewBalance = (CurrentBalance - tonumber(data['WithdrawAmount']))
            Player.Functions.AddMoney('cash', tonumber(data['WithdrawAmount']), data['WithdrawReason'])
            LSCore.Functions.ExecuteSql(false, "UPDATE player_accounts SET `balance` = '" .. NewBalance .. "' WHERE `bankid` = '" ..data['BankId'].. "'")
            AddTransactionCard({['Message'] = 'Geld opname door '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname, ['BankId'] = data['BankId'], ['Amount'] = '- €'..data['WithdrawAmount'], ['Reason'] = data['WithdrawReason'], ['Type'] = 'withdraw'})
            cb(true)
        else
            cb(false)
        end
    end
end)

LSCore.Functions.CreateCallback("framework-bank:server:deposit:money", function(source, cb, data)
    local Player = LSCore.Functions.GetPlayer(source)
    if data['Type'] == 'standard' then
        
	local cashBalance = Player.Functions.GetItemByName('cash')
	if cashBalance == nil then return false end
		if cashBalance.amount > tonumber(data['DepositAmount']) then
        -- if Player.PlayerData.money['cash'] >= tonumber(data['DepositAmount']) then
            Player.Functions.RemoveMoney('cash', tonumber(data['DepositAmount']))
            Player.Functions.AddMoney('bank', tonumber(data['DepositAmount']))
            cb(true)
        else
            cb(false)
        end
    elseif data['Type'] == 'private' or data['Type'] == 'shared' or data['Type'] == 'business' then
        local CurrentBalance = GetCurrentAccountBalance(data['BankId'])
        if Player.Functions.RemoveMoney('cash', tonumber(data['DepositAmount']), data['DepositReason']) then
            local NewBalance = (CurrentBalance + tonumber(data['DepositAmount']))
            LSCore.Functions.ExecuteSql(false, "UPDATE player_accounts SET `balance` = '" .. NewBalance .. "' WHERE `bankid` = '" ..data['BankId'].. "'")
            AddTransactionCard({['Message'] = 'Geld storting door '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname, ['BankId'] = data['BankId'], ['Amount'] = '+ €'..data['DepositAmount'], ['Reason'] = data['DepositReason'], ['Type'] = 'deposit'})
            cb(true)
        else
            cb(false)
        end
    end
end)

LSCore.Functions.CreateCallback("framework-bank:server:delete:account", function(source, cb, BankId)
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM player_accounts WHERE `bankid` = '"..BankId.."'", function(result) 
        if result[1] ~= nil then
            if result[1].balance == 0 or result[1].balance < 0 then
                LSCore.Functions.ExecuteSql(false, 'DELETE FROM `player_accounts` WHERE `bankid` = "'..BankId..'"')
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

LSCore.Functions.CreateCallback("framework-bank:server:create:account", function(source, cb, data)
    local Player = LSCore.Functions.GetPlayer(source)
    local RandomIban = CreateRandomIban()
    LSCore.Functions.InsertSql(false, "INSERT INTO `player_accounts` (`citizenid`, `type`, `name`, `bankid`, `authorized`) VALUES ('"..Player.PlayerData.citizenid.."', '"..data['Type'].."', '"..data['Name'].."', '"..RandomIban.."', '[\""..Player.PlayerData.citizenid.."\"]')")
    cb(true)
end)

LSCore.Functions.CreateCallback("framework-bank:server:transfer:money", function(source, cb, data)
    local Player = LSCore.Functions.GetPlayer(source)
    if data['Type'] == 'standard' then
        LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..data['TBankId'].."%'", function(result)
            if result[1] ~= nil then
                local TargetPlayer = LSCore.Functions.GetPlayerByCitizenId(result[1].citizenid)
                if TargetPlayer ~= nil then
                    if Player.PlayerData.money['bank'] >= tonumber(data['TransferAmount']) then
                        Player.Functions.RemoveMoney('bank', data['TransferAmount'], data['TransferReason'])
                        TargetPlayer.Functions.AddMoney('bank', data['TransferAmount'], data['TransferReason'])
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    if Player.PlayerData.money['bank'] >= tonumber(data['TransferAmount']) then
                        Player.Functions.RemoveMoney('bank', data['TransferAmount'], data['TransferReason'])
                        local TargetMoney = json.decode(result[1].money)
                        TargetMoney.bank = TargetMoney.bank + data['TransferAmount']
                        LSCore.Functions.ExecuteSql(false, "UPDATE `players` SET `money` = '"..json.encode(TargetMoney).."' WHERE `citizenid` = '"..result[1].citizenid.."'")
                        cb(true)
                    else
                        cb(false)
                    end
                end
            else
                if Player.PlayerData.money['bank'] >= tonumber(data['TransferAmount']) then
                    Player.Functions.RemoveMoney('bank', data['TransferAmount'], data['TransferReason'])
                    local TargetBalance = GetCurrentAccountBalance(data['TBankId'])
                    local NewTBalance = TargetBalance + data['TransferAmount']
                    LSCore.Functions.ExecuteSql(false, "UPDATE player_accounts SET `balance` = '" ..NewTBalance.. "' WHERE `bankid` = '" ..data['TBankId'].. "'")
                    AddTransactionCard({['Message'] = 'Geld ontvangen van '..Player.PlayerData.charinfo.account, ['BankId'] = data['TBankId'], ['Amount'] = '+ €'..data['TransferAmount'], ['Reason'] = data['TransferReason'], ['Type'] = 'transfer'})
                    cb(true)
                else
                    cb(false)
                end
            end
        end)
    else
        LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..data['TBankId'].."%'", function(result)
            if result[1] ~= nil then
                local TargetPlayer = LSCore.Functions.GetPlayerByCitizenId(result[1].citizenid)
                if TargetPlayer ~= nil then
                    local MyBalance = GetCurrentAccountBalance(data['MBankId'])
                    local NewMBalance = MyBalance - data['TransferAmount']
                    if MyBalance >= data['TransferAmount'] then
                        TargetPlayer.Functions.AddMoney('bank', data['TransferAmount'])
                        LSCore.Functions.ExecuteSql(false, "UPDATE `player_accounts` SET `balance` = '" ..NewMBalance.. "' WHERE `bankid` = '" ..data['MBankId'].. "'")
                        AddTransactionCard({['Message'] = 'Geld overgemaakt naar '..TargetPlayer.PlayerData.charinfo.account, ['BankId'] = data['MBankId'], ['Amount'] = '- €'..data['TransferAmount'], ['Reason'] = data['TransferReason'], ['Type'] = 'transfer'})
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    local TargetMoney = json.decode(result[1].money)
                    local TargetCharinfo = json.decode(result[1].charinfo)
                    local MyBalance = GetCurrentAccountBalance(data['MBankId'])
                    local NewMBalance = MyBalance - data['TransferAmount']
                    if MyBalance >= data['TransferAmount'] then
                        TargetMoney.bank = TargetMoney.bank + data['TransferAmount']
                        LSCore.Functions.ExecuteSql(false, "UPDATE `players` SET `money` = '"..json.encode(TargetMoney).."' WHERE `citizenid` = '"..result[1].citizenid.."'")
                        LSCore.Functions.ExecuteSql(false, "UPDATE `player_accounts` SET `balance` = '" ..NewMBalance.. "' WHERE `bankid` = '" ..data['MBankId'].. "'")
                        AddTransactionCard({['Message'] = 'Geld overgemaakt naar '..TargetCharinfo.account, ['BankId'] = data['MBankId'], ['Amount'] = '- €'..data['TransferAmount'], ['Reason'] = data['TransferReason'], ['Type'] = 'transfer'})
                        cb(true)
                    else
                        cb(false)
                    end
                end
            else
                local TargetBalance = GetCurrentAccountBalance(data['TBankId'])
                local MyBalance = GetCurrentAccountBalance(data['MBankId'])
                if MyBalance ~= nil and TargetBalance ~= nil then
                    if MyBalance >= data['TransferAmount'] then
                        local NewTBalance = TargetBalance + data['TransferAmount']
                        local NewMBalance = MyBalance - data['TransferAmount']
                        LSCore.Functions.ExecuteSql(false, "UPDATE `player_accounts` SET `balance` = '" ..NewTBalance.. "' WHERE `bankid` = '" ..data['TBankId'].. "'")
                        LSCore.Functions.ExecuteSql(false, "UPDATE `player_accounts` SET `balance` = '" ..NewMBalance.. "' WHERE `bankid` = '" ..data['MBankId'].. "'")
                        AddTransactionCard({['Message'] = 'Geld ontvangen van '..data['MBankId'], ['BankId'] = data['TBankId'], ['Amount'] = '+ €'..data['TransferAmount'], ['Reason'] = data['TransferReason'], ['Type'] = 'transfer'})
                        AddTransactionCard({['Message'] = 'Geld verstuurd naar '..data['MBankId'], ['BankId'] = data['MBankId'], ['Amount'] = '- €'..data['TransferAmount'], ['Reason'] = data['TransferReason'], ['Type'] = 'transfer'})
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            end
        end)
    end
end)

LSCore.Functions.CreateCallback("framework-bank:server:delete:player", function(source, cb, data)
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM player_accounts WHERE `bankid` = '"..data['BankId'].."'", function(result)
        if result[1] ~= nil then
            local UserData = json.decode(result[1].authorized)
            local NewUsers = {}
            for k, v in pairs(UserData) do
                if v ~= data['CitizenId'] then
                 table.insert(NewUsers, v)
                end
            end
            LSCore.Functions.ExecuteSql(false, "UPDATE player_accounts SET `authorized` = '" .. json.encode(NewUsers) .. "' WHERE `bankid` = '" ..data['BankId'].. "'")
            cb(true)
        else
            cb(false)
        end
    end)
end)

LSCore.Functions.CreateCallback("framework-bank:server:add:player", function(source, cb, data)
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM player_accounts WHERE `bankid` = '"..data['BankId'].."'", function(result)
        if result[1] ~= nil then
            local UserData = json.decode(result[1].authorized)
            local NewUser = data['CitizenId']
            local NewUsers = {}
            for k, v in pairs(UserData) do
                table.insert(NewUsers, v)
            end
            table.insert(NewUsers, NewUser:upper())
            LSCore.Functions.ExecuteSql(false, "UPDATE player_accounts SET `authorized` = '" .. json.encode(NewUsers) .. "' WHERE `bankid` = '" ..data['BankId'].. "'")
            cb(true)
        else
            cb(false)
        end
    end)
end)

function AddTransactionCard(Data)
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM player_accounts WHERE `bankid` = '"..Data['BankId'].."'", function(result)
        if result[1] ~= nil then
            local AddTransaction = {['Message'] = Data['Message'], ['Amount'] = Data['Amount'], ['Type'] = Data['Type'], ['Reason'] = Data['Reason'], ['Time'] = os.date('%H:'..'%M'), ['Date'] = os.date('%d-'..'%m-'..'%y')}
            local CurrentTransactions = json.decode(result[1].transactions)
            if CurrentTransactions ~= nil then
                table.insert(CurrentTransactions, AddTransaction)
                LSCore.Functions.ExecuteSql(false, "UPDATE player_accounts SET `transactions` = '" .. json.encode(CurrentTransactions) .. "' WHERE `bankid` = '" ..Data['BankId'].. "'")
            else
                local NewTransactionTable = {}
                table.insert(NewTransactionTable, AddTransaction)
                LSCore.Functions.ExecuteSql(false, "UPDATE player_accounts SET `transactions` = '" .. json.encode(NewTransactionTable) .. "' WHERE `bankid` = '" ..Data['BankId'].. "'")
            end
        end
    end)
end

function GetCurrentAccountBalance(AccountNumber)
    local ReturnData = nil
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM player_accounts WHERE `bankid` = '"..AccountNumber.."'", function(result)
        ReturnData = tonumber(result[1].balance)
    end)
    return ReturnData
end

function GetOwnerDbName(Cid)
    local ReturnName = 'Onbekend'
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid`= '"..Cid.."'", function(result) 
        if result[1] ~= nil then
            local Charinfo = json.decode(result[1].charinfo)
            ReturnName = Charinfo.firstname..' '..Charinfo.lastname
        end
    end)
    return ReturnName
end

function CreateRandomIban()
    return "NL0"..math.random(1,9)..LSCore.Shared.RandomInt(3):upper()..math.random(1111,9999)..math.random(1111,9999)..math.random(11,99)
end