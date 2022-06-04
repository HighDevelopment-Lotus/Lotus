LSCore = exports['fw-base']:GetCoreObject()

-- Code

local PlayerJob = {}

phoneProp = 0
local phoneModel = `prop_npc_phone_02`

PhoneData = {
    MetaData = {},
    isOpen = false,
    PlayerData = nil,
    Contacts = {},
    Tweets = {},
    MentionedTweets = {},
    Hashtags = {},
    Chats = {},
    Invoices = {},
    CallData = {},
    RecentCalls = {},
    Garage = {},
    Mails = {},
    Adverts = {},
    GarageVehicles = {},
    AnimationData = {
        lib = nil,
        anim = nil,
    },
    SuggestedContacts = {},
    CryptoTransactions = {},
    BankData = {},
}

RegisterNetEvent('framework-phone:client:RaceNotify')
AddEventHandler('framework-phone:client:RaceNotify', function(message)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Racing",
                text = message,
                icon = "fas fa-flag-checkered",
                color = "#353b48",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Racing",
                content = message,
                icon = "fas fa-flag-checkered",
                timeout = 3500,
                color = "#353b48",
            },
        })
    end
end)

RegisterNetEvent('framework-phone:client:AddRecentCall')
AddEventHandler('framework-phone:client:AddRecentCall', function(data, time, type)
    table.insert(PhoneData.RecentCalls, {
        name = IsNumberInContacts(data.number),
        time = time,
        type = type,
        number = data.number,
        anonymous = data.anonymous
    })
    TriggerServerEvent('framework-phone:server:SetPhoneAlerts', "phone")
    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    SendNUIMessage({
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
end)

RegisterNetEvent('LSCore:Client:OnJobUpdate')
AddEventHandler('LSCore:Client:OnJobUpdate', function(JobInfo)
    if JobInfo.name == "police" then
        SendNUIMessage({
            action = "UpdateApplications",
            JobData = JobInfo,
            applications = Config.PhoneApplications
        })
    elseif JobInfo.name == "ambulance" then
        SendNUIMessage({
            action = "UpdateApplications",
            JobData = JobInfo,
            applications = Config.PhoneApplications
        })
    elseif PlayerJob.name == "police" and JobInfo.name == "unemployed" then
        SendNUIMessage({
            action = "UpdateApplications",
            JobData = JobInfo,
            applications = Config.PhoneApplications
        })
    end

    PlayerJob = JobInfo
end)

RegisterNUICallback('ClearRecentAlerts', function(data, cb)
    TriggerServerEvent('framework-phone:server:SetPhoneAlerts', "phone", 0)
    Config.PhoneApplications["phone"].Alerts = 0
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('SetBackground', function(data)
    local background = data.background

    PhoneData.MetaData.background = background
    TriggerServerEvent('framework-phone:server:SaveMetaData', PhoneData.MetaData)
end)

RegisterNUICallback('GetMissedCalls', function(data, cb)
    cb(PhoneData.RecentCalls)
end)

RegisterNUICallback('GetSuggestedContacts', function(data, cb)
    cb(PhoneData.SuggestedContacts)
end)

function IsNumberInContacts(num)
    local retval = num
    for _, v in pairs(PhoneData.Contacts) do
        if num == v.number then
            retval = v.name
        end
    end
    return retval
end

local isLoggedIn = false

RegisterCommand("phone", function ()
    if not PhoneData.isOpen then
        local Player = LSCore.Functions.GetPlayerData()
        if not Player.metadata['ishandcuffed'] and not Player.metadata['isdead'] then
            OpenPhone()
        else
            LSCore.Functions.Notify("Actie momenteel niet mogelijk..", "error")
        end
    end
end, false)

RegisterKeyMapping('phone', 'Mobiel', 'keyboard', 'm')

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()

    local obj = {}

	if minute <= 9 then
		minute = "0" .. minute
    end

    obj.hour = hour
    obj.minute = minute

    return obj
end

Citizen.CreateThread(function()
    while true do
        if PhoneData.isOpen then
            SendNUIMessage({
                action = "UpdateTime",
                InGameTime = CalculateTimeToDisplay(),
            })
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        if isLoggedIn then
            LSCore.Functions.TriggerCallback('framework-phone:server:GetPhoneData', function(pData)
                if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then
                    PhoneData.Contacts = pData.PlayerContacts
                end

                SendNUIMessage({
                    action = "RefreshContacts",
                    Contacts = PhoneData.Contacts
                })
            end)
        end
    end
end)

function LoadPhone()
    Citizen.Wait(100)
    isLoggedIn = true
    LSCore.Functions.TriggerCallback('framework-phone:server:GetPhoneData', function(pData)
        PlayerJob = LSCore.Functions.GetPlayerData().job
        PhoneData.PlayerData = LSCore.Functions.GetPlayerData()
        local PhoneMeta = PhoneData.PlayerData.metadata["phone"]
        PhoneData.MetaData = PhoneMeta

        if PhoneMeta.profilepicture == nil then
            PhoneData.MetaData.profilepicture = "default"
        else
            PhoneData.MetaData.profilepicture = PhoneMeta.profilepicture
        end

        if pData.Applications ~= nil and next(pData.Applications) ~= nil then
            for k, v in pairs(pData.Applications) do
                Config.PhoneApplications[k].Alerts = v
            end
        end

        if pData.MentionedTweets ~= nil and next(pData.MentionedTweets) ~= nil then
            PhoneData.MentionedTweets = pData.MentionedTweets
        end

        if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then
            PhoneData.Contacts = pData.PlayerContacts
        end

        if pData.Chats ~= nil and next(pData.Chats) ~= nil then
            local Chats = {}
            for k, v in pairs(pData.Chats) do
                Chats[v.number] = {
                    name = IsNumberInContacts(v.number),
                    number = v.number,
                    messages = json.decode(v.messages)
                }
            end

            PhoneData.Chats = Chats
        end

        if pData.Invoices ~= nil and next(pData.Invoices) ~= nil then
            for _, invoice in pairs(pData.Invoices) do
                invoice.name = IsNumberInContacts(invoice.number)
            end
            PhoneData.Invoices = pData.Invoices
        end

        if pData.Hashtags ~= nil and next(pData.Hashtags) ~= nil then
            PhoneData.Hashtags = pData.Hashtags
        end

        if pData.Tweets ~= nil and next(pData.Tweets) ~= nil then
            PhoneData.Tweets = pData.Tweets
        end

        if pData.Mails ~= nil and next(pData.Mails) ~= nil then
            PhoneData.Mails = pData.Mails
        end

        if pData.Adverts ~= nil and next(pData.Adverts) ~= nil then
            PhoneData.Adverts = pData.Adverts
        end

        if pData.CryptoTransactions ~= nil and next(pData.CryptoTransactions) ~= nil then
            PhoneData.CryptoTransactions = pData.CryptoTransactions
        end

        if pData.BankData ~= nil and next(pData.BankData) ~= nil then
            PhoneData.BankData = pData.BankData
        end

        Citizen.Wait(300)

        SendNUIMessage({
            action = "LoadPhoneData",
            PhoneData = PhoneData,
            PlayerData = PhoneData.PlayerData,
            PlayerJob = PhoneData.PlayerData.job,
            applications = Config.PhoneApplications
        })
    end)
end

Citizen.CreateThread(function()
    Wait(500)
    LoadPhone()
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    PhoneData = {
        MetaData = {},
        isOpen = false,
        PlayerData = nil,
        Contacts = {},
        Tweets = {},
        MentionedTweets = {},
        Hashtags = {},
        Chats = {},
        Invoices = {},
        CallData = {},
        RecentCalls = {},
        Garage = {},
        Mails = {},
        Adverts = {},
        GarageVehicles = {},
        AnimationData = {
            lib = nil,
            anim = nil,
        },
        SuggestedContacts = {},
        CryptoTransactions = {},
        BankData = {}
    }

    isLoggedIn = false
end)

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    LoadPhone()
end)

RegisterNUICallback('HasPhone', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-phone:server:HasPhone', function(HasPhone)
        cb(HasPhone)
    end)
end)

function OpenPhone()
    LSCore.Functions.TriggerCallback('framework-phone:server:HasPhone', function(HasPhone)
        if HasPhone then
            PhoneData.PlayerData = LSCore.Functions.GetPlayerData()
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "open",
                Tweets = PhoneData.Tweets,
                AppData = Config.PhoneApplications,
                CallData = PhoneData.CallData,
                PlayerData = PhoneData.PlayerData,
            })
            PhoneData.isOpen = true

            Citizen.CreateThread(function()
                while PhoneData.isOpen do
                    DisableDisplayControlActions()
                    Citizen.Wait(1)
                end
            end)
            if not PhoneData.CallData.InCall then
                DoPhoneAnimation('cellphone_text_in')
            else
                DoPhoneAnimation('cellphone_call_to_text')
            end

            SetTimeout(250, function()
                newPhoneProp()
            end)

            LSCore.Functions.TriggerCallback('framework-phone:server:GetGarageVehicles', function(vehicles)
                PhoneData.GarageVehicles = vehicles
            end)
        else
            LSCore.Functions.Notify("Je hebt geen Telefoon", "error")
        end
    end)
