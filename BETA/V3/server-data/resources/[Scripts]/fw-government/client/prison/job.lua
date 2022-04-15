local currentLocation = 0
currentBlip = nil
local isWorking = false

-- Functions

function JobDone()
    if math.random(1, 100) <= 30 then
        LSCore.Functions.Notify('Gevangenis straf verminderd door goed gedrag')
        TriggerServerEvent('framework-prison:server:reduce:reward')
    end
end