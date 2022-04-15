local LSCore = exports['fw-base']:GetCoreObject()

-- Code

local LSPhone = {}
local Tweets = {}
local AppAlerts = {}
local MentionedTweets = {}
local Hashtags = {}
local Calls = {}
local Adverts = {}
local GeneratedPlates = {}
local EmploymentGroup = {}
local WebHook = "https://discord.com/api/webhooks/942080643230236702/gQhrk34MNn1DqVDT8G_JSGDVNmXKLG6OFYF_IJ_2p8RYi_4ZjjgbGOZiT98GEKbqAV_f"

LSCore.Commands.Add("notify", "Test het notificatie systeem", {}, false, function(source, args)
    TriggerClientEvent('framework-phone:client:notify', source, 'test', 'dit is een tekst ter invulling en voorbeeld')
end, "admin")

LSCore.Functions.CreateCallback("framework-phone:server:GetWebhook",function(source,cb)
    cb(WebHook)
end)

RegisterNetEvent('framework-phone:server:addImageToGallery', function(image)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    LSCore.Functions.InsertSql(false, "INSERT INTO `phone_gallery` (`citizenid`, `image`) VALUES ('"..Player.PlayerData.citizenid.."', '"..image.."')")
end)
RegisterNetEvent('framework-phone:server:getImageFromGallery', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `phone_gallery` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' ORDER BY `id` ASC", function(result)

    -- local images = exports['oxmysql']:execute("SELECT * FROM `phone_gallery` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
    TriggerClientEvent('framework-phone:refreshImages', src, result)
end)
end)

RegisterNetEvent('framework-phone:server:RemoveImageFromGallery', function(data)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local image = data.image
    LSCore.Functions.ExecuteSql(false, "DELETE FROM `phone_gallery` WHERE `citizenid` = "..Player.PlayerData.citizenid.." AND image = "..image.."")
end)

RegisterServerEvent('framework-phone:server:AddAdvert')
AddEventHandler('framework-phone:server:AddAdvert', function(msg)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid

    if Adverts[CitizenId] ~= nil then
        Adverts[CitizenId].message = msg
        Adverts[CitizenId].name = "@"..Player.PlayerData.charinfo.firstname..""..Player.PlayerData.charinfo.lastname
        Adverts[CitizenId].number = Player.PlayerData.charinfo.phone
    else
        Adverts[CitizenId] = {
            message = msg,
            name = "@"..Player.PlayerData.charinfo.firstname..""..Player.PlayerData.charinfo.lastname,
            number = Player.PlayerData.charinfo.phone,
        }
    end

    TriggerClientEvent('framework-phone:client:UpdateAdverts', -1, Adverts, "@"..Player.PlayerData.charinfo.firstname..""..Player.PlayerData.charinfo.lastname)
end)

function GetOnlineStatus(number)
    local Target = LSCore.Functions.GetPlayerByPhone(number)
    local retval = false
    if Target ~= nil then retval = true end
    return retval
end

function ProfilePicture(number)
    local retval = false
    local Player = LSCore.Functions.GetPlayerByPhone(number)
    if Target ~= nil then retval = true end
        if retval then
        return Player.PlayerData.metadata.profilepicture
        end
end

LSCore.Functions.CreateCallback('framework-phone:server:GetPhoneData', function(source, cb)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Player ~= nil then
        local PhoneData = {
            Applications = {},
            PlayerContacts = {},
            MentionedTweets = {},
            Chats = {},
            Hashtags = {},
            Invoices = {},
            Garage = {},
            Mails = {},
            Adverts = {},
            CryptoTransactions = {},
            Tweets = {},
            Images = {},
            BankData = {}
        }

        PhoneData.Adverts = Adverts
        LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_contacts` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' ORDER BY `name` ASC", function(result)
            local Contacts = {}
            if result[1] ~= nil then
                for k, v in pairs(result) do
                    -- v.picture = ProfilePicture(v.number)
                    v.status = GetOnlineStatus(v.number)
                end

                PhoneData.PlayerContacts = result
            end

            -- LSCore.Functions.ExecuteSql(false, "SELECT * FROM phone_invoices WHERE `citizenid` = @citizenid", {
            --     ["@citizenid"] = Player.PlayerData.citizenid
            -- }, function(invoices)
            --     if invoices[1] ~= nil then
            --         for k, v in pairs(invoices) do
            --             local Ply = LSCore.Functions.GetPlayerByCitizenId(v.sender)
            --             if Ply ~= nil then
            --                 v.number = Ply.PlayerData.charinfo.phone
            --             else
            --                 LSCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = @citizenid", {
            --                     ["@citizenid"] = v.sender
            --                 }, function(res)
            --                     if res[1] ~= nil then
            --                         res[1].charinfo = json.decode(res[1].charinfo)
            --                         v.number = res[1].charinfo.phone
            --                     else
            --                         v.number = nil
            --                     end
            --                 end)
            --             end
            --         end
            --         PhoneData.Invoices = invoices
            --     end

                LSCore.Functions.ExecuteSql(false, "SELECT * FROM player_vehicles WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(garageresult)
                    if garageresult[1] ~= nil then
                        -- for k, v in pairs(garageresult) do
                        --     if (LSCore.Shared.Vehicles[v.vehicle] ~= nil) and (Garages[v.garage] ~= nil) then
                        --         v.garage = Garages[v.garage].label
                        --         v.vehicle = LSCore.Shared.Vehicles[v.vehicle].name
                        --         v.brand = LSCore.Shared.Vehicles[v.vehicle].brand
                        --     end
                        -- end

                        PhoneData.Garage = garageresult
                    end
                    LSCore.Functions.ExecuteSql(false, "SELECT * FROM player_messages WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(messages)
                        if messages ~= nil and next(messages) ~= nil then
                            PhoneData.Chats = messages
                        end

                        if AppAlerts[Player.PlayerData.citizenid] ~= nil then
                            PhoneData.Applications = AppAlerts[Player.PlayerData.citizenid]
                        end

                        if MentionedTweets[Player.PlayerData.citizenid] ~= nil then
                            PhoneData.MentionedTweets = MentionedTweets[Player.PlayerData.citizenid]
                        end

                        if Hashtags ~= nil and next(Hashtags) ~= nil then
                            PhoneData.Hashtags = Hashtags
                        end

                        if Tweets ~= nil and next(Tweets) ~= nil then
                            PhoneData.Tweets = Tweets
                        end

                        LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_mails` WHERE `citizenid` = '"..Player.PlayerData.citizenid.." ORDER BY `date` ASC'", function(result)
                            if result then
                                for k, v in pairs(result) do
                                    if result[k].button ~= nil then
                                        result[k].button = json.decode(result[k].button)
                                    end
                                end
                                PhoneData.Mails = mails
                            end

                            -- LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_accounts` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
                            --     if result[1] ~= nil then
                            --         for k, v in pairs(result) do
                            --             table.insert(PhoneData.BankData, {
                            --                 Label = v.name,
                            --                 BankId = v.bankid,
                            --                 Balance = v.balance
                            --             })
                            --         end
                            --     end

                                LSCore.Functions.ExecuteSql(false, "SELECT * FROM `phone_gallery` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
                                    if result then
                                            PhoneData.Images = result
                                    end
                                    LSCore.Functions.ExecuteSql(false, "SELECT * FROM phone_tweets WHERE `date` > NOW() - INTERVAL 24 hour", function(Tweets)
                                        if Tweets then
                                                PhoneData.Tweets = Tweets
                                        end
                                cb(PhoneData)
                                    end)
                                end)
                            -- end)
                        end)
                    end)
                end)
            --end)
        end)
    end
end)

LSCore.Functions.CreateCallback('framework-phone:server:getSharedAccounts', function(source, cb)
    local bacc = {}
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    LSCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_accounts` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'"', function(bankaccounts)
        if bankaccounts[1] ~= nil then
            for k, v in pairs(bankaccounts) do
                table.insert(bacc, {
                    Label = v.name,
                    BankId = v.bankid,
                    Balance = v.balance
                })
            end
        end
        cb(bacc)
    end)