end

RegisterNUICallback('SetupGarageVehicles', function(data, cb)
    cb(PhoneData.GarageVehicles)
end)

RegisterNUICallback('SetupSharedAccounts', function(data, cb)
    cb(PhoneData.BankData)
end)

RegisterNUICallback('RefreshSharedAccounts', function(data, cb)
    LSCore.Functions.TriggerCallback('LSCore:phone/getSharedAccounts', function(accounts)
        cb(accounts)
    end)
end)

RegisterNUICallback('Close', function()
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SetTimeout(1000, function()
        PhoneData.isOpen = false
    end)
end)

RegisterNUICallback('RemoveMail', function(data, cb)
    local MailId = data.mailId

    TriggerServerEvent('framework-phone:server:RemoveMail', MailId)
    cb('ok')
end)

RegisterNetEvent('framework-phone:client:UpdateMails')
AddEventHandler('framework-phone:client:UpdateMails', function(NewMails)
    SendNUIMessage({
        action = "UpdateMails",
        Mails = NewMails
    })
    PhoneData.Mails = NewMails
end)

RegisterNUICallback('AcceptMailButton', function(data)
    TriggerEvent(data.buttonEvent, data.buttonData)
    TriggerServerEvent('framework-phone:server:ClearButtonData', data.mailId)
end)

RegisterNetEvent('framework-phone:client:force:close')
AddEventHandler('framework-phone:client:force:close', function()
    DoPhoneAnimation('cellphone_text_out')
    SetTimeout(400, function()
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end)
    SendNuiMessage({
        action = 'close-force'
    })
    SetNuiFocus(false, false)
    PhoneData.isOpen = false
end)

RegisterNUICallback('AddNewContact', function(data, cb)
    table.insert(PhoneData.Contacts, {
        name = data.ContactName,
        number = data.ContactNumber,
        iban = data.ContactIban
    })
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[data.ContactNumber] ~= nil and next(PhoneData.Chats[data.ContactNumber]) ~= nil then
        PhoneData.Chats[data.ContactNumber].name = data.ContactName
    end
    TriggerServerEvent('framework-phone:server:AddNewContact', data.ContactName, data.ContactNumber, data.ContactIban)
end)

RegisterNUICallback('GetMails', function(data, cb)
    cb(PhoneData.Mails)
end)

RegisterNUICallback('GetWhatsappChat', function(data, cb)
    if PhoneData.Chats[data.phone] ~= nil then
        cb(PhoneData.Chats[data.phone])
    else
        cb(false)
    end
end)

RegisterNUICallback('GetProfilePicture', function(data, cb)
    local number = data.number

    LSCore.Functions.TriggerCallback('framework-phone:server:GetPicture', function(picture)
        cb(picture)
    end, number)
end)

RegisterNUICallback('GetBankContacts', function(data, cb)
    cb(PhoneData.Contacts)
end)

RegisterNUICallback('GetInvoices', function(data, cb)
    if PhoneData.Invoices ~= nil and next(PhoneData.Invoices) ~= nil then
        cb(PhoneData.Invoices)
    else
        cb(nil)
    end
end)

function GetKeyByDate(Number, Date)
    local retval = nil
    if PhoneData.Chats[Number] ~= nil then
        if PhoneData.Chats[Number].messages ~= nil then
            for key, chat in pairs(PhoneData.Chats[Number].messages) do
                if chat.date == Date then
                    retval = key
                    break
                end
            end
        end
    end
    return retval
end

function GetKeyByNumber(Number)
    local retval = nil
    if PhoneData.Chats then
        for k, v in pairs(PhoneData.Chats) do
            if v.number == Number then
                retval = k
            end
        end
    end
    return retval
end

function ReorganizeChats(key)
    local ReorganizedChats = {}
    ReorganizedChats[1] = PhoneData.Chats[key]
    for k, chat in pairs(PhoneData.Chats) do
        if k ~= key then
            table.insert(ReorganizedChats, chat)
        end
    end
    PhoneData.Chats = ReorganizedChats
