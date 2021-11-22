Config = Config or {}

Config.CurrentEffect = {}

Config.InsideUnicorn = false

Config.Location = {['StripClub'] = {['X'] = 119.12, ['Y'] = -1289.86, ['Z'] = 28.26}}

Config.Poles = {
    [1] = {
        ['X'] = 108.81,
        ['Y'] = -1288.98,
        ['Z'] = 29.43,
    },
    [2] = {
        ['X'] = 104.80,
        ['Y'] = -1294.19,
        ['Z'] = 29.24,
    },
    [3] = {
        ['X'] = 102.25,
        ['Y'] = -1289.82,
        ['Z'] = 29.24,
    },
}

Config.Dances = {
    [1] = {
        ['Anim'] = 'pd_dance_01',
        ['Dict'] = 'mini@strip_club@pole_dance@pole_dance1',
    },
    [2] = {
        ['Anim'] = 'pd_dance_02',
        ['Dict'] = 'mini@strip_club@pole_dance@pole_dance2',
    },
    [3] = {
        ['Anim'] = 'pd_dance_03',
        ['Dict'] = 'mini@strip_club@pole_dance@pole_dance3',
    },
}

Config.EffectsMenu = {
    [1] = {['Name'] = 'Vuurwerk',          ['Desc'] = 'Zet het vuurwerk effect aan.',         ['Dict'] = 'proj_xmas_firework',  ['Effect'] = 'scr_firework_xmas_ring_burst_rgw',  ['Event'] = 'ls-unicorn:server:set:effect'},
    [2] = {['Name'] = 'Sterren Fontijn',   ['Desc'] = 'Zet het sterren fontijn effect aan.',  ['Dict'] = 'scr_indep_fireworks', ['Effect'] = 'scr_indep_firework_fountain',       ['Event'] = 'ls-unicorn:server:set:effect'},
    [3] = {['Name'] = 'Water Fontijn',     ['Desc'] = 'Zet het water fontijn effect aan.',    ['Dict'] = 'scr_carwash',         ['Effect'] = 'ent_amb_car_wash_jet',              ['Event'] = 'ls-unicorn:server:set:effect'},
    [4] = {['Name'] = 'Vuur Fontijn',      ['Desc'] = 'Zet het vuur fontijn effect aan.',     ['Dict'] = 'core',                ['Effect'] = 'ent_amb_fbi_fire_beam',             ['Event'] = 'ls-unicorn:server:set:effect'},
}

Config.Effects = {
    ['scr_indep_firework_fountain'] = {
        [1] = {['Coords'] = {['X'] = 109.59, ['Y'] = -1290.86, ['Z'] = 28.41}},
        [2] = {['Coords'] = {['X'] = 107.85, ['Y'] = -1287.83, ['Z'] = 28.41}},
        [3] = {['Coords'] = {['X'] = 101.44, ['Y'] = -1288.69, ['Z'] = 28.41}},
        [4] = {['Coords'] = {['X'] = 105.62, ['Y'] = -1295.97, ['Z'] = 28.41}},
    },
    ['ent_amb_car_wash_jet'] = {
        [1] = {['Coords'] = {['X'] = 109.59, ['Y'] = -1290.86, ['Z'] = 28.41}},
        [2] = {['Coords'] = {['X'] = 107.85, ['Y'] = -1287.83, ['Z'] = 28.41}},
        [3] = {['Coords'] = {['X'] = 101.44, ['Y'] = -1288.69, ['Z'] = 28.41}},
        [4] = {['Coords'] = {['X'] = 105.62, ['Y'] = -1295.97, ['Z'] = 28.41}},
    },
    ['ent_amb_fbi_fire_beam'] = {
        [1] = {['Coords'] = {['X'] = 109.59, ['Y'] = -1290.86, ['Z'] = 28.71}},
        [2] = {['Coords'] = {['X'] = 107.85, ['Y'] = -1287.83, ['Z'] = 28.71}},
        [3] = {['Coords'] = {['X'] = 101.44, ['Y'] = -1288.69, ['Z'] = 28.71}},
        [4] = {['Coords'] = {['X'] = 105.62, ['Y'] = -1295.97, ['Z'] = 28.71}},
    },
    ['scr_firework_xmas_ring_burst_rgw'] = {
        [1] = {['Coords'] = {['X'] = 104.65, ['Y'] = -1291.79, ['Z'] = 27.41}},
    },
}

Config.UnicornProps = {
    [1] = {
        ['Visible'] = false,
        ['Prop'] = 'v_ind_cf_flour',
        ['Coords'] = {
            ['X'] = 128.88, 
            ['Y'] = -1284.27, 
            ['Z'] = 28.00
        },
    },
    [2] = {
        ['Visible'] = true,
        ['Prop'] = 'prop_cs_silver_tray',
        ['Coords'] = {
            ['X'] = 129.08, 
            ['Y'] = -1285.53, 
            ['Z'] = 29.32
        },
    },
}