end)

LSCore.Functions.CreateCallback('framework-phone:server:GetCallState', function(source, cb, ContactData)
    local Target = LSCore.Functions.GetPlayerByPhone(ContactData.number)
    if Target ~= nil then
        if Calls[Target.PlayerData.citizenid] ~= nil then
            if Calls[Target.PlayerData.citizenid].inCall then
                cb(false, true)
            else
                cb(true, true)
            end
        else
            cb(true, true)
        end
    else
        cb(false, false)
    end
end)

RegisterServerEvent('framework-phone:server:SetCallState')
AddEventHandler('framework-phone:server:SetCallState', function(bool)
    local src = source
    local Ply = LSCore.Functions.GetPlayer(src)

    if Calls[Ply.PlayerData.citizenid] ~= nil then
        Calls[Ply.PlayerData.citizenid].inCall = bool
    else
        Calls[Ply.PlayerData.citizenid] = {}
        Calls[Ply.PlayerData.citizenid].inCall = bool
    end
end)

RegisterServerEvent('framework-phone:server:RemoveMail')
AddEventHandler('framework-phone:server:RemoveMail', function(MailId)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    LSCore.Functions.ExecuteSql(false, "DELETE FROM `player_mails` WHERE `mailid` = '"..MailId.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
    SetTimeout(100, function()
        LSCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` ASC', function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
            TriggerClientEvent('framework-phone:client:UpdateMails', src, mails)
        end)
    end)
end)

function GenerateMailId()
    return math.random(111111, 999999)
end

RegisterServerEvent('framework-phone:server:sendNewMail')
AddEventHandler('framework-phone:server:sendNewMail', function(mailData)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if mailData.button == nil then
        LSCore.Functions.InsertSql(true, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
    else
        LSCore.Functions.InsertSql(true, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
    end
    TriggerClientEvent('framework-phone:client:NewMailNotify', src, mailData)
    SetTimeout(200, function()
        -- local mails = exports['oxmysql']:execute('SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `id` ASC')
        LSCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` ASC', function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
            TriggerClientEvent('framework-phone:client:UpdateMails', src, mails)
        end)
    end)
end)

RegisterServerEvent('framework-phone:server:sendNewMailToOffline')
AddEventHandler('framework-phone:server:sendNewMailToOffline', function(citizenid, mailData)
    local Player = LSCore.Functions.GetPlayerByCitizenId(citizenid)
    if Player ~= nil then
        local src = Player.PlayerData.source
        if mailData.button == nil then
        LSCore.Functions.InsertSql(true, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
            TriggerClientEvent('framework-phone:client:NewMailNotify', src, mailData)
        else
            LSCore.Functions.InsertSql(true, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
            TriggerClientEvent('framework-phone:client:NewMailNotify', src, mailData)
        end
        SetTimeout(200, function()
            LSCore.Functions.ExecuteSql(true, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` ASC', function(mails)
                if mails[1] ~= nil then
                    for k, v in pairs(mails) do
                        if mails[k].button ~= nil then
                            mails[k].button = json.decode(mails[k].button)
                        end
                    end
                end
                TriggerClientEvent('framework-phone:client:UpdateMails', src, mails)
            end)
        end)
    else
        if mailData.button == nil then
            LSCore.Functions.InsertSql(true, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
        else
            LSCore.Functions.InsertSql(true, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
        end
    end
end)

RegisterServerEvent('framework-phone:server:sendNewEventMail')
AddEventHandler('framework-phone:server:sendNewEventMail', function(citizenid, mailData)
    local Player = LSCore.Functions.GetPlayerByCitizenId(citizenid)
    if mailData.button == nil then
        LSCore.Functions.InsertSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
    else
        LSCore.Functions.InsertSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
    end
    SetTimeout(200, function()
        exports['oxmysql']:execute('SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` ASC', function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
            TriggerClientEvent('framework-phone:client:UpdateMails', src, mails)
        end)
    end)
end)

RegisterServerEvent('framework-phone:server:sendNewtrapMail')
AddEventHandler('framework-phone:server:sendNewtrapMail', function(citizenid, mailData)
    local Player = LSCore.Functions.GetPlayerByCitizenId(citizenid)
    if Player ~= nil then
        local playersource = Player.PlayerData.source
        print(citizenid)
        if mailData.button == nil then
            LSCore.Functions.InsertSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
        else
            LSCore.Functions.InsertSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
        end
        SetTimeout(1200, function()
            LSCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` ASC', function(mails)
                if mails[1] ~= nil then
                    for k, v in pairs(mails) do
                        if mails[k].button ~= nil then
                            mails[k].button = json.decode(mails[k].button)
                        end
                    end
                end
                TriggerClientEvent('framework-phone:client:UpdateMails', playersource, mails)
                TriggerClientEvent('framework-phone:client:AlertTrap', playersource)
            end)
        end)
    end
end)

RegisterServerEvent('framework-phone:server:ClearButtonData')
AddEventHandler('framework-phone:server:ClearButtonData', function(mailId)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    LSCore.Functions.ExecuteSql(false, 'UPDATE `player_mails` SET `button` = "" WHERE `mailid` = "'..mailId..'" AND `citizenid` = "'..Player.PlayerData.citizenid..'"')
    SetTimeout(200, function()
        LSCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` ASC', function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
            TriggerClientEvent('framework-phone:client:UpdateMails', src, mails)
        end)
    end)
end)

RegisterServerEvent('framework-phone:server:MentionedPlayer')
AddEventHandler('framework-phone:server:MentionedPlayer', function(firstName, lastName, TweetMessage)
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.charinfo.firstname == firstName and Player.PlayerData.charinfo.lastname == lastName) then
                LSPhone.SetPhoneAlerts(Player.PlayerData.citizenid, "twitter")
                LSPhone.AddMentionedTweet(Player.PlayerData.citizenid, TweetMessage)
                TriggerClientEvent('framework-phone:client:GetMentioned', Player.PlayerData.source, TweetMessage, AppAlerts[Player.PlayerData.citizenid]["twitter"])
            else
                LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '"..firstName.."' AND `charinfo` LIKE '"..lastName.."'", function(result)
                    if result[1] ~= nil then
                        local MentionedTarget = result[1].citizenid
                        LSPhone.SetPhoneAlerts(MentionedTarget, "twitter")
                        LSPhone.AddMentionedTweet(MentionedTarget, TweetMessage)
                    end
                end)
            end
        end
	end