end

RegisterNUICallback('SendMessage', function(data, cb)
    local ChatMessage = data.ChatMessage
    local ChatDate = data.ChatDate
    local ChatNumber = data.ChatNumber
    local ChatTime = data.ChatTime
    local ChatType = data.ChatType

    local Ped = GetPlayerPed(-1)
    local Pos = GetEntityCoords(Ped)
    local NumberKey = GetKeyByNumber(ChatNumber)
    local ChatKey = GetKeyByDate(NumberKey, ChatDate)

    if PhoneData.Chats[NumberKey] ~= nil then
        if PhoneData.Chats[NumberKey].messages[ChatKey] ~= nil then
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = "Gedeelde Locatie",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })
            end
            TriggerServerEvent('framework-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, false)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        else
            table.insert(PhoneData.Chats[NumberKey].messages, {
                date = ChatDate,
                messages = {},
            })
            ChatKey = GetKeyByDate(NumberKey, ChatDate)
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatDate].messages, {
                    message = "Gedeelde Locatie",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })
            end
            TriggerServerEvent('framework-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        end
    else
        table.insert(PhoneData.Chats, {
            name = IsNumberInContacts(ChatNumber),
            number = ChatNumber,
            messages = {},
        })
        NumberKey = GetKeyByNumber(ChatNumber)
        table.insert(PhoneData.Chats[NumberKey].messages, {
            date = ChatDate,
            messages = {},
        })
        ChatKey = GetKeyByDate(NumberKey, ChatDate)
        if ChatType == "message" then
            table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                message = ChatMessage,
                time = ChatTime,
                sender = PhoneData.PlayerData.citizenid,
                type = ChatType,
                data = {},
            })
        elseif ChatType == "location" then
            table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                message = "Gedeelde Locatie",
                time = ChatTime,
                sender = PhoneData.PlayerData.citizenid,
                type = ChatType,
                data = {
                    x = Pos.x,
                    y = Pos.y,
                },
            })
        end
        TriggerServerEvent('framework-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
        NumberKey = GetKeyByNumber(ChatNumber)
        ReorganizeChats(NumberKey)
    end

    LSCore.Functions.TriggerCallback('framework-phone:server:GetContactPicture', function(Chat)
        SendNUIMessage({
            action = "UpdateChat",
            chatData = Chat,
            chatNumber = ChatNumber,
        })
    end,  PhoneData.Chats[GetKeyByNumber(ChatNumber)])
end)

RegisterNUICallback('SharedLocation', function(data)
    local x = data.coords.x
    local y = data.coords.y

    SetNewWaypoint(x, y)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Whatsapp",
            text = "Locatie is ingesteld!",
            icon = "fab fa-whatsapp",
            color = "#25D366",
            timeout = 1500,
        },
    })
end)

RegisterNetEvent('framework-phone:client:UpdateMessages')
AddEventHandler('framework-phone:client:UpdateMessages', function(ChatMessages, SenderNumber, New)
    local Sender = IsNumberInContacts(SenderNumber)

    local NumberKey = GetKeyByNumber(SenderNumber)

    if New then
        PhoneData.Chats[NumberKey] = {
            name = IsNumberInContacts(SenderNumber),
            number = SenderNumber,
            messages = ChatMessages
        }

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Nieuw bericht van "..IsNumberInContacts(SenderNumber).."!",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Waarom stuur je berichtjes naar jezelf you sadfuck?",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Wait(100)
            LSCore.Functions.TriggerCallback('framework-phone:server:GetContactPictures', function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        else
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = "Whatsapp",
                    content = "Je hebt een nieuw bericht ontvangen van "..IsNumberInContacts(SenderNumber).."!",
                    icon = "fab fa-whatsapp",
                    timeout = 3500,
                    color = "#25D366",
                },
            })
            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('framework-phone:server:SetPhoneAlerts', "whatsapp")
        end
    else
        PhoneData.Chats[NumberKey].messages = ChatMessages

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Nieuw bericht van "..IsNumberInContacts(SenderNumber).."!",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Waarom stuur je berichtjes naar jezelf you sadfuck?",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Wait(100)
            LSCore.Functions.TriggerCallback('framework-phone:server:GetContactPictures', function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        else
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = "Whatsapp",
                    content = "Je hebt een nieuw bericht ontvangen van "..IsNumberInContacts(SenderNumber).."!",
                    icon = "fab fa-whatsapp",
                    timeout = 3500,
                    color = "#25D366",
                },
            })

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('framework-phone:server:SetPhoneAlerts', "whatsapp")
        end
    end
end)

RegisterNetEvent("framework-phone:client:BankNotify")
AddEventHandler("framework-phone:client:BankNotify", function(text)
    print('wow')
    SendNUIMessage({
        action = "Notification",
        NotifyData = {
            title = "Bank",
            content = text,
            icon = "fas fa-university",
            timeout = 3500,
            color = "#ff002f",
        },
    })
end)

RegisterNetEvent('framework-phone:client:NewMailNotify')
AddEventHandler('framework-phone:client:NewMailNotify', function(MailData)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Mail",
                text = "Je hebt een nieuwe Mail ontvangen van "..MailData.sender,
                icon = "fas fa-envelope",
                color = "#ff002f",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Mail",
                content = "Je hebt een nieuwe Mail ontvangen van "..MailData.sender,
                icon = "fas fa-envelope",
                timeout = 3500,
                color = "#ff002f",
            },
        })
    end
    Config.PhoneApplications['mail'].Alerts = Config.PhoneApplications['mail'].Alerts + 1
    TriggerServerEvent('framework-phone:server:SetPhoneAlerts', "mail")
end)

RegisterNUICallback('PostAdvert', function(data)
    TriggerServerEvent('framework-phone:server:AddAdvert', data.message)
end)

