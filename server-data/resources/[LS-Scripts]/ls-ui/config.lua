Config = Config or {}

Config.DoingSkill = false

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
                ['EventName'] = 'ls-banking:client:open:atm', 
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
                ['EventName'] = 'ls-banking:client:open:atm', 
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
                ['EventName'] = 'ls-banking:client:open:atm', 
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
                ['EventName'] = 'ls-banking:client:open:atm', 
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
                ['EventName'] = 'ls-ui:client:practice:game', 
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
                ['EventName'] = 'ls-ui:client:practice:game', 
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
                ['EventName'] = 'ls-ui:client:open:newspaper', 
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
                ['EventName'] = 'ls-ui:client:purchase:magazine', 
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
                ['EventName'] = 'ls-ui:client:open:newspaper', 
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
                ['EventName'] = 'ls-ui:client:purchase:magazine', 
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
                ['EventName'] = 'ls-ui:client:open:newspaper', 
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
                ['EventName'] = 'ls-ui:client:purchase:magazine', 
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
                ['EventName'] = 'ls-ui:client:open:newspaper', 
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
                ['EventName'] = 'ls-ui:client:purchase:magazine', 
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
                ['EventName'] = 'ls-crafting:client:open:crafting', 
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
                ['EventName'] = 'ls-materials:client:open:recycle:crafting', 
                ['Enabled'] = function()
                    if exports['ls-materials']:InsideRecycle() then
                        return true
                    end
                end,
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
                ['EventName'] = 'ls-materials:client:recycle:toggle:duty',
                ['Enabled'] = function()
                    if exports['ls-materials']:InsideRecycle() then
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
                ['EventName'] = 'ls-jobmanager:client:request:payment',
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
                ['EventName'] = 'ls-jobmanager:client:request:vehicle:taxi', 
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
                ['EventName'] = 'ls-cardealer:client:open:select:menu',
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
                ['EventName'] = 'ls-motordealer:client:open:select:menu',
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
                ['EventName'] = 'ls-items:client:remove:wheelchair',
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
            --     ['EventName'] = 'ls-vehicles:client:control:vehicle',
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
                ['EventName'] = 'ls-cityhall:client:open:menu',
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
                ['EventName'] = 'ls-cityhall:client:open:menu',
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
                ['EventName'] = 'ls-cityhall:client:open:menu',
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
                ['EventName'] = 'ls-cityhall:client:request:items',
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
                ['EventName'] = 'ls-garage:client:open:depot:menu',
                ['Enabled'] = function()
                    if exports['ls-garages']:IsInsideDepot() then
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
                ['EventName'] = 'ls-garages:client:open:impound:menu',
                ['Enabled'] = function()
                    if exports['ls-garages']:IsInsideDepot() then
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
                ['EventName'] = 'ls-jobmanager:client:request:payment',
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
                ['EventName'] = 'ls-jobmanager:client:request:vehicle:tow',
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
                ['EventName'] = 'ls-interactions:client:yoga',
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
                ['EventName'] = 'ls-interactions:client:yoga',
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
                ['EventName'] = 'ls-interactions:client:yoga',
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
                ['EventName'] = 'ls-interactions:client:yoga',
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
                ['EventName'] = 'ls-jobmanager:client:request:vehicle:trash',
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
                ['EventName'] = 'ls-jobmanager:client:request:payment',
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
                ['EventName'] = 'ls-stores:server:open:shop',
                ['Enabled'] = function()
                    if exports['ls-stores']:IsNearStore() then
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
                ['EventName'] = 'ls-stores:client:rob:register',
                ['Enabled'] = function()
                    if GetObjectFragmentDamageHealth(Config.EntityData['Entity'], true) < 1.0 and exports['ls-heists']:IsNearStoreRob() then
                        if math.random(1,100) < 45 then
                            TriggerServerEvent('ls-police:server:send:alert:store', GetEntityCoords(GetPlayerPed(-1)), LSCore.Functions.GetStreetLabel(), exports['ls-heists']:GetStoreNumber())
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
                ['EventName'] = 'ls-stores:server:open:shop',
                ['Enabled'] = function()
                    if exports['ls-stores']:IsNearStore() then
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
                ['EventName'] = 'ls-stores:server:open:shop',
                ['Enabled'] = function()
                    if exports['ls-stores']:IsNearStore() then
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
                ['EventName'] = 'ls-stores:client:open:custom:store',
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
                ['EventName'] = 'ls-stores:client:open:custom:store',
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
                ['EventName'] = 'ls-materials:client:search:trash',
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
                ['EventName'] = 'ls-jobmanager:client:get:trash',
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
                ['EventName'] = 'ls-materials:client:search:trash',
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
                ['EventName'] = 'ls-jobmanager:client:get:trash',
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
                ['EventName'] = 'ls-materials:client:search:trash',
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
                ['EventName'] = 'ls-jobmanager:client:get:trash',
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
                ['EventName'] = 'ls-materials:client:search:trash',
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
                ['EventName'] = 'ls-jobmanager:client:get:trash',
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
                ['EventName'] = 'ls-materials:client:search:trash',
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
                ['EventName'] = 'ls-jobmanager:client:get:trash',
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
                ['EventName'] = 'ls-materials:client:search:trash',
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
                ['EventName'] = 'ls-jobmanager:client:get:trash',
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
                ['EventName'] = 'ls-materials:client:search:trash',
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
                ['EventName'] = 'ls-jobmanager:client:get:trash',
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
                ['EventName'] = 'ls-jewellery:client:disable:alarm',
                ['EventParameter'] = 'Niks',
                ['Enabled'] = function()
                    if exports['ls-heists']:CanDisableAlarm() and exports['ls-heists']:IsInsideJewel() then
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
                ['EventName'] = 'ls-autocare:client:open:craft',
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
                ['EventName'] = 'ls-autocare:client:open:storage',
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
                ['EventName'] = 'ls-unicorn:client:open:storage',
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
                ['EventName'] = 'ls-autocare:client:open:craft',
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
                ['EventName'] = 'ls-autocare:client:open:storage',
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
                ['EventName'] = 'ls-sushi:client:open:storage',
                ['Enabled'] = function()
                    if exports['ls-sushi']:IsNearRestaurant() then
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
                ['EventName'] = 'ls-unicorn:client:open:tray',
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
                ['EventName'] = 'ls-heists:client:grab:jewels',
                ['Enabled'] = function()
                    if exports['ls-heists']:CanRobVitrine() then
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
                ['EventName'] = 'ls-heists:client:jewel:hack:doors',
                ['Enabled'] = function()
                    if exports['ls-heists']:IsNearVent() then
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
                ['EventName'] = 'ls-stores:client:open:custom:store',
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
                ['EventName'] = 'ls-stores:client:open:custom:store',
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
                ['EventName'] = 'ls-bankrobbery:client:use:option',
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
                ['EventName'] = 'ls-bankrobbery:client:grab:option',
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
                ['EventName'] = 'ls-unicorn:client:open:effect:panel',
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
                ['EventName'] = 'ls-prison:client:check:time',
                ['Enabled'] = function()
                    if exports['ls-prison']:GetInJailStatus() then
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
                ['EventName'] = 'ls-appartments:server:logout',
                ['Enabled'] = function()
                    if exports['ls-prison']:GetInJailStatus() then
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
                ['EventName'] = 'ls-burgershot:client:open:register',
                ['Enabled'] = function()
                    if exports['ls-burgershot']:IsInsideBurgershot() then
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
                ['EventName'] = 'ls-burgershot:client:open:payment',
                ['Enabled'] = function()
                    if exports['ls-burgershot']:IsInsideBurgershot() then
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
                ['EventName'] = 'ls-burgershot:client:open:register',
                ['Enabled'] = function()
                    if exports['ls-burgershot']:IsInsideBurgershot() then
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
                ['EventName'] = 'ls-burgershot:client:open:tray',
                ['Enabled'] = function()
                    if exports['ls-burgershot']:IsInsideBurgershot() then
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
                ['EventName'] = 'ls-burgershot:client:open:tray',
                ['Enabled'] = function()
                    if exports['ls-burgershot']:IsInsideBurgershot() then
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
                ['EventName'] = 'ls-burgershot:client:open:tray',
                ['Enabled'] = function()
                    if exports['ls-burgershot']:IsInsideBurgershot() then
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
                ['EventName'] = 'ls-burgershot:server:get:bag',
                ['Enabled'] = function()
                    if exports['ls-burgershot']:IsInsideBurgershot() then
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
                ['EventName'] = 'ls-burgershot:server:get:bag',
                ['Enabled'] = function()
                    if exports['ls-burgershot']:IsInsideBurgershot() then
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
                ['EventName'] = 'ls-burgershot:client:open:hot:storage',
                ['Enabled'] = function()
                    if exports['ls-burgershot']:IsInsideBurgershot() then
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
                ['EventName'] = 'ls-burgershot:client:bake:meat',
                ['Enabled'] = function()
                    if exports['ls-burgershot']:IsInsideBurgershot() then
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
                ['EventName'] = 'ls-burgershot:client:bake:fries',
                ['Enabled'] = function()
                    if exports['ls-burgershot']:IsInsideBurgershot() then
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
                ['EventName'] = 'ls-burgershot:client:open:cold:storage',
                ['Enabled'] = function()
                    if exports['ls-burgershot']:IsInsideBurgershot() then
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
                ['EventName'] = 'ls-pawnshop:client:smelter:inventory',
                ['Enabled'] = function()
                    if exports['ls-pawnshop']:NearSmelter() then
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
                ['EventName'] = 'ls-pawnshop:client:start:smelter',
                ['Enabled'] = function()
                    if exports['ls-pawnshop']:NearSmelter() then
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
                ['EventName'] = 'ls-burgershot:client:create:drink',
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
                ['EventName'] = 'ls-burgershot:client:create:drink',
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
                    if exports['ls-burgershot']:IsInsideBurgershot() then
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
                    if exports['ls-sushi']:IsNearRestaurant() then
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
                ['EventName'] = 'ls-sushi:client:open:register',
                ['Enabled'] = function()
                    if exports['ls-sushi']:IsNearRestaurant() then
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
                ['EventName'] = 'ls-sushi:client:open:payment',
                ['Enabled'] = function()
                    if exports['ls-sushi']:IsNearRestaurant() then
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
                ['EventName'] = 'ls-sushi:client:open:cooker',
                ['Enabled'] = function()
                    if exports['ls-sushi']:IsNearRestaurant() then
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
                ['EventName'] = 'ls-sushi:client:open:storage',
                ['Enabled'] = function()
                    if exports['ls-sushi']:IsNearRestaurant() then
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
                ['EventName'] = 'ls-sushi:client:make:tea',
                ['Enabled'] = function()
                    if exports['ls-sushi']:IsNearRestaurant() then
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
                ['EventName'] = 'ls-burgershot:client:create:burger',
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
                ['EventName'] = 'ls-burgershot:client:create:burger',
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
                ['EventName'] = 'ls-burgershot:client:create:burger',
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
                ['EventName'] = 'ls-burgershot:client:create:burger',
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
                ['EventName'] = 'ls-houseobbery:client:steal:item',
                ['Enabled'] = function()
                    if exports['ls-houserobbery']:CanRobItems() then
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
                ['EventName'] = 'ls-houseobbery:client:steal:item',
                ['Enabled'] = function()
                    if exports['ls-houserobbery']:CanRobItems() then
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
                ['EventName'] = 'ls-hospital:client:lay:bed',
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
                ['EventName'] = 'ls-hospital:client:lay:bed',
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
                ['EventName'] = 'ls-hospital:client:lay:bed',
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
                ['EventName'] = 'ls-heists:client:bobcat:try:grab:trolly',
                ['Enabled'] = function()
                    if exports['ls-heists']:IsInsideBobcat() then
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
                ['EventName'] = 'ls-heists:client:bobcat:try:grab:crate',
                ['Enabled'] = function()
                    if exports['ls-heists']:IsInsideBobcat() then
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
    --             ['EventName'] = 'ls-illegal:client:open:dry:rack',
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
                ['EventName'] = 'ls-assets:client:change:dui:menu',
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
                ['EventName'] = 'ls-police:client:try:toggle:disco',
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
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-burgershot:server:sell:tickets',
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-randomdealer:client:talk',
                ['Enabled'] = function()
                    if exports['ls-randomdealer']:NearNpc() then
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
                ['EventName'] = 'ls-illegal:client:start:oxy',
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() and exports['ls-illegal']:CanStartOxy() then
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
                ['EventName'] = 'ls-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-interactions:client:talk:to:npc', 
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-illegal:server:try:sell:other', 
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-fishing:client:sell:fish',
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-interactions:client:talk:to:npc',
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-houserobbery:client:start:job',
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-police:client:open:garage', 
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
                ['EventName'] = 'ls-flightschool:client:open:rental', 
                ['Enabled'] = function()
                    if exports['ls-flightschool']:HasBrevet() then
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
                ['EventName'] = 'ls-flightschool:client:open:learn', 
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
                ['EventName'] = 'ls-illegal:server:sell:weedbrick', 
                ['Enabled'] = function()
                    if exports['ls-illegal']:NearNpc() then
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
                ['EventName'] = 'ls-interactions:client:talk:to:npc', 
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-pawnshop:client:try:sell', 
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-jobmanager:server:sell:hunting', 
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
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
                ['EventName'] = 'ls-interactions:client:talk:to:npc', 
                ['Enabled'] = function()
                    if exports['ls-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
                ['EventParameter'] = 'Niks',
            },
        },
    },
}