end)

RegisterServerEvent('framework-phone:server:CallContact')
AddEventHandler('framework-phone:server:CallContact', function(TargetData, CallId, AnonymousCall)
    local src = source
    local Ply = LSCore.Functions.GetPlayer(src)
    local Target = LSCore.Functions.GetPlayerByPhone(TargetData.number)
    if Target ~= nil and Target.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent('framework-phone:client:GetCalled', Target.PlayerData.source, Ply.PlayerData.charinfo.phone, CallId, AnonymousCall)
    end
end)

LSCore.Functions.CreateCallback('framework-phone:server:PayInvoice', function(source, cb, sender, amount, invoiceId)
    local src = source
    local Ply = LSCore.Functions.GetPlayer(src)
    local Trgt = LSCore.Functions.GetPlayerByCitizenId(sender)
    local Invoices = {}

    if Trgt ~= nil then
        if Ply.PlayerData.money.bank >= amount then
            Ply.Functions.RemoveMoney('bank', amount, "paid-invoice")
            TriggerEvent('LSCore:banking/addTransaction', src, Ply.PlayerData.charinfo.account, 'Remove', 'Betaling van een factuur', amount)
            Trgt.Functions.AddMoney('bank', amount, "paid-invoice")
            TriggerEvent('LSCore:banking/addTransaction', src, Trgt.PlayerData.charinfo.account, 'Add', 'Ontvangen betaling van een factuur', amount)
            LSCore.Functions.ExecuteSql(false, "DELETE FROM `phone_invoices` WHERE `invoiceid` = '"..invoiceId.."'")
            LSCore.Functions.ExecuteSql(false, "SELECT * FROM `phone_invoices` WHERE `citizenid` = '"..Ply.PlayerData.citizenid.."'", function(invoices)
                if invoices[1] ~= nil then
                    for k, v in pairs(invoices) do
                        local Target = LSCore.Functions.GetPlayerByCitizenId(v.sender)
                        if Target ~= nil then
                            v.number = Target.PlayerData.charinfo.phone
                        else
                            LSCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..v.sender.."'", function(res)
                                if res[1] ~= nil then
                                    res[1].charinfo = json.decode(res[1].charinfo)
                                    v.number = res[1].charinfo.phone
                                else
                                    v.number = nil
                                end
                            end)
                        end
                    end
                    Invoices = invoices
                end
                cb(true, Invoices)
            end)
        else
            cb(false)
        end
    else
        LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..sender.."'", function(result)
            if result[1] ~= nil then
                local moneyInfo = json.decode(result[1].money)
                moneyInfo.bank = math.ceil((moneyInfo.bank + amount))
                LSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `money` = @money WHERE `citizenid` = @citizenid", {
                    ["@money"] = json.encode(moneyInfo),
                    ["@citizenid"] = sender
                })
                Ply.Functions.RemoveMoney('bank', amount, "paid-invoice")
                LSCore.Functions.ExecuteSql(true, "DELETE FROM `phone_invoices` WHERE `invoiceid` = '"..invoiceId.."'")
                LSCore.Functions.ExecuteSql(false, "SELECT * FROM `phone_invoices` WHERE `citizenid` = '"..Ply.PlayerData.citizenid.."'", function(invoices)
                    if invoices[1] ~= nil then
                        for k, v in pairs(invoices) do
                            local Target = LSCore.Functions.GetPlayerByCitizenId(v.sender)
                            if Target ~= nil then
                                v.number = Target.PlayerData.charinfo.phone
                            else
                                LSCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..v.sender.."'", function(res)
                                    if res[1] ~= nil then
                                        res[1].charinfo = json.decode(res[1].charinfo)
                                        v.number = res[1].charinfo.phone
                                    else
                                        v.number = nil
                                    end
                                end)
                            end
                        end
                        Invoices = invoices
                    end
                    cb(true, Invoices)
                end)
            else
                cb(false)
            end
        end)
    end
end)

LSCore.Functions.CreateCallback('framework-phone:server:DeclineInvoice', function(source, cb, sender, amount, invoiceId)
    local src = source
    local Ply = LSCore.Functions.GetPlayer(src)
    local Trgt = LSCore.Functions.GetPlayerByCitizenId(sender)
    local Invoices = {}
    LSCore.Functions.ExecuteSql(true, "DELETE FROM `phone_invoices` WHERE `invoiceid` = '"..invoiceId.."'")
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `phone_invoices` WHERE `citizenid` = '"..Ply.PlayerData.citizenid.."'", function(invoices)
        if invoices[1] ~= nil then
            for k, v in pairs(invoices) do
                local Target = LSCore.Functions.GetPlayerByCitizenId(v.sender)
                if Target ~= nil then
                    v.number = Target.PlayerData.charinfo.phone
                else
                    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..v.sender.."'", function(res)
                        if res[1] ~= nil then
                            res[1].charinfo = json.decode(res[1].charinfo)
                            v.number = res[1].charinfo.phone
                        else
                            v.number = nil
                        end
                    end)
                end
            end
            Invoices = invoices
        end
        cb(true, invoices)
    end)
end)

local LSBNTable = {}
local LSBNTableID = 0

RegisterNetEvent('framework-phone:server:Send_lsbn_ToChat', function(data)
    LSBNTableID = LSBNTableID + 1
    if data.Type == "Text" then
        LSBNTable[LSBNTableID] = {['Text'] = data.Text, ['Image'] = "none", ['ID'] = LSBNTableID, ['Type'] = data.Type, ['Time'] = data.Time,}
    elseif data.Type == "Image" then
        LSBNTable[LSBNTableID] = {['Text'] = data.Text, ['Image'] = data.Image, ['ID'] = LSBNTableID, ['Type'] = data.Type, ['Time'] = data.Time,}
    end
    local Tables = {
        {
            ['Text'] = data.Text, ['Image'] = data.Image, ['ID'] = LSBNTableID, ['Type'] = data.Type, ['Time'] = data.Time,
        },
    }
    TriggerClientEvent('framework-phone:LSBN-reafy-for-add', -1, Tables, true, data.Text)
end)