RegisterNetEvent('framework-phone:client:UpdateAdverts')
AddEventHandler('framework-phone:client:UpdateAdverts', function(Adverts, LastAd)
    PhoneData.Adverts = Adverts

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Advertentie",
                text = "Er is een nieuwe AD gepost door "..LastAd,
                icon = "fas fa-ad",
                color = "#ff8f1a",
                timeout = 2500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Advertentie",
                content = "Er is een nieuwe AD gepost door "..LastAd,
                icon = "fas fa-ad",
                timeout = 2500,
                color = "#ff8f1a",
            },
        })
    end

    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('LoadAdverts', function()
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('ClearAlerts', function(data, cb)
    local chat = data.number
    local ChatKey = GetKeyByNumber(chat)

    if PhoneData.Chats[ChatKey].Unread ~= nil then
        local newAlerts = (Config.PhoneApplications['whatsapp'].Alerts - PhoneData.Chats[ChatKey].Unread)
        Config.PhoneApplications['whatsapp'].Alerts = newAlerts
        TriggerServerEvent('framework-phone:server:SetPhoneAlerts', "whatsapp", newAlerts)

        PhoneData.Chats[ChatKey].Unread = 0

        SendNUIMessage({
            action = "RefreshWhatsappAlerts",
            Chats = PhoneData.Chats,
        })
        SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    end
end)

RegisterNUICallback('PayInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId

    LSCore.Functions.TriggerCallback('framework-phone:server:PayInvoice', function(CanPay, Invoices)
        if CanPay then PhoneData.Invoices = Invoices end
        cb(CanPay)
    end, sender, amount, invoiceId)
end)

RegisterNUICallback('DeclineInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId

    LSCore.Functions.TriggerCallback('framework-phone:server:DeclineInvoice', function(CanPay, Invoices)
        PhoneData.Invoices = Invoices
        cb('ok')
    end, sender, amount, invoiceId)
end)

RegisterNUICallback('EditContact', function(data, cb)
    local NewName = data.CurrentContactName
    local NewNumber = data.CurrentContactNumber
    local NewIban = data.CurrentContactIban
    local OldName = data.OldContactName
    local OldNumber = data.OldContactNumber
    local OldIban = data.OldContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == OldName and v.number == OldNumber then
            v.name = NewName
            v.number = NewNumber
            v.iban = NewIban
        end
    end
    if PhoneData.Chats[NewNumber] ~= nil and next(PhoneData.Chats[NewNumber]) ~= nil then
        PhoneData.Chats[NewNumber].name = NewName
    end
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    TriggerServerEvent('framework-phone:server:EditContact', NewName, NewNumber, NewIban, OldName, OldNumber, OldIban)
end)

local function escape_str(s)
	-- local in_char  = {'\\', '"', '/', '\b', '\f', '\n', '\r', '\t'}
	-- local out_char = {'\\', '"', '/',  'b',  'f',  'n',  'r',  't'}
	-- for i, c in ipairs(in_char) do
	--   s = s:gsub(c, '\\' .. out_char[i])
	-- end
	return s
end

function GenerateTweetId()
    local tweetId = "TWEET-"..math.random(11111111, 99999999)
    return tweetId
end

RegisterNetEvent('framework-phone:client:UpdateHashtags')
AddEventHandler('framework-phone:client:UpdateHashtags', function(Handle, msgData)
    if PhoneData.Hashtags[Handle] ~= nil then
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    else
        PhoneData.Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    end

    SendNUIMessage({
        action = "UpdateHashtags",
        Hashtags = PhoneData.Hashtags,
    })
end)

RegisterNUICallback('GetHashtagMessages', function(data, cb)
    if PhoneData.Hashtags[data.hashtag] ~= nil and next(PhoneData.Hashtags[data.hashtag]) ~= nil then
        cb(PhoneData.Hashtags[data.hashtag])
    else
        cb(nil)
    end
end)

RegisterNUICallback('GetTweets', function(data, cb)
    cb(PhoneData.Tweets)
end)

RegisterNUICallback('UpdateProfilePicture', function(data)
    local pf = data.profilepicture

    PhoneData.MetaData.profilepicture = pf

    TriggerServerEvent('framework-phone:server:SaveMetaData', PhoneData.MetaData)
end)

local patt = "[?!@#]"

RegisterNUICallback('PostNewTweet', function(data, cb)
    local TweetMessage = {
        firstName = PhoneData.PlayerData.charinfo.firstname,
        lastName = PhoneData.PlayerData.charinfo.lastname,
        message = escape_str(data.Message),
        time = data.Date,
        tweetId = GenerateTweetId(),
        picture = data.Picture
    }

    local TwitterMessage = data.Message
    local MentionTag = TwitterMessage:split("@")
    local Hashtag = TwitterMessage:split("#")

    if #Hashtag <= 5 then
        for i = 2, #Hashtag, 1 do
            local Handle = Hashtag[i]:split(" ")[1]
            if Handle ~= nil or Handle ~= "" then
                local InvalidSymbol = string.match(Handle, patt)
                if InvalidSymbol then
                    Handle = Handle:gsub("%"..InvalidSymbol, "")
                end
                TriggerServerEvent('framework-phone:server:UpdateHashtags', Handle, TweetMessage)
            end
        end
    end

    for i = 2, #MentionTag, 1 do
        local Handle = MentionTag[i]:split(" ")[1]
        if Handle ~= nil or Handle ~= "" then
            local Fullname = Handle:split("_")
            local Firstname = Fullname[1]
            table.remove(Fullname, 1)
            local Lastname = table.concat(Fullname, " ")

            if (Firstname ~= nil and Firstname ~= "") and (Lastname ~= nil and Lastname ~= "") then
                if Firstname ~= PhoneData.PlayerData.charinfo.firstname and Lastname ~= PhoneData.PlayerData.charinfo.lastname then
                    TriggerServerEvent('framework-phone:server:MentionedPlayer', Firstname, Lastname, TweetMessage)
                else
                    SetTimeout(2500, function()
                        SendNUIMessage({
                            action = "PhoneNotification",
                            PhoneNotify = {
                                title = "Twitter",
                                text = "Je kan jezelf niet mentionen!",
                                icon = "fab fa-twitter",
                                color = "#1DA1F2",
                            },
                        })
                    end)
                end
            end
        end
    end

    table.insert(PhoneData.Tweets, TweetMessage)
    Citizen.Wait(100)
    cb(PhoneData.Tweets)

    TriggerServerEvent('framework-phone:server:UpdateTweets', TweetMessage)
end)

RegisterNetEvent('framework-phone:client:TransferMoney')
AddEventHandler('framework-phone:client:TransferMoney', function(amount, newmoney)
    PhoneData.PlayerData.money.bank = newmoney
    if PhoneData.isOpen then
        SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "LSBank", text = "Er is &euro;"..amount.." bijgeschreven!", icon = "fas fa-university", color = "#8c7ae6", }, })
        SendNUIMessage({ action = "UpdateBank", NewBalance = PhoneData.PlayerData.money.bank })
    else
        SendNUIMessage({ action = "Notification", NotifyData = { title = "LSBank", content = "Er is &euro;"..amount.." bijgeschreven!", icon = "fas fa-university", timeout = 2500, color = nil, }, })
    end
end)

RegisterNetEvent('framework-phone:client:force:update')
AddEventHandler('framework-phone:client:force:update', function(Tweets)
    PhoneData.Tweets = Tweets
end)

