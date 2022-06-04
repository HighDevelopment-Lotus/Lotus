local Config, Players, Types, Entities, Models, Zones, Bones, PlayerData = {}, {}, {}, {}, {}, {}, {}, {}
Types[1], Types[2], Types[3] = {}, {}, {}

-- This is the vehicle bones table, this is needed to verify if the vehicle bone exists when checking them, here is a list of vehicle bones you can use, all of them are included in this table: https://wiki.rage.mp/index.php?title=Vehicle_Bones
Config.VehicleBones = {'chassis', 'chassis_lowlod', 'chassis_dummy', 'seat_dside_f', 'seat_dside_r', 'seat_dside_r1', 'seat_dside_r2', 'seat_dside_r3', 'seat_dside_r4', 'seat_dside_r5', 'seat_dside_r6', 'seat_dside_r7', 'seat_pside_f', 'seat_pside_r', 'seat_pside_r1', 'seat_pside_r2', 'seat_pside_r3', 'seat_pside_r4', 'seat_pside_r5', 'seat_pside_r6', 'seat_pside_r7', 'window_lf1', 'window_lf2', 'window_lf3', 'window_rf1', 'window_rf2', 'window_rf3', 'window_lr1', 'window_lr2', 'window_lr3', 'window_rr1', 'window_rr2', 'window_rr3', 'door_dside_f', 'door_dside_r', 'door_pside_f', 'door_pside_r', 'handle_dside_f', 'handle_dside_r', 'handle_pside_f', 'handle_pside_r', 'wheel_lf', 'wheel_rf', 'wheel_lm1', 'wheel_rm1', 'wheel_lm2', 'wheel_rm2', 'wheel_lm3', 'wheel_rm3', 'wheel_lr', 'wheel_rr', 'suspension_lf', 'suspension_rf', 'suspension_lm', 'suspension_rm', 'suspension_lr', 'suspension_rr', 'spring_rf', 'spring_lf', 'spring_rr', 'spring_lr', 'transmission_f', 'transmission_m', 'transmission_r', 'hub_lf', 'hub_rf', 'hub_lm1', 'hub_rm1', 'hub_lm2', 'hub_rm2', 'hub_lm3', 'hub_rm3', 'hub_lr', 'hub_rr', 'windscreen', 'windscreen_r', 'window_lf', 'window_rf', 'window_lr', 'window_rr', 'window_lm', 'window_rm', 'bodyshell', 'bumper_f', 'bumper_r', 'wing_rf', 'wing_lf', 'bonnet', 'boot', 'exhaust', 'exhaust_2', 'exhaust_3', 'exhaust_4', 'exhaust_5', 'exhaust_6', 'exhaust_7', 'exhaust_8', 'exhaust_9', 'exhaust_10', 'exhaust_11', 'exhaust_12', 'exhaust_13', 'exhaust_14', 'exhaust_15', 'exhaust_16', 'engine', 'overheat', 'overheat_2', 'petrolcap', 'petrolcap', 'petroltank', 'petroltank_l', 'petroltank_r', 'steering', 'hbgrip_l', 'hbgrip_r', 'headlight_l', 'headlight_r', 'taillight_l', 'taillight_r', 'indicator_lf', 'indicator_rf', 'indicator_lr', 'indicator_rr', 'brakelight_l', 'brakelight_r', 'brakelight_m', 'reversinglight_l', 'reversinglight_r', 'extralight_1', 'extralight_2', 'extralight_3', 'extralight_4', 'numberplate', 'interiorlight', 'siren1', 'siren2', 'siren3', 'siren4', 'siren5', 'siren6', 'siren7', 'siren8', 'siren9', 'siren10', 'siren11', 'siren12', 'siren13', 'siren14', 'siren15', 'siren16', 'siren17', 'siren18', 'siren19', 'siren20', 'siren_glass1', 'siren_glass2', 'siren_glass3', 'siren_glass4', 'siren_glass5', 'siren_glass6', 'siren_glass7', 'siren_glass8', 'siren_glass9', 'siren_glass10', 'siren_glass11', 'siren_glass12', 'siren_glass13', 'siren_glass14', 'siren_glass15', 'siren_glass16', 'siren_glass17', 'siren_glass18', 'siren_glass19', 'siren_glass20', 'spoiler', 'struts', 'misc_a', 'misc_b', 'misc_c', 'misc_d', 'misc_e', 'misc_f', 'misc_g', 'misc_h', 'misc_i', 'misc_j', 'misc_k', 'misc_l', 'misc_m', 'misc_n', 'misc_o', 'misc_p', 'misc_q', 'misc_r', 'misc_s', 'misc_t', 'misc_u', 'misc_v', 'misc_w', 'misc_x', 'misc_y', 'misc_z', 'misc_1', 'misc_2', 'weapon_1a', 'weapon_1b', 'weapon_1c', 'weapon_1d', 'weapon_1a_rot', 'weapon_1b_rot', 'weapon_1c_rot', 'weapon_1d_rot', 'weapon_2a', 'weapon_2b', 'weapon_2c', 'weapon_2d', 'weapon_2a_rot', 'weapon_2b_rot', 'weapon_2c_rot', 'weapon_2d_rot', 'weapon_3a', 'weapon_3b', 'weapon_3c', 'weapon_3d', 'weapon_3a_rot', 'weapon_3b_rot', 'weapon_3c_rot', 'weapon_3d_rot', 'weapon_4a', 'weapon_4b', 'weapon_4c', 'weapon_4d', 'weapon_4a_rot', 'weapon_4b_rot', 'weapon_4c_rot', 'weapon_4d_rot', 'turret_1base', 'turret_1barrel', 'turret_2base', 'turret_2barrel', 'turret_3base', 'turret_3barrel', 'ammobelt', 'searchlight_base', 'searchlight_light', 'attach_female', 'roof', 'roof2', 'soft_1', 'soft_2', 'soft_3', 'soft_4', 'soft_5', 'soft_6', 'soft_7', 'soft_8', 'soft_9', 'soft_10', 'soft_11', 'soft_12', 'soft_13', 'forks', 'mast', 'carriage', 'fork_l', 'fork_r', 'forks_attach', 'frame_1', 'frame_2', 'frame_3', 'frame_pickup_1', 'frame_pickup_2', 'frame_pickup_3', 'frame_pickup_4', 'freight_cont', 'freight_bogey', 'freightgrain_slidedoor', 'door_hatch_r', 'door_hatch_l', 'tow_arm', 'tow_mount_a', 'tow_mount_b', 'tipper', 'combine_reel', 'combine_auger', 'slipstream_l', 'slipstream_r', 'arm_1', 'arm_2', 'arm_3', 'arm_4', 'scoop', 'boom', 'stick', 'bucket', 'shovel_2', 'shovel_3', 'Lookat_UpprPiston_head', 'Lookat_LowrPiston_boom', 'Boom_Driver', 'cutter_driver', 'vehicle_blocker', 'extra_1', 'extra_2', 'extra_3', 'extra_4', 'extra_5', 'extra_6', 'extra_7', 'extra_8', 'extra_9', 'extra_ten', 'extra_11', 'extra_12', 'break_extra_1', 'break_extra_2', 'break_extra_3', 'break_extra_4', 'break_extra_5', 'break_extra_6', 'break_extra_7', 'break_extra_8', 'break_extra_9', 'break_extra_10', 'mod_col_1', 'mod_col_2', 'mod_col_3', 'mod_col_4', 'mod_col_5', 'handlebars', 'forks_u', 'forks_l', 'wheel_f', 'swingarm', 'wheel_r', 'crank', 'pedal_r', 'pedal_l', 'static_prop', 'moving_prop', 'static_prop2', 'moving_prop2', 'rudder', 'rudder2', 'wheel_rf1_dummy', 'wheel_rf2_dummy', 'wheel_rf3_dummy', 'wheel_rb1_dummy', 'wheel_rb2_dummy', 'wheel_rb3_dummy', 'wheel_lf1_dummy', 'wheel_lf2_dummy', 'wheel_lf3_dummy', 'wheel_lb1_dummy', 'wheel_lb2_dummy', 'wheel_lb3_dummy', 'bogie_front', 'bogie_rear', 'rotor_main', 'rotor_rear', 'rotor_main_2', 'rotor_rear_2', 'elevators', 'tail', 'outriggers_l', 'outriggers_r', 'rope_attach_a', 'rope_attach_b', 'prop_1', 'prop_2', 'elevator_l', 'elevator_r', 'rudder_l', 'rudder_r', 'prop_3', 'prop_4', 'prop_5', 'prop_6', 'prop_7', 'prop_8', 'rudder_2', 'aileron_l', 'aileron_r', 'airbrake_l', 'airbrake_r', 'wing_l', 'wing_r', 'wing_lr', 'wing_rr', 'engine_l', 'engine_r', 'nozzles_f', 'nozzles_r', 'afterburner', 'wingtip_1', 'wingtip_2', 'gear_door_fl', 'gear_door_fr', 'gear_door_rl1', 'gear_door_rr1', 'gear_door_rl2', 'gear_door_rr2', 'gear_door_rml', 'gear_door_rmr', 'gear_f', 'gear_rl', 'gear_lm1', 'gear_rr', 'gear_rm1', 'gear_rm', 'prop_left', 'prop_right', 'legs', 'attach_male', 'draft_animal_attach_lr', 'draft_animal_attach_rr', 'draft_animal_attach_lm', 'draft_animal_attach_rm', 'draft_animal_attach_lf', 'draft_animal_attach_rf', 'wheelcover_l', 'wheelcover_r', 'barracks', 'pontoon_l', 'pontoon_r', 'no_ped_col_step_l', 'no_ped_col_strut_1_l', 'no_ped_col_strut_2_l', 'no_ped_col_step_r', 'no_ped_col_strut_1_r', 'no_ped_col_strut_2_r', 'light_cover', 'emissives', 'neon_l', 'neon_r', 'neon_f', 'neon_b', 'dashglow', 'doorlight_lf', 'doorlight_rf', 'doorlight_lr', 'doorlight_rr', 'unknown_id', 'dials', 'engineblock', 'bobble_head', 'bobble_base', 'bobble_hand', 'chassis_Control'}

-------------------------------------------------------------------------------
-- Settings
-------------------------------------------------------------------------------
-- It's possible to interact with entities through walls so this should be low
Config.MaxDistance = 3.0

-- Enable debug options and distance preview
Config.Debug = false

Config.RaycastDebug = false

-- Enable outlines around the entity you're looking at
Config.EnableOutline = false

-- Enable default options (Toggling vehicle doors)
Config.EnableDefaultOptions = false

-------------------------------------------------------------------------------
-- Target Configs
-------------------------------------------------------------------------------

-- These are all empty for you to fill in, refer to the .md files for help in filling these in

