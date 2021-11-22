Config = Config or {}

Config.Menus = {
    ['Identity'] = {
        [1] = {
            ['Name'] = 'Identiteits Kaart',
            ['Desc'] = 'Kosten: €50,-',
            ['Type'] = 'id',
            ['EventType'] = 'Server',
            ['Event'] = 'ls-cityhall:server:request:identity',
        },
        [2] = {
            ['Name'] = 'Rijbewijs',
            ['Desc'] = 'Kosten: €50,-',
            ['Type'] = 'drive',
            ['EventType'] = 'Server',
            ['Event'] = 'ls-cityhall:server:request:identity',
        },
    },
    ['Licences'] = {
        [1] = {
            ['Name'] = 'Jaag Vergunning',
            ['Desc'] = 'Kosten: €5000,-',
            ['Type'] = 'hunting',
            ['EventType'] = 'Server',
            ['Event'] = 'ls-cityhall:server:request:license',
        },
    },
    ['Work'] = {
        [1] = {
            ['Name'] = 'Depot Medewerker',
            ['Desc'] = 'Verdient: €50,-',
            ['Type'] = 'tow',
            ['EventType'] = 'Server',
            ['Event'] = 'ls-cityhall:server:request:work',
        },
        [2] = {
            ['Name'] = 'Vuilnis Medewerker',
            ['Desc'] = 'Verdient: €50,-',
            ['Type'] = 'garbage',
            ['EventType'] = 'Server',
            ['Event'] = 'ls-cityhall:server:request:work',
        },
        -- [5] = {
        --     ['Name'] = 'Wijnmaker',
        --     ['Desc'] = 'Verdient: €50,-',
        --     ['Type'] = 'winemaker',
        --     ['EventType'] = 'Server',
        --     ['Event'] = 'ls-cityhall:server:request:work',
        -- },
        -- [6] = {
        --     ['Name'] = 'Duiker',
        --     ['Desc'] = 'Verdient: €50,-',
        --     ['Type'] = 'diver',
        --     ['EventType'] = 'Server',
        --     ['Event'] = 'ls-cityhall:server:request:work',
        -- },
    },
    -- ['Appartment'] = {
    --     [1] = {
    --         ['Name'] = 'South Rockford Drive',
    --         ['Desc'] = 'Verhuis Kosten: €10000,-',
    --         ['Type'] = 'apartment1',
    --         ['EventType'] = 'Server',
    --         ['Event'] = 'ls-cityhall:server:request:appartment',
    --     },
    --     [2] = {
    --         ['Name'] = 'Morningwood Blvd',
    --         ['Desc'] = 'Verhuis Kosten: €10000,-',
    --         ['Type'] = 'apartment2',
    --         ['EventType'] = 'Server',
    --         ['Event'] = 'ls-cityhall:server:request:appartment',
    --     },
    --     [3] = {
    --         ['Name'] = 'Integrity Way',
    --         ['Desc'] = 'Verhuis Kosten: €10000,-',
    --         ['Type'] = 'apartment3',
    --         ['EventType'] = 'Server',
    --         ['Event'] = 'ls-cityhall:server:request:appartment',
    --     },
    --     [4] = {
    --         ['Name'] = 'Vinewood Towers',
    --         ['Desc'] = 'Verhuis Kosten: €10000,-',
    --         ['Type'] = 'apartment4',
    --         ['EventType'] = 'Server',
    --         ['Event'] = 'ls-cityhall:server:request:appartment',
    --     },
    --     [5] = {
    --         ['Name'] = 'Fantastic Plaza',
    --         ['Desc'] = 'Verhuis Kosten: €10000,-',
    --         ['Type'] = 'apartment5',
    --         ['EventType'] = 'Server',
    --         ['Event'] = 'ls-cityhall:server:request:appartment',
    --     },
    --     [6] = {
    --         ['Name'] = 'Phillbox Hill',
    --         ['Desc'] = 'Verhuis Kosten: €10000,-',
    --         ['Type'] = 'apartment6',
    --         ['EventType'] = 'Server',
    --         ['Event'] = 'ls-cityhall:server:request:appartment',
    --     },
    -- },
}

Config.CityProps = {
    [1] = {
        ['Visible'] = false,
        ['PlacePropGood'] = false,
        ['Prop'] = 'v_ilev_gunsign_assmg',
        ['Coords'] = {
            ['X'] = -550.81, 
            ['Y'] = -192.13, 
            ['Z'] = 38.32,
            ['H'] = 29.82,
        },
    },
    [2] = {
        ['Visible'] = false,
        ['PlacePropGood'] = false,
        ['Prop'] = 'v_ilev_gunsign_assmg',
        ['Coords'] = {
            ['X'] = -552.71, 
            ['Y'] = -193.23, 
            ['Z'] = 38.32,
            ['H'] = 29.82,
        },
    },
}

Config.MetalDetector = {
    ['Scanned'] = false,
    ['Coords'] = {
        [1] = {
          ['X'] = -536.11,
          ['Y'] = -185.72,
          ['Z'] = 38.21,
        },
        [2] = {
          ['X'] = -537.44,
          ['Y'] = -186.37,
          ['Z'] = 42.76,
        },
    },
}