RegisterNetEvent('framework-phone:client:UpdateTweets')
AddEventHandler('framework-phone:client:UpdateTweets', function(src, Tweets, NewTweetData)
    PhoneData.Tweets = Tweets
    local MyPlayerId = PhoneData.PlayerData.source

    if src ~= MyPlayerId then
        if not PhoneData.isOpen then
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = "Nieuwe Tweet (@"..NewTweetData.firstName.." "..NewTweetData.lastName..")",
                    content = NewTweetData.message,
                    icon = "fab fa-twitter",
                    timeout = 3500,
                    color = "#1DA1F2",
                },
            })
        else
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Nieuwe Tweet (@"..NewTweetData.firstName.." "..NewTweetData.lastName..")",
                    text = NewTweetData.message,
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                },
            })
        end
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Twitter",
                text = "De tweet is geplaatst!",
                icon = "fab fa-twitter",
                color = "#1DA1F2",
                timeout = 1000,
            },
        })
    end
end)

RegisterNUICallback('GetMentionedTweets', function(data, cb)
    cb(PhoneData.MentionedTweets)
end)

RegisterNUICallback('HTMLMessage', function(data, cb)
    TriggerServerEvent("framework-phone:server:htmlMessage", data.message, data.app)
end)

RegisterNUICallback('GetHashtags', function(data, cb)
    if PhoneData.Hashtags ~= nil and next(PhoneData.Hashtags) ~= nil then
        cb(PhoneData.Hashtags)
    else
        cb(nil)
    end
end)

RegisterNetEvent('framework-phone:client:GetMentioned')
AddEventHandler('framework-phone:client:GetMentioned', function(TweetMessage, AppAlerts)
    Config.PhoneApplications["twitter"].Alerts = AppAlerts
    if not PhoneData.isOpen then
        SendNUIMessage({ action = "Notification", NotifyData = { title = "Je bent gementioned in een Tweet!", content = TweetMessage.message, icon = "fab fa-twitter", timeout = 3500, color = nil, }, })
    else
        SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "Je bent gementioned in een Tweet!", text = TweetMessage.message, icon = "fab fa-twitter", color = "#1DA1F2", }, })
    end
    local TweetMessage = {firstName = TweetMessage.firstName, lastName = TweetMessage.lastName, message = escape_str(TweetMessage.message), time = TweetMessage.time, picture = TweetMessage.picture}
    table.insert(PhoneData.MentionedTweets, TweetMessage)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    SendNUIMessage({ action = "UpdateMentionedTweets", Tweets = PhoneData.MentionedTweets })
end)

RegisterNUICallback('ClearMentions', function()
    Config.PhoneApplications["twitter"].Alerts = 0
    SendNUIMessage({
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
    TriggerServerEvent('framework-phone:server:SetPhoneAlerts', "twitter", 0)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('ClearGeneralAlerts', function(data)
    SetTimeout(400, function()
        Config.PhoneApplications[data.app].Alerts = 0
        SendNUIMessage({
            action = "RefreshAppAlerts",
            AppData = Config.PhoneApplications
        })
        TriggerServerEvent('framework-phone:server:SetPhoneAlerts', data.app, 0)
        SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    end)
end)

function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end

RegisterNUICallback('TransferMoney', function(data, cb)
    data.amount = tonumber(data.amount)
    if tonumber(PhoneData.PlayerData.money.bank) >= data.amount then
        local amaountata = PhoneData.PlayerData.money.bank - data.amount
        TriggerServerEvent('framework-phone:server:TransferMoney', data.iban, data.amount)
        local cbdata = {
            CanTransfer = true,
            NewAmount = amaountata
        }
        cb(cbdata)
    else
        local cbdata = {
            CanTransfer = false,
            NewAmount = nil,
        }
        cb(cbdata)
    end
end)

RegisterNUICallback('GetWhatsappChats', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-phone:server:GetContactPictures', function(Chats)
        cb(Chats)
    end, PhoneData.Chats)
end)

RegisterNUICallback('CallContact', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-phone:server:GetCallState', function(CanCall, IsOnline)
        local status = {
            CanCall = CanCall,
            IsOnline = IsOnline,
            InCall = PhoneData.CallData.InCall,
        }
        cb(status)
        if CanCall and not status.InCall and (data.ContactData.number ~= PhoneData.PlayerData.charinfo.phone) then
            CallContact(data.ContactData, data.Anonymous)
        end
    end, data.ContactData)
end)

function GenerateCallId(caller, target)
    local CallId = math.ceil(((tonumber(caller) + tonumber(target)) / 100 * 1))
    return CallId
end

CallContact = function(CallData, AnonymousCall)
    local RepeatCount = 0
    PhoneData.CallData.CallType = "outgoing"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.CallId = GenerateCallId(PhoneData.PlayerData.charinfo.phone, CallData.number)

    TriggerServerEvent('framework-phone:server:CallContact', PhoneData.CallData.TargetData, PhoneData.CallData.CallId, AnonymousCall)
    TriggerServerEvent('framework-phone:server:SetCallState', true)

    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerServerEvent('framework-sound:server:play:distance', 2.0, 'phone-ringing', 0.1)
                else
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                CancelCall()
                break
            end
        else
            break
        end
    end
end

CancelCall = function()
    TriggerServerEvent('framework-phone:server:CancelCall', PhoneData.CallData)
    if PhoneData.CallData.CallType == "ongoing" then
        exports['fw-voice']:removePlayerFromCall(PhoneData.CallData.CallId)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}
    PhoneData.CallData.CallId = nil

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('framework-phone:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Telefoon",
                content = "De oproep is beëindigd",
                icon = "fas fa-phone",
                timeout = 3500,
                color = "#e84118",
            },
        })
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Telefoon",
                text = "De oproep is beëindigd",
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end

RegisterNetEvent('framework-phone:client:CancelCall')
AddEventHandler('framework-phone:client:CancelCall', function()
    if PhoneData.CallData.CallType == "ongoing" then
        SendNUIMessage({
            action = "CancelOngoingCall"
        })
        exports['fw-voice']:addPlayerToCall(PhoneData.CallData.CallId)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('framework-phone:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Telefoon",
                content = "De oproep is beëindigd",
                icon = "fas fa-phone",
                timeout = 3500,
                color = "#e84118",
            },
        })
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Telefoon",
                text = "De oproep is beëindigd",
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end)