Config.CircleZones = {
    ["BurgershotCashRegister1"] = {
        name = "Burgershot Register1",
        coords = vector3(-1194.38, -893.93, 14.08),
        radius = 0.60,
        useZ = true,
        debugPoly = false,
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:open:register",
                icon = "fas fa-cash-register",
                label = "Use Register",
                job = "burger",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
            {
                type = "client", 
                event = "framework-jobmanager:client:open:payment",
                icon = "fas fa-receipt",
                label = "Betaal",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
        distance = 2.5
    },
    ["BurgershotCashRegister2"] = {
        name = "Burgershot Register2",
        coords = vector3(-1195.4, -892.44, 14.08),
        radius = 0.60,
        useZ = true,
        debugPoly = false,
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:open:register",
                icon = "fas fa-cash-register",
                label = "Use Register",
                job = "burger",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
            {
                type = "client", 
                event = "framework-jobmanager:client:open:payment",
                icon = "fas fa-receipt",
                label = "Betaal",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
        distance = 2.5
    },
    ["BurgershotCashRegister3"] = {
        name = "Burgershot Register3",
        coords = vector3(-1192.8, -906.47, 14.13),
        radius = 0.60,
        useZ = true,
        debugPoly = false,
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:open:register",
                icon = "fas fa-cash-register",
                label = "Use Register",
                job = "burger",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
        distance = 2.5
    },
    ["BurgershotTray1"] = {
        name = "Burgershot Tray 1",
        coords = vector3(-1193.9, -894.41, 14.08),
        radius = 0.60,
        useZ = true,
        debugPoly = false,
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:open:tray",
                icon = "fas fa-utensils",
                label = "Dienblad",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-jobmanager:client:open:tray', 1)
                end,
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
        distance = 2.5
    },
    ["BurgershotTray2"] = {
        name = "Burgershot Tray 2",
        coords = vector3(-1194.94, -892.88, 14.08),
        radius = 0.45,
        useZ = true,
        debugPoly = false,
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:open:tray",
                icon = "fas fa-utensils",
                label = "Dienblad",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-jobmanager:client:open:tray', 2)
                end,
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
        distance = 2.5
    },
    ["BurgershotTray3"] = {
        name = "Burgershot Tray 3",
        coords = vector3(-1195.93, -891.32, 14.08),
        radius = 0.50,
        useZ = true,
        debugPoly = false, 
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:open:tray",
                icon = "fas fa-utensils",
                label = "Tray",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-jobmanager:client:open:tray', 3)
                end,
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
        distance = 2.5
    },
    ["BurgershoDrive"] = {
        name = "Burgershot Drive",
        coords = vector3(-1193.81, -907.03, 14.13),
        radius = 0.70,
        useZ = true,
        debugPoly = false,  
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:open:payment",
                icon = "fas fa-receipt",
                label = "Betaal",
            },
            {
                type = "client", 
                event = "framework-jobmanager:client:open:tray",
                icon = "fas fa-utensils",
                label = "Dienblad",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-jobmanager:client:open:tray', 'Drive')
                end,
            },
        },
        distance = 5.0
    },
    ["Burgershotboss"] = {
        name = "Burgershot Bossmenu",
        coords = vector3(-1178.185, -896.3922, 13.922982),
        radius = 0.70,
        useZ = true,
        debugPoly = false,  
        options = {
            {
                type = "server", 
                event = "framework-bossmenu:server:openMenu",
                icon = "fas fa-receipt",
                label = "Baas Menu",
            },
        },
        distance = 2.0
    },
    ["HeistContainer"] = {
        name = "HeistContainer",
        coords = vector3(809.16619, -3147.903, 6.1956911),
        radius = 0.70,
        useZ = true,
        debugPoly = false,  
        options = {
            {
                type = "client", 
                event = "",
                icon = "fas fa-receipt",
                label = "Locatie Hacken",
            },
        },
        distance = 2.0
    },
  
    ["TacoStelen"] = {
        name = "TacoStelen",
        coords = vector3(-1165.114, -1260.262, 6.4637069),
        radius = 0.50,
        useZ = true,
        debugPoly = false,  
        options = {
            {
                type = "client", 
                event = "framework-tacos:client:register:rob",
                icon = "fas fa-receipt",
                label = "Geld stelen",
            },
        },
        distance = 2.0
    },
    ["PhoneBooth1"] = {
        name = "PhoneBooth1",
        coords = vector3(1830.9487, 2586.9797, 46.54906),
        radius = 0.30,
        useZ = true,
        debugPoly = false,  
        options = {
            {
                type = "client", 
                event = "framework-prison:client:setbooth",
                icon = "fas fa-receipt",
                label = "Telefoon",
            },
            -- action = function()
            --     if IsPedAPlayer() then return false end
            --     TriggerEvent('framework-prison:client:setbooth', 1)
            -- end,
            -- canInteract = function()
            --     if exports['fw-prison']:GetInJailStatus() then
            --         return true
            --     end
            -- end,
        },
        distance = 2.0
    },
    -- ["PhoneBooth2"] = {
    --     name = "PhoneBooth2",
    --     coords = vector3(1830.9874, 2588.3312, 46.570476),
    --     radius = 0.30,
    --     useZ = true,
    --     debugPoly = true,  
    --     options = {
    --         {
    --             type = "client", 
    --             event = "framework-prison:client:setbooth",
    --             icon = "fas fa-receipt",
    --             label = "Telefoon",
    --         },
    --         -- action = function()
    --         --     TriggerEvent('framework-prison:client:setbooth', '2')
    --         -- end,
    --         canInteract = function()
    --             if exports['fw-prison']:GetInJailStatus() then
    --                 return true
    --             end
    --         end,
    --     },
    --     distance = 2.0
    -- },
    -- ["PhoneBooth3"] = {
    --     name = "PhoneBooth3",
    --     coords = vector3(1831.097, 2590.2629, 46.515647),
    --     radius = 0.30,
    --     useZ = true,
    --     debugPoly = true,  
    --     options = {
    --         {
    --             type = "client", 
    --             event = "framework-prison:client:setbooth",
    --             icon = "fas fa-receipt",
    --             label = "Telefoon",
    --         },
    --         -- action = function()
    --         --     if IsPedAPlayer() then return false end
    --         --     TriggerEvent('framework-prison:client:setbooth', 3)
    --         -- end,
    --         -- canInteract = function()
    --         --     if exports['fw-prison']:GetInJailStatus() then
    --         --         return true
    --         --     end
    --         -- end,
    --     },
    --     distance = 2.0
    -- },
    -- ["PhoneBooth4"] = {
    --     name = "PhoneBooth4",
    --     coords = vector3(1830.9825, 2585.2019, 46.99),
    --     radius = 0.20,
    --     useZ = true,
    --     debugPoly = true,  
    --     options = {
    --         {
    --             type = "client", 
    --             event = "framework-prison:client:setbooth",
    --             icon = "fas fa-receipt",
    --             label = "Telefoon",
    --         },
    --         -- action = function()
    --         --     if IsPedAPlayer() then return false end
    --         --     TriggerEvent('framework-prison:client:setbooth', 4)
    --         -- end,
    --         -- canInteract = function()
    --         --     if exports['fw-prison']:GetInJailStatus() then
    --         --         return true
    --         --     end
    --         -- end,
    --     },
    --     distance = 2.0
    -- },
    -- ["PhoneBooth4a"] = {
    --     name = "PhoneBooth4a",
    --     coords = vector3(1831.6899, 2586.3903, 46.461292),
    --     radius = 0.20,
    --     useZ = true,
    --     debugPoly = true,  
    --     options = {
    --         {
    --             type = "client", 
    --             event = "framework-prison:client:setbooth",
    --             icon = "fas fa-receipt",
    --             label = "Telefoon",
    --         },
    --         -- action = function()
    --         --     if IsPedAPlayer() then return false end
    --         --     TriggerEvent('framework-prison:client:setbooth', 5)
    --         -- end,
    --         canInteract = function()
    --             if exports['fw-prison']:InPrisonHouse() then
    --                 return true
    --             end
    --         end,
    --     },
    --     distance = 2.0
    -- },
    ["PhoneBooth3a"] = {
        name = "PhoneBooth3a",
        coords = vector3(1831.6877, 2588.2233, 46.507804),
        radius = 0.20,
        useZ = true,
        debugPoly = false,  
        options = {
            {
                type = "client", 
                event = "framework-prison:client:setbooth",
                icon = "fas fa-receipt",
                label = "Telefoon",
            },
            -- action = function()
            --     if IsPedAPlayer() then return false end
            --     TriggerEvent('framework-prison:client:setbooth', 6)
            -- end,
            -- canInteract = function()
            --     if exports['fw-prison']:InPrisonHouse() then
            --         return true
            --     end
            -- end,
        },
        distance = 2.0
    },
    -- ["PhoneBooth2a"] = {
    --     name = "PhoneBooth2a",
    --     coords = vector3(1831.6768, 2589.923, 46.5191),
    --     radius = 0.20,
    --     useZ = true,
    --     debugPoly = false,  
    --     options = {
    --         {
    --             type = "client", 
    --             event = "framework-prison:client:setbooth",
    --             icon = "fas fa-receipt",
    --             label = "Telefoon",
    --         },
    --         -- action = function()
    --         --     if IsPedAPlayer() then return false end
    --         --     TriggerEvent('framework-prison:client:setbooth', 7)
    --         -- end,
    --         -- canInteract = function()
    --         --     if exports['fw-prison']:InPrisonHouse() then
    --         --         return true
    --         --     end
    --         -- end,
    --     },
    --     distance = 2.0
    -- },
    -- ["PhoneBooth1a"] = {
    --     name = "PhoneBooth1a",
    --     coords = vector3(1831.679, 2591.8127, 46.629257),
    --     radius = 0.20,
    --     useZ = true,
    --     debugPoly = true,  
    --     options = {
    --         {
    --             type = "client", 
    --             event = "framework-prison:client:setbooth",
    --             icon = "fas fa-receipt",
    --             label = "Telefoon",
    --         },
    --         -- action = function()
    --         --     if IsPedAPlayer() then return false end
    --         --     TriggerEvent('framework-prison:client:setbooth', 8)
    --         -- end,
    --         -- canInteract = function()
    --         --     if exports['fw-prison']:InPrisonHouse() then
    --         --         return true
    --         --     end
    --         -- end,
    --     },
    --     distance = 2.0
    -- },
}

