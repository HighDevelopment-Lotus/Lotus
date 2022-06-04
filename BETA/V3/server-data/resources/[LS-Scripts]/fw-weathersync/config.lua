Config = Config or {}

Config.Syncing = true

Config.SyncData = {
    ['Hour'] = 13,
    ['Minutes'] = 00,
    ['Weather'] = 'EXTRASUNNY',
    ['Blackout'] = false,
}

Config.WeatherTypes = {
    [1] = {['Weather'] = 'EXTRASUNNY',  ['Label'] = 'Extra Zonnig', ['AllowRandom'] = true,  ['MaxTime'] = 6},
    [2] = {['Weather'] = 'NEUTRAL',     ['Label'] = 'Neutraal',     ['AllowRandom'] = false},
    [3] = {['Weather'] = 'SMOG',        ['Label'] = 'Mistig',       ['AllowRandom'] = false},
    [4] = {['Weather'] = 'FOGGY',       ['Label'] = 'Erg Mistig',   ['AllowRandom'] = false},
    [5] = {['Weather'] = 'CLEARING',    ['Label'] = 'Opklaren',     ['AllowRandom'] = false},
    [6] = {['Weather'] = 'RAIN',        ['Label'] = 'Regen',        ['AllowRandom'] = true,   ['MaxTime'] = 1},
    [7] = {['Weather'] = 'THUNDER',     ['Label'] = 'Storm',        ['AllowRandom'] = false,  ['MaxTime'] = 1},
    [8] = {['Weather'] = 'SNOW',        ['Label'] = 'Sneeuw',       ['AllowRandom'] = false},
    [9] = {['Weather'] = 'XMAS',        ['Label'] = 'Kerst Sneeuw', ['AllowRandom'] = false},
    [10] = {['Weather'] = 'HALLOWEEN',  ['Label'] = 'Halloween',    ['AllowRandom'] = false},
}

Config.TimeStamps = {
    [1] = {['Label'] = 'Ochtend', ['Hour'] = 8,  ['Minutes'] = 0},
    [2] = {['Label'] = 'Middag',  ['Hour'] = 12, ['Minutes'] = 0},
    [3] = {['Label'] = 'Avond',  ['Hour'] = 18, ['Minutes'] = 0},
    [4] = {['Label'] = 'Nacht',  ['Hour'] = 23, ['Minutes'] = 30},
}