RegisterNetEvent('framework-phone:client:GetCalled')
AddEventHandler('framework-phone:client:GetCalled', function(CallerNumber, CallId, AnonymousCall)
    local RepeatCount = 0
    local CallData = {
        number = CallerNumber,
        name = IsNumberInContacts(CallerNumber),
        anonymous = AnonymousCall
    }

    print(AnonymousCall)

    if AnonymousCall then
        CallData.name = "Anoniem"
    end

    PhoneData.CallData.CallType = "incoming"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.CallId = CallId

    TriggerServerEvent('framework-phone:server:SetCallState', true)

    SendNUIMessage({
        action = "SetupHomeCall",
        CallData = PhoneData.CallData,
    })

    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerServerEvent('framework-sound:server:play:distance', 2.0, 'phone-ringing2', 0.1)

                    if not PhoneData.isOpen then
                        SendNUIMessage({
                            action = "IncomingCallAlert",
                            CallData = PhoneData.CallData.TargetData,
                            Canceled = false,
                            AnonymousCall = AnonymousCall,
                        })
                    end
                else
                    SendNUIMessage({
                        action = "IncomingCallAlert",
                        CallData = PhoneData.CallData.TargetData,
                        Canceled = true,
                        AnonymousCall = AnonymousCall,
                    })
                    TriggerServerEvent('framework-phone:server:AddRecentCall', "missed", CallData)
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                SendNUIMessage({
                    action = "IncomingCallAlert",
                    CallData = PhoneData.CallData.TargetData,
                    Canceled = true,
                    AnonymousCall = AnonymousCall,
                })
                TriggerServerEvent('framework-phone:server:AddRecentCall', "missed", CallData)
                break
            end
        else
            TriggerServerEvent('framework-phone:server:AddRecentCall', "missed", CallData)
            break
        end
    end
end)

RegisterNUICallback('CancelOutgoingCall', function()
    CancelCall()
end)

RegisterNUICallback('DenyIncomingCall', function()
    CancelCall()
end)

RegisterNUICallback('CancelOngoingCall', function()
    CancelCall()
end)

RegisterNUICallback('AnswerCall', function()
    AnswerCall()
end)

function AnswerCall()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('framework-phone:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)

        TriggerServerEvent('framework-phone:server:AnswerCall', PhoneData.CallData)
        exports['fw-voice']:addPlayerToCall(PhoneData.CallData.CallId)
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Telefoon",
                text = "Je hebt geen inkomende oproep...",
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })
    end
end

RegisterNetEvent('framework-phone:client:AnswerCall')
AddEventHandler('framework-phone:client:AnswerCall', function()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('framework-phone:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)

        exports['fw-voice']:addPlayerToCall(PhoneData.CallData.CallId)
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Telefoon",
                text = "Je hebt geen inkomende oproep...",
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })
    end
end)

-- AddEventHandler('onResourceStop', function(resource)
--     if resource == GetCurrentResourceName() then
--         -- SetNuiFocus(false, false)
--     end
-- end)

RegisterNUICallback('FetchSearchResults', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-phone:server:FetchResult', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleResults', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-phone:server:GetVehicleSearchResults', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleScan', function(data, cb)
    local vehicle = LSCore.Functions.GetClosestVehicle()
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetEntityModel(vehicle)
    LSCore.Functions.TriggerCallback('framework-phone:server:ScanPlate', function(result)
        local vehicleInfo = LSCore.Shared.Vehicles[model] ~= nil and LSCore.Shared.Vehicles[model] or {["brand"] = "Onbekend merk..", ["name"] = ""}
        result.label = vehicleInfo["name"]
        cb(result)
    end, plate)
end)

RegisterNetEvent('framework-phone:client:addPoliceAlert')
AddEventHandler('framework-phone:client:addPoliceAlert', function(alertData)
    if PlayerJob.name == 'police' and PlayerJob.onduty then
        SendNUIMessage({
            action = "AddPoliceAlert",
            alert = alertData,
        })
    end
end)

RegisterNetEvent('framework-phone:client:addPagerAlert')
AddEventHandler('framework-phone:client:addPagerAlert', function(alertData)
    if PlayerJob.name == 'ambulance' and PlayerJob.onduty then
        SendNUIMessage({
            action = "AddPagerAlert",
            alert = alertData,
        })
    end
end)

RegisterNUICallback('SetAlertWaypoint', function(data)
    local coords = data.alert.coords

    LSCore.Functions.Notify('GPS Locatie ingesteld: '..data.alert.title)
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterNUICallback('RemoveSuggestion', function(data, cb)
    local data = data.data

    if PhoneData.SuggestedContacts ~= nil and next(PhoneData.SuggestedContacts) ~= nil then
        for k, v in pairs(PhoneData.SuggestedContacts) do
            if (data.name[1] == v.name[1] and data.name[2] == v.name[2]) and data.number == v.number and data.bank == v.bank then
                table.remove(PhoneData.SuggestedContacts, k)
            end
        end
    end
end)

function GetClosestPlayer()
    local closestPlayers = LSCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

RegisterNetEvent('framework-phone:client:GiveContactDetails')
AddEventHandler('framework-phone:client:GiveContactDetails', function()
    local ped = GetPlayerPed(-1)

    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local PlayerId = GetPlayerServerId(player)
        TriggerServerEvent('framework-phone:server:GiveContactDetails', PlayerId)
    else
        LSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

-- Citizen.CreateThread(function()
--     Wait(1000)
--     TriggerServerEvent('framework-phone:server:GiveContactDetails', 1)
-- end)

RegisterNUICallback('DeleteContact', function(data, cb)
    local Name = data.CurrentContactName
    local Number = data.CurrentContactNumber
    local Account = data.CurrentContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == Name and v.number == Number then
            table.remove(PhoneData.Contacts, k)
            if PhoneData.isOpen then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Telefoon",
                        text = "Je hebt contact verwijderd!",
                        icon = "fa fa-phone-alt",
                        color = "#04b543",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "Notification",
                    NotifyData = {
                        title = "Telefoon",
                        content = "Je hebt contact verwijderd!",
                        icon = "fa fa-phone-alt",
                        timeout = 3500,
                        color = "#04b543",
                    },
                })
            end
            break
        end
    end
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[Number] ~= nil and next(PhoneData.Chats[Number]) ~= nil then
        PhoneData.Chats[Number].name = Number
    end
    TriggerServerEvent('framework-phone:server:RemoveContact', Name, Number)
end)

RegisterNetEvent('framework-phone:client:AddNewSuggestion')
AddEventHandler('framework-phone:client:AddNewSuggestion', function(SuggestionData)
    table.insert(PhoneData.SuggestedContacts, SuggestionData)

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Telefoon",
                text = "Je hebt een nieuw voorgesteld contact!",
                icon = "fa fa-phone-alt",
                color = "#04b543",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Telefoon",
                content = "Je hebt een nieuw voorgesteld contact!",
                icon = "fa fa-phone-alt",
                timeout = 3500,
                color = "#04b543",
            },
        })
    end

    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    TriggerServerEvent('framework-phone:server:SetPhoneAlerts', "phone", Config.PhoneApplications["phone"].Alerts)