Config.BoxZones = {
    -- // PDM \\ --
    -- ["showroomn1"] = {
    --     name = "PDM Showroom 1",
    --     coords = vector3(-51.01, -1086.72, 27.27),
    --     length = 0.4,
    --     width = 0.8,
    --     heading = 337,
    --     debugPoly = false,
    --     minZ = 27.27,
    --     maxZ = 27.87,
    --     options = {
    --         {
    --             type = "client", 
    --             event = "framework-showrooms:enterExperience",
    --             icon = "fas fa-car",
    --             label = "View Catalog" 
    --         },
    --     },
    --     distance = 1.5
    -- },

    -- ["showroomn2"] = {
    --     name = "PDM Showroom 2",
    --     coords = vector3(-39.29, -1100.41, 27.27),
    --     length = 0.4,
    --     width = 0.8,
    --     heading = 291,
    --     debugPoly = false,
    --     minZ = 27.27,
    --     maxZ = 27.87,
    --     options = {
    --         {
    --             type = "client", 
    --             event = "framework-showrooms:enterExperience",
    --             icon = "fas fa-car",
    --             label = "View Catalog" 
    --         },
    --     },
    --     distance = 1.5
    -- },

    -- ["showroomn3"] = {
    --     name = "PDM Showroom 3",
    --     coords = vector3(-51.96, -1095.2, 27.27),
    --     length = 0.4,
    --     width = 0.8,
    --     heading = 300,
    --     debugPoly = false,
    --     minZ = 27.27,
    --     maxZ = 27.87,
    --     options = {
    --         {
    --             type = "client", 
    --             event = "framework-showrooms:enterExperience",
    --             icon = "fas fa-car",
    --             label = "View Catalog" 
    --         },
    --     },
    --     distance = 1.5
    -- },

    -- ["showroomn4"] = {
    --     name = "PDM Showroom 4",
    --     coords = vector3(-47.0, -1095.11, 27.27),
    --     length = 0.4,
    --     width = 0.8,
    --     heading = 11,
    --     debugPoly = false,
    --     minZ = 27.27,
    --     maxZ = 27.87,
    --     options = {
    --         {
    --             type = "client", 
    --             event = "framework-showrooms:enterExperience",
    --             icon = "fas fa-car",
    --             label = "View Catalog" 
    --         },
    --     },
    --     distance = 1.5
    -- },

    -- ["showroomn5"] = {
    --     name = "PDM Showroom 5",
    --     coords = vector3(-40.06, -1094.38, 27.27),
    --     length = 0.8,
    --     width = 0.4,
    --     heading = 25,
    --     debugPoly = false,
    --     minZ = 27.27,
    --     maxZ = 27.87,
    --     options = {
    --         {
    --             type = "client", 
    --             event = "framework-showrooms:enterExperience",
    --             icon = "fas fa-car",
    --             label = "View Catalog" 
    --         },
    --     },
    --     distance = 1.5
    -- },

    -- // Stripclub \\ --
    
    ["stripclub2"] = {
        name = "Slush Machine Stripclub",
        coords = vector3(133.72, -1286.7, 29.27),
        length = 0.6,
        width = 0.8,
        heading = 300,
        debugPoly = false,
        minZ = 29.22,
        maxZ = 30.22,
        options = {
            {
                type = "client", 
                event = "framework-unicorn:client:maken", 
                icon = 'fab fa-youtube', 
                label = 'Slushy', 
                job = 'vanilla', 
            },
        },
        distance = 1.5
    },

    ["stripclub3"] = {
        name = "Cash Register Stripclub",
        coords = vector3(129.03, -1284.99, 29.27),
        length = 0.6,
        width = 1.0,
        heading = 30,
        debugPoly = false,
        minZ = 29.27,
        maxZ = 29.67,
        options = {
            {
                type = "client", 
                event = "framework-unicorn:client:open:register", 
                icon = 'fas fa-coins', 
                label = 'Kassa', 
                job = 'vanilla', 
            },
            {
                type = "client", 
                event = "framework-unicorn:client:open:payment", 
                icon = 'fas fa-coins', 
                label = 'Betaal',
            },
        },
        distance = 1.5
    },

    ["stripclub4"] = {
        name = "Tray Stripclub",
        coords = vector3(128.47, -1284.07, 29.27),
        length = 1.0,
        width = 1.0,
        heading = 300,
        debugPoly = false,
        minZ = 29.27,
        maxZ = 29.67,
        options = {
            {
                type = "client", 
                event = "framework-unicorn:client:open:tray", 
                icon = 'fab fa-youtube', 
                label = 'Dienblad',
            },
        },
        distance = 1.5
    },

    ["stripclub5"] = {
        name = "Cocktail Stripclub",
        coords = vector3(131.08, -1282.3, 29.27),
        length = 1.0,
        width = 2.2,
        heading = 300,
        debugPoly = false,
        minZ = 29.27,
        maxZ = 29.87,
        options = {
            {
                type = "client", 
                event = "framework-unicorn:client:open:craft", 
                icon = 'fab fa-youtube', 
                label = 'Cocktails',
                job = 'vanilla',
            },
        },
        distance = 1.5
    },

    ["stripclub6"] = {
        name = "Stash 1 Stripclub",
        coords = vector3(129.02, -1284.84, 29.27),
        length = 1.0,
        width = 2.8,
        heading = 300,
        debugPoly = false,
        minZ = 28.27,
        maxZ = 29.27,
        options = {
            {
                type = "client", 
                event = "framework-stores:server:open:shop", 
                icon = 'fab fa-youtube', 
                label = 'Bar',
                job = 'vanilla', 
            },
        },
        distance = 1.5
    },

    ["stripclub7"] = {
        name = "Stash Stripclub",
        coords = vector3(130.08, -1280.53, 29.27),
        length = 1.0,
        width = 1.4,
        heading = 300,
        debugPoly = false,
        minZ = 28.27,
        maxZ = 29.27,
        options = {
            {
                type = "client", 
                event = "framework-unicorn:client:open:storage", 
                icon = 'fab fa-youtube', 
                label = 'Storage',
                job = 'vanilla', 
            },
        },
        distance = 1.5
    },

    ["stripclub8"] = {
        name = "Stash 2 Stripclub",
        coords = vector3(132.87, -1285.28, 29.27),
        length = 1.0,
        width = 1.4,
        heading = 300,
        debugPoly = false,
        minZ = 28.27,
        maxZ = 29.27,
        options = {
            {
                type = "client", 
                event = "framework-unicorn:client:open:storage", 
                icon = 'fab fa-youtube', 
                label = 'Storage',
                job = 'vanilla', 
            },
        },
        distance = 1.5
    },

    ["stripclub9"] = {
        name = "Ice Stripclub",
        coords = vector3(127.93, -1281.9, 29.27),
        length = 1.0,
        width = 0.8,
        heading = 301,
        debugPoly = false,
        minZ = 28.27,
        maxZ = 29.47,
        options = {
            {
                type = "client", 
                event = "framework-unicorn:client:ijsblokjes", 
                icon = 'fab fa-youtube', 
                label = 'Make Ice Cubes',
                job = 'vanilla', 
            },
        },
        distance = 1.5
    },

    ["stripclub10"] = {
        name = "Sig Machine Stripclub",
        coords = vector3(125.56, -1292.17, 29.27),
        length = 1.0,
        width = 1.0,
        heading = 300,
        debugPoly = false,
        minZ = 29.27,
        maxZ = 30.27,
        options = {
            {
                type = "client", 
                event = "framework-stores:server:open:shop", 
                icon = 'fab fa-youtube', 
                label = 'Sig Machine',
            },
        },
        distance = 1.5
    },

    ["stripclub11"] = {
        name = "Effects Stripclub",
        coords = vector3(121.52, -1282.94, 29.48),
        length = 0.1,
        width = 0.2,
        heading = 30,
        debugPoly = false,
        minZ = 29.53,
        maxZ = 29.93,
        options = {
            {
                type = "client", 
                event = "framework-unicorn:client:open:effect:panel", 
                icon = 'fab fa-youtube', 
                label = 'Podium Effects', 
                job = 'vanilla', 
            },
            {
                type = "client", 
                event = "framework-unicorn:client:call:strippers", 
                icon = 'fab fa-youtube', 
                label = 'Strippers', 
                job = 'vanilla', 
            },
        },
        distance = 1.5
    },

    ["stripclub12"] = {
        name = "Lapdance Stripclub",
        coords = vector3(119.57, -1302.0, 29.27),
        length = 0.6,
        width = 0.6,
        heading = 351,
        debugPoly = false,
        minZ = 26.17,
        maxZ = 30.17,
        options = {
            {
                type = "client", 
                event = "", 
                icon = 'fab fa-youtube', 
                label = 'test', 
            },
        },
        distance = 1.5
    },

    ["police3"] = {
        name = "PD Weaponry",
        coords = vector3(482.54, -994.75, 30.69),
        length = 0.4,
        width = 1,
        heading = 0,
        debugPoly = false,
        minZ = 29.74,
        maxZ = 31.54,
        options = {
            {
                type = "client", 
                event = "framework-police:polyzone:weaponry", 
                icon = "fas fa-user-shield", 
                label = "Wapenkluis",
                job = "police", 
            },          
        },
        distance = 1.5
    },

    ["police4"] = {
        name = "PD Personal Locker 1",
        coords = vector3(461.94, -995.56, 30.69),
        length = 0.2,
        width = 4.4,
        heading = 0,
        debugPoly = false,
        minZ = 29.69,
        maxZ = 32.49,
        options = {
            {
                type = "client", 
                event = "framework-police:polyzone:personallocker", 
                icon = "fas fa-person-booth", 
                label = "Personal Locker",
                job = "police", 
            },          
        },
        distance = 1.5
    },

    ["police5"] = {
        name = "PD Personal Locker 2",
        coords = vector3(461.94, -1000.05, 30.69),
        length = 0.2,
        width = 4.4,
        heading = 0,
        debugPoly = false,
        minZ = 29.69,
        maxZ = 32.49,
        options = {
            {
                type = "client", 
                event = "framework-police:polyzone:personallocker", 
                icon = "fas fa-person-booth", 
                label = "Personal Locker",
                job = "police", 
            },          
        },
        distance = 1.5
    },

    ["police6"] = {
        name = "PD Fingerprint",
        coords = vector3(473.16, -1006.92, 26.27),
        length = 0.4,
        width = 0.5,
        heading = 0,
        debugPoly = false,
        minZ = 26.17,
        maxZ = 26.27,
        options = {
            {
                type = "client", 
                event = "framework-police:polyzone:fingerscanner", 
                icon = "fas fa-fingerprint", 
                label = "Vinger Scanner",
                job = "police", 
            },          
        },
        distance = 1.5
    },

    ["police7"] = {
        name = "PD Evidence 1",
        coords = vector3(475.8, -995.3, 26.27),
        length = 4.6,
        width = 0.8,
        heading = 0,
        debugPoly = false,
        minZ = 25.52,
        maxZ = 27.72, 
        options = {
            {
                type = "client", 
                event = "framework-police:polyzone:evidence", 
                icon = "fas fa-inbox", 
                label = "Bewijskluis",
                job = "police", 
            },          
        },
        distance = 1.5
    },

    ["police8"] = {
        name = "PD Evidence 2",
        coords = vector3(473.88, -995.21, 26.27),
        length = 4.6,
        width = 0.8,
        heading = 0,
        debugPoly = false,
        minZ = 25.52,
        maxZ = 27.72, 
        options = {
            {
                type = "client", 
                event = "framework-police:polyzone:evidence", 
                icon = "fas fa-inbox", 
                label = "Bewijskluis",
                job = "police", 
            },          
        },
        distance = 1.5
    },

    ["police9"] = {
        name = "PD Evidence 3",
        coords = vector3(471.88, -995.39, 26.27),
        length = 4.6,
        width = 0.8,
        heading = 0,
        debugPoly = false,
        minZ = 25.52,
        maxZ = 27.72, 
        options = {
            {
                type = "client", 
                event = "framework-police:polyzone:evidence", 
                icon = "fas fa-inbox", 
                label = "Bewijskluis",
                job = "police", 
            },          
        },
        distance = 1.5
    },
    ["police10"] = {
        name = "PD Board Room",
        coords = vector3(439.49, -985.84, 34.97),
        length = 2.6,
        width = 0.05,
        heading = 0,
        debugPoly = false,
        minZ = 35.02,
        maxZ = 36.92, 
        options = {
            {
                type = "client", 
                event = "framework-assets:client:change:dui:menu", 
                icon = "fas fa-boxes", 
                label = "Verander Foto",
                job = "police", 
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-assets:client:change:dui:menu', 'police-briefing')
                end
            },   
            {
                type = "client", 
                event = "framework-police:client:try:toggle:disco", 
                icon = "fas fa-music", 
                label = "Disco Mode",
                job = "police", 
            },        
        },
        distance = 1.5
    },

    ["police11"] = {
        name = "PD Weaponry Vespuci",
        coords = vector3(-1074.4, -831.71, 19.3),
        length = 1.6,
        width = 1.0,
        heading = 309,
        debugPoly = false,
        minZ = 1.95,
        maxZ = 21.35,
        options = {
            {
                type = "client", 
                event = "framework-police:polyzone:weaponry", 
                icon = "fas fa-user-shield", 
                label = "Wapenkluis",
                job = "police", 
            },          
        },
        distance = 1.5
    },

    --// Hospital \\--

    ["hospital2"] = {
        name = "Hospital Shop",
        coords = vector3(308.58, -562.25, 43.28),
        length = 1,
        width = 0.05,
        heading = 340,
        debugPoly = false,
        minZ = 42.28,
        maxZ = 44.48, 
        options = {
            {
                type = "client", 
                event = "framework-hospital:client:polyzone:safe", 
                icon = "fas fa-briefcase-medical",
                label = "Ziekenhuis Winkel",
                job = "ambulance", 
            },          
        },
        distance = 1.5
    },

    ["hospital3"] = {
        name = "Hospital Storage",
        coords = vector3(310.15, -569.45, 43.28),
        length = 1,
        width = 0.2,
        heading = 340,
        debugPoly = false,
        minZ = 42.28,
        maxZ = 44.48,
        options = {
            {
                type = "client", 
                event = "framework-hospital:client:polyzone:storage", 
                icon = "fas fa-briefcase-medical",
                label = "Ziekenhuis Opslag",
                job = "ambulance", 
            },          
        },
        distance = 1.5
    },

    ["hospital4"] = {
        name = "Hospital Main Floor Elevator 1",
        coords = vector3(332.02, -597.2, 43.28),
        length = 0.2,
        width = 0.2,
        heading = 340,
        debugPoly = false,
        minZ = 43.48,
        maxZ = 43.78,
        options = {
            {
                type = "client", 
                event = "framework-hospital:client:polyzone:roof", 
                icon = "fas fa-arrow-circle-up", 
                label = "Helipad",
                job = "ambulance", 
            },
            {
                type = "client", 
                event = "framework-hospital:client:polyzone:lower", 
                icon = "fas fa-arrow-circle-down", 
                label = "Beneden Verdieping",
            },          
        },
        distance = 1.5
    },

    ["hospital5"] = {
        name = "Hospital Main Floor Elevator 2",
        coords = vector3(330.04, -602.7, 43.28),
        length = 0.2,
        width = 0.2,
        heading = 339,
        debugPoly = false,
        minZ = 43.48,
        maxZ = 43.73, 
        options = {
            {
                type = "client", 
                event = "framework-hospital:client:polyzone:lower2", 
                icon = "fas fa-arrow-circle-down", 
                label = "Beneden Verdieping",
            },         
        },
        distance = 1.5
    },

    ["hospital6"] = {
        name = "Hospital Lower Floor Elevator 1",
        coords = vector3(345.93, -580.93, 28.8),
        length = 0.2,
        width = 0.4,
        heading = 340,
        debugPoly = false,
        minZ = 29.0,
        maxZ = 29.4, 
        options = {
            {
                type = "client", 
                event = "framework-hospital:client:polyzone:main", 
                icon = "fas fa-arrow-circle-up", 
                label = "Eerste Verdieping",
            },         
        },
        distance = 1.5
    },


    ["hospital9"] = {
        name = "Hospital Lower Floor Elevator 2",
        coords = vector3(344.59, -584.65, 28.8),
        length = 0.2,
        width = 0.4,
        heading = 340,
        debugPoly = false,
        minZ = 29.0,
        maxZ = 29.4,
        options = {
            {
                type = "client", 
                event = "framework-hospital:client:polyzone:main2", 
                icon = "fas fa-arrow-circle-up", 
                label = "Main Floor",
            },          
        },
        distance = 1.5
    },

    ["hospital10"] = {
        name = "Hospital Helipad Elevator",
        coords = vector3(338.11, -583.66, 74.16),
        length = 1,
        width = 0.4,
        heading = 340,
        debugPoly = false,
        minZ = 74.16,
        maxZ = 74.46,  
        options = {
            {
                type = "client", 
                event = "framework-hospital:client:polyzone:main", 
                icon = "fas fa-arrow-circle-down", 
                label = "Main Floor",
                job = "ambulance"
            },         
        },
        distance = 1.5
    },
    ["hospital11"] = {
        name = "Viceroy Helipad Elevator",
        coords = vector3(-794.64, -1247.35, 7.34),
        length = 1,
        width = 0.4,
        heading = 320,
        debugPoly = false,
        minZ = 7.54,
        maxZ = 7.84,
        options = {
            {
                type = "client", 
                event = "framework-hospital:client:polyzone:vice:roof", 
                icon = "fas fa-arrow-circle-up", 
                label = "Helipad",
                job = "ambulance"
            },         
        },
        distance = 1.5
    },
-- // Impound \\
    ["impound"] = {
        name = "Impound Options",
        coords = vector3(-192.6, -1161.95, 23.67),
        length = 0.8,
        width = 0.8,
        heading = 0,
        debugPoly = false,
        minZ = 23.42,
        maxZ = 23.57,
        options = {
            {
                type = "client", 
                event = "framework-garage:client:open:depot:menu",
                icon = "fas fa-truck",
                label = "Depot Voertuigen"
            },
            {
                type = "client", 
                event = "framework-garages:client:open:impound:menu",
                icon = "fas fa-truck",
                label = "Beslaghuis",
                job = "police"
            },
            {
                type = "client", 
                event = "framework-jobmanager:client:request:payment",
                icon = "fas fa-money-bill-alt",
                label = "Ontvang Sleep Salaris",
                job = "tow"
            },
            {
                type = "client", 
                event = "framework-jobmanager:client:request:vehicle:tow",
                icon = "fas fa-truck",
                label = "Huur Sleepwagen ($350)",
                job = "tow"
            },
        },
        distance = 1.5
    },
-- // Garbage Door \\
    ["GarbageDoor"] = {
        name = "Garbage Door",
        coords = vector3(-350.34, -1569.96, 25.22),
        length = 1.8,
        width = 1,
        heading = 25,
        debugPoly = false,
        minZ = 24.87,
        maxZ = 26.47,
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:request:vehicle:trash",
                icon = "fas fa-truck",
                label = "Werkvoertuig Huren ($350)",
                job = "garbage"
            },
            {
                type = "client", 
                event = "framework-jobmanager:client:request:payment",
                icon = "fas fa-money-bill-alt",
                label = "Ontvang Salaris",
                job = "garbage"
            },
        },
        distance = 1.5
    },
    -- // Hayes Autos \\
    ["HayesAutos"] = {
        name = "Hayes Autos",
        coords = vector3(-1415.18, -452.19, 35.91),
        length = 3.6,
        width = 0.8,
        heading = 302,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 36.51,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:open:craft",
                icon = "fas fa-wrench",
                label = "Crafting",
                job = "mechanic"
            },
            {
                type = "client", 
                event = "framework-mechanic:client:open:storage",
                icon = "fas fa-box",
                label = "Storage",
                job = "mechanic",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-mechanic:client:open:storage', 'repairshop')
                end,
            },
        },
        distance = 1.5
    },
    ["HayesAutos1"] = {
        name = "Hayes Autos1",
        coords = vector3(-1421.7, -456.38, 35.91),
        length = 3.6,
        width = 0.8,
        heading = 302,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 36.51,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:open:craft",
                icon = "fas fa-wrench",
                label = "Crafting",
                job = "mechanic"
            },
            {
                type = "client", 
                event = "framework-mechanic:client:open:storage",
                icon = "fas fa-box",
                label = "Storage",
                job = "mechanic",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-mechanic:client:open:storage', 'repairshop')
                end,
            },
        },
        distance = 1.5
    },
    ["HayesAutos2"] = {
        name = "Hayes Autos2",
        coords = vector3(-1407.33, -447.47, 35.91),
        length = 3.6,
        width = 0.8,
        heading = 302,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 36.51,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:open:craft",
                icon = "fas fa-wrench",
                label = "Crafting",
                job = "mechanic"
            },
            {
                type = "client", 
                event = "framework-mechanic:client:open:storage",
                icon = "fas fa-box",
                label = "Storage",
                job = "mechanic",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-mechanic:client:open:storage', 'repairshop')
                end,
            },
        },
        distance = 1.5
    },
    ["HayesAutos3"] = {
        name = "Hayes Autos3",
        coords = vector3(1155.23, -792.18, 57.61),
        length = 3.6,
        width = 0.8,
        heading = 358,
        debugPoly = false,
        minZ = 57.61,
        maxZ = 58.21,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:open:craft",
                icon = "fas fa-wrench",
                label = "Crafting",
                job = "mechanic"
            },
            {
                type = "client", 
                event = "framework-mechanic:client:open:storage",
                icon = "fas fa-box",
                label = "Storage",
                job = "mechanic",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-mechanic:client:open:storage', 'mechanic')
                end,
            },
        },
        distance = 1.5
    },
    ["HayesAutosDuty"] = {
        name = "Hayes Duty",
        coords = vector3(-1426.75, -458.25, 35.91),
        length = 1,
        width = 1,
        heading = 0,
        debugPoly = false,
        minZ = 34.91,
        maxZ = 36.31, 
        options = {
            {
                type = "server", 
                event = "LSCore:ToggleDuty",
                icon = "fas fa-user-clock",
                label = "In / Uit Dienst",
                job = "mechanic"
            },
        },
        distance = 1.5
    },
    ["HayesRegister"] = {
        name = "Mechanic Register1",
        coords = vector3(-1428.66, -453.97, 35.91),
        length = 1,
        width = 1,
        heading = 126,
        debugPoly = false,
        minZ = 36.01,
        maxZ = 36.21, 
        options = {
            {
                type = "client", 
                event = "framework-mechanic:client:open:register",
                icon = "fas fa-cash-register",
                label = "Use Register",
                job = "burger",
                canInteract = function()
                    if exports['fw-mechanic']:IsInsideAutocare() then
                        return true
                    end
                end,
            },
            {
                type = "client", 
                event = "framework-mechanic:client:open:payment",
                icon = "fas fa-receipt",
                label = "Betaal",
                canInteract = function()
                    if exports['fw-mechanic']:IsInsideAutocare() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    -- // Recycle \\    
    ["RecycleEnter"] = {
        name = "RecycleEnter",
        coords = vector3(6.243391, 6414.6733, 31.552413),
        length = 1.2,
        width = 1.8,
        heading = 228.83206,
        debugPoly = false,
        minZ = 30.452413,
        maxZ = 33.152413,
        options = {
            {
                type = "client", 
                event = "framework-recycling:client:enter", 
                icon = 'fab fa-youtube', 
                label = 'Naar Binnen',
                -- job = 'vanilla', 
            },
        },
        distance = 1.5
    },
    -- // AutoCare \\
    ["mechanic-spot-1"] = {
        name = "Autocare Spot 1",
        coords = vector3(-326.84, -144.46, 39.02),
        length = 7.5,
        width = 4,
        heading = 70.0,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 41.00,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:check:vehicle",
                icon = "fas fa-wrench",
                label = "Voertuig nakijken",
                job = "mechanic",
                canInteract = function()
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                    if Vehicle ~= -1 and Distance < 10.0 then
                        return true
                    end
                end,
            },
        },
        distance = 3.5
    },
    ["mechanic-spot-2"] = {
        name = "Autocare Spot 2",
        coords = vector3(-324.92, -139.15, 39.02),
        length = 7.5,
        width = 4,
        heading = 70.0,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 41.00,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:check:vehicle",
                icon = "fas fa-wrench",
                label = "Voertuig nakijken",
                job = "mechanic",
                canInteract = function()
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                    if Vehicle ~= -1 and Distance < 10.0 then
                        return true
                    end
                end,
            },
        },
        distance = 3.5
    },
    ["mechanic-spot-3"] = {
        name = "Autocare Spot 3",
        coords = vector3(-323.08, -133.94, 39.02),
        length = 7.5,
        width = 4,
        heading = 70.0,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 41.00,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:check:vehicle",
                icon = "fas fa-wrench",
                label = "Voertuig nakijken",
                job = "mechanic",
                canInteract = function()
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                    if Vehicle ~= -1 and Distance < 10.0 then
                        return true
                    end
                end,
            },
        },
        distance = 3.5
    },
    ["mechanic-spot-4"] = {
        name = "Autocare Spot 4",
        coords = vector3(-321.2, -128.76, 39.02),
        length = 7.5,
        width = 4,
        heading = 70.0,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 41.00,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:check:vehicle",
                icon = "fas fa-wrench",
                label = "Voertuig nakijken",
                job = "mechanic",
                canInteract = function()
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                    if Vehicle ~= -1 and Distance < 10.0 then
                        return true
                    end
                end,
            },
        },
        distance = 3.5
    },
    ["mechanic-spot-5"] = {
        name = "Autocare Spot 5",
        coords = vector3(-319.39, -123.57, 39.02),
        length = 7.5,
        width = 4,
        heading = 70.0,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 41.00,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:check:vehicle",
                icon = "fas fa-wrench",
                label = "Voertuig nakijken",
                job = "mechanic",
                canInteract = function()
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                    if Vehicle ~= -1 and Distance < 10.0 then
                        return true
                    end
                end,
            },
        },
        distance = 3.5
    },
    ["mechanic-spot-6"] = {
        name = "Autocare Spot 6",
        coords = vector3(-317.46, -118.42, 39.02),
        length = 7.5,
        width = 4,
        heading = 70.0,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 41.00,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:check:vehicle",
                icon = "fas fa-wrench",
                label = "Voertuig nakijken",
                job = "mechanic",
                canInteract = function()
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                    if Vehicle ~= -1 and Distance < 10.0 then
                        return true
                    end
                end,
            },
        },
        distance = 3.5
    },
    ["mechanic-spot-7"] = {
        name = "Autocare Spot 7",
        coords = vector3(-315.6, -113.19, 39.02),
        length = 7.5,
        width = 4,
        heading = 70.0,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 41.00,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:check:vehicle",
                icon = "fas fa-wrench",
                label = "Voertuig nakijken",
                job = "mechanic",
                canInteract = function()
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                    if Vehicle ~= -1 and Distance < 10.0 then
                        return true
                    end
                end,
            },
        },
        distance = 3.5
    },
    ["mechanic-spot-8"] = {
        name = "Autocare Spot 8",
        coords = vector3(-313.68, -108.04, 39.02),
        length = 7.5,
        width = 4,
        heading = 70.0,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 41.00,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:check:vehicle",
                icon = "fas fa-wrench",
                label = "Voertuig nakijken",
                job = "mechanic",
                canInteract = function()
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                    if Vehicle ~= -1 and Distance < 10.0 then
                        return true
                    end
                end,
            },
        },
        distance = 3.5
    },
    ["mechanic-spot-9"] = {
        name = "Autocare Spot 9",
        coords = vector3(-311.77, -102.87, 39.02),
        length = 7.5,
        width = 4,
        heading = 70.0,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 41.00,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:check:vehicle",
                icon = "fas fa-wrench",
                label = "Voertuig nakijken",
                job = "mechanic",
                canInteract = function()
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                    if Vehicle ~= -1 and Distance < 10.0 then
                        return true
                    end
                end,
            },
        },
        distance = 3.5
    },
    ["mechanic-spot-10"] = {
        name = "Autocare Spot 10",
        coords = vector3(-343.12, -113.67, 39.02),
        length = 7.5,
        width = 4,
        heading = 70.0,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 41.00,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:check:vehicle",
                icon = "fas fa-wrench",
                label = "Voertuig nakijken",
                job = "mechanic",
                canInteract = function()
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                    if Vehicle ~= -1 and Distance < 10.0 then
                        return true
                    end
                end,
            },
        },
        distance = 3.5
    },
    ["mechanic-spot-11"] = {
        name = "Autocare Spot 11",
        coords = vector3(-347.05, -124.57, 39.02),
        length = 7.5,
        width = 4,
        heading = 70.0,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 41.00,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:check:vehicle",
                icon = "fas fa-wrench",
                label = "Voertuig nakijken",
                job = "mechanic",
                canInteract = function()
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                    if Vehicle ~= -1 and Distance < 10.0 then
                        return true
                    end
                end,
            },
        },
        distance = 3.5
    },
    ["mechanic-spot-12"] = {
        name = "Autocare Spot 12",
        coords = vector3(-349.41, -131.33, 39.02),
        length = 7.5,
        width = 4,
        heading = 70.0,
        debugPoly = false,
        minZ = 35.91,
        maxZ = 41.00,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:check:vehicle",
                icon = "fas fa-wrench",
                label = "Voertuig nakijken",
                job = "mechanic",
                canInteract = function()
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                    if Vehicle ~= -1 and Distance < 10.0 then
                        return true
                    end
                end,
            },
        },
        distance = 3.5
    },
    ["AutoCareBossMenu"] = {
        name = "AutoCareBossMenu",
        coords = vector3(-339.53, -156.85, 44.59),
        length = 2.65,
        width = 0.8,
        heading = 83,
        debugPoly = false,
        minZ = 43.00,
        maxZ = 45.00, 
        options = {
            {
                type = "server", 
                event = "framework-bossmenu:server:openMenu", 
                icon = "fas fa-user-shield", 
                label = "Baas Menu",
                job = "mechanic",
            },   
        },
        distance = 1.0
    },
    ["AutoCareVehSpawnMenu"] = {
        name = "AutoCareVehSpawnMenu",
        coords = vector3(-356.73, -159.69, 38.73),
        length = 10.75,
        width = 6.5,
        heading = 30.30,
        debugPoly = false,
        minZ = 37.50,
        maxZ = 42.00, 
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:openCarMenu", 
                icon = "fas fa-car", 
                label = "Wagenpark Low Santos",
                job = "mechanic", 
            },
            {
                type = "client",
                event = "framework-autocare:client:deleteVehicle",
                icon = "fa-solid fa-x",
                label = "Voertuig verwijderen",
                job = "mechanic",
            }, 
        },
        distance = 10.0
    },
    ["Autocare-Werkbank-1"] = {
        name = "Autocare Werkbank 1",
        coords = vector3(-322.15, -146.50, 39.02),
        length = 3.9,
        width = 0.8,
        heading = 340.21,
        debugPoly = false,
        minZ = 38.80,
        maxZ = 39.50,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:open:craft",
                icon = "fas fa-wrench",
                label = "Crafting",
                job = "mechanic"
            },
            {
                type = "client", 
                event = "framework-autocare:client:open:storage",
                icon = "fas fa-box",
                label = "Opslag",
                job = "mechanic",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-autocare:client:open:storage', 'repairshop')
                end,
            },
        },
        distance = 1.5
    },
     ["Autocare-Werkbank-2"] = {
        name = "Autocare Werkbank 2",
        coords = vector3(-310.0, -113.65, 39.02),
        length = 3.9,
        width = 0.8,
        heading = 340.21,
        debugPoly = false,
        minZ = 38.80,
        maxZ = 39.50,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:open:craft",
                icon = "fas fa-wrench",
                label = "Crafting",
                job = "mechanic"
            },
            {
                type = "client", 
                event = "framework-autocare:client:open:storage",
                icon = "fas fa-box",
                label = "Opslag",
                job = "mechanic",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-autocare:client:open:storage', 'repairshop')
                end,
            },
        },
        distance = 1.5
    },
    ["Autocare-Werkbank-3"] = {
        name = "Autocare Werkbank 3",
        coords = vector3(-346.7, -111.25, 39.02),
        length = 3.9,
        width = 0.8,
        heading = 159.64,
        debugPoly = false,
        minZ = 38.80,
        maxZ = 39.50,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:open:craft",
                icon = "fas fa-wrench",
                label = "Crafting",
                job = "mechanic"
            },
            {
                type = "client", 
                event = "framework-autocare:client:open:storage",
                icon = "fas fa-box",
                label = "Opslag",
                job = "mechanic",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-autocare:client:open:storage', 'repairshop')
                end,
            },
        },
        distance = 1.5
    },
    ["Autocare-Werkbank-4"] = {
        name = "Autocare Werkbank 4",
        coords = vector3(-339.05, -90.05, 39.02),
        length = 3.9,
        width = 0.8,
        heading = 249.64,
        debugPoly = false,
        minZ = 38.80,
        maxZ = 39.50,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:open:craft",
                icon = "fas fa-wrench",
                label = "Crafting",
                job = "mechanic"
            },
            {
                type = "client", 
                event = "framework-autocare:client:open:storage",
                icon = "fas fa-box",
                label = "Opslag",
                job = "mechanic",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-autocare:client:open:storage', 'repairshop')
                end,
            },
        },
        distance = 1.5
    },
    ["Autocare-Werkbank-5"] = {
        name = "Autocare Werkbank 5",
        coords = vector3(-367.1, -79.65, 39.02),
        length = 3.9,
        width = 0.8,
        heading = 249.64,
        debugPoly = false,
        minZ = 38.80,
        maxZ = 39.50,
        options = {
            {
                type = "client", 
                event = "framework-autocare:client:open:craft",
                icon = "fas fa-wrench",
                label = "Crafting",
                job = "mechanic"
            },
            {
                type = "client", 
                event = "framework-autocare:client:open:storage",
                icon = "fas fa-box",
                label = "Opslag",
                job = "mechanic",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-autocare:client:open:storage', 'repairshop')
                end,
            },
        },
        distance = 1.5
    },
    -- // Burgershot \\
    ["BurgershotBurgers"] = {
        name = "Burgershot Burgers",
        coords = vector3(-1199.51, -897.75, 13.98),
        length = 1.8,
        width = 0.8,
        heading = 34,
        debugPoly = false,
        minZ = 9.98,
        maxZ = 14.3,
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:create:burger",
                icon = "fas fa-hamburger",
                label = "Bleeder",
                job = "burger",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-jobmanager:client:create:burger', 'burger-bleeder')
                end,
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
            {
                type = "client", 
                event = "framework-jobmanager:client:create:burger",
                icon = "fas fa-hamburger",
                label = "Heartstopper",
                job = "burger",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-jobmanager:client:create:burger', 'burger-heartstopper')
                end,
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
            {
                type = "client", 
                event = "framework-jobmanager:client:create:burger",
                icon = "fas fa-hamburger",
                label = "Moneyshot",
                job = "burger",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-jobmanager:client:create:burger', 'burger-moneyshot')
                end,
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
            {
                type = "client", 
                event = "framework-jobmanager:client:create:burger",
                icon = "fas fa-hamburger",
                label = "Torpedo",
                job = "burger",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-jobmanager:client:create:burger', 'burger-torpedo')
                end,
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["BurgershotDrink"] = {
        name = "Burgershot Drink",
        coords = vector3(-1199.76, -895.24, 13.98),
        length = 2.2,
        width = 1,
        heading = 34,
        debugPoly = false,
        minZ = 13.98,
        maxZ = 16.78,
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:create:drink",
                icon = "fas fa-wine-bottle",
                label = "Softdrink",
                job = "burger",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-jobmanager:client:create:drink', 'burger-softdrink')
                end,
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
            {
                type = "client", 
                event = "framework-jobmanager:client:create:drink",
                icon = "fas fa-wine-bottle",
                label = "Coffee",
                job = "burger",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-jobmanager:client:create:drink', 'burger-coffee')
                end,
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["BurgershotStorage"] = {
        name = "Burgershot Storage",
        coords = vector3(-1197.96, -894.0, 13.98),
        length = 0.8,
        width = 3.2,
        heading = 304,
        debugPoly = false,
        minZ = 10.63,
        maxZ = 14.63,
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:open:hot:storage",
                icon = "fas fa-hamburger",
                label = "Open Heat Shelf",
                job = "burger",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["BurgershotMeat"] = {
        name = "Burgershot Meat",
        coords = vector3(-1202.7, -897.22, 13.98),
        length = 0.6,
        width = 1.6,
        heading = 304,
        debugPoly = false,
        minZ = 10.63,
        maxZ = 14.63,
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:bake:meat",
                icon = "fas fa-drumstick-bite",
                label = "Bak Vlees",
                job = "burger",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["BurgershotFries"] = {
        name = "Burgershot Fries",
        coords = vector3(-1201.86, -898.61, 13.98),
        length = 0.8,
        width = 1.6,
        heading = 304,
        debugPoly = false,
        minZ = 10.63,
        maxZ = 14.63,
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:bake:fries",
                icon = "fas fa-drumstick-bite",
                label = "Bak Patat",
                job = "burger",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["BurgershotColdStorage"] = {
        name = "Burgershot Cold Storage",
        coords = vector3(-1205.99, -893.19, 13.98),
        length = 1.4,
        width = 4.8,
        heading = 304,
        debugPoly = false,
        minZ = 11.23,
        maxZ = 15.23,
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:open:cold:storage",
                icon = "fas fa-boxes",
                label = "Open Storage",
                job = "burger",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["Burgershot Duty"] = {
        name = "Burgershot Duty",
        coords = vector3(-1191.89, -900.84, 13.98),
        length = 1.4,
        width = 1,
        heading = 32,
        debugPoly = false,
        minZ = 14.18,
        maxZ = 15.33,
        options = {
            {
                type = "server", 
                event = "LSCore:ToggleDuty",
                icon = "fas fa-user-clock",
                label = "On/Off Duty",
                job = "burger",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then 
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },  
    ["Burgershot Koeling"] = {
        name = "Burgershot Koeling",
        coords = vector3(-1196.664, -902.0546, 13.971955),
        length = 1.4,
        width = 1,
        heading = 212.17962,
        debugPoly = false,
        minZ = 13.18,
        maxZ = 15.33,
        options = {
            {
                type = "client", 
                event = "framework-jobmanager:client:open:cold:storage",
                icon = "fas fa-user-clock",
                label = "Opslag",
                job = "burger",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then 
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    }, 
-- // Pawnshop/Smelter
    ["PawnshopSmelterStarter"] = {
        name = "Pawnshop Smelter/Starter",
        coords = vector3(1087.31, -2002.5, 30.88),
        length = 1.2,
        width = 3.0,
        heading = 320,
        debugPoly = false,
        minZ = 30.38,
        maxZ = 31.98,
        options = {
            {
                type = "client", 
                event = "framework-pawnshop:client:smelter:inventory",
                icon = "fas fa-boxes",
                label = "Open Smelter Inventory",
            },
            {
                type = "client", 
                event = "framework-pawnshop:client:start:smelter",
                icon = "fas fa-play",
                label = "Start Smelting",
            },
        },
        distance = 1.5
    },
    -- // Recycle \\
    ["Recycle"] = {
        name = "Recycle",
        coords = vector3(996.59, -3099.41, -39.0),
        length = 1.6,
        width = 0.8,
        heading = 0,
        debugPoly = false,
        minZ = -40.0,
        maxZ = -38.8, 
        options = {
            {
                type = "client", 
                event = "framework-materials:client:open:recycle:crafting",
                icon = "fas fa-wrench",
                label = "Recycle Crafting",
            },
            {
                type = "client",
                event = "framework-crafting:client:open:crafting",
                icon = "fas fa-newspaper",
                label = "Crafting",
            },
        },
        distance = 1.5
    },
    ["Crafting1"] = {
        name = "Crafting1",
        coords = vector3(738.37, -1077.99, 22.17),
        length = 1.6,
        width = 0.8,
        heading = 359,
        debugPoly = false,
        minZ = 21.37,
        maxZ = 22.37, 
        options = {
            {
                type = "client",
                event = "framework-crafting:client:open:crafting",
                icon = "fas fa-newspaper",
                label = "Crafting",
            },
        },
        distance = 1.5
    },
    ["Crafting2"] = {
        name = "Crafting2",
        coords = vector3(-31.49, -1039.29, 28.6),
        length = 1.6,
        width = 0.8,
        heading = 340,
        debugPoly = false,
        minZ = 27.8,
        maxZ = 28.8, 
        options = {
            {
                type = "client",
                event = "framework-crafting:client:open:crafting",
                icon = "fas fa-newspaper",
                label = "Crafting",
            },
        },
        distance = 1.5
    },
    ["Crafting3"] = {
        name = "Crafting3",
        coords = vector3(-197.36, -1321.15, 31.09),
        length = 1.6,
        width = 0.8,
        heading = 0,
        debugPoly = false,
        minZ = 30.29,
        maxZ = 31.29, 
        options = {
            {
                type = "client",
                event = "framework-crafting:client:open:crafting",
                icon = "fas fa-newspaper",
                label = "Crafting",
            },
        },
        distance = 1.5
    },
    ["Crafting4"] = {
        name = "Crafting4",
        coords = vector3(97.47, 6618.98, 32.44),
        length = 1.6,
        width = 0.8,
        heading = 316,
        debugPoly = false,
        minZ = 31.64,
        maxZ = 32.64, 
        options = {
            {
                type = "client",
                event = "framework-crafting:client:open:crafting",
                icon = "fas fa-newspaper",
                label = "Crafting",
            },
        },
        distance = 1.5
    },
    -- Taco
    ["TacoBezorg"] = {
        name = "TacoBezorg",
        coords = vector3(-1163.427, -1255.256, 6.3267874),
        length = 0.8,
        width = 1.8,
        heading = 199.78141,
        debugPoly = false,
        minZ = 3.64,
        maxZ = 6.64, 
        options = {
            {
                type = "client",
                event = "framework-tacos:client:add:taco",
                icon = "fas fa-newspaper",
                label = "Voorraad Aanvullen",
            },
        },
        distance = 1.5
    },
    
    ["TacoSla"] = {
        name = "TacoSla",
        coords = vector3(-1160.194, -1256.451, 6.3267874),
        length = 0.8,
        width = 1.8,
        heading = 199.78141,
        debugPoly = false,
        minZ = 3.64,
        maxZ = 6.64, 
        options = {
            {
                type = "client",
                event = "framework-tacos:client:create:lettuce",
                icon = "fas fa-newspaper",
                label = "Pak Sla",
            },
        },
        distance = 1.5
    },
    ["TacoMaken"] = {
        name = "TacoMaken",
        coords = vector3(-1161.62, -1253.678, 6.3267874),
        length = 0.8,
        width = 1.1,
        heading = 199.78141,
        debugPoly = false,
        minZ = 3.64,
        maxZ = 6.64, 
        options = {
            {
                type = "client",
                event = "framework-tacos:client:create:taco",
                icon = "fas fa-newspaper",
                label = "Bereid Taco",
            },
        },
        distance = 1.5
    },
    ["TacoStock"] = {
        name = "TacoStock",
        coords = vector3(-1158.252, -1255.677, 6.3267874),
        length = 0.7,
        width = 1.5,
        heading = 20.259298,
        debugPoly = false,
        minZ = 3.64,
        maxZ = 7.24, 
        options = {
            {
                type = "client",
                event = "framework-tacos:client:add:stock",
                icon = "fas fa-newspaper",
                label = "Ingredienten Inleveren",
            },
        },
        distance = 1.5
    },
    ["TacoVlees"] = {
        name = "TacoVlees",
        coords = vector3(-1160.625, -1251.119, 6.3267874),
        length = 0.7,
        width = 0.7,
        heading = 20.259298,
        debugPoly = false,
        minZ = 3.64,
        maxZ = 6.74, 
        options = {
            {
                type = "client",
                event = "framework-tacos:client:create:meat",
                icon = "fas fa-newspaper",
                label = "Bak Vlees",
            },
        },
        distance = 1.5
    },
    -- Taxi
    ["Taxi1"] = {
        name = "BaasMenu",
        coords = vector3(288.4078, -1160.219, 29.1881),
        length = 1.6,
        width = 1.0,
        heading = 363,
        debugPoly = false,
        minZ = 29.15,
        maxZ = 29.35,
        options = {
            {
                type = "server", 
                event = "framework-bossmenu:server:openMenu", 
                icon = "fas fa-user-shield", 
                label = "Baas Menu",
                job = "taxi", 
            },          
        },
        distance = 1.5
    },
    -- ["Taxi2"] = {
    --     name = "HuurwagenTaxi",
    --     coords = vector3(299.9727, -1153.461, 29.1881),
    --     length = 0.3,
    --     width = 0.4,
    --     heading = 0,
    --     debugPoly = false,
    --     minZ = 28.05,
    --     maxZ = 29.45,
    --     options = {
    --         {
    --             type = "server", 
    --             event = "framework-bossmenu:server:openMenu", 
    --             icon = "fas fa-user-shield", 
    --             label = "Huur een wagen",
    --             job = "taxi", 
    --         },          
    --     },
    --     distance = 1.5
    -- },
    ["Taxi3"] = {
        name = "Inchecken",
        coords = vector3(295.79345, -1163.026, 29.1881),
        length = 0.6,
        width = 0.6,
        heading = 284.22171,
        debugPoly = false,
        minZ = 29.25,
        maxZ = 29.45,
        options = {
            {
                type = "server", 
                event = "Framework:ToggleDuty", 
                icon = "fas fa-user-shield", 
                label = "Inchecken",
                job = "taxi", 
            },   
            {
                type = "client", 
                event = "framework-taxi:client:openMenu", 
                icon = "fas fa-user-shield", 
                label = "Verzoek Dienstvoertuig",
                job = "taxi", 
            },          
        },
        distance = 1.5,
    },
    ["Taxi4"] = {
        name = "StashTaxi",
        coords = vector3(286.40542, -1165.203, 29.1881),
        length = 0.6,
        width = 0.6,
        heading = 284.22171,
        debugPoly = false,
        minZ = 29.25,
        maxZ = 29.45,
        options = {
            {
                type = "client", 
                event = "framework-taxi:client:stashopen", 
                icon = "fas fa-user-shield", 
                label = "Opslag",
                job = "taxi", 
            },         
        },
        distance = 1.5,
    },
    
    ["BossmenuCD"] = {
        name = "BossmenuCD",
        coords = vector3(-809.4165, -207.5364, 37.918216),
        length = 1.1,
        width = 1.2,
        heading = 25.600097,
        debugPoly = false,
        minZ = 37.018216,
        maxZ = 37.918216, 
        options = {
            {
                type = "server",
                event = "framework-bossmenu:server:openMenu",
                icon = "fas fa-newspaper",
                label = "Baas Menu",
            },
        },
        distance = 2.5
    },
    ["BossmenuPD"] = {
        name = "BossmenuPD",
        coords = vector3(461.51705, -986.1557, 31.660392),
        length = 1.1,
        width = 1.2,
        heading = 25.600097,
        debugPoly = false,
        minZ = 30.018216,
        maxZ = 31.360392, 
        options = {
            {
                type = "server",
                event = "framework-bossmenu:server:openMenu",
                icon = "fas fa-newspaper",
                label = "Baas Menu",
            },
        },
        distance = 2.5
    },

    ["Ambuboord"] = {
        name = "Ambuboord",
        coords = vector3(-780.8895, -1233.135, 8.9123554),
        length = 1.0,
        width = 0.8,
        heading = 25.600097,
        debugPoly = false,
        minZ = 8.1123554,
        maxZ = 8.9123554, 
        options = {
            {
                type = "client",
                event = "framework-hospital:client:take:photo",
                icon = "fas fa-newspaper",
                label = "Rontgen Maken",
            },
        },
        distance = 2.5
    },
    -- Pawnshop
    
    -- ["Pawnshop1"] = {
    --     name = "Pawnshop1",
    --     coords = vector3(176.4056, -1323.762, 29.17246),
    --     length = 0.8,
    --     width = 0.8,
    --     heading = 152,
    --     debugPoly = false,
    --     minZ = 29.02246,
    --     maxZ = 29.17246, 
    --     options = {
    --         {
    --             type = "client",
    --             event = "framework-pawnshop:client:sellitems",
    --             icon = "fas fa-newspaper",
    --             label = "Verkoop Items",
    --         },
    --     },
    --     distance = 2.5
    -- },
    -- ["Pawnshop2"] = {
    --     name = "Pawnshop2",
    --     coords = vector3(174.3647, -1322.728, 29.17246),
    --     length = 0.8,
    --     width = 0.8,
    --     heading = 152,
    --     debugPoly = false,
    --     minZ = 29.02246,
    --     maxZ = 29.17246, 
    --     options = {
    --         {
    --             type = "client",
    --             event = "framework-pawnshop:client:open:selling",
    --             icon = "fas fa-newspaper",
    --             label = "Verkoop Goud",
    --         },
    --     },
    --     distance = 2.5
    -- },

    ["CraftTrap"] = {
        name = "CraftTrap",
        coords = vector3(-1206.899, -1304.646, -27.64999),
        length = 1.0,
        width = 1.3,
        heading = 178.40998,
        debugPoly = false,
        minZ = -28.64999,
        maxZ = -27.64999, 
        options = {
            {
                type = "client",
                event = "framework-traphouse:client:open:craft",
                icon = "fas fa-newspaper",
                label = "Craften",
            },
        },
        distance = 1.5
    },
    ["Radvanfortuin"] = {
        name = "Radvanfortuin",
        coords = vector3(-1828.727, -1183.631, 14.314135),
        length = 0.4,
        width = 1.5,
        heading = 152,
        debugPoly = false,
        minZ = 14.314135,
        maxZ = 14.914135, 
        options = {
            {
                type = "client",
                event = "luckywheel:client:startWheel",
                icon = "fas fa-newspaper",
                label = "Rad Draaien",
            },
        },
        distance = 2.5
    },
    ["Slots1"] = {
        name = "Slots1",
        coords = vector3(-1833.054, -1200.344, 13.45706),
        length = 0.6,
        width = 0.7,
        heading = 149,
        debugPoly = false,
        minZ = 13.414135,
        maxZ = 14.914135, 
        options = {
            {
                type = "client",
                event = "framework-slots:enterBets",
                icon = "fas fa-newspaper",
                label = "Spelen",
            },
        },
        distance = 2.5
    },
    ["Slots3"] = {
        name = "Slots3",
        coords = vector3(-1828.892, -1202.386, 13.45706),
        length = 0.6,
        width = 0.7,
        heading = 149,
        debugPoly = false,
        minZ = 13.414135,
        maxZ = 14.914135, 
        options = {
            {
                type = "client",
                event = "framework-slots:enterBets",
                icon = "fas fa-newspaper",
                label = "Spelen",
            },
        },
        distance = 2.5
    },
    ["Prisonbreakout"] = {
        name = "Prisonbreakout",
        coords = vector3(1846.0982, 2604.7019, 45.634716),
        length = 0.8,
        width = 0.8,
        heading = 0,
        debugPoly = false,
        minZ = 44.7,
        maxZ = 47.0, 
        options = {
            {
                type = "client",
                event = "electronickit:UseElectronickit",
                icon = "fas fa-network-wired",
                label = "Hacken",
            },
        },
        distance = 1.5
    },
    ["CraftingTuner"] = {
        name = "CraftingTuner",
        coords = vector3(-1406.907, -443.4111, 35.956428),
        length = 1.2,
        width = 0.8,
        heading = 30,
        debugPoly = false,
        minZ = 35.156428,
        maxZ = 36.22, 
        options = {
            {
                type = "client",
                event = "framework-autocare:client:open:craft",
                icon = "fas fa-vehicle",
                label = "Craften",
            },
        },
        distance = 1.5
    },
    ["CraftingOpslag"] = {
        name = "CraftingOpslag",
        coords = vector3(-1413.029, -450.8783, 35.90966),
        length = 1.1,
        width = 0.8,
        heading = 120,
        debugPoly = false,
        minZ = 35.156428,
        maxZ = 36.82, 
        options = {
            {
                type = "client",
                event = "framework-autocare:client:open:storage",
                icon = "fas fa-vehicle",
                label = "Opslag",
            },
        },
        distance = 1.5
    },
    ["WeedRegister"] = {
        name = "WeedRegister",
        coords = vector3(188.15299, -243.5134, 54.321857),
        length = 0.5,
        width = 2.5,
        heading = 70,
        debugPoly = false,
        minZ = 54.00,
        maxZ = 54.35, 
        options = {
            {
                type = "client",
                event = "framework-jonkohuis:client:open:register",
                icon = "fas fa-vehicle",
                label = "Kassa",
                job = "weed",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideWeedshop() then
                        return true
                    end
                end,
            },
            {
                type = "client",
                event = "framework-jonkohuis:client:open:payment",
                icon = "fas fa-vehicle",
                label = "Betalen",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideWeedshop() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["WeedTray"] = {
        name = "WeedTray",
        coords = vector3(189.00729, -241.1178, 54.345836),
        length = 1.1,
        width = 0.8,
        heading = 70,
        debugPoly = false,
        minZ = 54.08,
        maxZ = 54.35, 
        options = {
            {
                type = "client",
                event = "framework-jonkohuis:client:open:tray",
                icon = "fas fa-vehicle",
                label = "Dienblad",
                canInteract = function()
                    if exports['fw-jobs']:IsInsideWeedshop() then
                        return true
                    end
                end,
            },
        },
        distance = 2.5
    },
    ["WeedCraft"] = {
        name = "WeedCraft",
        coords = vector3(185.55912, -241.5433, 54.366294),
        length = 0.6,
        width = 1.2,
        heading = 0,
        debugPoly = false,
        minZ = 54.00,
        maxZ = 54.35, 
        options = {
            {
                type = "client",
                event = "framework-jonkohuis:client:open:craft",
                icon = "fas fa-vehicle",
                label = "Craften",
                job = "weed",
            },
        },
        distance = 1.5
    },
    ["Weedstash"] = {
        name = "Weedstash",
        coords = vector3(184.31449, -244.362, 53.89899),
        length = 1.2,
        width = 0.8,
        heading = -20,
        debugPoly = false,
        minZ = 53.036265,
        maxZ = 54.55, 
        options = {
            {
                type = "client",
                event = "framework-jonkohuis:client:open:storage",
                icon = "fas fa-vehicle",
                label = "Stash",
                job = "weed",
            },
        },
        distance = 1.5
    },
}

Config.PolyZones = {

}

Config.TargetBones = {
    ["thrunk"] = {
        bones = "boot",
        options = {
            -- {
            --     event = 'framework-assets:client:getin:trunk',
            --     icon = 'fas fa-couch',
            --     label = 'Enter Kofferbak',
            --     -- canInteract = function()
            --     --     if not exports['fw-assets']:GetInTrunkState() then
            --     --         return true
            --     --     end
            --     -- end,
            -- },
            -- {
            --     event = 'framework-assets:client:getout:trunk',
            --     icon = 'fas fa-couch',
            --     label = 'Uit Kofferbak',
            --     canInteract = function()
            --         if exports['fw-assets']:GetInTrunkState() then
            --             return true
            --         end
            --     end,
            -- },
            {
                icon = 'fas fa-truck-loading',
                label = 'Open/Sluit Kofferbak',
                action = function()
                    local Vehicle = LSCore.Functions.GetClosestVehicle()
                    if GetVehicleDoorAngleRatio(Vehicle, 5) > 0.0 then
                        SetVehicleDoorShut(Vehicle, 5, false)
                    else
                        SetVehicleDoorOpen(Vehicle, 5, false, false)
                    end
                end
            }
        },
        distance = 0.7,
    },
    ["Verkopen"] = {
        bones = "bonnet",
        options = {
            {
                type = 'client',
                event = 'framework-cardealer:client:sell:clossest:vehicle',
                icon = 'fas fa-car',
                label = 'Voertuig Verkopen',
                job = 'cardealer',
                canInteract = function()
                    if exports['fw-vehicleshop']:InsideCardealer() then
                        return true
                    end
                end,
            },
        },
        distance = 0.7,
    },
    ["Kopen"] = {
        bones = "bonnet",
        options = {
            {
                type = 'client',
                event = 'framework-vehicleshop:client:buy:vehicle',
                icon = 'fas fa-dollar-sign',
                label = 'Voertuig Kopen',
                canInteract = function()
                    if exports['fw-vehicleshop']:IsInsideDealer() then
                        return true
                    end
                end,
            },
        },
        distance = 0.8,
    },
    ["Testen"] = {
        bones = "bonnet",
        options = {
            {
                event = 'framework-cardealer:client:test:closest:vehicle',
                icon = 'fas fa-car',
                label = 'Voertuig Testrit',
                job = 'cardealer',
                canInteract = function()
                    if exports['fw-vehicleshop']:InsideCardealer() then
                        return true
                    end
                end,
            },
        },
        distance = 0.7,
    },
    ["VehicleMenu"] = {
        bones = "bonnet",
        options = {
            {
                event = 'framework-autocare:client:check:vehicle',
                job = 'mechanic',
                icon = 'fas fa-car',
                label = 'Opties Bekijken'
            },
        },
        distance = 0.7,
    }
}

Config.TargetEntities = {

}

Config.EntityZones = {

}

Config.TargetModels = {
    ["StoreCashRegister1"] = {
        models = {
            'prop_till_01'
        },
        options = {
            {
                event = "framework-stores:server:open:shop",
                icon = 'fas fa-shopping-basket',
                label = 'Winkel',
                canInteract = function()
                    if exports['fw-misc']:IsNearStore() then
                        return true
                    end
                end
            },
            {
                event = "framework-stores:client:rob:register",
                icon = 'fas fa-hammer',
                label = 'Kassa Stelen',
                canInteract = function()
                    local ped = PlayerPedId()
                    if GetObjectFragmentDamageHealth(GetClosestObjectOfType(GetEntityCoords(ped), 1.0, GetHashKey("prop_till_01"), false, false, false), true) < 1.0 and exports['fw-heists']:IsNearStoreRob() then
                        -- if math.random(1,10) < 3 then
                            TriggerServerEvent('framework-police:server:send:alert:store', GetEntityCoords(PlayerPedId()), LSCore.Functions.GetStreetLabel(), exports['fw-heists']:GetStoreNumber())
                        -- end
                        return true
                    end
                end,      
            },
        },
        distance = 1.0
    },
    ["StoreCashRegister2"] = {
        models = {
            'prop_till_02',
            'prop_till_03',
        },
        options = {
            {
                event = "framework-stores:server:open:shop",
                icon = 'fas fa-shopping-basket',
                label = 'Shop',
                canInteract = function()
                    if exports['fw-stores']:IsNearStore() then
                        return true
                    end
                end
            },
        },
        distance = 1.0
    },
    -- PEDS
    ["a_m_m_farmer_01"] = {
        models = {
            "a_m_m_farmer_01"
        },
        options = {
            {
                type = "client",
                event = "framework-interactions:client:talk:to:npc",
				icon = "fas fa-boxes",
				label = "Praten",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-interactions:client:talk:to:npc', '')
                end,
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["ig_old_man2"] = {
        models = {
            -1573327682,
            -283816889
        },
        options = {
            {
                type = "client",
                event = "framework-interactions:client:talk:to:npc",
				icon = "fas fa-boxes",
				label = "Ouwe Man",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-interactions:client:talk:to:npc', '')
                end,
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["s_m_m_ammucountry"] = {
        models = {
            789136230,
            233415434
        },
        options = {
            {
                type = "server",
                event = "framework-jobmanager:server:sell:hunting",
				icon = "fas fa-boxes",
				label = "Goederen Verkopen",
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
        },
        distance = 2.5
    },
    ["g_m_m_mexboss_01"] = {
        models = {
            -886670410,
            1466037421
        },
        options = {
            {
                type = "client",
                event = "framework-interactions:client:talk:to:npc",
				icon = "fas fa-boxes",
				label = "Opslag",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-interactions:client:talk:to:npc', 'BarsItem')
                end,
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
            {
                type = "client",
                event = "framework-pawnshop:client:try:sell",
                icon = "fas fa-comments",
                label = "Verkopen",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-pawnshop:client:try:sell', 'BarsItem')
                end,
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["a_m_m_polynesian_01"] = {
        models = {
            -289921594,
            -1445349730
        },
        options = {
            {
                type = "server",
                event = "framework-illegal:server:sell:weedbrick",
				icon = "fas fa-dollar-sign",
				label = "Verkopen",
                canInteract = function()
                    if exports['fw-illegal']:NearNpcSell() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["s_m_m_pilot_01"] = {
        models = {
            144259659,
            -413447396
        },
        options = {
            {
                type = "client",
                event = "framework-flightschool:client:open:rental",
				icon = "fas fa-plane",
				label = "Huur Vliegtuig",
                canInteract = function()
                    if exports['fw-flightschool']:HasBrevet() then
                        return true
                    end
                end,
            },
            {
                type = "client",
                event = "framework-flightschool:client:open:learn",
				icon = "fas fa-plane",
				label = "Practice Plane",
                canInteract = function()
                    return true
                end,
            },
        },
        distance = 1.5
    },
    ["a_f_y_vinewood_02"] = {
        models = {
            -1842666575,
            -625565461
        },
        options = {
            {
                type = "client",
                event = "framework-houserobbery:client:start:job",
				icon = "fas fa-house-damage",
				label = "Praten",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-houserobbery:client:start:job', '')
                end,
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    -- ["u_f_m_casinocash_01"] = {
    --     models = {
    --         'u_f_m_casinocash_01',
    --     },
    --     options = {
    --         {
    --             type = "client",
    --             event = "framework-interactions:client:talk:to:npc",
	-- 			icon = "fas fa-gem",
	-- 			label = "Casino Chips",
    --             action = function()
    --                 if IsPedAPlayer() then return false end
    --                 TriggerEvent('framework-interactions:client:talk:to:npc', '')
    --             end,
    --             canInteract = function()
    --                 if exports['fw-interactions']:NearInteractNpc() then
    --                     return true
    --                 end
    --             end,
    --         },
    --     },
    --     distance = 1.5
    -- },
    
    ["a_m_y_vinewood_01"] = {
        models = {
            'a_m_y_vinewood_01',
        },
        options = {
            {
                type = "client",
                event = "framework-interactions:client:talk:to:npc",
				icon = "fas fa-gem",
				label = "Voertuig Aanbieden",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-interactions:client:talk:to:npc', 'VehicleSell')
                end,
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
        },
        distance = 4.5
    },
    ["a_f_m_ktown_02"] = {
        models = {
            1415783048,
	        1090617681
        },
        options = {
            {
                type = "client",
                event = "framework-interactions:client:talk:to:npc",
				icon = "fas fa-comment",
				label = "Praten",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-interactions:client:talk:to:npc', '')
                end,
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["a_m_m_eastsa_02"] = {
        models = {
            37570852,
	        131961260
        },
        options = {
            {
                type = "client",
                event = "framework-interactions:client:talk:to:npc",
				icon = "fas fa-car",
				label = "Vehicle Rental",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-interactions:client:talk:to:npc', '')
                end,
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["a_m_m_bevhills_02"] = {
        models = {
            -707429586,
	        1068876755
        },
        options = {
            {
                type = "client",
                event = "framework-interactions:client:talk:to:npc",
				icon = "fas fa-comments",
				label = "Praten",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-interactions:client:talk:to:npc', '')
                end,
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["a_f_m_prolhost_01"] = {
        models = {
            1429149102,
	        379310561
        },
        options = {
            {
                type = "client",
                event = "framework-fishing:client:sell:fish",
				icon = "fas fa-fish",
				label = "Vis Verkopen",
            },
        },
        distance = 1.5
    },
    ["s_m_m_gardener_01"] = {
        models = {
            -1037636782,
	        1240094341
        },
        options = {
            {
                type = "client",
                event = "framework-interactions:client:talk:to:npc",
				icon = "fas fa-key",
				label = "Hardware Store",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-interactions:client:talk:to:npc', '')
                end,
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end
            },
        },
        distance = 1.5
    },
    ["mp_m_waremech_01"] = {
        models = {
            'mp_m_waremech_01'
        },
        options = {
            {
                type = "client",
                event = "framework-interactions:client:talk:to:npc",
				icon = "fas fa-boxes",
				label = "Opslag",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-interactions:client:talk:to:npc', 'OtherSell')
                end,
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
            {
                type = "server",
                event = "framework-illegal:server:try:sell:other",
				icon = "fas fa-boxes",
				label = "Verkopen",
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["a_m_y_vinewood_03"] = {
        models = {
            'a_m_y_vinewood_03'
        },
        options = {
            {
                type = "client",
                event = "framework-interactions:client:talk:to:npc",
				icon = "fas fa-boxes",
				label = "Hout Inkoper",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-interactions:client:talk:to:npc', 'WoodSell')
                end,
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
            {
                type = "server",
                event = "framework-pawnshop:client:try:sell",
				icon = "fas fa-boxes",
				label = "Verkopen",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-pawnshop:client:try:sell', 'WoodSell')
                end,
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    -- ["a_m_m_farmer_01"] = {
    --     models = {
    --         -685780898,
	--         -1806291497
    --     },
    --     options = {
    --         {
    --             type = "client",
    --             event = "framework-interactions:client:talk:to:npc",
	-- 			icon = "fas fa-comments",
	-- 			label = "Praten",
    --             canInteract = function()
    --                 if exports['fw-interactions']:NearInteractNpc() then return false end 
    --                 return true
    --             end,
    --         },
    --     },
    --     distance = 1.5
    -- },
    ["a_m_m_soucent_03"] = {
        models = {
            `a_m_m_soucent_03`,
        },
        options = {
            {
                type = "client",
                event = "framework-illegal:client:start:oxy",
				icon = "fas fa-comments",
				label = "Werken ($1000)",
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() and exports['fw-illegal']:CanStartOxy() then
                        return true
                    end
                end,
            },
            {
                type = "client",
                event = "framework-illegal:client:open:shop",
				icon = "fas fa-comments",
				label = "Winkelen",
                canInteract = function()
                    if exports['fw-interactions']:NearInteractNpc() and exports['fw-illegal']:CanStartOxy() then
                        return true
                    end
                end,
            },
        },
        distance = 1.5
    },
    ["a_m_m_eastsa_01"] = {
        models = {
            -106498753,
	        -2059856138
        },
        options = {
            {
                type = "client",
                event = "framework-randomdealer:client:talk",
				icon = "fas fa-comments",
				label = "Praten",
                canInteract = function()
                    if exports['fw-dealers']:NearNpc() then 
                        return true 
                    end 
                    return false
                end,
            },
        },
        distance = 1.5
    },
    -- MODELS
    ["trash"] = {
        models = {
            -1255698084,
            1917016601
        },
        options = {
            {
                type = "client",
                event = "framework-jobmanager:client:return:job:vehicle",
				icon = "fas fa-car",
				label = "Voertuig Terugbrengen",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-jobmanager:client:return:job:vehicle', 'garbage')
                end,
            },
        },
        distance = 1.5
    },
    ["taxi"] = {
        models = {
            'taxi',
        },
        options = {
            {
                type = "client",
                event = "framework-jobmanager:client:return:job:vehicle",
				icon = "fas fa-car",
				label = "Voertuig Terugbrengen",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-jobmanager:client:return:job:vehicle', 'taxi')
                end,
            },
        },
        distance = 1.5
    },
    ["tow"] = {
        models = {
            'flatbed',
        },
        options = {
            {
                type = "client",
                event = "framework-jobmanager:client:return:job:vehicle",
				icon = "fas fa-car",
				label = "Voertuig Terugbrengen",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-jobmanager:client:return:job:vehicle', 'tow')
                end,
            },
        },
        distance = 1.5
    },
    ["bobcattrolly"] = {
        models = {
            "ch_prop_ch_cash_trolly_01c",
        },
        options = {
            {
                type = "client",
                event = "framework-heists:client:bobcat:try:grab:trolly",
                icon = "fas fa-hand-holding-usd",
                label = "Pakken",
                canInteract = function()
                    if exports['fw-heists']:IsInsideBobcat() then
                        return true
                    end
                end,
            },
        },
        distance = 1.0
    },
    ["bobcatcrate"] = {
        models = {
            "prop_mil_crate_02",
        },
        options = {
            {
                type = "client",
                event = "framework-heists:client:bobcat:try:grab:crate",
                icon = "fas fa-hand-holding-usd",
                label = "Pakken",
                canInteract = function()
                    if exports['fw-heists']:IsInsideBobcat() then
                        return true
                    end
                end,
            },
        },
        distance = 1.0
    },
    ["tv"] = {
        models = {
            "prop_tv_flat_01",
        },
        options = {
            {
                type = "client",
                event = "framework-houseobbery:client:steal:item:tv",
                icon = "fas fa-shopping-bag",
                label = "Stelen",
                -- action = function()
                --     if IsPedAPlayer() then return false end
                --     TriggerEvent('framework-houseobbery:client:steal:item', 'TV')
                -- end,
                canInteract = function()
                    if exports['fw-illegal']:CanRobItems() then
                        return true
                    end
                end,
            },
        },
        distance = 1.0
    },
    ["micro"] = {
        models = {
            "prop_micro_01",
        },
        options = {
            {
                type = "client",
                event = "framework-houseobbery:client:steal:item:micro",
                icon = "fas fa-hands",
                label = "Stelen",
                -- action = function()
                --     if IsPedAPlayer() then return false end
                --     TriggerEvent('framework-houseobbery:client:steal:item', 'Micro')
                -- end,
                canInteract = function()
                    if exports['fw-illegal']:CanRobItems() then
                        return true
                    end
                end,
            },
        },
        distance = 1.0
    },
    ["chairs"] = {
        models = {
            -1519439119,
            1268458364,
            96868307,
            1037469683,
            867556671,
            -377849416,
            -109356459,
            536071214,
            -1173315865,
            1805980844,
        },
        options = {
            {
                type = "client",
                event = "framework-assets:client:sitchair",
                icon = "fas fa-couch",
                label = "Zitten",
            },
        },
        distance = 1.5
    },
    ["cardealer1"] = {
        models = {
            'prop_monitor_04a',
        },
        options = {
            {
                type = "client",
                event = "framework-cardealer:client:open:select:menu",
                icon = "fas fa-clipboard-list",
                label = "Voertuig Beheer",
            },
        },
        distance = 1.5
    },
    ["hospitalbed"] = {
        models = {
            -1519439119,
            -289946279,
            -1091386327,
            1631638868,
        },
        options = {
            {
                type = "client",
                event = "framework-assets:client:sitchair",
                icon = "fas fa-procedures",
                label = "Liggen",
            },
        },
        distance = 1.5
    },
    ["burgabag"] = {
        models = {
            "prop_food_bs_bag_01",
            "prop_food_bs_bag_02",
        },
        options = {
            {
                type = "server",
                event = "framework-jobmanager:server:get:bag",
                icon = "fas fa-shopping-bag",
                label = "Pak Zak",
                job = "burger",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerServerEvent('framework-jobmanager:server:get:bag', 3)
                end,
                canInteract = function()
                    if exports['fw-jobs']:IsInsideBurgershot() then
                        return true
                    end
                end,
            },
        },
        distance = 1.0
    },
    ["atm"] = {
        models = {
            "prop_atm_01",
            "prop_atm_02",
            "prop_atm_03",
            "prop_fleeca_atm",
        },
        options = {
            {
                type = "client",
                event = "framework-banking:client:open:atm",
                icon = "far fa-credit-card",
                label = "Gebruiken",
                canInteract = function()
                    return true
                end,
            },
        },
        distance = 2.0
    },
    ["practisegame"] = {
        models = {
            "prop_arcade_01"
        },
        options = {
            {
                type = "client",
                event = "framework-ui:client:practice:game",
                icon = "fas fa-th",
                label = "Cube (€350)",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-ui:client:practice:game', 'Blocks')
                end
            },
            {
                type = "client",
                event = "framework-ui:client:practice:game",
                icon = "fas fa-th",
                label = "1234 (€500)",
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-ui:client:practice:game', 'Shapes')
                end
            },
        },
        distance = 1.0
    },
    -- ["parkmeter"] = {
    --     models = {
    --         "prop_parknmeter_02",
    --         "prop_parknmeter_01",

    --     },
    --     options = {
    --         {
    --             type = "client",
    --             event = "framework-parkmeter:client:open",
    --             icon = "fas fa-parking",
    --             label = "Openbreken",
    --         },
    --     },
    --     distance = 1.0
    -- },
    ["newspaper"] = {
        models = {
            "prop_news_disp_02a",
            "prop_news_disp_02c",
            "prop_news_disp_05a",
            "prop_news_disp_01a",

        },
        options = {
            {
                type = "client",
                event = "framework-ui:client:open:newspaper",
                icon = "fas fa-newspaper",
                label = "Nieuwsblad",
            },
        },
        distance = 1.0
    },
    -- ["workbenchcrafting"] = {
    --     models = {
    --         "prop_toolchest_05"
    --     },
    --     options = {
    --         {
    --             type = "client",
    --             event = "framework-crafting:client:open:crafting",
    --             icon = "fas fa-newspaper",
    --             label = "Crafting",
    --         },
    --     },
    --     distance = 1.0
    -- },
    ["wheelchair"] = {
        models = {
            "wheelchair"
        },
        options = {
            {
                type = "client",
                event = "framework-items:client:remove:wheelchair",
                icon = "fas fa-wheelchair",
                label = "Rolstoel",
            },
        },
        distance = 1.0
    },
    --// Recycle \\ --
    ["recycle"] = {
        models = {
            "v_ind_meatwash"
        },
        options = {
            {
                type = "client",
                event = "framework-materials:client:recycle:toggle:duty",
                icon = "fas fa-toggle-on",
                label = "In / Uit Dienst",
            },
        },
        distance = 1.0
    },
    -- // Yoga Mats \\ --
    -- ["YogaMats"] = {
    --     models = {
    --         "prop_yoga_mat_01",
    --         "prop_yoga_mat_02",
    --         "prop_yoga_mat_03",
    --         "p_yoga_mat_01_s",
    --     },
    --     options = {
    --         {
    --             event = "framework-interactions:client:yoga",
    --             icon = 'fas fa-child',
    --             label = 'Yoga Mat',
    --         },
    --     },
    --     distance = 4.0
    -- },
    -- // Vending \\ --

    -- // Automaats \\ --
    ["VendingMachines"] = {
        models = {
            "prop_vend_snak_01"
        },
        options = {
            {
                event = "framework-stores:client:open:custom:store",
                icon = 'fab fa-gulp',
                label = 'Automaat',
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-stores:client:open:custom:store', 'Vending')
                end,
            },
        },
        distance = 1.0
    },
    ["VendingMachines2"] = {
        models = {
            "prop_vend_soda_01",
            "prop_vend_soda_02"
        },
        options = {
            {
                event = "framework-stores:client:open:custom:store",
                icon = 'fab fa-gulp',
                label = 'Automaat',
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-stores:client:open:custom:store', 'FVending')
                end,
            },
        },
        distance = 1.0
    },
    -- // Coffee Machines \\ --
    ["CoffeeMachines"] = {
        models = {
            "prop_vend_coffe_01",
        },
        options = {
            {
                event = "framework-stores:client:open:custom:store",
                icon = 'fas fa-coffee',
                label = 'Koffie Machine',
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-stores:client:open:custom:store', 'Coffee')
                end,
            },
        },
        distance = 1.0
    },
    -- // Dumpsters \\
    ["dumpsters"] = {
        models = {
            "prop_cs_dumpster_01a",
            "prop_dumpster_01a",
            "prop_dumpster_02a",
            "prop_dumpster_02b",
            "prop_dumpster_4b",
            "prop_dumpster_3a",
            "prop_bin_05a",
        },
        options = {
            -- {
            --     type = "client",
            --     event = "framework-materials:client:search:trash",
            --     icon = "fas fa-dumpster",
            --     label = "Zoek vuilnisbak",
            -- },

            {
                type = "client",
                event = "framework-jobmanager:client:get:trash",
                icon = "fas fa-recycle",
                label = "Pak Vuilnis",
                job = "garbage",
            },
        },
        distance = 1.5
    },
-- // Robberies \\
    ["HeistPanel"] = {
        models = {
            "hei_prop_hei_securitypanel",
        },
        options = {
            {
                event = "framework-bankrobbery:client:use:option",
                icon = 'fas fa-server',
                label = 'Hack Paneel'
            },
        },
        distance = 1.0
    },
    ["HeistDepositBox"] = {
        models = {
            "hei_prop_heist_deposit_box",
        },
        options = {
            {
                event = "framework-bankrobbery:client:grab:option",
                icon = 'fas fa-hand-paper',
                label = 'Pakken'
            },
        },
        distance = 1.0
    },
    ["BankAlarm"] = {
        models = {
            "hei_prop_bank_alarm_01",
        },
        options = {
            {
                event = "framework-jewellery:client:disable:alarm",
                icon = 'fas fa-bell',
                label = 'Alarm Uitschakelen'
            },
        },
        distance = 1.0
    },
    ["JewelryGrabJewel"] = {
        models = {
            "p_counter_04_glass",
        },
        options = {
            {
                event = "framework-heists:client:grab:jewels",
                icon = 'far fa-gem',
                label = 'Juwelen Stelen'
            },
        },
        distance = 1.0
    },
    ["JewelryHackDoor"] = {
        models = {
            "prop_aircon_m_04",
        },
        options = {
            {
                event = "framework-heists:client:jewel:hack:doors",
                icon = 'fas fa-wind',
                label = 'Juwelier Ventilator'
            },
        },
        distance = 1.0
    },
-- // Prison \\
    ["PrisonCheckTime"] = {
        models = {
            "p_phonebox_02_s",
        },
        options = {
            {
                event = "framework-prison:client:check:time",
                icon = 'fas fa-clock',
                label = 'Check Detentie Tijd'
            },
        },
        distance = 1.0
    },
    ["Bikepickup"] = {
        models = {
            "bmx",
            "bimx",
            "unicycle",
        },
        options = {
            {
                type = "client",
                event = 'framework-vehicles:client:carry:bicycle',
                icon = 'fas fa-bicycle',
                label = 'Draag Fiets',
                
            },
        },
        distance = 1.0
    },
    ["Voertugreturn"] = {
        models = {
            "PolitieTouran",
            "PolitieVelar",
            "PolitieVito",
            "police2",
            "riot",
        },
        options = {
            {
                type = "client",
                event = "framework-police:client:delete:vehicle",
                icon = "fas fa-car",
                label = "Voertuig Terugbrengen",
                job = 'police',
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-police:client:delete:vehicle', '')
                end,
                canInteract = function()
                    if exports['fw-government']:IsNearPoliceGarage() then
                        return true
                    end
                end,
                
            },
        },
        distance = 1.5
    },
    -- // Arcade \\
    ["Arcade"] = {
        models = {
            `ch_prop_arcade_degenatron_01a`,
            `ch_prop_arcade_monkey_01a`,
            `ch_prop_arcade_penetrator_01a`,
            815879628,
            -1502319666,
            1876055757,
            568464183,
            -88750881,
            398786301,
            -395173800,

        },
        options = {
            {
                event = "fw-arcade:client:openArcadeGames",
                icon = 'fas fa-gamepad',
                label = 'Speel Arcade Games'
            },
        },
        distance = 1.5
    },
    
    ["Tankstation"] = {
        models = {
            `prop_gas_pump_1d`,
            `prop_gas_pump_1a`,
            `prop_gas_pump_1b`,
            `prop_gas_pump_1c`,
        },
        options = {
            {
                type = "client",
                event = "framework-fuel:client:open:menu",
				icon = "fas fa-gas-pump",
				label = "Voertuig Tanken",
                canInteract = function()
                    if exports['fw-vehicles']:NearGasPump() then
                        return true
                    end
                end
            },
        },
        distance = 3.5
    },
}

Config.GlobalPedOptions = {
    options = {
        {
            type = "client",
            event = "framework-illegal:client:sell:to:ped",
            icon = "fas fa-handshake",
            label = "Verkopen",
            action = function()
                if IsPedAPlayer() then return false end
                TriggerEvent('framework-illegal:client:sell:to:ped')
            end,
            canInteract = function()
                -- if exports['fw-illegal']:NearSellNpc() then
                    return true
                -- end
            end,
        },
    },
}


Config.GlobalObjectOptions = {

}

Config.GlobalVehicleOptions = {
    options = {
        {
            type = "client",
            event = "framework-garages:client:try:park:vehicle",
            icon = "fas fa-parking",
            label = "Parkeer Voertuig",
            canInteract = function()
                if exports['fw-housing']:IsPlayerOnAParkingSpot() then
                    return true
                end
            end,
        },
        {
            type = "client",
            event = "framework-illegal:client:try:deliver",
            icon = "fas fa-box",
            label = "Geef Pakket",
            canInteract = function(entity)
                if exports['fw-illegal']:CanDeliverOxyBox(entity) then
                    return true
                end
            end,
        },
        -- {
        --     type = "client",
        --     event = "framework-autocare:client:check:vehicle",
        --     icon = "fas fa-vehicle",
        --     label = "Check Voertuig",
        --     -- canInteract = function()
        --     --     if exports['fw-autocare']:InShop() then
        --     --         return true
        --     --     end
        --     -- end,
        -- },
        {
            type = 'client',
            event = 'framework-vehicleshop:client:buy:vehicle',
            icon = 'fas fa-dollar-sign',
            label = 'Voertuig Kopen',
            canInteract = function()
                if exports['fw-vehicleshop']:IsInsideDealer() then
                    return true
                end
            end,
        },
    },
    distance = 2.0
}

Config.GlobalPlayerOptions = {
    options = {
        {
            event = "framework-phone:client:GiveContactDetails",
            icon = 'fas fa-mobile',
            label = 'Geef Contactgegevens',
        },
        {
            event = "framework-vehiclekeys:client:give:key",
            icon = 'fas fa-keys',
            label = 'Geef Voertuigsleutels',
        }
    },
    distance = 1.5 
}


Config.Peds = {
    -- // Shops \\ --
    [1] = {
        model = 'mp_f_boatstaff_01',
        coords = vector4(-254.1607, -971.0853, 31.400201, 162.69192),
        currentpednumber = 0,
		target = {
			options = {
				{
					event = "framework-stores:client:open:custom:store",
					icon = 'fas fa-shopping-basket',
					label = 'Koffie Shop',
                    
                action = function()
                    if IsPedAPlayer() then return false end
                    TriggerEvent('framework-stores:client:open:custom:store', 'Coffee')
                end,
				}
			},
			distance = 1.5
        },
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    -- // Fruit Market \\ --
    [2] = {
        model = 'a_f_m_eastsa_02',
        coords = vector4(1087.62, 6511.26, 21.02, 176.84),
        currentpednumber = 0,
        target = {
			options = {
				{
					event = "framework-stores:server:open:shop",
					icon = 'fas fa-shopping-basket',
					label = 'Winkelen',
				}
			},
			distance = 1.5
        },
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },

    [3] = {
        model = 'a_f_m_eastsa_02',
        coords = vector4(-1043.28, 5326.55, 44.56, 36.74),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },

    [4] = {
        model = 'a_f_m_eastsa_02',
        coords = vector4(-2510.90, 3614.87, 13.68, 256.71),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [5] = {
        model = 'a_f_y_femaleagent',
        coords = vector4(149.45362, -1042.08, 29.367994, 342.8749),
        currentpednumber = 0,
        target = {
			options = {
                {
                    type = 'client',
                    event = "framework-banking:client:open:bank", 
                    icon = 'far fa-credit-card', 
                    label = 'Gebruik Bank', 
                },
                {
                    type = 'server',
                    event = "LSCore:Server:recieve:paycheck", 
                    icon = 'fas fa-receipt', 
                    label = 'Ontvang Salaris', 
                },
                {
                    type = 'server',
                    event = "framework-jobmanager:server:sell:tickets", 
                    icon = 'fas fa-receipt', 
                    label = 'Lever Bonnen In', 
                    job = 'burger',
                },
                {
                    type = 'server',
                    event = "framework-jobmanager:server:sell:tickets", 
                    icon = 'fas fa-receipt', 
                    label = 'Lever Bonnen In', 
                    job = 'vanilla',
                },
                {
                    type = 'server',
                    event = "framework-jobmanager:server:sell:tickets", 
                    icon = 'fas fa-receipt', 
                    label = 'Lever Bonnen In', 
                    job = 'weed',
                },
            },
			distance = 3.5
		},
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [6] = {
        model = 'a_f_y_femaleagent',
        coords = vector4(313.84, -280.44, 54.16, 332.39),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [7] = {
        model = 'a_f_y_femaleagent',
        coords = vector4(-1211.93, -331.92, 37.78, 28.30),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [8] = {
        model = 'a_f_y_femaleagent',
        coords = vector4(-2961.16, 482.86, 15.69, 76.65),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [9] = {
        model = 'a_f_y_femaleagent',
        coords = vector4(-112.25, 6471.10, 31.62, 132.77),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [10] = {
        model = 'a_f_y_femaleagent',
        coords = vector4(-351.36, -51.25, 49.03, 341.27),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [11] = {
        model = 'csb_trafficwarden',
        coords = vector4(441.40, -998.27, 25.69, 0.14),
        currentpednumber = 0,
        target = {
			options = {
                {
					event = "framework-police:client:open:garage",
					icon = "fas fa-warehouse",
					label = "Politie Garage",
                    job = "police"
                },
            },
			distance = 1.5
		},
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [12] = {
        model = 'u_m_y_pogo_01',
        coords = vector4(117.01135, -747.3101, 45.75159, 116.80137),
        currentpednumber = 0,
        target = {
            options = {
                {
                    event = "framework-cityhall:client:open:menu",
                    icon = 'fas fa-copy',
                    label = 'Pak een baan',
                    action = function()
                        if IsPedAPlayer() then return false end
                        TriggerEvent('framework-cityhall:client:open:menu', 'Work')
                    end,
                    -- canInteract = function()
                    --     if exports['fw-cityhall']:NearCityHall() then
                    --         return true
                    --     end
                    -- end,
                },
                {
                    event = "framework-cityhall:client:open:menu",
                    icon = 'fas fa-id-card',
                    label = 'Identiteit',
                    action = function()
                        if IsPedAPlayer() then return false end
                        TriggerEvent('framework-cityhall:client:open:menu', 'Identity')
                    end,
                    -- canInteract = function()
                    --     if exports['fw-cityhall']:NearCityHall() then
                    --         return true
                    --     end
                    -- end,
                },
                {
                    event = "framework-cityhall:client:open:menu",
                    icon = 'far fa-credit-card',
                    label = 'Vergunningen',
                    action = function()
                        if IsPedAPlayer() then return false end
                        TriggerEvent('framework-cityhall:client:open:menu', 'Licences')
                    end,
                    -- canInteract = function()
                    --     if exports['fw-cityhall']:NearCityHall() then
                    --         return true
                    --     end
                    -- end,
                },
                {
                    event = "framework-cityhall:client:request:items",
                    icon = 'fas fa-box',
                    label = 'Spullen terug vragen',
                    -- canInteract = function()
                    --     if exports['fw-cityhall']:NearCityHall() then
                    --         return true
                    --     end
                    -- end,
                },
            },
            distance = 3.0
        },
        freeze = true,
        blockevents = true,
        invincible = true,
        minusOne = true,
    },
    [13] = {
        model = 'a_f_y_business_01',
        coords = vector4(-551.06, -191.00, 38.21, 209.43),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [14] = {
        model = 's_m_y_armymech_01',
        coords = vector4(-420.18, -1688.58, 19.03, 90.51),
        currentpednumber = 0,
        target = {
			options = {
                {
					event = "framework-materials:client:scrap:vehicle",
					icon = "fas fa-car",
					label = "Scrap Voertuig"
                },
            },
			distance = 3.0
		},
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [15] = {
        model = 's_m_y_ammucity_01',
        coords = vector4(-662.8313, -933.551, 21.829219, 175.24743),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
        scenario = 'WORLD_HUMAN_COP_IDLES',
    },
    [16] = {
        model = 's_m_y_ammucity_01',
        coords = vector4(810.78558, -2158.986, 29.618999, 0.6202358),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
        scenario = 'WORLD_HUMAN_COP_IDLES',
    },
    [17] = {
        model = 's_m_y_ammucity_01',
        coords = vector4(1691.9165, 3760.5314, 34.705314, 229.27586),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
        scenario = 'WORLD_HUMAN_COP_IDLES',
    },
    [18] = {
        model = 's_m_y_ammucity_01',
        coords = vector4(-331.9635, 6084.5849, 31.454771, 224.43782),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
        scenario = 'WORLD_HUMAN_COP_IDLES',
    },
    [19] = {
        model = 's_m_y_ammucity_01',
        coords = vector4(2568.5109, 292.59301, 108.73487, 358.72494),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
        scenario = 'WORLD_HUMAN_COP_IDLES',
    },
    [20] = {
        model = 's_m_y_ammucity_01',
        coords = vector4(-1119.356, 2699.3574, 18.554128, 227.29251),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
        scenario = 'WORLD_HUMAN_COP_IDLES',
    },
    [21] = {
        model = 's_m_y_ammucity_01',
        coords = vector4(842.94665, -1035.319, 28.194866, 1.0868238),
        currentpednumber = 0,
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
        scenario = 'WORLD_HUMAN_COP_IDLES',
    },

    [22] = {
        model = 's_m_y_prisoner_01',
        coords = vector4(1783.2984, 2558.9797, 45.672962, 186.86451),
        currentpednumber = 0,
        target = {
			options = {
                {
                    type = 'client',
					event = "framework-stores:server:open:shop",
					icon = 'fas fa-shopping-basket',
					label = 'Bajes Kantine',
                    canInteract = function()
                        if exports['fw-misc']:IsNearStore() then
                            return true
                        end
                    end,
				},
			},
			distance = 2.5
        },
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
        scenario = 'WORLD_HUMAN_COP_IDLES',
    },
    -- // Prison \\ --
    -- [23] = {
    --     model = 'a_m_o_tramp_01',
    --     coords = vector4(1840.3093, 2577.6804, 46.014358, 357.46646),
    --     currentpednumber = 0,
	-- 	target = {
	-- 		options = {
	-- 			{
	-- 				event = "framework-prison:client:leave:prison",
	-- 				icon = 'fas fa-door-open',
	-- 				label = 'Verlaat Gevangenis',
    --                 canInteract = function()
    --                     if exports['fw-prison']:GetInJailStatus() then
    --                         return true
    --                     end
    --                 end,
	-- 			}
	-- 		},
	-- 		distance = 1.5
    --     },
    --     freeze = true,
    --     blockevents = true,
    --     invincible = true,
	-- 	minusOne = true,
    -- },
    [24] = {
        model = 'cs_lifeinvad_01',
        coords = vector4(-1653.801, -1062.053, 12.160425, 140.10739),
        currentpednumber = 0,
		target = {
			options = {
				{
					event = "framework-arcade:client:openTicketMenu",
					icon = 'fab fa-speakap',
					label = 'Praten met Arcade Werknemer',
				}
			},
			distance = 2.5
        },
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [25] = {
        model = 'a_f_y_genhot_01',
        coords = vector4(904.15466, -162.3978, 74.166053, 324.59249),
        currentpednumber = 0,
		target = {
            options = {
                {
                    type = "client", 
                    event = "framework-jobmanager:client:request:vehicle:taxi",
                    icon = "fas fa-tools",
                    label = "Taxi Pakken ($350)",
                    job = "taxi" 
                    -- canInteract = function()
                    --     if exports['fw-jobs']:InsideTaxi() then
                    --         return true
                    --     end
                    -- end,
                },
                {
                    type = "client", 
                    event = "framework-jobmanager:client:request:payment",
                    icon = "fas fa-money-bill-alt",
                    label = "Ontvang Salaris",
                    job = "taxi"
                    -- canInteract = function()
                    --     if exports['fw-jobs']:InsideTaxi() then
                    --         return true
                    --     end
                    -- end,
                },
            },
			distance = 2.5
        },
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [26] = {
        model = 'mp_f_bennymech_01',
        coords = vector4(45.386241, -1394.188, 29.391368, 323.90499),
        currentpednumber = 0,
		target = {
			options = {
				{
                    type = "client",
                    event = "framework-carwash:client:start:wasj",
                    icon = "fas fa-car",
                    label = "Voertuig Wassen",
				}
			},
			distance = 4.5
        },
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [27] = {
        model = 'csb_tomcasino',
        coords = vector4(-1679.856, -1111.381, 13.152157, 135.98506),
        currentpednumber = 0,
		target = {
			options = {
				{
                    type = "server",
                    event = "framework-lottery:server:sell:card",
                    icon = "fas fa-finger",
                    label = "Loterijkaarten inleveren",
				}
			},
			distance = 2.5
        },
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [28] = {
        model = 'g_f_y_families_01',
        coords = vector4(1996.2326, 2825.4619, 50.307567, 338.80172),
        currentpednumber = 0,
		target = {
			options = {
				{
                    type = "server",
                    event = "framework-paintball:server:buy:ammo",
                    icon = "fas fa-finger",
                    label = "Koop Kogels",
				}
			},
			distance = 2.5
        },
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [29] = {
        model = 'cs_old_man1a',
        coords = vector4(3426.9365, 5174.581, 7.4144773, 85.074729),
        currentpednumber = 0,
		target = {
			options = {
				{
                    type = "server",
                    event = "framework-oudeheer:server:open:menu",
                    icon = "fas fa-finger",
                    label = "Praten Met Oude Heer",
				}
			},
			distance = 2.5
        },
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [30] = {
        model = 'a_m_m_soucent_01',
        coords = vector4(-1137.936, -2805.383, 39.726032, 160.0),
        currentpednumber = 0,
		target = {
			options = {
				{
                    type = "client",
                    event = "framework-materials:client:open:craft",
                    icon = "fas fa-finger",
                    label = "Witwassen",
				}
			},
			distance = 1.5
        },
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    [31] = {
        model = 'a_m_y_runner_01',
        coords = vector4(1207.4073, -3122.664, 5.5403304, 354.96585),
        currentpednumber = 0,
		target = {
			options = {
				{
                    type = "client",
                    event = "framework-materials:client:open:craft",
                    icon = "fas fa-finger",
                    label = "Witwassen",
				}
			},
			distance = 1.5
        },
        freeze = true,
        blockevents = true,
        invincible = true,
		minusOne = true,
    },
    -- [32] = {
    --     model = 's_m_m_security_01',
    --     coords = vector4(131.22285, -1297.563, 29.233448, 209.93035),
    --     currentpednumber = 0,
	-- 	target = {
	-- 		options = {
	-- 			{
    --                 type = "client", 
	-- 				event = "framework-cityhall:client:request:items",
	-- 				icon = 'fab fa-speakap',
	-- 				label = 'Spullen terug vragen',
	-- 			}
	-- 		},
	-- 		distance = 2.5
    --     },
    --     freeze = true,
    --     blockevents = true,
    --     invincible = true,
	-- 	minusOne = true,
    -- },
}

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

if Config.EnableDefaultOptions then
	Config.ToggleDoor = function(vehicle, door)
		if GetVehicleDoorLockStatus(vehicle) ~= 2 then
			if GetVehicleDoorAngleRatio(vehicle, door) > 0.0 then
				SetVehicleDoorShut(vehicle, door, false)
			else
				SetVehicleDoorOpen(vehicle, door, false)
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Default options
-------------------------------------------------------------------------------

-- These options don't represent the actual way of making TargetBones or filling out Config.TargetBones, refer to the TEMPLATES.md for a template on that, this is only the way to add it without affecting the config table

if Config.EnableDefaultOptions then
	Bones['seat_dside_f'] = {
		["Toggle Front Door"] = {
			icon = "fas fa-door-open",
			label = "Toggle Front Door",
			canInteract = function(entity)
				return GetEntityBoneIndexByName(entity, 'door_dside_f') ~= -1
			end,
			action = function(entity)
				Config.ToggleDoor(entity, 0)
			end,
			distance = 1.2
		}
	}

	Bones['seat_pside_f'] = {
		["Toggle Front Door"] = {
			icon = "fas fa-door-open",
			label = "Toggle Front Door",
			canInteract = function(entity)
				return GetEntityBoneIndexByName(entity, 'door_pside_f') ~= -1
			end,
			action = function(entity)
				Config.ToggleDoor(entity, 1)
			end,
			distance = 1.2
		}
	}

	Bones['seat_dside_r'] = {
        ["Toggle Rear Door"] = {
            icon = "fas fa-door-open",
            label = "Toggle Rear Door",
            canInteract = function(entity)
                return GetEntityBoneIndexByName(entity, 'door_dside_r') ~= -1
            end,
            action = function(entity)
                Config.ToggleDoor(entity, 2)
            end,
            distance = 1.2
        }
	}

	Bones['seat_pside_r'] = {
		["Toggle Rear Door"] = {
			icon = "fas fa-door-open",
			label = "Toggle Rear Door",
			canInteract = function(entity)
				return GetEntityBoneIndexByName(entity, 'door_pside_r') ~= -1
			end,
			action = function(entity)
				Config.ToggleDoor(entity, 3)
			end,
			distance = 1.2
		}
	}

	Bones['bonnet'] = {
		["Toggle Hood"] = {
			icon = "fa-duotone fa-engine",
			label = "Toggle Hood",
			action = function(entity)
				Config.ToggleDoor(entity, 4)
			end,
			distance = 0.9
		}
	}
end

-------------------------------------------------------------------------------
return Config, Players, Types, Entities, Models, Zones, Bones, PlayerData
-------------------------------------------------------------------------------