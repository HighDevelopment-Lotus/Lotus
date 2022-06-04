Config = Config or {}

Config.DoingSkill = false

Config.MaxPlayers = GetConvarInt('sv_maxclients', 64) -- It returnes 64 if it cant find the Convar Int

-- Minimum Police for Actions
Config.IllegalActions = {
    ["storerobbery"] = {
        minimum = 1,
        busy = false,
    },
    ["bankrobbery"] = {
        minimum = 4,
        busy = false,
    },
    ["jewellery"] = {
        minimum = 3,
        busy = false,
    },
    ["humanelabs"] = {
        minimum = 6,
        busy = false,
    },
    ["pacific"] = {
        minimum = 6,
        busy = false,
    },
    ["banktruck"] = {
        minimum = 4,
        busy = false,
    },
    ["applestore"] = {
        minimum = 2,
        busy = false,
    },
}

-- Current Cops Online
Config.CurrentCops = 0
Config.CurrentAmbus = 0
Config.CurrentAutocare = 0
Config.CurrentCardealers = 0

Config.EntityData = {}

Config.ObjectOptions = {
    [GetHashKey('prop_atm_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Pin Automaat',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="far fa-credit-card"></i>',
                ['EventName'] = 'framework-banking:client:open:atm', 
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_atm_02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Pin Automaat',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="far fa-credit-card"></i>',
                ['EventName'] = 'framework-banking:client:open:atm', 
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_atm_03')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Pin Automaat',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="far fa-credit-card"></i>',
                ['EventName'] = 'framework-banking:client:open:atm', 
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_fleeca_atm')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Pin Automaat',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="far fa-credit-card"></i>',
                ['EventName'] = 'framework-banking:client:open:atm', 
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_arcade_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Blokjes (€350)',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-th"></i>',
                ['EventName'] = 'framework-ui:client:practice:game', 
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 'Blocks',
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = '1234 (€500)',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-sort-numeric-up-alt"></i>',
                ['EventName'] = 'framework-ui:client:practice:game', 
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 'Shapes',
            },
        },
    },
    [GetHashKey('prop_news_disp_02a')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Krant',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-newspaper"></i>',
                ['EventName'] = 'framework-ui:client:open:newspaper', 
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Carspotters Magazine (€4)',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-scroll"></i>',
                ['EventName'] = 'framework-ui:client:purchase:magazine', 
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_news_disp_02c')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Krant',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-newspaper"></i>',
                ['EventName'] = 'framework-ui:client:open:newspaper', 
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Carspotters Magazine (€4)',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-scroll"></i>',
                ['EventName'] = 'framework-ui:client:purchase:magazine', 
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_news_disp_05a')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Krant',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-newspaper"></i>',
                ['EventName'] = 'framework-ui:client:open:newspaper', 
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Carspotters Magazine (€4)',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-scroll"></i>',
                ['EventName'] = 'framework-ui:client:purchase:magazine', 
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_news_disp_01a')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Krant',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-newspaper"></i>',
                ['EventName'] = 'framework-ui:client:open:newspaper', 
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Carspotters Magazine (€4)',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-scroll"></i>',
                ['EventName'] = 'framework-ui:client:purchase:magazine', 
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_toolchest_05')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Workbench',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-tools"></i>',
                ['EventName'] = 'framework-crafting:client:open:crafting', 
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Recycle Workbench',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-recycle"></i>',
                ['EventName'] = 'framework-materials:client:open:recycle:crafting', 
                ['Enabled'] = function()
                    if exports['fw-jobs']:InsideRecycle() then
                        return true
                    end
                end,
            },
        },
    },

    [GetHashKey('bkr_prop_coke_table01a')] = {
        ['Options'] = {
            [1] = {
                ['Name'] = 'Verwerk Crack',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-cannabis"></i>',
                ['EventName'] = 'framework-tables:client:process:table',
                ['EventParameter'] = 'Crack',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 0,
            },
            [2] = {
                ['Name'] = 'Tafel Oppakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hand-rock"></i>',
                ['EventName'] = 'framework-tables:client:pickup:table',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 0,
            },
        },
    },

    [GetHashKey('bkr_prop_meth_table01a')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Opbreken Trays',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-pencil-ruler"></i>',
                ['EventName'] = 'framework-tables:client:process:table',
                ['EventParameter'] = 'Meth',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Name'] = 'Tafel Oppakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hand-rock"></i>',
                ['EventName'] = 'framework-tables:client:pickup:table',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 0,
            },
        },
    },
    [GetHashKey('bkr_prop_weed_table_01a')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Wiet',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-pencil-ruler"></i>',
                ['EventName'] = 'framework-tables:client:process:table',
                ['EventParameter'] = 'Weed',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Name'] = 'Tafel Oppakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hand-rock"></i>',
                ['EventName'] = 'framework-tables:client:pickup:table',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 0,
            },
        },
    },

    [GetHashKey('v_ind_meatwash')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'In / Uit Dienst',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-toggle-on"></i>',
                ['EventName'] = 'framework-materials:client:recycle:toggle:duty',
                ['Enabled'] = function()
                    if exports['fw-jobs']:InsideRecycle() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('v_ind_cm_paintbckt06')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'taxi',
                ['UseDuty'] = false,
                ['Name'] = 'Loon Ontvangen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-money-bill-alt"></i>',
                ['EventName'] = 'framework-jobmanager:client:request:payment',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = 'taxi',
                ['UseDuty'] = false,
                ['Name'] = 'Taxi Huren (€350)',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-tools"></i>',
                ['EventName'] = 'framework-jobmanager:client:request:vehicle:taxi', 
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_monitor_04a')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'cardealer',
                ['UseDuty'] = true,
                ['Name'] = 'Voertuig Beheer',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-clipboard-list"></i>',
                ['EventName'] = 'framework-cardealer:client:open:select:menu',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('bkr_prop_clubhouse_laptop_01a')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'motordealer',
                ['UseDuty'] = true,
                ['Name'] = 'Voertuig Beheer',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-clipboard-list"></i>',
                ['EventName'] = 'framework-motordealer:client:open:select:menu',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('wheelchair')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Rolstoel Oppakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-wheelchair"></i>',
                ['EventName'] = 'framework-items:client:remove:wheelchair',
                ['Enabled'] = function()
                    return true
                end,
            },
            -- [2] = {
            --     ['Job'] = false,
            --     ['UseDuty'] = false,
            --     ['Name'] = 'Rolstoel Duwen',
            --     ['EventType'] = 'Client',
            --     ['Logo'] = '<i class="fas fa-wheelchair"></i>',
            --     ['EventName'] = 'framework-vehicles:client:control:vehicle',
            --     ['Enabled'] = function()
            --         return true
            --     end,
            --     ['EventParameter'] = '',
            -- },
        },
    },
    [GetHashKey('v_ilev_gunsign_assmg')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Werk Zoeken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-copy"></i>',
                ['EventName'] = 'framework-cityhall:client:open:menu',
                ['EventParameter'] = 'Work',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Identiteits Bewijzen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-id-card"></i>',
                ['EventName'] = 'framework-cityhall:client:open:menu',
                ['EventParameter'] = 'Identity',
                ['Enabled'] = function()
                    return true
                end,
            },
            [3] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Vergunningen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-scroll"></i>',
                ['EventName'] = 'framework-cityhall:client:open:menu',
                ['EventParameter'] = 'Licences',
                ['Enabled'] = function()
                    return true
                end,
            },
            [4] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Spullen terug halen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-box"></i>',
                ['EventName'] = 'framework-cityhall:client:request:items',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('v_ind_cs_oiltub')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Depot Voertuigen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-truck"></i>',
                ['EventName'] = 'framework-garage:client:open:depot:menu',
                ['Enabled'] = function()
                    if exports['fw-housing']:IsInsideDepot() then
                        return true
                    end
                end,
            },
            [2] = {
                ['Job'] = 'police',
                ['UseDuty'] = true,
                ['Name'] = 'Beslag Opslag',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-truck"></i>',
                ['EventName'] = 'framework-garages:client:open:impound:menu',
                ['Enabled'] = function()
                    if exports['fw-housing']:IsInsideDepot() then
                        return true
                    end
                end,
            },
            [3] = {
                ['Job'] = 'tow',
                ['UseDuty'] = false,
                ['Name'] = 'Loon Ontvangen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-money-bill-alt"></i>',
                ['EventName'] = 'framework-jobmanager:client:request:payment',
                ['Enabled'] = function()
                    return true
                end,
            },
            [4] = {
                ['Job'] = 'tow',
                ['UseDuty'] = false,
                ['Name'] = 'Takelvoertuig Huren (€350)',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-truck"></i>',
                ['EventName'] = 'framework-jobmanager:client:request:vehicle:tow',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_yoga_mat_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Yoga Mat',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-child"></i>',
                ['EventName'] = 'framework-interactions:client:yoga',
                ['EventParameter'] = 'Niks',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_yoga_mat_02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Yoga Mat',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-child"></i>',
                ['EventName'] = 'framework-interactions:client:yoga',
                ['EventParameter'] = 'Niks',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_yoga_mat_03')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Yoga Mat',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-child"></i>',
                ['EventName'] = 'framework-interactions:client:yoga',
                ['EventParameter'] = 'Niks',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('p_yoga_mat_01_s')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Yoga Mat',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-child"></i>',
                ['EventName'] = 'framework-interactions:client:yoga',
                ['EventParameter'] = 'Niks',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('v_corp_fib_glass_thin')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'garbage',
                ['UseDuty'] = false,
                ['Name'] = 'Werkvoertuig Huren (€350)',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-truck"></i>',
                ['EventName'] = 'framework-jobmanager:client:request:vehicle:trash',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = 'garbage',
                ['UseDuty'] = false,
                ['Name'] = 'Loon Ontvangen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-money-bill-alt"></i>',
                ['EventName'] = 'framework-jobmanager:client:request:payment',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('v_ind_cs_bucket')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'police',
                ['UseDuty'] = false,
                ['Name'] = 'In / Uit Dienst',
                ['EventType'] = 'Server',
                ['Logo'] = '<i class="fas fa-user-clock"></i>',
                ['EventName'] = 'LSCore:ToggleDuty',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('p_amb_clipboard_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'ambulance',
                ['UseDuty'] = false,
                ['Name'] = 'In / Uit Dienst',
                ['EventType'] = 'Server',
                ['Logo'] = '<i class="fas fa-user-clock"></i>',
                ['EventName'] = 'LSCore:ToggleDuty',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_till_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Winkel',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-shopping-basket"></i>',
                ['EventName'] = 'framework-stores:server:open:shop',
                ['Enabled'] = function()
                    if exports['fw-stores']:IsNearStore() then
                        return true
                    end
                end,
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Leeg Trekken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hammer"></i>',
                ['EventName'] = 'framework-stores:client:rob:register',
                ['Enabled'] = function()
                    if GetObjectFragmentDamageHealth(Config.EntityData['Entity'], true) < 1.0 and exports['fw-heists']:IsNearStoreRob() then
                        if math.random(1,100) < 45 then
                            TriggerServerEvent('framework-police:server:send:alert:store', GetEntityCoords(PlayerPedId()), LSCore.Functions.GetStreetLabel(), exports['fw-heists']:GetStoreNumber())
                        end
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('prop_till_02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Winkel',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-shopping-basket"></i>',
                ['EventName'] = 'framework-stores:server:open:shop',
                ['Enabled'] = function()
                    if exports['fw-stores']:IsNearStore() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('prop_till_03')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Winkel',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-shopping-basket"></i>',
                ['EventName'] = 'framework-stores:server:open:shop',
                ['Enabled'] = function()
                    if exports['fw-stores']:IsNearStore() then
                        return true
                    end
                end,
            },
        },
    },

    [GetHashKey('prop_vend_coffe_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Koffie Machine',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-coffee"></i>',
                ['EventName'] = 'framework-stores:client:open:custom:store',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 'Coffee',
            },
        },
    },
    [GetHashKey('prop_vend_snak_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Snoep Automaat',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-candy-cane"></i>',
                ['EventName'] = 'framework-stores:client:open:custom:store',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 'Vending',
            },
        },
    },
    -- Dumpsters --
    [GetHashKey('prop_cs_dumpster_01a')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Prullenbak Graaien',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-dumpster"></i>',
                ['EventName'] = 'framework-materials:client:search:trash',
                ['EventParameter'] = 'Niks',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = 'garbage',
                ['UseDuty'] = true,
                ['Name'] = 'Vuilnis Pakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-recycle"></i>',
                ['EventName'] = 'framework-jobmanager:client:get:trash',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_dumpster_02a')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Prullenbak Graaien',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-dumpster"></i>',
                ['EventName'] = 'framework-materials:client:search:trash',
                ['EventParameter'] = 'Niks',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = 'garbage',
                ['UseDuty'] = true,
                ['Name'] = 'Vuilnis Pakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-recycle"></i>',
                ['EventName'] = 'framework-jobmanager:client:get:trash',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_dumpster_01a')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Prullenbak Graaien',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-dumpster"></i>',
                ['EventName'] = 'framework-materials:client:search:trash',
                ['EventParameter'] = 'Niks',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = 'garbage',
                ['UseDuty'] = true,
                ['Name'] = 'Vuilnis Pakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-recycle"></i>',
                ['EventName'] = 'framework-jobmanager:client:get:trash',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_dumpster_02b')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Prullenbak Graaien',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-dumpster"></i>',
                ['EventName'] = 'framework-materials:client:search:trash',
                ['EventParameter'] = 'Niks',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = 'garbage',
                ['UseDuty'] = true,
                ['Name'] = 'Vuilnis Pakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-recycle"></i>',
                ['EventName'] = 'framework-jobmanager:client:get:trash',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_dumpster_4b')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Prullenbak Graaien',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-dumpster"></i>',
                ['EventName'] = 'framework-materials:client:search:trash',
                ['EventParameter'] = 'Niks',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = 'garbage',
                ['UseDuty'] = true,
                ['Name'] = 'Vuilnis Pakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-recycle"></i>',
                ['EventName'] = 'framework-jobmanager:client:get:trash',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_dumpster_3a')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Prullenbak Graaien',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-dumpster"></i>',
                ['EventName'] = 'framework-materials:client:search:trash',
                ['EventParameter'] = 'Niks',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = 'garbage',
                ['UseDuty'] = true,
                ['Name'] = 'Vuilnis Pakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-recycle"></i>',
                ['EventName'] = 'framework-jobmanager:client:get:trash',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('prop_bin_05a')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Prullenbak Graaien',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-dumpster"></i>',
                ['EventName'] = 'framework-materials:client:search:trash',
                ['EventParameter'] = 'Niks',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = 'garbage',
                ['UseDuty'] = true,
                ['Name'] = 'Vuilnis Pakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-recycle"></i>',
                ['EventName'] = 'framework-jobmanager:client:get:trash',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('hei_prop_bank_alarm_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Alarm Uitschakelen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-bell"></i>',
                ['EventName'] = 'framework-jewellery:client:disable:alarm',
                ['EventParameter'] = 'Niks',
                ['Enabled'] = function()
                    if exports['fw-heists']:CanDisableAlarm() and exports['fw-heists']:IsInsideJewel() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('v_ind_cf_flour')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'mechanic',
                ['UseDuty'] = false,
                ['Name'] = 'Craften',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-wrench"></i>',
                ['EventName'] = 'framework-autocare:client:open:craft',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = 'mechanic',
                ['UseDuty'] = false,
                ['Name'] = 'Opslag',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-box"></i>',
                ['EventName'] = 'framework-autocare:client:open:storage',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 'mechanic',
            },
            [3] = {
                ['Job'] = 'stripclub',
                ['UseDuty'] = true,
                ['Name'] = 'Opslag',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-box"></i>',
                ['EventName'] = 'framework-unicorn:client:open:storage',
                ['Enabled'] = function()
                    return true
                end,
            },
            [4] = {
                ['Job'] = 'repairshop',
                ['UseDuty'] = false,
                ['Name'] = 'Craften',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-wrench"></i>',
                ['EventName'] = 'framework-autocare:client:open:craft',
                ['Enabled'] = function()
                    return true
                end,
            },
            [5] = {
                ['Job'] = 'repairshop',
                ['UseDuty'] = false,
                ['Name'] = 'Opslag',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-box"></i>',
                ['EventName'] = 'framework-autocare:client:open:storage',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 'repairshop',
            },
            [6] = {
                ['Job'] = 'sushi',
                ['UseDuty'] = true,
                ['Name'] = 'Opslag',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-box"></i>',
                ['EventName'] = 'framework-sushi:client:open:storage',
                ['Enabled'] = function()
                    if exports['fw-sushi']:IsNearRestaurant() then
                        return true
                    end
                end,
                ['EventParameter'] = 'Storage',
            },
        },
    },
    [GetHashKey('prop_cs_silver_tray')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Dranken Blad',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-cocktail"></i>',
                ['EventName'] = 'framework-unicorn:client:open:tray',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('p_counter_04_glass')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Stelen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="far fa-gem"></i>',
                ['EventName'] = 'framework-heists:client:grab:jewels',
                ['Enabled'] = function()
                    if exports['fw-heists']:CanRobVitrine() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('prop_aircon_m_04')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Juwelier Ventilator',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-wind"></i>',
                ['EventName'] = 'framework-heists:client:jewel:hack:doors',
                ['Enabled'] = function()
                    if exports['fw-heists']:IsNearVent() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('prop_vend_soda_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Frisdrank Automaat',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fab fa-gulp"></i>',
                ['EventName'] = 'framework-stores:client:open:custom:store',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 'FVending',
            },
        },
    },
    [GetHashKey('prop_vend_soda_02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Frisdrank Automaat',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fab fa-gulp"></i>',
                ['EventName'] = 'framework-stores:client:open:custom:store',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 'FVending',
            },
        },
    },
    [GetHashKey('hei_prop_hei_securitypanel')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Beveiligings Paneel',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-server"></i>',
                ['EventName'] = 'framework-bankrobbery:client:use:option',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('hei_prop_heist_deposit_box')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Pakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hand-paper"></i>',
                ['EventName'] = 'framework-bankrobbery:client:grab:option',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('ba_prop_club_dimmer')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'stripclub',
                ['UseDuty'] = true,
                ['Name'] = 'Effecten Dimmer',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hand-paper"></i>',
                ['EventName'] = 'framework-unicorn:client:open:effect:panel',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('p_phonebox_02_s')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Tijd Checken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-clock"></i>',
                ['EventName'] = 'framework-prison:client:check:time',
                ['Enabled'] = function()
                    if exports['fw-prison']:GetInJailStatus() then
                        return true
                    end
                end,
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Slapen',
                ['EventType'] = 'Server',
                ['Logo'] = '<i class="fas fa-bed"></i>',
                ['EventName'] = 'framework-appartments:server:logout',
                ['Enabled'] = function()
                    if exports['fw-prison']:GetInJailStatus() then
                        return true
                    end
                end,
            },
        },
    },
    -- BurgerShot Props --
    [GetHashKey('v_ind_bin_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Bestelling Opnemen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-cash-register"></i>',
                ['EventName'] = 'framework-burgershot:client:open:register',
                ['Enabled'] = function()
                    if exports['fw-burgershot']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Betalen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-receipt"></i>',
                ['EventName'] = 'framework-burgershot:client:open:payment',
                ['Enabled'] = function()
                    if exports['fw-burgershot']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('v_ind_cfbin')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Burgershot Kassa',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-cash-register"></i>',
                ['EventName'] = 'framework-burgershot:client:open:register',
                ['Enabled'] = function()
                    if exports['fw-burgershot']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('v_ind_cm_paintbckt01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Dienblad',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-utensils"></i>',
                ['EventName'] = 'framework-burgershot:client:open:tray',
                ['Enabled'] = function()
                    if exports['fw-burgershot']:IsInsideBurgershot() then
                        return true
                    end
                end,
                ['EventParameter'] = 1,
            },
        },
    },
    [GetHashKey('v_ind_cm_paintbckt02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Dienblad',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-utensils"></i>',
                ['EventName'] = 'framework-burgershot:client:open:tray',
                ['Enabled'] = function()
                    if exports['fw-burgershot']:IsInsideBurgershot() then
                        return true
                    end
                end,
                ['EventParameter'] = 2,
            },
        },
    },
    [GetHashKey('prop_food_bs_tray_03')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Dienblad',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-utensils"></i>',
                ['EventName'] = 'framework-burgershot:client:open:tray',
                ['Enabled'] = function()
                    if exports['fw-burgershot']:IsInsideBurgershot() then
                        return true
                    end
                end,
                ['EventParameter'] = 3,
            },
        },
    },
    [GetHashKey('prop_food_bs_bag_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Zak Pakken',
                ['EventType'] = 'Server',
                ['Logo'] = '<i class="fas fa-shopping-bag"></i>',
                ['EventName'] = 'framework-burgershot:server:get:bag',
                ['Enabled'] = function()
                    if exports['fw-burgershot']:IsInsideBurgershot() then
                        return true
                    end
                end,
                ['EventParameter'] = 3,
            },
        },
    },
    [GetHashKey('prop_food_bs_bag_02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Zak Pakken',
                ['EventType'] = 'Server',
                ['Logo'] = '<i class="fas fa-shopping-bag"></i>',
                ['EventName'] = 'framework-burgershot:server:get:bag',
                ['Enabled'] = function()
                    if exports['fw-burgershot']:IsInsideBurgershot() then
                        return true
                    end
                end,
                ['EventParameter'] = 3,
            },
        },
    },
    [GetHashKey('ch_prop_whiteboard')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Warmte Bak',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hamburger"></i>',
                ['EventName'] = 'framework-burgershot:client:open:hot:storage',
                ['Enabled'] = function()
                    if exports['fw-burgershot']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('v_ret_gc_bag01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Vlees Bakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-drumstick-bite"></i>',
                ['EventName'] = 'framework-burgershot:client:bake:meat',
                ['Enabled'] = function()
                    if exports['fw-burgershot']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('v_ret_gc_bag02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Friet Bakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-drumstick-bite"></i>',
                ['EventName'] = 'framework-burgershot:client:bake:fries',
                ['Enabled'] = function()
                    if exports['fw-burgershot']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('v_m_props_ff_fridge_01_door')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Koeling Opslag',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-boxes"></i>',
                ['EventName'] = 'framework-burgershot:client:open:cold:storage',
                ['Enabled'] = function()
                    if exports['fw-burgershot']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('v_ilev_fib_frame03')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = true,
                ['Name'] = 'Smelter Inventaris',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-boxes"></i>',
                ['EventName'] = 'framework-pawnshop:client:smelter:inventory',
                ['Enabled'] = function()
                    if exports['fw-pawnshop']:NearSmelter() then
                        return true
                    end
                end,
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = true,
                ['Name'] = 'Start Smelter',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-play"></i>',
                ['EventName'] = 'framework-pawnshop:client:start:smelter',
                ['Enabled'] = function()
                    if exports['fw-pawnshop']:NearSmelter() then
                        return true
                    end
                end,
            }
        },
    },
    [GetHashKey('v_ilev_fib_frame02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Softdrink Maken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-wine-bottle"></i>',
                ['EventName'] = 'framework-burgershot:client:create:drink',
                ['EventParameter'] = 'burger-softdrink',
                ['Enabled'] = function()
                    return true
                end,
            },
            [2] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Koffie Maken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-wine-bottle"></i>',
                ['EventName'] = 'framework-burgershot:client:create:drink',
                ['EventParameter'] = 'burger-coffee',
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('v_ind_cs_toolboard')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'burger',
                ['UseDuty'] = false,
                ['Name'] = 'In / Uit Klokken',
                ['EventType'] = 'Server',
                ['Logo'] = '<i class="fas fa-user-clock"></i>',
                ['EventName'] = 'LSCore:ToggleDuty',
                ['Enabled'] = function()
                    if exports['fw-burgershot']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
            [2] = {
                ['Job'] = 'sushi',
                ['UseDuty'] = false,
                ['Name'] = 'In / Uit Klokken',
                ['EventType'] = 'Server',
                ['Logo'] = '<i class="fas fa-user-clock"></i>',
                ['EventName'] = 'LSCore:ToggleDuty',
                ['Enabled'] = function()
                    if exports['fw-sushi']:IsNearRestaurant() then
                        return true
                    end    
                end,
            },
        },
    },
    [GetHashKey('v_ind_cm_paintbckt03')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'sushi',
                ['UseDuty'] = true,
                ['Name'] = 'Bestelling Opnemen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-cash-register"></i>',
                ['EventName'] = 'framework-sushi:client:open:register',
                ['Enabled'] = function()
                    if exports['fw-sushi']:IsNearRestaurant() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('v_ind_cm_paintbckt04')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Betalen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-receipt"></i>',
                ['EventName'] = 'framework-sushi:client:open:payment',
                ['Enabled'] = function()
                    if exports['fw-sushi']:IsNearRestaurant() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('prop_kitch_pot_huge')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'sushi',
                ['UseDuty'] = true,
                ['Name'] = 'Eten Maken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-fish"></i>',
                ['EventName'] = 'framework-sushi:client:open:cooker',
                ['Enabled'] = function()
                    if exports['fw-sushi']:IsNearRestaurant() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('prop_plate_warmer')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Dienblad',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-utensils"></i>',
                ['EventName'] = 'framework-sushi:client:open:storage',
                ['Enabled'] = function()
                    if exports['fw-sushi']:IsNearRestaurant() then
                        return true
                    end
                end,
                ['EventParameter'] = 'Tray',
            },
        },
    },
    [GetHashKey('v_res_fa_pottea')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'sushi',
                ['UseDuty'] = true,
                ['Name'] = 'Thee zetten',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-utensils"></i>',
                ['EventName'] = 'framework-sushi:client:make:tea',
                ['Enabled'] = function()
                    if exports['fw-sushi']:IsNearRestaurant() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('v_ret_fh_pot01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Bleeder Maken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hamburger"></i>',
                ['EventName'] = 'framework-burgershot:client:create:burger',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 'burger-bleeder',
            },
            [2] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Heartstopper Maken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hamburger"></i>',
                ['EventName'] = 'framework-burgershot:client:create:burger',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 'burger-heartstopper',
            },
            [3] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Moneyshot Maken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hamburger"></i>',
                ['EventName'] = 'framework-burgershot:client:create:burger',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 'burger-moneyshot',
            },
            [4] = {
                ['Job'] = 'burger',
                ['UseDuty'] = true,
                ['Name'] = 'Torpedo Maken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hamburger"></i>',
                ['EventName'] = 'framework-burgershot:client:create:burger',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 'burger-torpedo',
            },
        },
    },
    [GetHashKey('prop_tv_flat_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Stelen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hands"></i>',
                ['EventName'] = 'framework-houseobbery:client:steal:item',
                ['Enabled'] = function()
                    if exports['fw-illegal']:CanRobItems() then
                        return true
                    end
                end,
                ['EventParameter'] = 'TV',
            },
        },
    },
    [GetHashKey('prop_micro_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Stelen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hands"></i>',
                ['EventName'] = 'framework-houseobbery:client:steal:item',
                ['Enabled'] = function()
                    if exports['fw-illegal']:CanRobItems() then
                        return true
                    end
                end,
                ['EventParameter'] = 'Micro',
            },
        },
    },
    [GetHashKey('v_med_bed1')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Liggen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-procedures"></i>',
                ['EventName'] = 'framework-hospital:client:lay:bed',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = '',
            },
        },
    },
    [-1519439119] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Liggen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-procedures"></i>',
                ['EventName'] = 'framework-hospital:client:lay:bed',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = '',
            },
        },
    },
    [-289946279] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Liggen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-procedures"></i>',
                ['EventName'] = 'framework-hospital:client:lay:bed',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = '',
            },
        },
    },
    [GetHashKey('ch_prop_ch_cash_trolly_01c')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Pakken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-hand-holding-usd"></i>',
                ['EventName'] = 'framework-heists:client:bobcat:try:grab:trolly',
                ['Enabled'] = function()
                    if exports['fw-heists']:IsInsideBobcat() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
        },
    },
    [GetHashKey('prop_mil_crate_02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Krat Openmaken',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-boxes"></i>',
                ['EventName'] = 'framework-heists:client:bobcat:try:grab:crate',
                ['Enabled'] = function()
                    if exports['fw-heists']:IsInsideBobcat() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
        },
    },
    -- [GetHashKey('prop_byard_scfhold01')] = {
    --     ['Options'] = {
    --         [1] = {
    --             ['Job'] = false,
    --             ['UseDuty'] = false,
    --             ['Name'] = 'Droog Rek',
    --             ['EventType'] = 'Client',
    --             ['Logo'] = '<i class="fas fa-seedling"></i>',
    --             ['EventName'] = 'framework-illegal:client:open:dry:rack',
    --             ['Enabled'] = function()
    --                 return true
    --             end,
    --             ['EventParameter'] = '',
    --         },
    --     },
    -- },
    [GetHashKey('p_planning_board_02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'police',
                ['UseDuty'] = true,
                ['Name'] = 'URL Veranderen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-boxes"></i>',
                ['EventName'] = 'framework-assets:client:change:dui:menu',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = 'police-briefing',
            },
            [2] = {
                ['Job'] = 'police',
                ['UseDuty'] = true,
                ['Name'] = 'Disco Mode',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-music"></i>',
                ['EventName'] = 'framework-police:client:try:toggle:disco',
                ['Enabled'] = function()
                    return true
                end,
                ['EventParameter'] = '',
            },
        },
    },
    -- Peds --
    [GetHashKey('s_m_m_highsec_02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Salaris Ophalen',
                ['EventType'] = 'Server',
                ['Logo'] = '<i class="fas fa-receipt"></i>',
                ['EventName'] = 'LSCore:Server:recieve:paycheck',
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
            [2] = {
                ['Job'] = 'burger',
                ['UseDuty'] = false,
                ['Name'] = 'Bonnetjes Inleveren',
                ['EventType'] = 'Server',
                ['Logo'] = '<i class="fas fa-receipt"></i>',
                ['EventName'] = 'framework-burgershot:server:sell:tickets',
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
        },
    },
    [GetHashKey('a_m_m_eastsa_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Praten',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-comments"></i>',
                ['EventName'] = 'framework-randomdealer:client:talk',
                ['Enabled'] = function()
                    if exports['fw-randomdealer']:NearNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
        },
    },
    [GetHashKey('a_m_m_soucent_03')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Werken (€1000)',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-comments"></i>',
                ['EventName'] = 'framework-illegal:client:start:oxy',
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() and exports['fw-illegal']:CanStartOxy() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
        },
    },
    [GetHashKey('a_m_m_farmer_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Praten',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-comments"></i>',
                ['EventName'] = 'framework-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = 'Niks',
            },
        },
    },
    [GetHashKey('mp_m_waremech_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Verkoop Inventaris',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-boxes"></i>',
                ['EventName'] = 'framework-interactions:client:talk:to:npc', 
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = 'BarsItem',
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Goederen Verkopen',
                ['EventType'] = 'Server',
                ['Logo'] = '<i class="fas fa-comments"></i>',
                ['EventName'] = 'framework-illegal:server:try:sell:other', 
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = 'BarsItem',
            },
        },
    },
    [GetHashKey('s_m_m_gardener_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Tool Winkel',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-key"></i>',
                ['EventName'] = 'framework-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
        },
    },
    [GetHashKey('a_f_m_prolhost_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Vis Winkel',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-key"></i>',
                ['EventName'] = 'framework-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Vis Verkopen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-fish"></i>',
                ['EventName'] = 'framework-fishing:client:sell:fish',
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
        },
    },
    [GetHashKey('a_f_m_ktown_02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Praten',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-comments"></i>',
                ['EventName'] = 'framework-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
        },
    },  
    [GetHashKey('a_m_m_bevhills_02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Praten',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-comments"></i>',
                ['EventName'] = 'framework-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
        },
    },  
    [GetHashKey('a_m_m_eastsa_02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Voertuig Huren',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-car"></i>',
                ['EventName'] = 'framework-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
        },
    },  
    [GetHashKey('u_f_m_casinocash_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Test',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-car"></i>',
                ['EventName'] = 'framework-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
        },
    },  
    [GetHashKey('a_f_y_vinewood_02')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Praten',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-house-damage"></i>',
                ['EventName'] = 'framework-houserobbery:client:start:job',
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
        },
    },
    [GetHashKey('csb_trafficwarden')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = 'police',
                ['UseDuty'] = true,
                ['Name'] = 'Politie Garage',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-warehouse"></i>',
                ['EventName'] = 'framework-police:client:open:garage', 
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('s_m_m_pilot_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Voertuig Huren',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-plane"></i>',
                ['EventName'] = 'framework-flightschool:client:open:rental', 
                ['Enabled'] = function()
                    if exports['fw-flightschool']:HasBrevet() then
                        return true
                    end
                end,
            },
            [2] = {
                ['Job'] = 'flightschool',
                ['UseDuty'] = true,
                ['Name'] = 'Oefen Voertuig',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-plane"></i>',
                ['EventName'] = 'framework-flightschool:client:open:learn', 
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
    [GetHashKey('A_M_M_POLYNESIAN_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Verkoop',
                ['EventType'] = 'Server',
                ['Logo'] = '<i class="fas fa-dollar-sign"></i>',
                ['EventName'] = 'framework-illegal:server:sell:weedbrick', 
                ['Enabled'] = function()
                    if exports['fw-illegal']:NearNpc() then
                        return true
                    end
                end,
            },
        },
    },
    [GetHashKey('g_m_m_mexboss_01')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Verkoop Inventaris',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-boxes"></i>',
                ['EventName'] = 'framework-interactions:client:talk:to:npc', 
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = 'BarsItem',
            },
            [2] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Goederen Verkopen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-comments"></i>',
                ['EventName'] = 'framework-pawnshop:client:try:sell', 
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = 'BarsItem',
            },
        },
    },
    [GetHashKey('s_m_m_ammucountry')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Goederen Verkoop',
                ['EventType'] = 'Server',
                ['Logo'] = '<i class="fas fa-boxes"></i>',
                ['EventName'] = 'framework-jobmanager:server:sell:hunting', 
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = '',
            },
        },
    },
    [GetHashKey('ig_old_man2')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Mijn Kerel',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="fas fa-boxes"></i>',
                ['EventName'] = 'framework-interactions:client:talk:to:npc', 
                ['Enabled'] = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = 'Niks',
            },
        },
    },
    [GetHashKey('vw_prop_vw_luckywheel_01a')] = {
        ['Options'] = {
            [1] = {
                ['Job'] = false,
                ['UseDuty'] = false,
                ['Name'] = 'Spelen',
                ['EventType'] = 'Client',
                ['Logo'] = '<i class="far fa-credit-card"></i>',
                ['EventName'] = 'luckywheel:client:startWheel', 
                ['Enabled'] = function()
                    return true
                end,
            },
        },
    },
}