end)

RegisterNUICallback('GetCryptoData', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-crypto:server:GetCryptoData', function(CryptoData)
        cb(CryptoData)
    end, data.crypto)
end)

RegisterNUICallback('BuyCrypto', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-crypto:server:BuyCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNUICallback('SellCrypto', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-crypto:server:SellCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNUICallback('TransferCrypto', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-crypto:server:TransferCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNetEvent('framework-phone:client:RemoveBankMoney')
AddEventHandler('framework-phone:client:RemoveBankMoney', function(amount)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Bank",
                text = "Er is €"..amount..",- van je bank afgeschreven!",
                icon = "fas fa-university",
                color = "#ff002f",
                timeout = 3500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Bank",
                content = "Er is €"..amount..",- van je bank afgeschreven!",
                icon = "fas fa-university",
                timeout = 3500,
                color = "#ff002f",
            },
        })
    end
end)

RegisterNetEvent('framework-phone:client:AddTransaction')
AddEventHandler('framework-phone:client:AddTransaction', function(SenderData, TransactionData, Message, Title)
    local Data = {
        TransactionTitle = Title,
        TransactionMessage = Message,
    }

    table.insert(PhoneData.CryptoTransactions, Data)

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Crypto",
                text = Message,
                icon = "fas fa-chart-pie",
                color = "#04b543",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Crypto",
                content = Message,
                icon = "fas fa-chart-pie",
                timeout = 3500,
                color = "#04b543",
            },
        })
    end

    SendNUIMessage({
        action = "UpdateTransactions",
        CryptoTransactions = PhoneData.CryptoTransactions
    })

    TriggerServerEvent('framework-phone:server:AddTransaction', Data)
end)

RegisterNUICallback('GetCryptoTransactions', function(data, cb)
    local Data = {
        CryptoTransactions = PhoneData.CryptoTransactions
    }
    cb(Data)
end)

RegisterNUICallback('GetAvailableRaces', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-lapraces:server:GetRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('JoinRace', function(data)
    TriggerServerEvent('framework-lapraces:server:JoinRace', data.RaceData)
end)

RegisterNUICallback('LeaveRace', function(data)
    TriggerServerEvent('framework-lapraces:server:LeaveRace', data.RaceData)
end)

RegisterNUICallback('StartRace', function(data)
    TriggerServerEvent('framework-lapraces:server:StartRace', data.RaceData.RaceId)
end)

RegisterNetEvent('framework-phone:client:UpdateLapraces')
AddEventHandler('framework-phone:client:UpdateLapraces', function()
    SendNUIMessage({
        action = "UpdateRacingApp",
    })
end)

RegisterNUICallback('GetRaces', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-lapraces:server:GetListedRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('GetTrackData', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-lapraces:server:GetTrackData', function(TrackData, CreatorData)
        TrackData.CreatorData = CreatorData
        cb(TrackData)
    end, data.RaceId)
end)

RegisterNUICallback('SetupRace', function(data, cb)
    TriggerServerEvent('framework-lapraces:server:SetupRace', data.RaceId, tonumber(data.AmountOfLaps))
end)

RegisterNUICallback('HasCreatedRace', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-lapraces:server:HasCreatedRace', function(HasCreated)
        cb(HasCreated)
    end)
end)

RegisterNUICallback('IsInRace', function(data, cb)
    local InRace = exports['fw-lapraces']:IsInRace()
    print(InRace)
    cb(InRace)
end)

RegisterNUICallback('IsAuthorizedToCreateRaces', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-lapraces:server:IsAuthorizedToCreateRaces', function(IsAuthorized, NameAvailable)
        local data = {
            IsAuthorized = IsAuthorized,
            IsBusy = exports['fw-lapraces']:IsInEditor(),
            IsNameAvailable = NameAvailable,
        }
        cb(data)
    end, data.TrackName)
end)

RegisterNUICallback('StartTrackEditor', function(data, cb)
    TriggerServerEvent('framework-lapraces:server:CreateLapRace', data.TrackName)
end)

RegisterNUICallback('GetRacingLeaderboards', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-lapraces:server:GetRacingLeaderboards', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('RaceDistanceCheck', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-lapraces:server:GetRacingData', function(RaceData)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local checkpointcoords = RaceData.Checkpoints[1].coords
        local dist = GetDistanceBetweenCoords(coords, checkpointcoords.x, checkpointcoords.y, checkpointcoords.z, true)
        print(dist)
        if dist <= 115.0 then
            if data.Joined then
                TriggerEvent('framework-lapraces:client:WaitingDistanceCheck')
            end
            cb(true)
        else
            LSCore.Functions.Notify('Je bent te ver van de race. Je navigatie is ingesteld naar de race.', 'error', 5000)
            SetNewWaypoint(checkpointcoords.x, checkpointcoords.y)
            cb(false)
        end
    end, data.RaceId)
end)

RegisterNUICallback('IsBusyCheck', function(data, cb)
    if data.check == "editor" then
        cb(exports['fw-lapraces']:IsInEditor())
    else
        cb(exports['fw-lapraces']:IsInRace())
    end
end)

RegisterNUICallback('CanRaceSetup', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-lapraces:server:CanRaceSetup', function(CanSetup)
        cb(CanSetup)
    end)
end)

RegisterNUICallback('GetPlayerHouses', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-phone:server:get:my:houses', function(Houses)
        cb(Houses)
    end)
end)

RegisterNUICallback('GetPlayerKeys', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-phone:server:get:my:houseskeys', function(Houses)
        cb(Houses)
    end)
end)

RegisterNUICallback('RemoveKeyholder', function(data)
    TriggerServerEvent('framework-housing:server:remove:house:key', data.House, data.RemoveCid)
end)

RegisterNUICallback('ChangeOwner', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-housing:server:TransferCid', function(DidTransfer)
        if DidTransfer then
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Huizen",
                    text = "Je huis is overgezet!",
                    icon = "far fa-check-circle",
                    color = "#00FF00",
                    timeout = 1500,
                },
            })
        else
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Huizen",
                    text = "Foutief BSN",
                    icon = "far fa-times-circle",
                    color = "#FF0000",
                    timeout = 1500,
                },
            })
        end
        cb(DidTransfer)
    end, data.newCid, data.HouseData)
end)