Config.VehicleMenu = {
    [1] = {
        ['Name'] = 'Kofferbak Liggen',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-couch"></i>',
        ['EventName'] = 'ls-assets:client:getin:trunk',
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
        ['EventName'] = 'ls-autocare:client:open:hood',
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
        ['EventName'] = 'ls-autocare:client:check:vehicle',
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
        ['EventName'] = 'ls-autocare:client:open:hood',
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
        ['EventName'] = 'ls-autocare:client:check:vehicle',
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
        ['EventName'] = 'ls-jobmanager:client:return:job:vehicle',
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
        ['EventName'] = 'ls-jobmanager:client:return:job:vehicle',
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
        ['EventName'] = 'ls-jobmanager:client:return:job:vehicle',
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
        ['EventName'] = 'ls-police:client:delete:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['ls-police']:IsNearGarage() then
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
        ['EventName'] = 'ls-fuel:client:open:menu',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['ls-fuel']:NearGasPump() then
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
        ['EventName'] = 'ls-garages:client:try:park:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['ls-garages']:IsPlayerOnAParkingSpot() then
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
        ['EventName'] = 'ls-cardealer:client:sell:clossest:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['ls-cardealer']:InsideCardealer() then
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
        ['EventName'] = 'ls-cardealer:client:test:closest:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['ls-cardealer']:InsideCardealer() then
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
        ['EventName'] = 'ls-vehicleshop:client:buy:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['ls-vehicleshop']:IsInsideDealer() then
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
        ['EventName'] = 'ls-motordealer:client:sell:clossest:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['ls-motordealer']:IsInsideMotorDealer() then
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
        ['EventName'] = 'ls-motordealer:client:test:closest:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['ls-motordealer']:IsInsideMotorDealer() then
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
        ['EventName'] = 'ls-illegal:client:try:deliver',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['ls-illegal']:CanDeliverOxyBox(Config.EntityData) then
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
        ['EventName'] = 'ls-vehicles:client:carry:bicycle',
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
        ['EventName'] = 'ls-garages:client:try:park:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['ls-garages']:IsPlayerOnAParkingSpot() then
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
        ['EventName'] = 'ls-vehicleshop:client:buy:vehicle',
        ['EventParameter'] = 'Niks',
        ['Enabled'] = function()
            if exports['ls-vehicleshop']:IsInsideDealer() then
                return true
            end
        end,
    },
}

Config.PlayerMenu = {}

Config.PedMenu = {}