Config.VehicleMenu = {
    [1] = {
        ['Name'] = 'Kofferbak Liggen',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-couch"></i>',
        ['EventName'] = 'framework-assets:client:getin:trunk',
        ['Enabled'] = function()
            if GetVehicleDoorAngleRatio(Config.EntityData['Entity'], 5) > 0 then
                return true
            end
        end,
    },
    [2] = {
        ['Job'] = 'mechanic',
        ['UseDuty'] = false,
        ['Name'] = 'Motor Kap',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-car"></i>',
        ['EventName'] = 'framework-autocare:client:open:hood',
        ['Enabled'] = function()
            return true
        end,
    },
    [3] = {
        ['Job'] = 'mechanic',
        ['UseDuty'] = false,
        ['Name'] = 'Voertuig Checken',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-cogs"></i>',
        ['EventName'] = 'framework-autocare:client:check:vehicle',
        ['Enabled'] = function()
            return true
        end,
    },
    [4] = {
        ['Job'] = 'repairshop',
        ['UseDuty'] = false,
        ['Name'] = 'Motor Kap',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-car"></i>',
        ['EventName'] = 'framework-autocare:client:open:hood',
        ['Enabled'] = function()
            return true
        end,
    },
    [5] = {
        ['Job'] = 'repairshop',
        ['UseDuty'] = false,
        ['Name'] = 'Voertuig Checken',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-cogs"></i>',
        ['EventName'] = 'framework-autocare:client:check:vehicle',
        ['Enabled'] = function()
            return true
        end,
    },
    [6] = {
        ['Job'] = 'garbage',
        ['UseDuty'] = true,
        ['Name'] = 'Voertuig Inleveren',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-car"></i>',
        ['EventName'] = 'framework-jobmanager:client:return:job:vehicle',
        ['EventParameter'] = 'garbage',
        ['Enabled'] = function()
            return true
        end,
    },
    [7] = {
        ['Job'] = 'tow',
        ['UseDuty'] = true,
        ['Name'] = 'Voertuig Inleveren',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-car"></i>',
        ['EventName'] = 'framework-jobmanager:client:return:job:vehicle',
        ['EventParameter'] = 'tow',
        ['Enabled'] = function()
            return true
        end,
    },
    [8] = {
        ['Job'] = 'taxi',
        ['UseDuty'] = true,
        ['Name'] = 'Voertuig Inleveren',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-car"></i>',
        ['EventName'] = 'framework-jobmanager:client:return:job:vehicle',
        ['EventParameter'] = 'taxi',
        ['Enabled'] = function()
            return true
        end,
    },
    [9] = {
        ['Job'] = 'police',
        ['UseDuty'] = true,
        ['Name'] = 'Voertuig Inleveren',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-car"></i>',
        ['EventName'] = 'framework-police:client:delete:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['fw-government']:IsNearGarage() then
                return true
            end
        end,
    },
    [10] = {
        ['Job'] = false,
        ['UseDuty'] = false,
        ['Name'] = 'Voertuig Tanken',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-gas-pump"></i>',
        ['EventName'] = 'framework-fuel:client:open:menu',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['fw-vehicles']:NearGasPump() then
                return true
            end
        end,
    },
    [11] = {
        ['Job'] = false,
        ['UseDuty'] = false,
        ['Name'] = 'Voertuig Parkeren',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-parking"></i>',
        ['EventName'] = 'framework-garages:client:try:park:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['fw-housing']:IsPlayerOnAParkingSpot() then
                return true
            end
        end,
    },
    [12] = {
        ['Job'] = 'cardealer',
        ['UseDuty'] = true,
        ['Name'] = 'Voertuig Verkopen',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-comments-dollar"></i>',
        ['EventName'] = 'framework-cardealer:client:sell:clossest:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['fw-cardealer']:InsideCardealer() then
                return true
            end
        end,
    },
    [13] = {
        ['Job'] = 'cardealer',
        ['UseDuty'] = true,
        ['Name'] = 'Voertuig Testen',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-shuttle-van"></i>',
        ['EventName'] = 'framework-cardealer:client:test:closest:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['fw-cardealer']:InsideCardealer() then
                return true
            end
        end,
    },
    [14] = {
        ['Job'] = false,
        ['UseDuty'] = false,
        ['Name'] = 'Voertuig Kopen',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-dollar-sign"></i>',
        ['EventName'] = 'framework-vehicleshop:client:buy:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['fw-vehicleshop']:IsInsideDealer() then
                return true
            end
        end,
    },
    [15] = {
        ['Job'] = 'motordealer',
        ['UseDuty'] = false,
        ['Name'] = 'Voertuig Verkopen',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-comments-dollar"></i>',
        ['EventName'] = 'framework-motordealer:client:sell:clossest:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['fw-motordealer']:IsInsideMotorDealer() then
                return true
            end
        end,
    },
    [16] = {
        ['Job'] = 'motordealer',
        ['UseDuty'] = false,
        ['Name'] = 'Voertuig Testen',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-shuttle-van"></i>',
        ['EventName'] = 'framework-motordealer:client:test:closest:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['fw-motordealer']:IsInsideMotorDealer() then
                return true
            end
        end,
    },
    [17] = {
        ['Job'] = false,
        ['UseDuty'] = false,
        ['Name'] = 'Pakketje Afgeven',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-box"></i>',
        ['EventName'] = 'framework-illegal:client:try:deliver',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['fw-illegal']:CanDeliverOxyBox(Config.EntityData) then
                return true
            end
        end,
    },
    
}

Config.BikeMenu = {
    [1] = {
        ['Job'] = false,
        ['UseDuty'] = true,
        ['Name'] = 'Fiets Tillen',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-bicycle"></i>',
        ['EventName'] = 'framework-vehicles:client:carry:bicycle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            return true
        end,
    },
    [2] = {
        ['Job'] = false,
        ['UseDuty'] = false,
        ['Name'] = 'Voertuig Parkeren',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-parking"></i>',
        ['EventName'] = 'framework-garages:client:try:park:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['fw-housing']:IsPlayerOnAParkingSpot() then
                return true
            end
        end,
    },
    [3] = {
        ['Job'] = false,
        ['UseDuty'] = false,
        ['Name'] = 'Voertuig Kopen',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-dollar-sign"></i>',
        ['EventName'] = 'framework-vehicleshop:client:buy:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['fw-vehicleshop']:IsInsideDealer() then
                return true
            end
        end,
    },
}

Config.PlayerMenu = {}

Config.PedMenu = {}