RegisterNUICallback('FetchPlayerHouses', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-phone:server:MeosGetPlayerHouses', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('SetGPSLocation', function(data, cb)
    SetNewWaypoint(data.CoordsX, data.CoordsY)
    LSCore.Functions.Notify('GPS is ingesteld!', 'success')
end)

RegisterNUICallback('setwaypoint', function(data)
    print(data.CoordsX, data.CoordsY)
    SetNewWaypoint(data.CoordsX, data.CoordsY)
    LSCore.Functions.Notify('GPS is ingesteld!', 'success')
end)

RegisterNUICallback('SetApartmentLocation', function(data, cb)
    local ApartmentData = data.data.appartmentdata
    local TypeData = Apartments.Locations[ApartmentData.type]

    SetNewWaypoint(TypeData.coords.enter.x, TypeData.coords.enter.y)
    LSCore.Functions.Notify('GPS is ingesteld!', 'success')
end)

RegisterNUICallback('GetCurrentLawyers', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-phone:server:GetCurrentLawyers', function(lawyers)
        cb(lawyers)
    end)
end)

RegisterNUICallback('GetCurrentAutocare', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-phone:server:getCurrentAutocare', function(autocare)
        cb(autocare)
    end)
end)

RegisterNUICallback('GetCurrentEstateagents', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-phone:server:GetCurrentEstateagents', function(estateagents)
        cb(estateagents)
    end)
end)

RegisterNUICallback('GetCurrentTaxi', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-phone:server:GetCurrentTaxi', function(taxis)
        cb(taxis)
    end)
end)

RegisterNUICallback('GetCurrentCardealers', function(data, cb)
    LSCore.Functions.TriggerCallback('framework-phone:server:GetCurrentCardealers', function(cardealers)
        cb(cardealers)
    end)
end)

-- Disables GTA controls when display is active
-- this allows for NUI input with ingame input
function DisableDisplayControlActions()
    DisableControlAction(0, 288, true) -- disable F1
    DisableControlAction(0, 1, true) -- disable mouse look
    DisableControlAction(0, 2, true) -- disable mouse look
    DisableControlAction(0, 3, true) -- disable mouse look
    DisableControlAction(0, 4, true) -- disable mouse look
    DisableControlAction(0, 5, true) -- disable mouse look
    DisableControlAction(0, 6, true) -- disable mouse look
    DisableControlAction(0, 263, true) -- disable melee
    DisableControlAction(0, 264, true) -- disable melee
    DisableControlAction(0, 257, true) -- disable melee
    DisableControlAction(0, 140, true) -- disable melee
    DisableControlAction(0, 141, true) -- disable melee
    DisableControlAction(0, 142, true) -- disable melee
    DisableControlAction(0, 143, true) -- disable melee
    DisableControlAction(0, 177, true) -- disable escape
    DisableControlAction(0, 200, true) -- disable escape
    DisableControlAction(0, 202, true) -- disable escape
    DisableControlAction(0, 322, true) -- disable escape
    DisableControlAction(0, 245, true) -- disable chat  
    DisableControlAction(0, 199, true) -- disable open map 
    DisableControlAction(0, 22, true)  -- disable jump
    DisableControlAction(0, 44, true)  -- disable cover
    DisableControlAction(0, 60, true)  -- disable crouch
    DisableControlAction(0, 61, true)  -- disable crouch
    DisableControlAction(0, 210, true)  -- disable crouch
    DisableControlAction(0, 224, true)  -- disable crouch
    DisableControlAction(0, 280, true)  -- disable crouch
    DisableControlAction(0, 281, true)  -- disable crouch
    DisableControlAction(0, 326, true)  -- disable crouch
    DisableControlAction(0, 341, true)  -- disable crouch
    DisableControlAction(0, 343, true)  -- disable crouch
    DisableControlAction(0, 36, true)  -- disable crouch
    DisableControlAction(0, 85, true)  -- disable radio
    DisableControlAction(0, 50, true)  -- disable scrollwheel
    DisableControlAction(0, 96, true)  -- disable scrollwheel
    DisableControlAction(0, 97, true)  -- disable scrollwheel
    DisableControlAction(0, 99, true)  -- disable scrollwheel
    DisableControlAction(0, 115, true)  -- disable scrollwheel
    DisableControlAction(0, 180, true)  -- disable scrollwheel
    DisableControlAction(0, 181, true)  -- disable scrollwheel
    DisableControlAction(0, 241, true)  -- disable scrollwheel
    DisableControlAction(0, 242, true)  -- disable scrollwheel
    DisableControlAction(0, 261, true)  -- disable scrollwheel
    DisableControlAction(0, 262, true)  -- disable scrollwheel
    DisableControlAction(0, 334, true)  -- disable scrollwheel
    DisableControlAction(0, 335, true)  -- disable scrollwheel
    DisableControlAction(0, 336, true)  -- disable scrollwheel
    DisableControlAction(0, 348, true)  -- disable scrollwheel
    DisableControlAction(0, 14, true)  -- disable scrollwheel
    DisableControlAction(0, 15, true)  -- disable scrollwheel
    DisableControlAction(0, 16, true)  -- disable scrollwheel
    DisableControlAction(0, 17, true)  -- disable scrollwheel
    DisableControlAction(0, 27, true)  -- disable scrollwheel
    DisableControlAction(0, 86, true)  -- disable horn
    DisableControlAction(0, 74, true)  -- disable headlights
    DisableControlAction(0, 86, true)  -- disable seatbelt 
    DisableControlAction(0, 182, true)  -- disable vehiclelock 
    DisableControlAction(0, 80, true)  -- disable cinematic view
    DisableControlAction(0, 79, true)  -- disable achteruit kijken
    DisableControlAction(0, 0, true)  -- disable cam wisselen
    DisableControlAction(0, 29, true)  -- disable begrenzer
    DisableControlAction(0, 20, true)  -- disable Z-inventory
    DisableControlAction(0, 20, true)  -- disable in/out vehicle
    DisableControlAction(0, 75, true)  -- disable in/out vehicle
    DisableControlAction(0, 23, true)  -- disable gordel
    DisableControlAction(0, 113, true)  -- disable gordel
    DisableControlAction(0, 23, true)  -- disable gordel
    DisableControlAction(0, 183, true)  -- disable gordel
    DisableControlAction(0, 24, true)  -- disable schieten
    DisableControlAction(0, 25, true)  -- disable richten
    DisableControlAction(0, 37, true)  -- disable TAB 
    DisableControlAction(0, 192, true)  -- disable TAB 
    DisableControlAction(0, 204, true)  -- disable TAB 
    DisableControlAction(0, 211, true)  -- disable TAB 
    DisableControlAction(0, 349, true)  -- disable TAB 
end