
Config = Config or {}

Config.Keys = {["F1"] = 288}
Config.HasHandCuffs = false

Config.Menu = {
    [1] = {
       id = "citizen",
       displayName = "Burger",
       icon = "#citizen-action",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() then
                return true
            end
       end,
       subMenus = {"citizen:escort", 'citizen:steal', 'citizen:contact', 'citizen:vehicle:getout', 'citizen:vehicle:getin', 'citizen:drugs:cornersell'}
    },
    [2] = {
       id = "animations",
       displayName = "Loop Stijl",
       icon = "#walking",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() then
                return true
            end
       end,
       subMenus = { "animations:brave", "animations:hurry", "animations:business", "animations:tipsy", "animations:injured","animations:tough", "animations:default", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:maneater", "animations:chichi", "animations:sassy", "animations:sad", "animations:posh", "animations:alien" }
    },
    [3] = {
        id = "expressions",
        displayName = "Gezicht Expressies",
        icon = "#expressions",
        enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() then
               return true
            end
        end,
        subMenus = { "expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
    },
    [4] = {
       id = "police",
       displayName = "Politie",
       icon = "#police-action",
       enableMenu = function()
           if not exports['fw-government']:GetDeathStatus() and LSCore.Functions.GetPlayerData().job.name == 'police' and LSCore.Functions.GetPlayerData().job.onduty then
               return true
           end
       end,
       subMenus = {"police:panic", "police:search", "police:tablet", "police:impound", "police:impound:force", "police:resetdoor", "police:enkelband", "police:dispatch", 'police:cams'}
    },
    [5] = {
       id = "police",
       displayName = "Radio Kanalen",
       icon = "#police-radio-channel",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() and LSCore.Functions.GetPlayerData().job.name == 'police' and LSCore.Functions.GetPlayerData().job.onduty then
                return true
            end
       end,
       subMenus = {"police:radio:one", "police:radio:two", "police:radio:three", "police:radio:four", "police:radio:five"}
    },
    [6] = {
       id = "police-down",
       displayName = "10-13A",
       icon = "#police-down",
       close = true,
       functiontype = "client",
       functionParameters = 'Urgent',
       functionName = "framework-radialmenu:client:send:down",
       enableMenu = function()
            if exports['fw-government']:GetDeathStatus() and LSCore.Functions.GetPlayerData().job.name == 'police' and LSCore.Functions.GetPlayerData().job.onduty then
                return true
            end
       end,
    },
    [7] = {
       id = "police-down",
       displayName = "10-13B",
       icon = "#police-down",
       close = true,
       functiontype = "client",
       functionParameters = 'Normal',
       functionName = "framework-radialmenu:client:send:down",
       enableMenu = function()
            if exports['fw-government']:GetDeathStatus() and LSCore.Functions.GetPlayerData().job.name == 'police' and LSCore.Functions.GetPlayerData().job.onduty then
                return true
            end
       end,
    },
    [8] = {
       id = "ambulance",
       displayName = "Ambulance",
       icon = "#ambulance-action",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() and LSCore.Functions.GetPlayerData().job.name == 'ambulance' and LSCore.Functions.GetPlayerData().job.onduty then
                return true
            end
       end,
       subMenus = {"ambulance:heal", "ambulance:revive", "police:panic", "ambulance:blood", "police:dispatch"}
    },
    [9] = {
       id = "vehicle",
       displayName = "Voertuig",
       icon = "#citizen-action-vehicle",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() then
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                if Vehicle ~= 0 and Distance < 2.3 then
                    return true
                end
            end
       end,
       subMenus = {"vehicle:flip", "vehicle:key"}
    },
    [10] = {
       id = "vehicle-doors",
       displayName = "Voertuig Deuren",
       icon = "#citizen-action-vehicle",
       enableMenu = function()
           if not exports['fw-government']:GetDeathStatus() then
                if IsPedSittingInAnyVehicle(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) and not IsPedInAnyHeli(PlayerPedId()) and not IsPedOnAnyBike(PlayerPedId()) then
                    return true
                end
           end
       end,
       subMenus = {"vehicle:door:motor", "vehicle:door:left:front", "vehicle:door:right:front", "vehicle:door:trunk", "vehicle:door:right:back", "vehicle:door:left:back"}
    },
    [11] = {
       id = "garage",
       displayName = "Garage",
       icon = "#citizen-action-garage",
       close = true,
       functiontype = "client",
       functionName = "framework-garage:client:open:garage:menu",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() then
                if exports['fw-housing']:IsPlayerOnAParkingSpot() then
                    return true
                end
            end
     end,
    },
    [12] = {
       id = "atm",
       displayName = "Bank",
       icon = "#global-bank",
       close = true,
       functiontype = "client",
       functionName = "framework-banking:client:open:bank",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() then
                if exports['fw-banking']:IsNearAnyBank() then
                    return true
                end
            end
     end,
    },
    [13] = {
       id = "housing-options",
       displayName = "Huis Opties",
       icon = "#citizen-action-garage",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() then
                if exports['fw-housing']:HasEnterdHouse() then
                    return true
                end
            end
       end,
       subMenus = {"house:setstash", "house:setlogout", "house:setclothes", "house:givekey", "house:decorate" }
    },
    [14] = {
       id = "judge-actions",
       displayName = "Rechter",
       icon = "#judge-actions",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() and LSCore.Functions.GetPlayerData().job.name == 'judge' then
                return true
            end
       end,
       subMenus = {"judge:job", "police:tablet"}
    },
    [15] = {
       id = "ambulance-garage",
       displayName = "Ambulance Garage",
       icon = "#citizen-action-garage",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() and LSCore.Functions.GetPlayerData().job.name == 'ambulance' and LSCore.Functions.GetPlayerData().job.onduty then
                local GarageData = exports['fw-government']:GetGarageShit()
                if GarageData ~= false then
                    Config.Menu[15].subMenus = GarageData
                    return true
                else
                    Config.Menu[15].subMenus = {}
                    return false
                end
            end
       end,
       subMenus = {}
    },
    [16] = {
       id = "scrapyard",
       displayName = "Voertuig Slopen",
       icon = "#police-action-vehicle-spawn",
       close = true,
       functiontype = "client",
       functionName = "framework-materials:client:scrap:vehicle",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() then
                if exports['fw-jobs']:IsNearScrapYard() then
                    return true
                end
            end
     end,
    },
    [17] = {
       id = "dealer",
       displayName = "Dealer Shop",
       icon = "#global-dealer",
       close = true,
       functiontype = "client",
       functionName = "framework-dealers:client:open:dealer",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() then
                if exports['fw-dealers']:CanOpenDealerShop() then
                    return true
                end
            end
     end,
    },
    [18] = {
       id = "tow-menu",
       displayName = "Bergnet Acties",
       icon = "#citizen-action-garage",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() and LSCore.Functions.GetPlayerData().job.name == 'tow' then
                return true
            end
       end,
       subMenus = {"tow:hook", "tow:npc"}
    },
    [19] = {
       id = "cuff",
       displayName = "Boeien",
       icon = "#citizen-action-cuff",
       close = true,
       functiontype = "client",
       functionName = "framework-police:client:cuff:closest",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() and Config.HasHandCuffs then
                return true
            end
     end,
    },
    [20] = {
       id = "trunk",
       displayName = "Uit Kofferbak",
       icon = "#citizen-vehicle-trunk",
       close = true,
       functiontype = "client",
       functionName = "framework-assets:client:getout:trunk",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() and exports['fw-assets']:GetInTrunkState() then
              return true
            end
     end,
    },
    [21] = {
       id = "hospital-menu",
       displayName = "In Checken",
       icon = "#citizen-clipboard",
       close = true,
       functiontype = "client",
       functionName = "framework-hospital:client:check:in",
       enableMenu = function()
            if exports['fw-government']:NearCheckin() then
                return true
            end
       end,
    },
    [22] = {
       id = "boat-menu",
       displayName = "Politie Boot",
       icon = "#police-boat",
       close = true,
       functiontype = "client",
       functionName = "framework-police:client:spawn:boat",
       enableMenu = function()
            if LSCore.Functions.GetPlayerData().job.name == 'police' and LSCore.Functions.GetPlayerData().job.onduty and IsEntityInWater(PlayerPedId()) then
                return true
            end
       end,
    },
    [23] = {
       id = "heli-menu",
       displayName = "Politie Heli",
       icon = "#police-action-vehicle-spawn-heli",
       close = true,
       functiontype = "client",
       functionName = "framework-police:client:open:garage",
       enableMenu = function()
            if LSCore.Functions.GetPlayerData().job.name == 'police' and LSCore.Functions.GetPlayerData().job.onduty and exports['fw-government']:IsNearHeli() then
                return true
            end
       end,
    },
    [24] = {
       id = "taxi-menu",
       displayName = "Taxi Acties",
       icon = "#taxi-action",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() and LSCore.Functions.GetPlayerData().job.name == 'taxi' then
                return true
            end
       end,
       subMenus = {"taxi:meter:toggle", "taxi:meter:active:toggle", "taxi:meter:reset", "taxi:npc"}
    },
    [25] = {
       id = "burger-menu",
       displayName = "Burgershot",
       icon = "#burger-action",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() and LSCore.Functions.GetPlayerData().job.name == 'burger' and LSCore.Functions.GetPlayerData().job.onduty then
                return true
            end
       end,
       subMenus = {"burger:give:payment"}
    },
    [26] = {
       id = "dark-doctor-menu",
       displayName = "Onderwereld Dokter",
       icon = "#ambulance-action",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() and LSCore.Functions.GetPlayerData().job.name == 'darkdoctor' and LSCore.Functions.GetPlayerData().job.onduty then
                return true
            end
       end,
       subMenus = {"ambulance:heal", "ambulance:revive"}
    },
    [27] = {
       id = "flightschool-menu",
       displayName = "Vliegschool",
       icon = "#plane-action",
       enableMenu = function()
            -- if not exports['fw-government']:GetDeathStatus() and LSCore.Functions.GetPlayerData().job.name == 'flightschool' and LSCore.Functions.GetPlayerData().job.onduty then
                return false
            -- end
       end,
       subMenus = {"flightschool:add:brevet"}
    },
    [28] = {
       id = "hospital-menu-dead",
       displayName = "Respawnen",
       icon = "#police-down",
       close = true,
       functiontype = "client",
       functionName = "framework-hospital:client:try:repsawn",
       enableMenu = function()
            if exports['fw-government']:GetDeathStatus() and exports['fw-government']:CanRespawn() then
                return true
            end
       end,
    },
    [29] = {
       id = "cardealer-menu-despawn",
       displayName = "Testrit Despawnen",
       icon = "#police-action-vehicle-delete",
       close = true,
       functiontype = "client",
       functionName = "LSCore:Command:DeleteVehicle",
       enableMenu = function()
            if not exports['fw-government']:GetDeathStatus() and (LSCore.Functions.GetPlayerData().job.name == 'cardealer') and LSCore.Functions.GetPlayerData().job.onduty and (exports['fw-vehicleshop']:InsideCardealer()) and IsPedInAnyVehicle(PlayerPedId()) then
                -- if not exports['fw-government']:GetDeathStatus() and (LSCore.Functions.GetPlayerData().job.name == 'cardealer' or LSCore.Functions.GetPlayerData().job.name == 'motordealer') and LSCore.Functions.GetPlayerData().job.onduty and (exports['fw-cardealer']:InsideCardealer() or exports['fw-motordealer']:IsInsideMotorDealer()) and IsPedInAnyVehicle(PlayerPedId()) then
                    return true
            end
       end,
    },
    [30] = {
       id = "steal-shoes",
       displayName = "Schoenen Stelen",
       icon = "#citizen-steal-shoes",
       close = true,
       functiontype = "client",
       functionName = "framework-interactions:client:steal:shoes",
       enableMenu = function()
           if not exports['fw-government']:GetDeathStatus() then
               local Player, Distance = LSCore.Functions.GetClosestPlayer()
               if Player ~= -1 and Distance < 3.0 then
                    local IsDead = false
                    local CaughtShoes = false
                    local TargetPed = GetPlayerPed(Player)
                    local ServerId = GetPlayerServerId(Player)
                    local FootProp = GetPedDrawableVariation(TargetPed, 6)
                    if not CaughtShoes then
                        if IsPedMale(TargetPed) then
                            if FootProp ~= 35 then
                                LSCore.Functions.TriggerCallback('framework-police:server:is:player:dead', function(result)
                                    IsDead = result
                                end, ServerId) 
                                CaughtShoes = true
                                Citizen.Wait(110)
                                return IsDead
                            end
                        else
                            if FootProp ~= 34 then
                                LSCore.Functions.TriggerCallback('framework-police:server:is:player:dead', function(result)
                                    IsDead = result
                                end, ServerId) 
                                CaughtShoes = true
                                Citizen.Wait(110)
                                return IsDead
                            end
                        end  
                    end
               end
           end
       end,
    },
}

Config.SubMenus = {
    ['flightschool:add:brevet'] = {
     title = "Brevet Geven",
     icon = "#plane-paper",
     close = true,
     functiontype = "client",
     functionName = "framework-flightschool:client:open:brevet"
    },
    ['burger:give:payment'] = {
     title = "Pin Apparaat Geven",
     icon = "#burger-action-cash",
     close = true,
     functiontype = "client",
     functionName = "framework-burgershot:client:give:payment"
    },
    ['taxi:meter:toggle'] = {
     title = "Toggle Meter",
     icon = "#taxi-action-meter",
     close = true,
     functiontype = "client",
     functionName = "framework-jobmanager:client:toggle:taxi:meter"
    },
    ['taxi:meter:active:toggle'] = {
     title = "Start/Stop Meter",
     icon = "#taxi-action-on",
     close = true,
     functiontype = "client",
     functionName = "framework-jobmanager:client:start:taxi:meter"
    },
    ['taxi:meter:reset'] = {
     title = "Reset Meter",
     icon = "#taxi-refresh",
     close = true,
     functiontype = "client",
     functionName = "framework-jobmanager:client:reset:taxi:meter"
    },
    ['taxi:npc'] = {
     title = "Werken",
     icon = "#taxi-action",
     close = true,
     functiontype = "client",
     functionName = "framework-jobmanager:client:taxi:npc"
    },
    ['police:radio:one'] = {
     title = "Radio #1",
     icon = "#police-radio",
     close = true,
     functionParameters = 1,
     functiontype = "client",
     functionName = "framework-radialmenu:client:enter:radio"
    },
    ['police:radio:two'] = {
     title = "Radio #2",
     icon = "#police-radio",
     close = true,
     functionParameters = 2,
     functiontype = "client",
     functionName = "framework-radialmenu:client:enter:radio"
    },
    ['police:radio:three'] = {
     title = "Radio #3",
     icon = "#police-radio",
     close = true,
     functionParameters = 3,
     functiontype = "client",
     functionName = "framework-radialmenu:client:enter:radio"
    },
    ['police:radio:four'] = {
     title = "Radio #4",
     icon = "#police-radio",
     close = true,
     functionParameters = 4,
     functiontype = "client",
     functionName = "framework-radialmenu:client:enter:radio"
    },
    ['police:radio:five'] = {
     title = "Radio #5",
     icon = "#police-radio",
     close = true,
     functionParameters = 5,
     functiontype = "client",
     functionName = "framework-radialmenu:client:enter:radio"
    },
    ['police:cams'] = {
     title = "Camera's",
     icon = "#police-action-cams",
     close = true,
     functiontype = "client",
     functionName = "framework-police:client:open:number"
    },
    ['police:panic'] = {
     title = "Noodknop",
     icon = "#police-action-panic",
     close = true,
     functiontype = "client",
     functionName = "framework-radialmenu:client:send:panic:button"
    },
    ['police:dispatch'] = {
     title = "Recente Meldingen",
     icon = "#police-action-bell",
     close = true,
     functiontype = "server",
     functionName = "framework-radialmenu:server:open:dispatch"
    },
    ['police:tablet'] = {
     title = "MEOS Tablet",
     icon = "#police-action-tablet",
     close = true,
     functiontype = "client",
     functionName = "framework-police:client:show:tablet"
    },
    ['police:impound'] = {
     title = "Voertuig Depot",
     icon = "#police-action-vehicle",
     close = true,
     functiontype = "client",
     functionName = "framework-police:client:impound:closest"
    },
    ['police:impound:force'] = {
     title = "Beslag Leggen",
     icon = "#police-action-vehicle",
     close = true,
     functiontype = "client",
     functionName = "framework-police:client:impound:force:closest"
    },
    ['police:search'] = {
     title = "Fouileeren",
     icon = "#police-action-search",
     close = true,
     functiontype = "client",
     functionName = "framework-police:client:search:closest"
    },
    ['police:resetdoor'] = {
     title = "Reset Huis Deur",
     icon = "#global-appartment",
     close = true,
     functiontype = "client",
     functionName = "framework-housing:client:reset:house:door"
    },
    ['police:enkelband'] = {
     title = "Enkelband",
     icon = "#police-action-enkelband",
     close = true,
     functiontype = "client",
     functionName = "framework-police:client:enkelband:closest"
    },
    ['police:vehicle:touran'] = {
     title = "Politie Touran",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieTouran',
     functiontype = "client",
     functionName = "framework-police:client:spawn:vehicle"
    },
    ['police:vehicle:klasse'] = {
     title = "Politie B-Klasse",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieKlasse',
     functiontype = "client",
     functionName = "framework-police:client:spawn:vehicle"
    },
    ['police:vehicle:vito'] = {
     title = "Politie Vito",
     icon = "#police-action-vehicle-spawn-bus",
     close = true,
     functionParameters = 'PolitieVito',
     functiontype = "client",
     functionName = "framework-police:client:spawn:vehicle"
    },
    ['police:vehicle:audir'] = {
     title = "Politie Audi",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieRS6',
     functiontype = "client",
     functionName = "framework-police:client:spawn:vehicle"
    },
    ['police:vehicle:audi'] = {
     title = "Politie A6",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieAudi',
     functiontype = "client",
     functionName = "framework-police:client:spawn:vehicle"
    },
    ['police:vehicle:amarok'] = {
     title = "Politie Amarok",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieAmarok',
     functiontype = "client",
     functionName = "framework-police:client:spawn:vehicle"
    },
    ['police:vehicle:velar'] = {
     title = "Politie Unmarked Velar",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieVelar',
     functiontype = "client",
     functionName = "framework-police:client:spawn:vehicle"
    },
    ['police:vehicle:bmw'] = {
     title = "Politie Unmarked M5",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieBmw',
     functiontype = "client",
     functionName = "framework-police:client:spawn:vehicle"
    },
    ['police:vehicle:unmaked:audi'] = {
     title = "Politie Unmarked A6",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieAudiUnmarked',
     functiontype = "client",
     functionName = "framework-police:client:spawn:vehicle"
    },
    ['police:vehicle:heli'] = {
     title = "Politie Zulu",
     icon = "#police-action-vehicle-spawn-heli",
     close = true,
     functionParameters = 'PolitieZulu',
     functiontype = "client",
     functionName = "framework-police:client:spawn:vehicle"
    },
    ['police:vehicle:dsi:heli'] = {
     title = "Politie DSI Zulu",
     icon = "#police-action-vehicle-spawn-heli",
     close = true,
     functionParameters = 'DsiZulu',
     functiontype = "client",
     functionName = "framework-police:client:spawn:vehicle"
    },
    ['police:vehicle:motor'] = {
     title = "Politie Motor",
     icon = "#police-action-vehicle-spawn-motor",
     close = true,
     functionParameters = 'PolitieMotor',
     functiontype = "client",
     functionName = "framework-police:client:spawn:vehicle"
    },
    ['ambulance:heal'] = {
      title = "Burger Verzorgen",
      icon = "#ambulance-action-heal",
      close = true,
      functiontype = "client",
      functionName = "framework-hospital:client:heal:closest"
    },
    ['ambulance:revive'] = {
      title = "Burger Revive",
      icon = "#ambulance-action-heal",
      close = true,
      functiontype = "client",
      functionName = "framework-hospital:client:revive:closest"
    },
    ['ambulance:blood'] = {
      title = "Bloed Monster Nemen",
      icon = "#ambulance-action-blood",
      close = true,
      functiontype = "client",
      functionName = "framework-hospital:client:take:blood:closest"
    },
    ['ambulance:garage:heli'] = {
      title = "Ambulance Heli",
      icon = "#police-action-vehicle-spawn",
      close = true,
      functionParameters = 'AmbulanceHeli',
      functiontype = "client",
      functionName = "framework-hospital:client:spawn:vehicle"
    },
    ['ambulance:garage:touran'] = {
     title = "Ambulance Touran",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'AmbulanceTouran',
     functiontype = "client",
     functionName = "framework-hospital:client:spawn:vehicle"
    },
    ['ambulance:garage:sprinter'] = {
     title = "Ambulance Sprinter",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'AmbulanceSprinter',
     functiontype = "client",
     functionName = "framework-hospital:client:spawn:vehicle"
    },
    ['vehicle:delete'] = {
     title = "Voertuig Verwijderen",
     icon = "#police-action-vehicle-delete",
     close = true,
     functiontype = "client",
     functionName = "LSCore:Command:DeleteVehicle"
    },
    ['judge:job'] = {
     title = "Advocaat Aannemen",
     icon = "#judge-actions",
     close = true,
     functiontype = "client",
     functionName = "framework-judge:client:lawyer:add:closest"
    },
    ['citizen:contact'] = {
     title = "Contact Gegevens",
     icon = "#citizen-contact",
     close = true,
     functiontype = "client",
     functionName = "framework-phone:client:GiveContactDetails"
    },
    ['citizen:escort'] = {
     title = "Escorteren",
     icon = "#citizen-action-escort",
     close = true,
     functiontype = "client",
     functionName = "framework-police:client:escort:closest"
    },
    ['citizen:steal'] = {
     title = "Beroven",
     icon = "#citizen-action-steal",
     close = true,
     functiontype = "client",
     functionName = "framework-police:client:steal:closest"
    },
    ['citizen:vehicle:getout'] = {
     title = "Uit Voertuig",
     icon = "#citizen-put-out-veh",
     close = true,
     functiontype = "client",
     functionName = "framework-police:client:set:out:vehicle:closest"
    },
    ['citizen:vehicle:getin'] = {
     title = "In Voertuig",
     icon = "#citizen-put-in-veh",
     close = true,
     functiontype = "client",
     functionName = "framework-police:client:set:in:vehicle:closest"
    },
    ['citizen:drugs:cornersell'] = {
     title = "Drugsverkoop",
     icon = "#citizen-put-in-veh",
     close = true,
     functiontype = "client",
     functionName = "framework-illegal:client:toggle:corner:selling"
    },
    ['vehicle:flip'] = {
     title = "Voertuig Omduwen",
     icon = "#citizen-action-vehicle",
     close = true,
     functiontype = "client",
     functionName = "framework-radialmenu:client:flip:vehicle"
    },
    ['vehicle:key'] = {
     title = "Geef Sleutel",
     icon = "#citizen-action-vehicle-key",
     close = true,
     functiontype = "client",
     functionName = "framework-vehiclekeys:client:give:key"
    },

    ['vehicle:door:left:front'] = {
     title = "Links Voor",
     icon = "#global-arrow-left",
     close = true,
     functionParameters = 0,
     functiontype = "client",
     functionName = "framework-radialmenu:client:open:door"
    },
    ['vehicle:door:motor'] = {
     title = "Motor Kap",
     icon = "#global-arrow-up",
     close = true,
     functionParameters = 4,
     functiontype = "client",
     functionName = "framework-radialmenu:client:open:door"
    },
    ['vehicle:door:right:front'] = {
     title = "Rechts Voor",
     icon = "#global-arrow-right",
     close = true,
     functionParameters = 1,
     functiontype = "client",
     functionName = "framework-radialmenu:client:open:door"
    },
    ['vehicle:door:right:back'] = {
     title = "Rechts Achter",
     icon = "#global-arrow-right",
     close = true,
     functionParameters = 3,
     functiontype = "client",
     functionName = "framework-radialmenu:client:open:door"
    },
    ['vehicle:door:trunk'] = {
     title = "Kofferbak",
     icon = "#global-arrow-down",
     close = true,
     functionParameters = 5,
     functiontype = "client",
     functionName = "framework-radialmenu:client:open:door"
    },
    ['vehicle:door:left:back'] = {
     title = "Links Achter",
     icon = "#global-arrow-left",
     close = true,
     functionParameters = 2,
     functiontype = "client",
     functionName = "framework-radialmenu:client:open:door"
    },
    ['tow:hook'] = {
     title = "Takel Voertuig",
     icon = "#citizen-action-vehicle",
     close = true,
     functiontype = "client",
     functionName = "framework-jobmanager:client:hook:car:tow"
    },
    ['tow:npc'] = {
     title = "Toggle NPC",
     icon = "#citizen-action",
     close = true,
     functiontype = "client",
     functionName = "framework-jobmanager:client:toggle:npc:tow"
    }, 
    ['house:setstash'] = {
     title = "Zet Stash",
     icon = "#citizen-put-out-veh",
     close = true,
     functionParameters = 'stash',
     functiontype = "client",
     functionName = "framework-housing:client:set:location"
    },
    ['house:setlogout'] = {
     title = "Zet Loguit",
     icon = "#citizen-put-out-veh",
     close = true,
     functionParameters = 'logout',
     functiontype = "client",
     functionName = "framework-housing:client:set:location"
    },
    ['house:setclothes'] = {
     title = "Zet Kledingkast",
     icon = "#citizen-put-out-veh",
     close = true,
     functionParameters = 'clothes',
     functiontype = "client",
     functionName = "framework-housing:client:set:location"
    },
    ['house:givekey'] = {
     title = "Geef Sleutels",
     icon = "#citizen-action-vehicle-key",
     close = true,
     functiontype = "client",
     functionName = "framework-housing:client:give:keys"
    },
    ['house:decorate'] = {
     title = "Decoreren",
     icon = "#global-box",
     close = true,
     functiontype = "client",
     functionName = "framework-housing:client:decorate"
    },
    -- // Anims and Expression \\ --
    ['animations:brave'] = {
        title = "Brave",
        icon = "#animation-brave",
        close = true,
        functionName = "AnimSet:Brave",
        functiontype = "client",
    },
    ['animations:hurry'] = {
        title = "Hurry",
        icon = "#animation-hurry",
        close = true,
        functionName = "AnimSet:Hurry",
        functiontype = "client",
    },
    ['animations:business'] = {
        title = "Business",
        icon = "#animation-business",
        close = true,
        functionName = "AnimSet:Business",
        functiontype = "client",
    },
    ['animations:tipsy'] = {
        title = "Tipsy",
        icon = "#animation-tipsy",
        close = true,
        functionName = "AnimSet:Tipsy",
        functiontype = "client",
    },
    ['animations:injured'] = {
        title = "Injured",
        icon = "#animation-injured",
        close = true,
        functionName = "AnimSet:Injured",
        functiontype = "client",
    },
    ['animations:tough'] = {
        title = "Tough",
        icon = "#animation-tough",
        close = true,
        functionName = "AnimSet:ToughGuy",
        functiontype = "client",
    },
    ['animations:sassy'] = {
        title = "Sassy",
        icon = "#animation-sassy",
        close = true,
        functionName = "AnimSet:Sassy",
        functiontype = "client",
    },
    ['animations:sad'] = {
        title = "Sad",
        icon = "#animation-sad",
        close = true,
        functionName = "AnimSet:Sad",
        functiontype = "client",
    },
    ['animations:posh'] = {
        title = "Posh",
        icon = "#animation-posh",
        close = true,
        functionName = "AnimSet:Posh",
        functiontype = "client",
    },
    ['animations:alien'] = {
        title = "Alien",
        icon = "#animation-alien",
        close = true,
        functionName = "AnimSet:Alien",
        functiontype = "client",
    },
    ['animations:nonchalant'] =
    {
        title = "Nonchalant",
        icon = "#animation-nonchalant",
        close = true,
        functionName = "AnimSet:NonChalant",
        functiontype = "client",
    },
    ['animations:hobo'] = {
        title = "Hobo",
        icon = "#animation-hobo",
        close = true,
        functionName = "AnimSet:Hobo",
        functiontype = "client",
    },
    ['animations:money'] = {
        title = "Money",
        icon = "#animation-money",
        close = true,
        functionName = "AnimSet:Money",
        functiontype = "client",
    },
    ['animations:swagger'] = {
        title = "Swagger",
        icon = "#animation-swagger",
        close = true,
        functionName = "AnimSet:Swagger",
        functiontype = "client",
    },
    ['animations:shady'] = {
        title = "Shady",
        icon = "#animation-shady",
        close = true,
        functionName = "AnimSet:Shady",
        functiontype = "client",
    },
    ['animations:maneater'] = {
        title = "Man Eater",
        icon = "#animation-maneater",
        close = true,
        functionName = "AnimSet:ManEater",
        functiontype = "client",
    },
    ['animations:chichi'] = {
        title = "ChiChi",
        icon = "#animation-chichi",
        close = true,
        functionName = "AnimSet:ChiChi",
        functiontype = "client",
    },
    ['animations:default'] = {
        title = "Default",
        icon = "#animation-default",
        close = true,
        functionName = "AnimSet:default",
        functiontype = "client",
    },
    ["expressions:angry"] = {
        title="Angry",
        icon="#expressions-angry",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_angry_1" },
        functiontype = "client",
    },
    ["expressions:drunk"] = {
        title="Drunk",
        icon="#expressions-drunk",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_drunk_1" },
        functiontype = "client",
    },
    ["expressions:dumb"] = {
        title="Dumb",
        icon="#expressions-dumb",
        close = true,
        functionName = "expressions",
        functionParameters =  { "pose_injured_1" },
        functiontype = "client",
    },
    ["expressions:electrocuted"] = {
        title="Electrocuted",
        icon="#expressions-electrocuted",
        close = true,
        functionName = "expressions",
        functionParameters =  { "electrocuted_1" },
        functiontype = "client",
    },
    ["expressions:grumpy"] = {
        title="Grumpy",
        icon="#expressions-grumpy",
        close = true,
        functionName = "expressions", 
        functionParameters =  { "mood_drivefast_1" },
        functiontype = "client",
    },
    ["expressions:happy"] = {
        title="Happy",
        icon="#expressions-happy",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_happy_1" },
        functiontype = "client",
    },
    ["expressions:injured"] = {
        title="Injured",
        icon="#expressions-injured",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_injured_1" },
        functiontype = "client",
    },
    ["expressions:joyful"] = {
        title="Joyful",
        icon="#expressions-joyful",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_dancing_low_1" },
        functiontype = "client",
    },
    ["expressions:mouthbreather"] = {
        title="Mouthbreather",
        icon="#expressions-mouthbreather",
        close = true,
        functionName = "expressions",
        functionParameters = { "smoking_hold_1" },
        functiontype = "client",
    },
    ["expressions:normal"]  = {
        title="Normal",
        icon="#expressions-normal",
        close = true,
        functionName = "expressions:clear",
        functiontype = "client",
    },
    ["expressions:oneeye"]  = {
        title="One Eye",
        icon="#expressions-oneeye",
        close = true,
        functionName = "expressions",
        functionParameters = { "pose_aiming_1" },
        functiontype = "client",
    },
    ["expressions:shocked"]  = {
        title="Shocked",
        icon="#expressions-shocked",
        close = true,
        functionName = "expressions",
        functionParameters = { "shocked_1" },
        functiontype = "client",
    },
    ["expressions:sleeping"]  = {
        title="Sleeping",
        icon="#expressions-sleeping",
        close = true,
        functionName = "expressions",
        functionParameters = { "dead_1" },
        functiontype = "client",
    },
    ["expressions:smug"]  = {
        title="Smug",
        icon="#expressions-smug",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_smug_1" },
        functiontype = "client",
    },
    ["expressions:speculative"]  = {
        title="Speculative",
        icon="#expressions-speculative",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_aiming_1" },
        functiontype = "client",
    },
    ["expressions:stressed"]  = {
        title="Stressed",
        icon="#expressions-stressed",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_stressed_1" },
        functiontype = "client",
    },
    ["expressions:sulking"]  = {
        title="Sulking",
        icon="#expressions-sulking",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_sulk_1" },
        functiontype = "client",
    },
    ["expressions:weird"]  = {
        title="Weird",
        icon="#expressions-weird",
        close = true,
        functionName = "expressions",
        functionParameters = { "effort_2" },
        functiontype = "client",
    },
    ["expressions:weird2"]  = {
        title="Weird 2",
        icon="#expressions-weird2",
        close = true,
        functionName = "expressions",
        functionParameters = { "effort_3" },
        functiontype = "client",
    }
}