RegisterNetEvent('framework-phone:server:GetLSBNchats', function()
    local src = source
    TriggerClientEvent('framework-phone:LSBN-reafy-for-add', src, LSBNTable, false, nil)
end)

LSCore.Functions.CreateCallback('framework-phone:server:GetGroupCSNs', function(source, cb, csn)
    if EmploymentGroup[csn] then
        cb(EmploymentGroup[csn]['UserName'])
    else
        cb(false)
    end
end)

RegisterNetEvent('framework-phone:server:employment_CreateJobGroup', function(data)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local CSN = Player.PlayerData.citizenid
    if Player then
        if not EmploymentGroup[CSN] then
            EmploymentGroup[CSN] = {['CSN'] = CSN, ['GName'] = data.name, ['GPass'] = data.pass, ['Users'] = 1, ['UserName'] = {CSN,}}
            TriggerClientEvent('framework-phone:client:EveryoneGrupAddsForAll', -1, EmploymentGroup)
            TriggerClientEvent('LSCore:Notify', src, "Groep aangemaakt", "success")
        else
            TriggerClientEvent('LSCore:Notify', src, "Je zit (al) in een groep", "error")
        end
    end
end)

RegisterNetEvent('framework-phone:server:employment_leave_grouped', function(data)
    local src = source
    for k, v in pairs(EmploymentGroup[data.id]['UserName']) do
        if v == data.csn then
            table.remove(EmploymentGroup[data.id]['UserName'], k)
            EmploymentGroup[data.id]['Users'] = EmploymentGroup[data.id]['Users'] - 1
            TriggerClientEvent('LSCore:Notify', src, "Done", "success")
            TriggerClientEvent('framework-phone:client:EveryoneGrupAddsForAll', -1, EmploymentGroup)
            return
        end
    end
end)


RegisterServerEvent('framework-phone:server:UpdateHashtags')
AddEventHandler('framework-phone:server:UpdateHashtags', function(Handle, messageData)
    if Hashtags[Handle] ~= nil and next(Hashtags[Handle]) ~= nil then
        table.insert(Hashtags[Handle].messages, messageData)
    else
        Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(Hashtags[Handle].messages, messageData)
    end
    TriggerClientEvent('framework-phone:client:UpdateHashtags', -1, Handle, messageData)
end)

LSPhone.AddMentionedTweet = function(citizenid, TweetData)
    if MentionedTweets[citizenid] == nil then MentionedTweets[citizenid] = {} end
    table.insert(MentionedTweets[citizenid], TweetData)
end

LSPhone.SetPhoneAlerts = function(citizenid, app, alerts)
    if citizenid ~= nil and app ~= nil then
        if AppAlerts[citizenid] == nil then
            AppAlerts[citizenid] = {}
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = alerts
                end
            end
        else
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = 0
                end
            else
                if alerts == nil then
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 1
                else
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 0
                end
            end
        end
    end
end

LSCore.Functions.CreateCallback('framework-phone:server:GetContactPictures', function(source, cb, Chats)
    for k, v in pairs(Chats) do
        local Player = LSCore.Functions.GetPlayerByPhone(v.number)
        LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..v.number.."%'", function(result)
            if result[1] ~= nil then
                local MetaData = json.decode(result[1].metadata)
                if MetaData.phone.profilepicture ~= nil then
                    v.picture = MetaData.phone.profilepicture
                else
                    v.picture = "default"
                end
            end
        end)
    end
    SetTimeout(100, function()
        cb(Chats)
    end)
end)

LSCore.Functions.CreateCallback('framework-phone:server:GetContactPicture', function(source, cb, Chat)
    local Player = LSCore.Functions.GetPlayerByPhone(Chat.number)
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..Chat.number.."%'", function(result)
        local MetaData = json.decode(result[1].metadata)
        if MetaData.phone.profilepicture ~= nil then
            Chat.picture = MetaData.phone.profilepicture
        else
            Chat.picture = "default"
        end
    end)
    SetTimeout(100, function()
        cb(Chat)
    end)
end)

