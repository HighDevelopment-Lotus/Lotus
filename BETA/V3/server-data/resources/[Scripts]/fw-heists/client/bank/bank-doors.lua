local DoingDoor = false

function CheckDoor(BankId)
    if BankId ~= nil then
        local Object = GetClosestObjectOfType(Config.Banks[BankId]["Coords"]["X"], Config.Banks[BankId]["Coords"]["Y"], Config.Banks[BankId]["Coords"]["Z"], 5.0, Config.Banks[BankId]['Door']['Object'], false, false, false)
        local Heading = GetEntityHeading(Object)
        if Config.Banks[BankId]['BankOpen'] then
            if Heading ~= Config.Banks[BankId]['Door']['Heading']['Open'] and not DoingDoor then
                DoingDoor = true
                OpenBankDoor(BankId)
            end
        else
            if Heading ~= Config.Banks[BankId]['Door']['Heading']['Closed'] and not DoingDoor then
                DoingDoor = true
                CloseBankDoor(BankId)
            end
        end
        Citizen.Wait(1000)
    end
end

function OpenBankDoor(BankId)
    local Object = GetClosestObjectOfType(Config.Banks[BankId]["Coords"]["X"], Config.Banks[BankId]["Coords"]["Y"], Config.Banks[BankId]["Coords"]["Z"], 5.0, Config.Banks[BankId]['Door']['Object'], false, false, false)
    if Object ~= 0 then
        SetEntityHeading(Object, Config.Banks[BankId]['Door']['Heading']['Open'])
        DoingDoor = false
    end
end

function CloseBankDoor(BankId)
    local Object = GetClosestObjectOfType(Config.Banks[BankId]["Coords"]["X"], Config.Banks[BankId]["Coords"]["Y"], Config.Banks[BankId]["Coords"]["Z"], 5.0, Config.Banks[BankId]['Door']['Object'], false, false, false)
    if Object ~= 0 then
        SetEntityHeading(Object, Config.Banks[BankId]['Door']['Heading']['Closed'])
        DoingDoor = false
    end
end