LSCore.Functions.CreateCallback('framework-phone:server:GetPicture', function(source, cb, number)
    local Player = LSCore.Functions.GetPlayerByPhone(number)
    local Picture = nil
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..number.."%'", function(result)
        if result[1] ~= nil then
            local MetaData = json.decode(result[1].metadata)
            if MetaData.phone.profilepicture ~= nil then
                Picture = MetaData.phone.profilepicture
            else
                Picture = "default"
            end
            cb(Picture)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('framework-phone:server:SetPhoneAlerts')
AddEventHandler('framework-phone:server:SetPhoneAlerts', function(app, alerts)
    local src = source
    local CitizenId = LSCore.Functions.GetPlayer(src).citizenid
    LSPhone.SetPhoneAlerts(CitizenId, app, alerts)
end)

LSCore.Commands.Add("cleartwitter", "Clear twitter", {}, false, function(source, args)
	Tweets = {}
    TriggerClientEvent('framework-phone:client:force:update', -1, Tweets)
end, "admin")

RegisterServerEvent('framework-phone:server:add:tweet')
AddEventHandler('framework-phone:server:add:tweet', function(TweetData)
    table.insert(Tweets, TweetData)
    Citizen.Wait(100)
    TriggerClientEvent('framework-phone:client:UpdateTweets', -1, -1, Tweets, TweetData)
end)
RegisterNetEvent('framework-phone:server:UpdateTweets', function(NewTweets, TweetData)
    local src = source
    LSCore.Functions.InsertSql(false, "INSERT INTO `phone_tweets` (`citizenid`, `firstName`, `lastName`, `message`, `date`, `url`, `picture`, `tweetid`) VALUES ('"..TweetData.citizenid.."', '"..TweetData.firstName.."', '"..TweetData.lastName.."', '"..TweetData.message.."', NOW(), '"..TweetData.url:gsub("[%<>\"()\' $]","").."', '"..TweetData.picture.."', '"..TweetData.tweetId.."')")
    -- TriggerEvent("framework-logs:server:SendLog", "twitter", "Nieuw twitter bericht", nil, "(citizenid: *" .. Player.PlayerData.citizenid .. "* | id: *(" .. src .. ")* heeft het volgende op twitter geplaats: **" .. TweetData.message .. "** .Het karakter naam waarmee dit is geplaatst is: **" .. TweetData.firstName .. " " .. TweetData.lastName .. "**")

    TriggerClientEvent('framework-phone:client:UpdateTweets', -1, src, NewTweets, TweetData, false)
end)

RegisterNetEvent('framework-phone:server:DeleteTweet', function(tweetId)
    local src = source
    for i = 1, #Tweets do
        if Tweets[i].tweetId == tweetId then
            Tweets[i] = nil
        end
    end
    TriggerClientEvent('framework-phone:client:UpdateTweets', -1, src, Tweets, {}, true)
end)

RegisterServerEvent('framework-phone:server:TransferMoney')
AddEventHandler('framework-phone:server:TransferMoney', function(iban, amount)
    local src = source
    local sender = LSCore.Functions.GetPlayer(src)

    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..iban.."%'", function(result)
        if result[1] ~= nil then
            local recieverSteam = LSCore.Functions.GetPlayerByCitizenId(result[1].citizenid)
            if recieverSteam ~= nil then
                local PhoneItem = recieverSteam.Functions.GetItemByName("phone")
                recieverSteam.Functions.AddMoney('bank', amount, "phone-transfered-from-"..sender.PlayerData.citizenid)
                TriggerEvent('LSCore:banking/addTransaction', src, recieverSteam.PlayerData.charinfo.account, 'Add', 'Ontvangen overschrijving', amount)
                sender.Functions.RemoveMoney('bank', amount, "phone-transfered-to-"..recieverSteam.PlayerData.citizenid)
                TriggerEvent('LSCore:banking/addTransaction', src, sender.PlayerData.charinfo.account, 'Remove', 'Geld overgemaakt naar ' .. recieverSteam.PlayerData.charinfo.account, amount)

                if PhoneItem ~= nil then
                    TriggerClientEvent('framework-phone:client:TransferMoney', recieverSteam.PlayerData.source, amount, recieverSteam.PlayerData.money.bank)
                end
            else
                local moneyInfo = json.decode(result[1].money)
                moneyInfo.bank = ((moneyInfo.bank + amount))
                LSCore.Functions.ExecuteSql(false, "UPDATE `players` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..result[1].citizenid.."'")
                sender.Functions.RemoveMoney('bank', amount, "phone-transfered")
                TriggerEvent('LSCore:banking/addTransaction', src, sender.PlayerData.charinfo.account, 'Remove', 'Mobiele overschrijving', amount)
            end
        else
            TriggerClientEvent('LSCore:Notify', src, "Dit rekeningnummer bestaat niet!", "error")
        end
    end)
end)

RegisterServerEvent('framework-phone:server:EditContact')
AddEventHandler('framework-phone:server:EditContact', function(newName, newNumber, newIban, oldName, oldNumber, oldIban)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    LSCore.Functions.ExecuteSql(false, "UPDATE `player_contacts` SET `name` = '"..newName.."', `number` = '"..newNumber.."', `iban` = '"..newIban.."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `name` = '"..oldName.."' AND `number` = '"..oldNumber.."'")
end)

RegisterServerEvent('framework-phone:server:RemoveContact')
AddEventHandler('framework-phone:server:RemoveContact', function(Name, Number)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    LSCore.Functions.ExecuteSql(false, "DELETE FROM `player_contacts` WHERE `name` = '"..Name.."' AND `number` = '"..Number.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
end)

RegisterServerEvent('framework-phone:server:AddNewContact')
AddEventHandler('framework-phone:server:AddNewContact', function(name, number, iban)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    LSCore.Functions.InsertSql(false, "INSERT INTO `player_contacts` (`citizenid`, `name`, `number`, `iban`) VALUES ('"..Player.PlayerData.citizenid.."', '"..tostring(name).."', '"..tostring(number).."', '"..tostring(iban).."')")
end)

RegisterServerEvent('framework-phone:server:UpdateMessages')
AddEventHandler('framework-phone:server:UpdateMessages', function(ChatMessages, ChatNumber, New)
    local src = source
    local SenderData = LSCore.Functions.GetPlayer(src)
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..ChatNumber.."%'", function(Player)
        if Player[1] ~= nil then
            local TargetData = LSCore.Functions.GetPlayerByCitizenId(Player[1].citizenid)
            if TargetData ~= nil then
                LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_messages` WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..ChatNumber.."'", function(Chat)
                    if Chat[1] ~= nil then
                        -- Update for target
                        LSCore.Functions.ExecuteSql(false, "UPDATE `player_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..TargetData.PlayerData.citizenid.."' AND `number` = '"..SenderData.PlayerData.charinfo.phone.."'")
                        -- Update for sender
                        LSCore.Functions.ExecuteSql(false, "UPDATE `player_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..TargetData.PlayerData.charinfo.phone.."'")
                        -- Send notification & Update messages for target
                        TriggerClientEvent('framework-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, false)
                    else
                        -- Insert for target
                        LSCore.Functions.InsertSql(false, "INSERT INTO `player_messages` (`citizenid`, `number`, `messages`) VALUES ('"..TargetData.PlayerData.citizenid.."', '"..SenderData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                        -- Insert for sender
                        LSCore.Functions.InsertSql(false, "INSERT INTO `player_messages` (`citizenid`, `number`, `messages`) VALUES ('"..SenderData.PlayerData.citizenid.."', '"..TargetData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                        -- Send notification & Update messages for target
                        TriggerClientEvent('framework-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, true)
                    end
                end)
            else
                LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_messages` WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..ChatNumber.."'", function(Chat)
                    if Chat[1] ~= nil then
                        -- Update for target
                        LSCore.Functions.ExecuteSql(false, "UPDATE `player_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..Player[1].citizenid.."' AND `number` = '"..SenderData.PlayerData.charinfo.phone.."'")
                        -- Update for sender
                        Player[1].charinfo = json.decode(Player[1].charinfo)
                        LSCore.Functions.ExecuteSql(false, "UPDATE `player_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..Player[1].charinfo.phone.."'")
                    else
                        -- Insert for target
                        LSCore.Functions.InsertSql(false, "INSERT INTO `player_messages` (`citizenid`, `number`, `messages`) VALUES ('"..Player[1].citizenid.."', '"..SenderData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                        -- Insert for sender
                        Player[1].charinfo = json.decode(Player[1].charinfo)
                        LSCore.Functions.InsertSql(false, "INSERT INTO `player_messages` (`citizenid`, `number`, `messages`) VALUES ('"..SenderData.PlayerData.citizenid.."', '"..Player[1].charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                    end
                end)
            end
        end
    end)
end)

RegisterServerEvent('framework-phone:server:AddRecentCall')
AddEventHandler('framework-phone:server:AddRecentCall', function(type, data)
    local src = source
    local Ply = LSCore.Functions.GetPlayer(src)

    local Hour = os.date("%H")
    local Minute = os.date("%M")
    local label = Hour..":"..Minute

    TriggerClientEvent('framework-phone:client:AddRecentCall', src, data, label, type)

    local Trgt = LSCore.Functions.GetPlayerByPhone(data.number)
    if Trgt ~= nil then
        TriggerClientEvent('framework-phone:client:AddRecentCall', Trgt.PlayerData.source, {
            name = Ply.PlayerData.charinfo.firstname .. " " ..Ply.PlayerData.charinfo.lastname,
            number = Ply.PlayerData.charinfo.phone,
            anonymous = anonymous
        }, label, "outgoing")
    end
end)

RegisterServerEvent('framework-phone:server:CancelCall')
AddEventHandler('framework-phone:server:CancelCall', function(ContactData)
    -- print(ContactData.TargetData.number)
    -- if ContactData.TargetData.number ~= '112' then
        local Ply = LSCore.Functions.GetPlayerByPhone(ContactData.TargetData.number)
        if Ply ~= nil then
            TriggerClientEvent('framework-phone:client:CancelCall', Ply.PlayerData.source)
        end
    -- end
end)

RegisterServerEvent('framework-phone:server:AnswerCall')
AddEventHandler('framework-phone:server:AnswerCall', function(CallData)
    local Ply = LSCore.Functions.GetPlayerByPhone(CallData.TargetData.number)
    if Ply ~= nil then
        TriggerClientEvent('framework-phone:client:AnswerCall', Ply.PlayerData.source)
    end
end)

RegisterServerEvent('framework-phone:server:SaveMetaData')
AddEventHandler('framework-phone:server:SaveMetaData', function(MData)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("phone", MData)
end)

function escape_sqli(source)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return source:gsub( "['\"]", replacements )
end

LSCore.Functions.CreateCallback('framework-phone:server:FetchResult', function(source, cb, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}
    local ApaData = {}
    LSCore.Functions.ExecuteSql(false, 'SELECT * FROM `players` WHERE `citizenid` = "'..search..'" OR `charinfo` LIKE "%'..search..'%"', function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                local charinfo = json.decode(v.charinfo)
                local metadata = json.decode(v.metadata)
                table.insert(searchData, {
                    citizenid = v.citizenid,
                    firstname = charinfo.firstname,
                    lastname = charinfo.lastname,
                    birthdate = charinfo.birthdate,
                    phone = charinfo.phone,
                    nationality = charinfo.nationality,
                    gender = charinfo.gender,
                    warrant = false,
                    driverlicense = metadata["licences"]["driver"],
                    huntinglicense = metadata["licences"]["hunting"],
                    flying = metadata["licences"]["flying"],
                    appartmentdata = metadata['appartment-id'],
                })
            end
            cb(searchData)
        else
            cb(nil)
        end
    end)
end)
LSCore.Functions.CreateCallback('framework-phone:server:MeosGetPlayerHouses', function(source, cb, input)
    if input then
        local search = escape_sqli(input)
        local searchData = {}
        local query = '%' .. search .. '%'
            LSCore.Functions.ExecuteSql(true, 'SELECT * FROM `player_houses` WHERE `citizenid` = "'..query..'"', function(result)
            if result ~= nil and result[1] ~= nil then
                    LSCore.Functions.ExecuteSql(true, 'SELECT * FROM `player_houses` WHERE `citizenid` = "'..result[1].citizenid..'"', function(houses)
                        if houses ~= nil and houses[1] ~= nil then
                            for k, v in pairs(houses) do
                                searchData[#searchData+1] = {
                                    name = v.house,
                                    keyholders = v.keyholders,
                                    owner = v.citizenid,
                                    price = Config.Houses[v.house].price,
                                    label = Config.Houses[v.house].adress,
                                    tier = Config.Houses[v.house].tier,
                                    garage = Config.Houses[v.house].garage,
                                    charinfo = json.decode(result[1].charinfo),
                                    coords = {
                                        x = Config.Houses[v.house].coords.enter.x,
                                        y = Config.Houses[v.house].coords.enter.y,
                                        z = Config.Houses[v.house].coords.enter.z
                                    }
                                }
                            end
                            cb(searchData)
                        end
                    end)
            else
                cb(nil)
            end
        end)
    else
        cb(nil)
    end
end)
-- LSCore.Functions.CreateCallback('framework-phone:server:MeosGetPlayerHouses', function(source, cb, search)
--     local src = source
--     local FoundByName = GetPlayerByName(search)
--     if FoundByName ~= false then
--         local ReturnData = {}
--         LSCore.Functions.ExecuteSql(true, 'SELECT * FROM `player_houses` WHERE `citizenid` = "'..FoundByName.citizenid..'"', function(result)
--             if result ~= nil and result[1] ~= nil then
--                 for k, v in pairs(result) do
--                     local InputData = {}
--                     InputData['CitizenId'] = FoundByName.citizenid
--                     InputData['CharName'] = LSCore.Functions.GetPlayerCharName(FoundByName.citizenid)
--                     InputData['Tier'] = v.tier
--                     InputData['Coords'] = json.decode(v.coords)
--                     InputData['HasGarage'] = v.hasgarage
--                     InputData['Label'] = v.label
--                     table.insert(ReturnData, InputData)
--                 end
--             end
--         end)
--         cb(ReturnData)
--     end
-- end)

function GetPlayerByName(Name)
    local ReturnInfo = false
    LSCore.Functions.ExecuteSql(true, 'SELECT * FROM `players` WHERE `charinfo` LIKE "%'..Name..'%"', function(result)
        if result[1] ~= nil then
            ReturnInfo = result[1]
        else
            ReturnInfo = false
        end
    end)
    return ReturnInfo
end


LSCore.Functions.CreateCallback('framework-phone:server:GetVehicleSearchResults', function(source, cb, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}
    LSCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_vehicles` WHERE `plate` LIKE "%'..search..'%" OR `citizenid` = "'..search..'"', function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                LSCore.Functions.ExecuteSql(true, 'SELECT * FROM `players` WHERE `citizenid` = "'..result[k].citizenid..'"', function(player)
                    if player[1] ~= nil then
                        local charinfo = json.decode(player[1].charinfo)
                        local vehicleInfo = LSCore.Shared.Vehicles[result[k].vehicle]
                        if vehicleInfo ~= nil then
                            table.insert(searchData, {
                                plate = result[k].plate,
                                status = true,
                                owner = charinfo.firstname .. " " .. charinfo.lastname,
                                citizenid = result[k].citizenid,
                                label = vehicleInfo["Name"]
                            })
                        else
                            table.insert(searchData, {
                                plate = result[k].plate,
                                status = true,
                                owner = charinfo.firstname .. " " .. charinfo.lastname,
                                citizenid = result[k].citizenid,
                                label = "Naam niet gevonden.."
                            })
                        end
                    end
                end)
            end
        else
            if GeneratedPlates[search] ~= nil then
                table.insert(searchData, {
                    plate = GeneratedPlates[search].plate,
                    status = GeneratedPlates[search].status,
                    owner = GeneratedPlates[search].owner,
                    citizenid = GeneratedPlates[search].citizenid,
                    label = "Merk niet bekend.."
                })
            else
                local ownerInfo = GenerateOwnerName()
                GeneratedPlates[search] = {
                    plate = search,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
                table.insert(searchData, {
                    plate = search,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                    label = "Merk niet bekend.."
                })
            end
        end
        cb(searchData)
    end)
end)

RegisterNetEvent('framework-phone:server:employment_JoinTheGroup', function(data)
    local src = source
    for k, v in pairs(EmploymentGroup) do
        for ke, ve in pairs(v['UserName']) do
            if ve == data.PCSN then
                TriggerClientEvent('LSCore:Notify', src, "You have already joined a group!", "error")
                return
            end
        end
        table.insert(EmploymentGroup[data.id]['UserName'], data.PCSN)
        EmploymentGroup[data.id]['Users'] = v.Users + 1
        TriggerClientEvent('LSCore:Notify', src, "You joined the group!", "success")
        TriggerClientEvent('framework-phone:client:EveryoneGrupAddsForAll', -1, EmploymentGroup)
        return
    end
end)
LSCore.Functions.CreateCallback('framework-phone:server:employment_CheckPlayerNames', function(source, cb, csn)
    local Names = {}
    for k, v in pairs(EmploymentGroup[csn]['UserName']) do
        local OtherPlayer = LSCore.Functions.GetPlayerByCitizenId(v)
        if OtherPlayer then
            local Name = OtherPlayer.PlayerData.charinfo.firstname.." "..OtherPlayer.PlayerData.charinfo.lastname
            table.insert(Names, Name)
        end
    end
    cb(Names)
end)

LSCore.Functions.CreateCallback('framework-phone:server:GetGroupCSNs', function(source, cb, csn)
    if EmploymentGroup[csn] then
        cb(EmploymentGroup[csn]['UserName'])
    else
        cb(false)
    end
end)

LSCore.Functions.CreateCallback('framework-phone:server:GetGroupsApp', function(source, cb)
    cb(EmploymentGroup)
end)

LSCore.Functions.CreateCallback('framework-phone:server:ScanPlate', function(source, cb, plate)
    local src = source
    local vehicleData = {}
    if plate ~= nil then
        LSCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_vehicles` WHERE `plate` = "'..plate..'"', function(result)
            if result[1] ~= nil then
                LSCore.Functions.ExecuteSql(true, 'SELECT * FROM `players` WHERE `citizenid` = "'..result[1].citizenid..'"', function(player)
                    local charinfo = json.decode(player[1].charinfo)
                    vehicleData = {
                        plate = plate,
                        status = true,
                        owner = charinfo.firstname .. " " .. charinfo.lastname,
                        citizenid = result[1].citizenid,
                    }
                end)
            elseif GeneratedPlates ~= nil and GeneratedPlates[plate] ~= nil then
                vehicleData = GeneratedPlates[plate]
            else
                local ownerInfo = GenerateOwnerName()
                GeneratedPlates[plate] = {
                    plate = plate,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
                vehicleData = {
                    plate = plate,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
            end
            cb(vehicleData)
        end)
    else
        TriggerClientEvent('LSCore:Notify', src, "Geen voertuig in de buurt..", "error")
        cb(nil)
    end
end)

function GenerateOwnerName()
    local names = {
        [1] = { name = "Jan Bloksteen", citizenid = "DSH091G93" },
        [2] = { name = "Jay Dendam", citizenid = "AVH09M193" },
        [3] = { name = "Ben Klaariskees", citizenid = "DVH091T93" },
        [4] = { name = "Bas Wimpers", citizenid = "GZP091G93" },
        [5] = { name = "Klaas Adriaan", citizenid = "DRH09Z193" },
        [6] = { name = "Nico Wolters", citizenid = "KGV091J93" },
        [7] = { name = "Mark Hendrickx", citizenid = "ODF09S193" },
        [8] = { name = "Bert Johannes", citizenid = "KSD0919H3" },
        [9] = { name = "Karel de Grote", citizenid = "NDX091D93" },
        [10] = { name = "Jan Pieter", citizenid = "ZAL0919X3" },
        [11] = { name = "Huig Roelink", citizenid = "ZAK09D193" },
        [12] = { name = "Corneel Boerselman", citizenid = "POL09F193" },
        [13] = { name = "Hermen Klein Overmeen", citizenid = "TEW0J9193" },
        [14] = { name = "Bart Rielink", citizenid = "YOO09H193" },
        [15] = { name = "Antoon Henselijn", citizenid = "LSC091H93" },
        [16] = { name = "Aad Keizer", citizenid = "YDN091H93" },
        [17] = { name = "Thijn Kiel", citizenid = "PJD09D193" },
        [18] = { name = "Henkie Krikhaar", citizenid = "RND091D93" },
        [19] = { name = "Teun Blaauwkamp", citizenid = "QWE091A93" },
        [20] = { name = "Dries Stielstra", citizenid = "KJH0919M3" },
        [21] = { name = "Karlijn Hensbergen", citizenid = "ZXC09D193" },
        [22] = { name = "Aafke van Daalen", citizenid = "XYZ0919C3" },
        [23] = { name = "Door Leeferds", citizenid = "ZYX0919F3" },
        [24] = { name = "Nelleke Broedersen", citizenid = "IOP091O93" },
        [25] = { name = "Renske de Raaf", citizenid = "PIO091R93" },
        [26] = { name = "Krisje Moltman", citizenid = "LEK091X93" },
        [27] = { name = "Mirre Steevens", citizenid = "ALG091Y93" },
        [28] = { name = "Joosje Kalvenhaar", citizenid = "YUR09E193" },
        [29] = { name = "Mirte Ellenbroek", citizenid = "SOM091W93" },
        [30] = { name = "Marlieke Meilink", citizenid = "KAS09193" },
    }
    return names[math.random(1, #names)]
end

LSCore.Functions.CreateCallback('framework-phone:server:GetGarageVehicles', function(source, cb)
    local ReturnVehicles = {}
    local Player = LSCore.Functions.GetPlayer(source)
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                local VehicleData = LSCore.Shared.Vehicles[v.vehicle]
                local VehicleMeta = json.decode(v.metadata)

                if VehicleData ~= nil then
                    local VehicleState = ""
                    if v.state == 'in' then
                        VehicleState = "Binnen"
                    elseif v.state == 'out' then
                        VehicleState = "Buiten"
                    elseif v.state == 'impounded' then
                        VehicleState = "In Beslag"
                    elseif v.state == 'autoscout' then
                        VehicleState = "Actief op Autoscout"
                    end

                    local VehicleImport = {}
                    if VehicleData["Brand"] ~= nil then
                        VehicleImport.fullname = VehicleData["Brand"] .. " " .. VehicleData["Name"]
                        VehicleImport.brand = VehicleData["Brand"]
                        VehicleImport.model = VehicleData["Name"]
                        VehicleImport.plate = v.plate
                        VehicleImport.garage = v.garage
                        VehicleImport.state = VehicleState
                        VehicleImport.fuel = VehicleMeta['Fuel']
                        VehicleImport.engine = VehicleMeta['Engine']
                        VehicleImport.body = VehicleMeta['Body']
                    else
                        VehicleImport.fullname = VehicleData["Name"]
                        VehicleImport.brand = VehicleData["Brand"]
                        VehicleImport.model = VehicleData["Name"]
                        VehicleImport.plate = v.plate
                        VehicleImport.garage = v.garage
                        VehicleImport.state = VehicleState
                        VehicleImport.fuel = VehicleMeta['Fuel']
                        VehicleImport.engine = VehicleMeta['Engine']
                        VehicleImport.body = VehicleMeta['Body']
                    end
                    table.insert(ReturnVehicles, VehicleImport)
                end
            end
            cb(ReturnVehicles)
        end
    end)
end)

LSCore.Functions.CreateCallback('framework-phone:server:HasPhone', function(source, cb)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local HasPhone = Player.Functions.GetItemByName("phone")
        local retval = false
        if HasPhone ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('framework-phone:server:GiveContactDetails')
AddEventHandler('framework-phone:server:GiveContactDetails', function(PlayerId)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local SuggestionData = {
        name = {
            [1] = Player.PlayerData.charinfo.firstname,
            [2] = Player.PlayerData.charinfo.lastname
        },
        number = Player.PlayerData.charinfo.phone,
        bank = Player.PlayerData.charinfo.account
    }
    TriggerClientEvent('framework-phone:client:AddNewSuggestion', PlayerId, SuggestionData)
end)

RegisterServerEvent('framework-phone:server:AddTransaction')
AddEventHandler('framework-phone:server:AddTransaction', function(data)
end)

LSCore.Functions.CreateCallback('framework-phone:server:GetCurrentLawyers', function(source, cb)
    local Lawyers = {}
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if Player.PlayerData.job.name == "lawyer" then
                table.insert(Lawyers, {
                    name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
                    phone = Player.PlayerData.charinfo.phone,
                })
            end
        end
    end
    cb(Lawyers)
end)

LSCore.Functions.CreateCallback('framework-phone:server:GetCurrentTaxi', function(source, cb)
    local Taxi = {}
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if Player.PlayerData.job.name == "taxi" and Player.PlayerData.job.onduty then
                table.insert(Taxi, {
                    name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
                    phone = Player.PlayerData.charinfo.phone,
                })
            end
        end
    end
    cb(Taxi)
end)

LSCore.Functions.CreateCallback('framework-phone:server:getCurrentAutocare', function(source, cb)
    local Autocare = {}
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        local businessName = nil
        if Player.PlayerData.job.name == "mechanic" then
            businessName = "LowSantos Repairs"
        elseif Player.PlayerData.job.name == "repairshop" then
            businessName = "Mirror Park Tuners"
        end
        if Player ~= nil then
            if (Player.PlayerData.job.name == "mechanic" or Player.PlayerData.job.name == "repairshop") and Player.PlayerData.job.onduty then
                table.insert(Autocare, {
                    name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
                    business = businessName,
                    phone = Player.PlayerData.charinfo.phone,
                })
            end
        end
    end
    cb(Autocare)
end)

LSCore.Functions.CreateCallback('framework-phone:server:GetCurrentEstateagents', function(source, cb)
    local Estateagents = {}
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if Player.PlayerData.job.name == "realestate" then
                table.insert(Estateagents, {
                    name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
                    phone = Player.PlayerData.charinfo.phone,
                })
            end
        end
    end
    cb(Estateagents)
end)

LSCore.Functions.CreateCallback('framework-phone:server:GetCurrentCardealers', function(source, cb)
    local Cardealers = {}
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if Player.PlayerData.job.name == "cardealer" and Player.PlayerData.job.onduty then
                table.insert(Cardealers, {
                    name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
                    phone = Player.PlayerData.charinfo.phone,
                })
            end
        end
    end
    cb(Cardealers)
end)

LSCore.Functions.CreateCallback("framework-phone:server:get:my:houses", function(source, cb)
    local src = source
    local TempTable = {}
    local Player = LSCore.Functions.GetPlayer(src)
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_houses` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result) 
        if result[1] ~= nil then
            for k, v in pairs(result) do 
                local HouseData = {}
                local HouseKeys = json.decode(v.keyholders)
                HouseData['Owner'] = v.citizenid
                HouseData['House'] = v.house
                HouseData['Label'] = v.label
                HouseData['Tier'] = v.tier
                HouseData['Garage'] = v.hasgarage
                HouseData['TotalKeys'] = #HouseKeys
                HouseData['Keyholders'] = {}
                table.insert(TempTable, HouseData)
                for Keys, Holders in pairs(HouseKeys) do
                    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..Holders.."'", function(CharData) 
                        if CharData[1] ~= nil then
                            local CharInfo = json.decode(CharData[1].charinfo)
                            table.insert(TempTable[k]['Keyholders'], {['Name'] = CharInfo.firstname..' '..CharInfo.lastname, ['CitizenId'] = Holders})
                        end
                    end)
                end
            end
        end
        SetTimeout(100, function()
            cb(TempTable)
        end)
    end)
end)

LSCore.Functions.CreateCallback("framework-phone-new:server:get:my:houseskeys", function(source, cb)
    local src = source
    local TempTable = {}
    local Player = LSCore.Functions.GetPlayer(src)
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_houses`", function(result) 
        if result[1] ~= nil then
            for k, v in pairs(result) do
                if v.keyholders ~= nil then
                    for Key, Holder in pairs(json.decode(v.keyholders)) do
                        if Holder == Player.PlayerData.citizenid and (v.citizenid ~= Player.PlayerData.citizenid) then
                            local HouseData = {}
                            local HouseKeys = json.decode(v.keyholders)
                            HouseData['Label'] = v.label
                            HouseData['Tier'] = v.tier
                            HouseData['Garage'] = v.hasgarage
                            HouseData['TotalKeys'] = #HouseKeys
                            HouseData['Coords'] = json.decode(v.coords)['Enter']
                            table.insert(TempTable, HouseData)
                        end
                    end
                end  
            end
            cb(TempTable)
        end
    end)
end)