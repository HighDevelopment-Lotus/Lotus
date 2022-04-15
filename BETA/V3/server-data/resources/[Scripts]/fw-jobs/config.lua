Config = Config or {}

Config.JobData = {}

Config.Debug = false
Config.JobBusy = false

Config.ActivePayments = {}

Config.CanScrap = true

Config.OpenedBins = {}

Config.Intercom = {
  ['Worker'] = vector3(-1192.00, -906.65, 14.09),
  ['Customer'] = vector3(-1204.79, -899.01, 13.30),
}

Config.BurgerItems = {
  [1] = 'burger-bun',
  [2] = 'burger-meat',
  [3] = 'burger-lettuce',
}

Config.HuntingData = {
    ['BaitEntitys'] = {},
    ['HuntingArea'] = {['Coords'] = {['X'] = -723.58, ['Y'] = 4932.37, ['Z'] = 201.26}},
    ['Animals'] = {
        [1] = {['Animal'] = 'a_c_boar',      ['HashName'] = GetHashKey('a_c_boar'),      ['AnimalName'] = 'Boar',      ['Illegal'] = false}, 
        [2] = {['Animal'] = 'a_c_deer',      ['HashName'] = GetHashKey('a_c_deer'),      ['AnimalName'] = 'Deer',      ['Illegal'] = false}, 
        [3] = {['Animal'] = 'a_c_coyote',    ['HashName'] = GetHashKey('a_c_coyote'),    ['AnimalName'] = 'Coyote',    ['Illegal'] = false}, 
        [4] = {['Animal'] = 'a_c_mtlion',    ['HashName'] = GetHashKey('a_c_mtlion'),    ['AnimalName'] = 'Mtlion',    ['Illegal'] = true}, 
        [5] = {['Animal'] = 'a_c_rabbit_01', ['HashName'] = GetHashKey('a_c_rabbit_01'), ['AnimalName'] = 'Rabbit',    ['Illegal'] = false}, 
        [6] = {['Animal'] = 'a_c_retriever', ['HashName'] = GetHashKey('a_c_retriever'), ['AnimalName'] = 'Retriever', ['Illegal'] = true}
    },
}

Config.Storage = vector3(-938.59, -2932.25, 13.94)

Config.RentalVehicles = {
    [1] = {
        ['Vehicle'] = 'frogger2',
        ['Label'] = 'Frogger S1540',
        ['Image'] = 'https://static.wikia.nocookie.net/gtawiki/images/0/05/Frogger-GTAV-front.png/revision/latest/scale-to-width-down/960?cb=20160116184549',
        ['Price'] = 10000,
    },
    [2] = {
        ['Vehicle'] = 'velum2',
        ['Label'] = 'Velum H57',
        ['Image'] = 'https://static.wikia.nocookie.net/gtawiki/images/3/38/Velum5Seater-GTAO-front.png/revision/latest?cb=20160302173740',
        ['Price'] = 10000,
    },
}

Config.SchoolVehicles = {
    [1] = {
        ['Vehicle'] = 'frogger2',
        ['Label'] = 'Frogger S1540',
        ['Image'] = 'https://static.wikia.nocookie.net/gtawiki/images/0/05/Frogger-GTAV-front.png/revision/latest/scale-to-width-down/960?cb=20160116184549',
    },
    [2] = {
        ['Vehicle'] = 'velum2',
        ['Label'] = 'Velum H57',
        ['Image'] = 'https://static.wikia.nocookie.net/gtawiki/images/3/38/Velum5Seater-GTAO-front.png/revision/latest?cb=20160302173740',
    },
    [3] = {
        ['Vehicle'] = 'swift2',
        ['Label'] = 'Swift S15',
        ['Image'] = 'https://static.wikia.nocookie.net/gtawiki/images/4/4d/SwiftDeluxe-GTAV-front.png/revision/latest?cb=20160117170332',
    },
    [4] = {
        ['Vehicle'] = 'volatus',
        ['Label'] = 'Volatus S01',
        ['Image'] = 'https://static.wikia.nocookie.net/gtawiki/images/0/0e/Volatus-GTAO-front.png/revision/latest?cb=20160609144955',
    },
}

Config.VehicleSpawns = {
    [1] = {['Coords'] = vector4(-1001.98, -3003.60, 13.94, 57.73)},
    [2] = {['Coords'] = vector4(-984.04, -2972.62, 13.94, 58.01)},
    [3] = {['Coords'] = vector4(-947.00, -2993.94, 13.94, 13.94)},
    [4] = {['Coords'] = vector4(-962.32, -3026.95, 13.94, 64.48)},
}

Config.JobLocations = {
    ['FlatBed'] = {['X'] = -177.94, ['Y'] = -1167.05, ['Z'] = 23.04, ['H'] = 176.34},
    ['TrashVeh'] = {['X'] = -340.76, ['Y'] = -1561.76, ['Z'] = 25.23, ['H'] = 94.50},
    ['TaxiVeh'] = {['X'] = 259.32878, ['Y'] = -1162.34, ['Z'] = 29.184331, ['H'] = 358.9306}
}

Config.TowLocations = {
    [1] = {['Coords'] =  {['X'] = -2480.87, ['Y'] = -211.96,  ['Z'] = 17.39,  ['H'] = 59.62}, ['Model'] = 'sultanrs'},
    [2] = {['Coords'] =  {['X'] = 487.24,   ['Y'] = -30.82,   ['Z'] = 88.85,  ['H'] = 59.62}, ['Model'] = 'oracle'},
    [3] = {['Coords'] =  {['X'] = -2723.39, ['Y'] = 13.20,    ['Z'] = 15.12,  ['H'] = 59.62}, ['Model'] = 'zion'},
    [4] = {['Coords'] =  {['X'] = -3139.75, ['Y'] = 1078.71,  ['Z'] = 20.18,  ['H'] = 59.62}, ['Model'] = 'chino'},
    [5] = {['Coords'] =  {['X'] = -1656.93, ['Y'] = -246.16,  ['Z'] = 54.51,  ['H'] = 59.62}, ['Model'] = 'baller2'},
    [6] = {['Coords'] =  {['X'] = -1586.65, ['Y'] = -647.56,  ['Z'] = 29.44,  ['H'] = 59.62}, ['Model'] = 'stanier'},
    [7] = {['Coords'] =  {['X'] = -1036.14, ['Y'] = -491.05,  ['Z'] = 36.21,  ['H'] = 59.62}, ['Model'] = 'washington'},
    [8] = {['Coords'] =  {['X'] = -1029.18, ['Y'] = -475.53,  ['Z'] = 36.41,  ['H'] = 59.62}, ['Model'] = 'buffalo'},
    [9] = {['Coords'] =  {['X'] = 209.16,   ['Y'] = 375.62,   ['Z'] = 107.02, ['H'] = 59.62}, ['Model'] = 'feltzer2'},
    [10] = {['Coords'] = {['X'] = -534.60,  ['Y'] = -756.71,  ['Z'] = 31.59,  ['H'] = 59.62}, ['Model'] = 'asea'},
    [11] = {['Coords'] = {['X'] = -4.5,     ['Y'] = -670.27,  ['Z'] = 31.85,  ['H'] = 59.62}, ['Model'] = 'fq2'},
    [12] = {['Coords'] = {['X'] = -772.20,  ['Y'] = -1281.81, ['Z'] = 4.56,   ['H'] = 59.62}, ['Model'] = 'sultanrs'},
    [13] = {['Coords'] = {['X'] = -111.89,  ['Y'] = 91.96,    ['Z'] = 71.08,  ['H'] = 59.62}, ['Model'] = 'baller2'},
    [14] = {['Coords'] = {['X'] = -314.26,  ['Y'] = -698.23,  ['Z'] = 32.54,  ['H'] = 59.62}, ['Model'] = 'oracle'},
    [15] = {['Coords'] = {['X'] = 322.36,   ['Y'] = 322.36,   ['Z'] = 25.77,  ['H'] = 59.62}, ['Model'] = 'baller2'},
    [16] = {['Coords'] = {['X'] = -858.91,  ['Y'] = -260.47,  ['Z'] = 39.56,  ['H'] = 59.62}, ['Model'] = 'sultan'},
    [17] = {['Coords'] = {['X'] = -775.55,  ['Y'] = 372.80,   ['Z'] = 87.87,  ['H'] = 59.62}, ['Model'] = 'sultanrs'},
    [18] = {['Coords'] = {['X'] = -416.16,  ['Y'] = 292.86,   ['Z'] = 83.22,  ['H'] = 59.62}, ['Model'] = 'panto'},
    [19] = {['Coords'] = {['X'] = 909.27,   ['Y'] = -56.61,   ['Z'] = 78.76,  ['H'] = 59.62}, ['Model'] = 'chino'},
    [20] = {['Coords'] = {['X'] = 1269.01,  ['Y'] = -366.17,  ['Z'] = 69.04,  ['H'] = 59.62}, ['Model'] = 'zion'},
    [21] = {['Coords'] = {['X'] = 1164.29,  ['Y'] = -1648.24, ['Z'] = 36.91,  ['H'] = 59.62}, ['Model'] = 'oracle'},
    [22] = {['Coords'] = {['X'] = -1061.69, ['Y'] = -2022.52, ['Z'] = 13.16,  ['H'] = 59.62}, ['Model'] = 'feltzer2'},
}

Config.MiningMaterials = {'metalscrap', 'copper-ore', 'aluminum-ore', 'iron-ore', 'gold-ore'}

Config.MiningSpots = {
    [1] = {['Coords'] = vector3(-591.51, 2075.49, 131.53), ['Mined'] = false, ['Busy'] = false},
    [2] = {['Coords'] = vector3(-591.47, 2068.60, 131.35), ['Mined'] = false, ['Busy'] = false},
    [3] = {['Coords'] = vector3(-588.28, 2061.77, 131.01), ['Mined'] = false, ['Busy'] = false},
    [4] = {['Coords'] = vector3(-587.39, 2056.42, 130.46), ['Mined'] = false, ['Busy'] = false},
    [5] = {['Coords'] = vector3(-585.73, 2046.64, 129.81), ['Mined'] = false, ['Busy'] = false},
    [6] = {['Coords'] = vector3(-581.29, 2038.38, 128.94), ['Mined'] = false, ['Busy'] = false},
    [7] = {['Coords'] = vector3(-579.61, 2032.56, 128.64), ['Mined'] = false, ['Busy'] = false},
    [8] = {['Coords'] = vector3(-575.17, 2029.90, 128.11), ['Mined'] = false, ['Busy'] = false},
    [9] = {['Coords'] = vector3(-566.89, 2019.91, 127.50), ['Mined'] = false, ['Busy'] = false},
    [10] = {['Coords'] = vector3(-554.28, 1999.35, 127.14), ['Mined'] = false, ['Busy'] = false},
    [11] = {['Coords'] = vector3(-544.85, 1987.94, 127.20), ['Mined'] = false, ['Busy'] = false},
    [12] = {['Coords'] = vector3(-549.94, 1996.79, 127.07), ['Mined'] = false, ['Busy'] = false},
    [13] = {['Coords'] = vector3(-546.36, 1984.26, 127.12), ['Mined'] = false, ['Busy'] = false},
    [14] = {['Coords'] = vector3(-565.33, 2015.69, 127.40), ['Mined'] = false, ['Busy'] = false},
    [15] = {['Coords'] = vector3(-561.65, 2011.61, 127.25), ['Mined'] = false, ['Busy'] = false},
    [16] = {['Coords'] = vector3(-541.22, 1981.7, 127.22),  ['Mined'] = false, ['Busy'] = false},
    [17] = {['Coords'] = vector3(-528.77, 1981.25, 126.91), ['Mined'] = false, ['Busy'] = false},
    [18] = {['Coords'] = vector3(-528.67, 1978.91, 126.90), ['Mined'] = false, ['Busy'] = false},
    [19] = {['Coords'] = vector3(-524.35, 1980.90, 126.76), ['Mined'] = false, ['Busy'] = false},
    [20] = {['Coords'] = vector3(-521.68, 1978.06, 126.71), ['Mined'] = false, ['Busy'] = false},
    [21] = {['Coords'] = vector3(-595.89, 2083.84, 131.48), ['Mined'] = false, ['Busy'] = false},
    [22] = {['Coords'] = vector3(-591.03, 2063.91, 131.08), ['Mined'] = false, ['Busy'] = false},
    [23] = {['Coords'] = vector3(-535.03, 1982.48, 127.02), ['Mined'] = false, ['Busy'] = false},
    [24] = {['Coords'] = vector3(-518.32, 1980.45, 126.49), ['Mined'] = false, ['Busy'] = false},
    [25] = {['Coords'] = vector3(-515.75, 1977.83, 126.41), ['Mined'] = false, ['Busy'] = false},
    [26] = {['Coords'] = vector3(-511.12, 1980.36, 126.20), ['Mined'] = false, ['Busy'] = false},
    [27] = {['Coords'] = vector3(-508.26, 1977.98, 126.17), ['Mined'] = false, ['Busy'] = false},
    [28] = {['Coords'] = vector3(-505.14, 1980.48, 126.09), ['Mined'] = false, ['Busy'] = false},
    [29] = {['Coords'] = vector3(-500.69, 1978.68, 125.87), ['Mined'] = false, ['Busy'] = false},
    [30] = {['Coords'] = vector3(-498.51, 1981.85, 125.61), ['Mined'] = false, ['Busy'] = false},
    [31] = {['Coords'] = vector3(-495.34, 1983.07, 125.21), ['Mined'] = false, ['Busy'] = false},
    [32] = {['Coords'] = vector3(-496.56, 1979.64, 125.59), ['Mined'] = false, ['Busy'] = false},
    [33] = {['Coords'] = vector3(-491.81, 1984.60, 124.77), ['Mined'] = false, ['Busy'] = false},
    [34] = {['Coords'] = vector3(-488.39, 1986.22, 124.41), ['Mined'] = false, ['Busy'] = false},
    [35] = {['Coords'] = vector3(-486.21, 1984.19, 124.43), ['Mined'] = false, ['Busy'] = false},
    [36] = {['Coords'] = vector3(-482.82, 1988.24, 124.09), ['Mined'] = false, ['Busy'] = false},
    [37] = {['Coords'] = vector3(-551.29, 1994.40, 127.07), ['Mined'] = false, ['Busy'] = false},
    [38] = {['Coords'] = vector3(-538.92, 1983.58, 127.02), ['Mined'] = false, ['Busy'] = false},
    [39] = {['Coords'] = vector3(-477.44, 1989.70, 123.89), ['Mined'] = false, ['Busy'] = false},
    [40] = {['Coords'] = vector3(-475.05, 1990.72, 123.76), ['Mined'] = false, ['Busy'] = false},
    [41] = {['Coords'] = vector3(-470.67, 1992.50, 123.63), ['Mined'] = false, ['Busy'] = false},
    [42] = {['Coords'] = vector3(-467.67, 1994.51, 123.54), ['Mined'] = false, ['Busy'] = false},
    [43] = {['Coords'] = vector3(-464.24, 1997.05, 123.54), ['Mined'] = false, ['Busy'] = false},
    [44] = {['Coords'] = vector3(-460.85, 2000.28, 123.54), ['Mined'] = false, ['Busy'] = false},
    [45] = {['Coords'] = vector3(-458.92, 2002.17, 123.57), ['Mined'] = false, ['Busy'] = false},
    [46] = {['Coords'] = vector3(-456.43, 2004.94, 123.54), ['Mined'] = false, ['Busy'] = false},
    [47] = {['Coords'] = vector3(-454.04, 2007.43, 123.54), ['Mined'] = false, ['Busy'] = false},
    [48] = {['Coords'] = vector3(-450.33, 2014.12, 123.54), ['Mined'] = false, ['Busy'] = false},
    [49] = {['Coords'] = vector3(-449.79, 2017.89, 123.54), ['Mined'] = false, ['Busy'] = false},
    [50] = {['Coords'] = vector3(-450.14, 2020.80, 123.57), ['Mined'] = false, ['Busy'] = false},
    [51] = {['Coords'] = vector3(-451.29, 2025.63, 123.48), ['Mined'] = false, ['Busy'] = false},
    [52] = {['Coords'] = vector3(-451.85, 2028.61, 123.39), ['Mined'] = false, ['Busy'] = false},
    [53] = {['Coords'] = vector3(-452.78, 2032.86, 123.21), ['Mined'] = false, ['Busy'] = false},
    [54] = {['Coords'] = vector3(-453.57, 2036.03, 123.06), ['Mined'] = false, ['Busy'] = false},
    [55] = {['Coords'] = vector3(-454.84, 2039.53, 122.88), ['Mined'] = false, ['Busy'] = false},
    [56] = {['Coords'] = vector3(-456.19, 2042.80, 122.75), ['Mined'] = false, ['Busy'] = false},
    [57] = {['Coords'] = vector3(-457.89, 2046.06, 122.66), ['Mined'] = false, ['Busy'] = false},
    [58] = {['Coords'] = vector3(-459.52, 2049.39, 122.53), ['Mined'] = false, ['Busy'] = false},
    [59] = {['Coords'] = vector3(-461.60, 2052.89, 122.18), ['Mined'] = false, ['Busy'] = false},
    [60] = {['Coords'] = vector3(-463.33, 2056.11, 121.74), ['Mined'] = false, ['Busy'] = false},
    [61] = {['Coords'] = vector3(-465.31, 2060.00, 121.21), ['Mined'] = false, ['Busy'] = false},
    [62] = {['Coords'] = vector3(-466.37, 2062.63, 120.96), ['Mined'] = false, ['Busy'] = false},
    [63] = {['Coords'] = vector3(-468.05, 2067.10, 120.75), ['Mined'] = false, ['Busy'] = false},
    [64] = {['Coords'] = vector3(-469.29, 2070.12, 120.60), ['Mined'] = false, ['Busy'] = false},
    [65] = {['Coords'] = vector3(-470.28, 2073.21, 120.44), ['Mined'] = false, ['Busy'] = false},
    [66] = {['Coords'] = vector3(-471.30, 2077.50, 120.35), ['Mined'] = false, ['Busy'] = false},
    [67] = {['Coords'] = vector3(-472.31, 2082.16, 120.18), ['Mined'] = false, ['Busy'] = false},
    [68] = {['Coords'] = vector3(-470.30, 2082.78, 120.17), ['Mined'] = false, ['Busy'] = false},
    [69] = {['Coords'] = vector3(-468.96, 2077.90, 120.33), ['Mined'] = false, ['Busy'] = false},
    [70] = {['Coords'] = vector3(-468.30, 2074.82, 120.45), ['Mined'] = false, ['Busy'] = false},
    [71] = {['Coords'] = vector3(-466.71, 2070.46, 120.77), ['Mined'] = false, ['Busy'] = false},
    [72] = {['Coords'] = vector3(-465.94, 2067.74, 120.73), ['Mined'] = false, ['Busy'] = false},
    [73] = {['Coords'] = vector3(-464.06, 2063.70, 121.09), ['Mined'] = false, ['Busy'] = false},
    [74] = {['Coords'] = vector3(-461.90, 2058.95, 121.65), ['Mined'] = false, ['Busy'] = false},
    [75] = {['Coords'] = vector3(-460.70, 2056.55, 121.97), ['Mined'] = false, ['Busy'] = false},
    [76] = {['Coords'] = vector3(-454.38, 2045.03, 122.83), ['Mined'] = false, ['Busy'] = false},
    [77] = {['Coords'] = vector3(-450.92, 2035.57, 123.19), ['Mined'] = false, ['Busy'] = false},
    [78] = {['Coords'] = vector3(-449.98, 2031.13, 123.31), ['Mined'] = false, ['Busy'] = false},
    [79] = {['Coords'] = vector3(-449.47, 2028.47, 123.41), ['Mined'] = false, ['Busy'] = false},
    [80] = {['Coords'] = vector3(-448.73, 2025.80, 123.53), ['Mined'] = false, ['Busy'] = false},
    [81] = {['Coords'] = vector3(-447.66, 2020.90, 123.63), ['Mined'] = false, ['Busy'] = false},
    [82] = {['Coords'] = vector3(-452.45, 2005.57, 123.62), ['Mined'] = false, ['Busy'] = false},
    [83] = {['Coords'] = vector3(-455.66, 2002.22, 123.54), ['Mined'] = false, ['Busy'] = false},
    [84] = {['Coords'] = vector3(-457.53, 2000.04, 123.63), ['Mined'] = false, ['Busy'] = false},
    [85] = {['Coords'] = vector3(-459.89, 1998.16, 123.54), ['Mined'] = false, ['Busy'] = false},
    [86] = {['Coords'] = vector3(-465.73, 1992.70, 123.67), ['Mined'] = false, ['Busy'] = false},
    [87] = {['Coords'] = vector3(-469.18, 1990.40, 123.696), ['Mined'] = false, ['Busy'] = false},
    [88] = {['Coords'] = vector3(-477.09, 1987.28, 123.937), ['Mined'] = false, ['Busy'] = false},
    [89] = {['Coords'] = vector3(-483.23, 1985.28, 124.181), ['Mined'] = false, ['Busy'] = false},
    [90] = {['Coords'] = vector3(-542.50, 1979.00, 127.05), ['Mined'] = false, ['Busy'] = false},
    [91] = {['Coords'] = vector3(-542.15, 1976.07, 127.05), ['Mined'] = false, ['Busy'] = false},
    [92] = {['Coords'] = vector3(-541.42, 1971.45, 126.98), ['Mined'] = false, ['Busy'] = false},
    [93] = {['Coords'] = vector3(-540.90, 1967.60, 126.91), ['Mined'] = false, ['Busy'] = false},
    [94] = {['Coords'] = vector3(-540.51, 1964.29, 126.81), ['Mined'] = false, ['Busy'] = false},
    [95] = {['Coords'] = vector3(-540.28, 1960.76, 126.68), ['Mined'] = false, ['Busy'] = false},
    [96] = {['Coords'] = vector3(-539.71, 1958.12, 126.52), ['Mined'] = false, ['Busy'] = false},
    [97] = {['Coords'] = vector3(-538.96, 1953.44, 126.34), ['Mined'] = false, ['Busy'] = false},
    [98] = {['Coords'] = vector3(-537.96, 1949.72, 126.14), ['Mined'] = false, ['Busy'] = false},
    [99] = {['Coords'] = vector3(-536.78, 1945.86, 125.91), ['Mined'] = false, ['Busy'] = false},
    [100] = {['Coords'] = vector3(-535.09, 1938.91, 125.44), ['Mined'] = false, ['Busy'] = false},
    [101] = {['Coords'] = vector3(-534.34, 1934.45, 125.11), ['Mined'] = false, ['Busy'] = false},
    [102] = {['Coords'] = vector3(-534.05, 1931.63, 124.90), ['Mined'] = false, ['Busy'] = false},
    [103] = {['Coords'] = vector3(-533.82, 1926.63, 124.53), ['Mined'] = false, ['Busy'] = false},
    [104] = {['Coords'] = vector3(-533.85, 1923.65, 124.31), ['Mined'] = false, ['Busy'] = false},
    [105] = {['Coords'] = vector3(-534.17, 1919.47, 124.01), ['Mined'] = false, ['Busy'] = false},
    [106] = {['Coords'] = vector3(-534.95, 1915.59, 123.73), ['Mined'] = false, ['Busy'] = false},
    [107] = {['Coords'] = vector3(-536.01, 1911.58, 123.46), ['Mined'] = false, ['Busy'] = false},
    [108] = {['Coords'] = vector3(-541.84, 1902.34, 123.07), ['Mined'] = false, ['Busy'] = false},
    [109] = {['Coords'] = vector3(-544.71, 1899.12, 123.05), ['Mined'] = false, ['Busy'] = false},
    [110] = {['Coords'] = vector3(-547.59, 1896.25, 123.03), ['Mined'] = false, ['Busy'] = false},
    [111] = {['Coords'] = vector3(-550.47, 1893.53, 123.03), ['Mined'] = false, ['Busy'] = false},
    [112] = {['Coords'] = vector3(-553.53, 1891.48, 123.06), ['Mined'] = false, ['Busy'] = false},
    [113] = {['Coords'] = vector3(-557.06, 1889.01, 123.03), ['Mined'] = false, ['Busy'] = false},
    [114] = {['Coords'] = vector3(-560.13, 1887.32, 123.03), ['Mined'] = false, ['Busy'] = false},
    [115] = {['Coords'] = vector3(-561.20, 1889.76, 123.10), ['Mined'] = false, ['Busy'] = false},
    [116] = {['Coords'] = vector3(-558.50, 1891.30, 123.14), ['Mined'] = false, ['Busy'] = false},
    [117] = {['Coords'] = vector3(-554.31, 1893.99, 123.17), ['Mined'] = false, ['Busy'] = false},
    [118] = {['Coords'] = vector3(-549.72, 1897.39, 123.03), ['Mined'] = false, ['Busy'] = false},
    [119] = {['Coords'] = vector3(-546.88, 1900.58, 123.15), ['Mined'] = false, ['Busy'] = false},
    [120] = {['Coords'] = vector3(-543.58, 1904.10, 123.16), ['Mined'] = false, ['Busy'] = false},
    [121] = {['Coords'] = vector3(-540.41, 1908.95, 123.31), ['Mined'] = false, ['Busy'] = false},
    [122] = {['Coords'] = vector3(-538.59, 1912.47, 123.57), ['Mined'] = false, ['Busy'] = false},
    [123] = {['Coords'] = vector3(-537.24, 1916.94, 123.88), ['Mined'] = false, ['Busy'] = false},
    [124] = {['Coords'] = vector3(-536.67, 1922.70, 124.29), ['Mined'] = false, ['Busy'] = false},
    [125] = {['Coords'] = vector3(-536.29, 1926.84, 124.57), ['Mined'] = false, ['Busy'] = false},
    [126] = {['Coords'] = vector3(-536.54, 1931.72, 125.01), ['Mined'] = false, ['Busy'] = false},
    [127] = {['Coords'] = vector3(-537.57, 1937.31, 125.50), ['Mined'] = false, ['Busy'] = false},
    [128] = {['Coords'] = vector3(-538.43, 1941.37, 125.81), ['Mined'] = false, ['Busy'] = false},
    [129] = {['Coords'] = vector3(-539.67, 1946.22, 126.14), ['Mined'] = false, ['Busy'] = false},
    [130] = {['Coords'] = vector3(-541.52, 1953.39, 126.43), ['Mined'] = false, ['Busy'] = false},
    [131] = {['Coords'] = vector3(-542.80, 1961.06, 126.79), ['Mined'] = false, ['Busy'] = false},
    [132] = {['Coords'] = vector3(-543.44, 1966.17, 127.02), ['Mined'] = false, ['Busy'] = false},
    [133] = {['Coords'] = vector3(-544.06, 1971.35, 127.08), ['Mined'] = false, ['Busy'] = false},
    [134] = {['Coords'] = vector3(-544.59, 1976.42, 127.08), ['Mined'] = false, ['Busy'] = false},
    [135] = {['Coords'] = vector3(-545.43, 1981.25, 127.02), ['Mined'] = false, ['Busy'] = false},
    [136] = {['Coords'] = vector3(-549.03, 1990.18, 127.07), ['Mined'] = false, ['Busy'] = false},
    [137] = {['Coords'] = vector3(-582.33, 2035.38, 128.91), ['Mined'] = false, ['Busy'] = false},
    [138] = {['Coords'] = vector3(-589.59, 2054.24, 130.42), ['Mined'] = false, ['Busy'] = false},
    [139] = {['Coords'] = vector3(-590.52, 2060.89, 130.80), ['Mined'] = false, ['Busy'] = false},
    [140] = {['Coords'] = vector3(-593.79, 2075.16, 131.40), ['Mined'] = false, ['Busy'] = false},
}

Config.GarbageLocations = {
    [1] = {['Coords'] =  {['X'] = -98.45,    ['Y'] = -1413.31, ['Z'] = 29.62}},
    [2] = {['Coords'] =  {['X'] = -79.29,    ['Y'] = -1427.15, ['Z'] = 29.67}},
    [3] = {['Coords'] =  {['X'] = -61.62,    ['Y'] = 202.17,   ['Z'] = 101.97}},
    [4] = {['Coords'] =  {['X'] = -771.05,   ['Y'] = -218.15,  ['Z'] = 37.28}}, 
    [5] = {['Coords'] =  {['X'] = -1136.85,  ['Y'] = -360.29,  ['Z'] = 37.67}},
    [6] = {['Coords'] =  {['X'] = -1054.91,  ['Y'] = -515.79,  ['Z'] = 36.03}},
    [7] = {['Coords'] =  {['X'] = 478.72,    ['Y'] = -1062.39, ['Z'] = 29.21}},
    [8] = {['Coords'] =  {['X'] = 468.76,    ['Y'] = -1584.92, ['Z'] = 29.27}},
    [9] = {['Coords'] =  {['X'] = 468.76,    ['Y'] = -1584.92, ['Z'] = 29.27}},
    [10] = {['Coords'] =  {['X'] = 562.95,   ['Y'] = -1773.50, ['Z'] = 29.35}},
    [11] = {['Coords'] =  {['X'] = 495.56,   ['Y'] = -1887.33, ['Z'] = 25.90}},
    [12] = {['Coords'] =  {['X'] = 298.32,   ['Y'] = -2018.32, ['Z'] = 20.50}},
    [13] = {['Coords'] =  {['X'] = 42.71,    ['Y'] = -1877.76, ['Z'] = 22.41}},
    [14] = {['Coords'] =  {['X'] = 118.27,   ['Y'] = -1944.04, ['Z'] = 20.66}}, 
    [15] = {['Coords'] =  {['X'] = -159.91,  ['Y'] = -2216.83, ['Z'] = 7.8}},
    [16] = {['Coords'] =  {['X'] = -886.33,  ['Y'] = -2750.03, ['Z'] = 13.9}},
    [17] = {['Coords'] =  {['X'] = -707.73,  ['Y'] = -2525.55, ['Z'] = 13.94}},
    [18] = {['Coords'] =  {['X'] = -1149.72, ['Y'] = -1989.26, ['Z'] = 13.16}},
    [19] = {['Coords'] =  {['X'] = -1126.72, ['Y'] = -1599.64, ['Z'] = 4.37}},
    [20] = {['Coords'] =  {['X'] = -1155.12, ['Y'] = -1538.29, ['Z'] = 4.27}},
    [21] = {['Coords'] =  {['X'] = -1603.83, ['Y'] = -814.14,  ['Z'] = 9.99}},
    [22] = {['Coords'] =  {['X'] = 130.17,   ['Y'] = -1054.9,  ['Z'] = 29.19}},
    [23] = {['Coords'] =  {['X'] = -51.65,   ['Y'] = -1061.28, ['Z'] = 27.72}},
    [24] = {['Coords'] =  {['X'] = -35.57,   ['Y'] = -90.30,   ['Z'] = 57.25}},
    [25] = {['Coords'] =  {['X'] = -761.29,  ['Y'] = 364.11,   ['Z'] = 87.86}},
    [26] = {['Coords'] =  {['X'] = -787.48,  ['Y'] = 354.95,   ['Z'] = 87.94}},
    [27] = {['Coords'] =  {['X'] = -1309.03, ['Y'] = -280.13,  ['Z'] = 39.64}},
    [28] = {['Coords'] =  {['X'] = -1309.03, ['Y'] = -280.13,  ['Z'] = 39.64}},
    [29] = {['Coords'] =  {['X'] = -1204.93, ['Y'] = -905.74,  ['Z'] = 13.44}},
    [30] = {['Coords'] =  {['X'] = -1323.89, ['Y'] = -767.61,  ['Z'] = 20.39}},
    [31] = {['Coords'] =  {['X'] = -1417.69, ['Y'] = -655.32,  ['Z'] = 28.67}},
}

Config.TaxiLocations = {
    [1] = {['PickupCoords'] = vector4(-1587.16, -861.70, 10.12, 100.0), ['SpecialChance'] = 10},
    [2] = {['PickupCoords'] = vector4(-1004.82, -716.68, 21.17, 44.08), ['SpecialChance'] = 5},
    [3] = {['PickupCoords'] = vector4(-1375.26, -47.10, 53.70, 97.26), ['SpecialChance'] = 35, ['Label'] = 'Golf Course'},
    [4] = {['PickupCoords'] = vector4(-1215.97, -857.19, 13.50, 217.39), ['SpecialChance'] = 35},
    [5] = {['PickupCoords'] = vector4(-225.03, -2036.69, 27.75, 234.56), ['SpecialChance'] = 10, ['Label'] = 'Mazebank Arena'},
    [6] = {['PickupCoords'] = vector4(285.17, -2005.43, 20.22, 236.46), ['SpecialChance'] = 10, ['Label'] = 'Bario'},
    [7] = {['PickupCoords'] = vector4(122.28, -1309.59, 29.22, 236.46), ['SpecialChance'] = 10, ['Label'] = 'Stripclub'},
    [8] = {['PickupCoords'] = vector4(1042.68, -742.67, 57.92, 152.01), ['SpecialChance'] = 10, ['Label'] = 'Mirror Park'},
    [9] = {['PickupCoords'] = vector4(925.44, 46.38, 80.90, 66.43), ['SpecialChance'] = 10, ['Label'] = 'Casino'},
    [10] = {['PickupCoords'] = vector4(1256.35, -1593.73, 52.87, 209.85), ['SpecialChance'] = 10, ['Label'] = 'Eastside'},
}

Config.TaxiEndCoords = {
    [1] = vector3(658.43, -18.97, 82.82),
}

Config.CurrentEffect = {}

Config.InsideUnicorn = false

Config.ActivePayments = {}

-- Config.Location = {['StripClub'] = {['X'] = 119.12, ['Y'] = -1289.86, ['Z'] = 28.26}}

Config.Location = {
    ['StripClub'] = {['X'] = 119.12, ['Y'] = -1289.86, ['Z'] = 28.26},
	['shop'] = { ['x'] = 129.76, ['y'] = -1281.82, ['z'] = 29.26, ['h'] = 295.61 },
	['vip'] = { ['x'] = 118.81668 , ['y'] = -1302.461, ['z'] = 29.269309, ['h'] = 211.85334 },
	['stripper'] = { ['x'] = 108.55, ['y'] = -1305.98, ['z'] = 28.76, ['h'] = 212.00  },
	['boss'] = { ['x'] = 95.15, ['y'] = -1293.38, ['z'] = 29.26, ['h'] = 290.99  },
}

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
    [1] = {['Name'] = 'Fireworks',          ['Desc'] = 'Turn on the fireworks effect.',         ['Dict'] = 'proj_xmas_firework',  ['Effect'] = 'scr_firework_xmas_ring_burst_rgw',  ['Event'] = 'framework-unicorn:server:set:effect'},
    [2] = {['Name'] = 'Star Fountain',      ['Desc'] = 'Turn on the star font effect.',         ['Dict'] = 'scr_indep_fireworks', ['Effect'] = 'scr_indep_firework_fountain',       ['Event'] = 'framework-unicorn:server:set:effect'},
    [3] = {['Name'] = 'Water Fountain',     ['Desc'] = 'Turn on the water fountain effect.',    ['Dict'] = 'scr_carwash',         ['Effect'] = 'ent_amb_car_wash_jet',              ['Event'] = 'framework-unicorn:server:set:effect'},
    [4] = {['Name'] = 'Fire Fountain',      ['Desc'] = 'Turn on the fire fountain effect.',     ['Dict'] = 'core',                ['Effect'] = 'ent_amb_fbi_fire_beam',             ['Event'] = 'framework-unicorn:server:set:effect'},
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

Config.Strippers = {
    ['locations'] ={
        {
            ['taken'] = 0,
            ['model'] = nil,
            ['sit'] = vector4(118.77422, -1302.212, 28.269432, 31.382211),
            ['stand'] = vector4(118.42105, -1301.561, 28.269502, 208.21502),
        },
        {
            ['taken'] = 0,
            ['model'] = nil,
            ['sit'] = vector4(116.74626, -1303.393, 28.273693, 32.705486),
            ['stand'] = vector4(116.29303, -1302.636, 28.269521, 207.09544),
        },
        {
            ['taken'] = 0,
            ['model'] = nil,
            ['sit'] = vector4(114.60829, -1304.639, 28.269498, 25.138725),
            ['stand'] = vector4(114.19611, -1303.985, 28.269498, 207.37702),
        },
        {
            ['taken'] = 0,
            ['model'] = nil,
            ['sit'] = vector4(112.82508, -1305.668, 28.2695, 30.056648),
            ['stand'] = vector4(112.34696, -1305.062, 28.269504, 202.59379),
        },
        {
            ['taken'] = 0,
            ['model'] = nil,
            ['sit'] = vector4(112.82508, -1305.668, 28.2695, 30.056648),
            ['stand'] = vector4(112.34696, -1305.062, 28.269504, 202.59379),
        },
    },
    ['peds'] = {
       'csb_stripper_01', -- White Stripper
	   's_f_y_stripperlite', -- Black Stripper
       'mp_f_stripperlite', -- Black Stripper
    }
}

Config.CocktailsItems = {
    [1] = {
        ['Label'] = 'Mojito',
        ['ItemName'] = 'mojito',
        ['Slot'] = 1,
        ['Amount'] = 10,
        ['Info'] = '',
        ['Weight'] = 5,
        ['Image'] = 'mojito.png',
        ['AddingPoints'] = 2,
        ['PointsNeeded'] = 0,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Lime Slice',
                ['ItemName'] = 'limoenschijfje',
                ['Image'] = 'limonschijfje.png',
                ['Amount'] = 5,
            },
            [2] = {
                ['Label'] = 'Shot of Cane Sugar',
                ['ItemName'] = 'shotrietsuiker',
                ['Image'] = 'shot.png',
                ['Amount'] = 5,
            },
            [3] = {
                ['Label'] = 'Shot Witte Rum',
                ['ItemName'] = 'shotwhiterum',
                ['Image'] = 'shot.png',
                ['Amount'] = 5,
            },
            [4] = {
                ['Label'] = 'Mint Leaves',
                ['ItemName'] = 'muntblaadjes',
                ['Image'] = 'muntblaadjes.png',
                ['Amount'] = 5,
            },
            [5] = {
                ['Label'] = 'Ice Cubes',
                ['ItemName'] = 'ijsblokjes',
                ['Image'] = 'ijsblokjes.png',
                ['Amount'] = 5,
            },
        },
    },
    [2] = {
        ['Label'] = 'Whiskey',
        ['ItemName'] = 'whiskey',
        ['Slot'] = 2,
        ['Amount'] = 10,
        ['Info'] = '',
        ['Weight'] = 5,
        ['Image'] = 'whiskey.png',
        ['AddingPoints'] = 2,
        ['PointsNeeded'] = 0,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Shot of Whiskey',
                ['ItemName'] = 'shotwhiskey',
                ['Image'] = 'shot.png',
                ['Amount'] = 5,
            },
            [2] = {
                ['Label'] = 'Ice Cubes',
                ['ItemName'] = 'ijsblokjes',
                ['Image'] = 'ijsblokjes.png',
                ['Amount'] = 5,
            },
        },
    },
    [3] = {
        ['Label'] = 'Tequila Sunrise',
        ['ItemName'] = 'tequila',
        ['Slot'] = 3,
        ['Amount'] = 10,
        ['Info'] = '',
        ['Weight'] = 5,
        ['Image'] = 'tequila.png',
        ['AddingPoints'] = 2,
        ['PointsNeeded'] = 0,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Shot Tequila',
                ['ItemName'] = 'shottequila',
                ['Image'] = 'shot.png',
                ['Amount'] = 5,
            },
            [2] = {
                ['Label'] = 'Shot of Orange Juice',
                ['ItemName'] = 'shotsinaasappelsap',
                ['Image'] = 'shot.png',
                ['Amount'] = 5,
            },
            [3] = {
                ['Label'] = 'Shot of Grenadine',
                ['ItemName'] = 'shotgrenadine',
                ['Image'] = 'shot.png',
                ['Amount'] = 5,
            },
            [4] = {
                ['Label'] = 'Ice Cubes',
                ['ItemName'] = 'ijsblokjes',
                ['Image'] = 'ijsblokjes.png',
                ['Amount'] = 5,
            },
        },
    },
}

Config.WeedItems = {
    [1] = {
        ['Label'] = 'Langevloei',
        ['ItemName'] = 'rolling-paper',
        ['Slot'] = 1,
        ['Amount'] = 400,
        ['Info'] = '',
        ['Weight'] = 5,
        ['Image'] = 'rolling-paper.png',
        ['AddingPoints'] = 2,
        ['PointsNeeded'] = 0,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Papier',
                ['ItemName'] = 'clean_paper',
                ['Image'] = 'clean_paper.png',
                ['Amount'] = 2,
            },
            [2] = {
                ['Label'] = 'Lijm',
                ['ItemName'] = 'lijm',
                ['Image'] = 'lijm.png',
                ['Amount'] = 1,
            },
        },
    },
    [2] = {
        ['Label'] = 'Leeg wietzakje',
        ['ItemName'] = 'empty_weed_bag',
        ['Slot'] = 2,
        ['Amount'] = 400,
        ['Info'] = '',
        ['Weight'] = 5,
        ['Image'] = 'plastic-bag.png',
        ['AddingPoints'] = 2,
        ['PointsNeeded'] = 0,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Plastic',
                ['ItemName'] = 'plastic',
                ['Image'] = 'plastic.png',
                ['Amount'] = 2,
            },
            [2] = {
                ['Label'] = 'Lijm',
                ['ItemName'] = 'lijm',
                ['Image'] = 'lijm.png',
                ['Amount'] = 1,
            },
        },
    },
}

Config.RegisterData = {}

Config.RestaurantCoords = vector3(-161.78, 293.22, 93.0)

Config.FoodCooker = {
    [1] = {
      ['FoodName'] = 'Sushi Onigiri',
      ['Food'] = 'sushi',
      ['Desc'] = '1x Rice, 1x Water',
    },
    [2] = {
      ['FoodName'] = 'Ramen',
      ['Food'] = 'sushi-ramen',
      ['Desc'] = '1x Water, 1x Raw Meat, 1x Ramen',
    },
    [3] = {
      ['FoodName'] = 'Beef Dish',
      ['Food'] = 'sushi-beef',
      ['Desc'] = '1x Raw Meat, 1x Ramen',
    },
}

Config.WorkProps = {
    [1] = {
      ['Name'] = 'ClockIn',
      ['PlaceOnGround'] = true,
      ['ShowItem'] = false,
      ['Prop'] = 'v_ind_cs_toolboard',
      ['Coords'] = vector4(-171.65, 305.71, 98.52, 271.99),
    },
    [2] = {
      ['Name'] = 'Pay',
      ['PlaceOnGround'] = false,
      ['ShowItem'] = false,
      ['Prop'] = 'v_ind_cm_paintbckt04',
      ['Coords'] = vector4(-170.97, 304.58, 98.6, 267.86),
    },
    [3] = {
      ['Name'] = 'Register',
      ['PlaceOnGround'] = false,
      ['ShowItem'] = false,
      ['Prop'] = 'v_ind_cm_paintbckt03',
      ['Coords'] = vector4(-174.01, 304.66, 98.49, 90.07),
    },
    [4] = {
      ['Name'] = 'Cooker',
      ['PlaceOnGround'] = true,
      ['ShowItem'] = true,
      ['Prop'] = 'prop_kitch_pot_huge',
      ['Coords'] = vector4(-173.74, 292.59, 99.37, 272.89),
    },
    [5] = {
      ['Name'] = 'Plate',
      ['PlaceOnGround'] = true,
      ['ShowItem'] = false,
      ['Prop'] = 'prop_plate_warmer',
      ['Coords'] = vector4(-171.30, 291.98, 99.37, 271.92),
    },
    [6] = {
      ['Name'] = 'Opslag',
      ['PlaceOnGround'] = false,
      ['ShowItem'] = false,
      ['Prop'] = 'v_ind_cf_flour',
      ['Coords'] = vector4(-172.61, 289.71, 98.23, 180.18),
    },
    [7] = {
      ['Name'] = 'Thee',
      ['PlaceOnGround'] = true,
      ['ShowItem'] = true,
      ['Prop'] = 'v_res_fa_pottea',
      ['Coords'] = vector4(-171.27, 290.89, 99.40, 273.28),
    },
}

Config.RandomNpcModel = {
    [1] = 'a_m_o_genstreet_01',
    [2] = 'a_m_o_salton_01',
    [3] = 'a_f_o_genstreet_01',
    [4] = 'a_m_m_tranvest_02',
    [5] = 'a_m_m_tourist_01',
    [6] = 'a_m_y_beachvesp_01',
    [7] = 'a_m_y_hasjew_01',
    [8] = 'a_m_y_musclbeac_01',
    [9] = 'a_f_m_prolhost_01',
    [10] = 'a_f_m_soucentmc_01',
    [11] = 'a_f_y_yoga_01',
    [12] = 'u_m_y_imporage',
}

Config.JobProps = {
    [1] = {
        ['Visible'] = false,
        ['PlacePropGood'] = false,
        ['Prop'] = 'v_ind_cs_oiltub',
        ['Coords'] = {
            ['X'] = -192.52, 
            ['Y'] = -1161.90, 
            ['Z'] = 23.30,
            ['H'] = 91.97,
        },
    },
    [2] = {
        ['Visible'] = false,
        ['PlacePropGood'] = false,
        ['Prop'] = 'v_corp_fib_glass_thin',
        ['Coords'] = {
            ['X'] = -350.07, 
            ['Y'] = -1569.94, 
            ['Z'] = 25.22,
            ['H'] = 114.03,
        },
    },
    [3] = {
        ['Visible'] = false,
        ['PlacePropGood'] = false,
        ['Prop'] = 'v_ind_cm_paintbckt06',
        ['Coords'] = {
            ['X'] = 901.88, 
            ['Y'] = -172.15, 
            ['Z'] = 74.14,
            ['H'] = 267.611,
        },
    },
}

Config.MineshaftLights = {
    [1] = vector3(-592.74, 2077.66, 132.40),
    [2] = vector3(-590.91, 2070.35, 132.40),
    [3] = vector3(-589.31, 2062.91, 132.00),
    [4] = vector3(-588.42, 2055.31, 132.00),
    [5] = vector3(-586.87, 2047.88, 131.50),
    [6] = vector3(-584.02, 2041.02, 131.50),
    [7] = vector3(-579.91, 2034.44, 129.50),
    [8] = vector3(-575.60, 2028.27, 129.50),
    [9] = vector3(-570.48, 2022.70, 129.50),
    [10] = vector3(-565.15, 2017.33, 128.50),
    [11] = vector3(-560.33, 2011.35, 128.50),
    [12] = vector3(-556.15, 2005.01, 128.50),
    [13] = vector3(-552.21, 1998.49, 128.50),
    [14] = vector3(-548.48, 1991.87, 128.50),
    [15] = vector3(-537.62, 1981.71, 128.30),
    [16] = vector3(-530.02, 1980.36, 127.90),
    [17] = vector3(-543.38, 1977.53, 128.00),
    [18] = vector3(-522.50, 1979.34, 127.90),
    [19] = vector3(-514.89, 1979.03, 127.90),
    [20] = vector3(-507.27, 1979.16, 127.90),
    [21] = vector3(-499.71, 1980.24, 126.90),
    [22] = vector3(-492.69, 1982.79, 125.90),
    [23] = vector3(-485.75, 1985.85, 125.90),
    [24] = vector3(-478.50, 1988.16, 124.90),
    [25] = vector3(-471.53, 2083.65, 121.40),
    [26] = vector3(-469.78, 2075.94, 121.40),
    [27] = vector3(-464.84, 2061.89, 122.40),
    [28] = vector3(-467.81, 2068.85, 121.40),
    [29] = vector3(-461.50, 2055.01, 122.40),
    [30] = vector3(-451.01, 2056.17, 123.40),
    [31] = vector3(-457.74, 2048.45, 123.40),
    [32] = vector3(-454.51, 2041.66, 123.40),
    [33] = vector3(-451.97, 2034.45, 124.40),
    [34] = vector3(-450.41, 2027.00, 124.40),
    [35] = vector3(-448.76, 2019.40, 124.40),
    [36] = vector3(-454.12, 2005.77, 124.40),
    [37] = vector3(-459.22, 2000.36, 124.40),
    [38] = vector3(-464.97, 1995.13, 124.40),
    [39] = vector3(-471.34, 1990.99, 124.40),
    [40] = vector3(-444.28, 2059.32, 122.40),
    [41] = vector3(-436.73, 2061.59, 122.40),
    [42] = vector3(-429.65, 2063.25, 121.40),
    [43] = vector3(-544.84, 1985.93, 128.40),
    [44] = vector3(-542.44, 1969.95, 127.40),
    [45] = vector3(-541.66, 1962.60, 127.40),
    [46] = vector3(-540.44, 1954.87, 127.40),
    [47] = vector3(-538.63, 1947.55, 127.40),
    [48] = vector3(-536.56, 1940.23, 126.40),
    [49] = vector3(-535.32, 1932.77, 126.40),
    [50] = vector3(-535.07, 1925.14, 125.40),
    [51] = vector3(-535.70, 1917.63, 124.40),
    [52] = vector3(-537.94, 1910.40, 124.40),
    [53] = vector3(-531.90, 1901.96, 124.40),
    [54] = vector3(-525.31, 1898.23, 123.40),
    [55] = vector3(-518.28, 1895.31, 123.40),
    [56] = vector3(-511.03, 1893.92, 122.40),
    [57] = vector3(-503.35, 1893.45, 122.15),
    [58] = vector3(-495.86, 1893.86, 121.15),
    [59] = vector3(-488.10, 1894.57, 121.14),
    [60] = vector3(-541.85, 1904.11, 124.14),
    [61] = vector3(-547.01, 1898.29, 124.14),
    [62] = vector3(-552.79, 1893.40, 124.14),
    [63] = vector3(-559.10, 1889.29, 124.14),
    [64] = vector3(-594.93, 2085.04, 132.14),
    [65] = vector3(-448.18, 2013.31, 124.50),
}
Config.Lumberjack = {
    -- Lumberjack Job
    Prices = {
        ['wood_proc'] = {30, 50}
    },
    ChanceToGetItem = 20, -- if math.random(0, 100) <= ChanceToGetItem then give item
    Items = {'wood_cut','wood_cut','wood_cut','wood_cut','wood_cut'},
    Sell = vector3(1210.0, -1318.51, 35.23),
    Process = vector3(-584.66, 5285.63, 70.26),
    Cars = vector3(1204.48, -1265.63, 35.23),
    delVeh = vector3(1187.84, -1286.76, 34.95),
    Objects = {
        ['pickaxe'] = 'w_me_hatchet',
    },
    WoodPosition = {
        {coords = vector3(-493.0, 5395.37, 77.18-0.97), heading = 282.49},
        {coords = vector3(-503.69, 5392.12, 75.98-0.97), heading = 113.62},
        {coords = vector3(-456.85, 5397.37, 79.49-0.97), heading = 29.92},
        {coords = vector3(-457.42, 5409.05, 78.78-0.97), heading = 209.65}
    },
   
}

Strings = {
    ['wood_info'] = 'Druk op ~INPUT_ATTACK~ om te hakken, ~INPUT_FRONTEND_RIGHT~ om te stoppen.',
    ['you_sold'] = 'Je hebt %sx %s verkocht voor €%s',
    ['e_sell'] = 'Druk op ~INPUT_CONTEXT~ om goederen te verkopen',
    ['someone_close'] = 'Er is nog een burger in de buurt!',
    ['wood'] = 'Houthak locatie',
    ['process'] = 'Houtverwerking',
    ['autotru'] = 'Houthakker voertuig',
    ['sell_wood'] = 'Verkoop hout',
    ['hevpark'] = 'Parking',
}

-- Koeien job
Config.Koeien = {
    vector3(2264.403, 4894.549, 40.894),
    vector3(2256.824, 4903.487, 40.877),
    vector3(2249.381, 4910.914, 40.729),
    vector3(2240.950, 4919.405, 40.772),
    vector3(2233.205, 4926.877, 40.830),
    vector3(2225.209, 4936.901, 40.934),
    vector3(2203.448, 4915.189, 40.609),
    vector3(2212.525, 4905.927, 40.786),
    vector3(2219.000, 4898.711, 40.750),
    vector3(2227.893, 4890.349, 40.702),
    vector3(2235.881, 4882.518, 40.928),
    vector3(2245.104, 4873.593, 40.849),
    vector3(2242.649, 4850.552, 40.745),
    vector3(2248.541, 4842.787, 40.657),
    vector3(2256.164, 4835.662, 40.657),
}


Config.Tanque = {
    vector3(2268.90, 4877.26, 40.91)
}


Config.Venta = {
    vector3(2415.6, 4992.8, 46.2)
}

-- Vissen

Config.MarkerData = {
    ["type"] = 6,
    ["size"] = vector3(2.0, 2.0, 2.0),
    ["color"] = vector3(0, 255, 150)
}

Config.FishingRestaurant = {
    ["name"] = "La Spada Fish Restaurant",
    ["blip"] = {
        ["sprite"] = 628,
        ["color"] = 3
    },
    ["ped"] = {
        ["model"] = 0xED0CE4C6,
        ["position"] = vector3(-1038.4545898438, -1397.0551757813, 5.553192615509),
        ["heading"] = 75.0
    }
}

Config.FishingItems = {
    ["rod"] = {
        ["name"] = "fishrod",
        ["label"] = "Vishengel"
    },
    ["bait"] = {
        ["name"] = "fishbait",
        ["label"] = "Vis aas"
    },
    ["fish-1"] = {
        ["price"] = 3 
    },
    ["fish-2"] = {
        ["price"] = 4
    },
    ["fish-3"] = {
        ["price"] = 5
    },
    ["special-fish"] = {
        ["price"] = 8
    },
    ["fish-dolphine"] = {
        ["price"] = 10
    },
    ["fish-box"] = {
        ["price"] = 28
    },
}

Config.FishingZones = {
    {
        ["name"] = "Beach Fishing",
        ["coords"] = vector3(-1948.1279296875, -749.79125976563, 2.5400819778442),
        ["radius"] = 50.0,
    },
    {
        ["name"] = "Sandy Fishing 1",
        ["coords"] = vector3(1311.5769042969, 4228.833984375, 33.915531158447),
        ["radius"] = 50.0,
    },
    {
        ["name"] = "Sandy Fishing 2",
        ["coords"] = vector3(1525.0518798828, 3908.9050292969, 30.799766540527),
        ["radius"] = 50.0,
    },
    {
        ["name"] = "Sandy Fishing 3",
        ["coords"] = vector3(2223.6940917969, 4575.70703125, 31.233570098877),
        ["radius"] = 50.0,
    },
    {
        ["name"] = "Sandy Fishing 4",
        ["coords"] = vector3(31.989250183105, 4294.7797851563, 31.231893539429),
        ["radius"] = 50.0,
    },
    {
        ["name"] = "ocean Fishing 1",
        ["coords"] = vector3(-1835.0385742188, -1820.4168701172, 3.6758048534393),
        ["radius"] = 200.0,
    },
    {
        ["name"] = "ocean Fishing 2",
        ["coords"] = vector3(-722.52124023438, 7188.6108398438, 1.8514842987061),
        ["radius"] = 200.0,
    },
    {
        ["name"] = "ocean Fishing 3",
        ["coords"] = vector3(3469.1770019531, 1271.2962646484, 1.366447687149),
        ["radius"] = 200.0,
    },
    {
        ["name"] = "ocean Fishing 4",
        ["coords"] = vector3(-3277.4191894531, 2613.3405761719, 1.6248697042465),
        ["radius"] = 200.0,
    },
    {
        ["name"] = "special0",
        ["coords"] = vector3(7040.34, 8172.63, 204.435),
        ["radius"] = 500.0,
        ["secret"] = true,
    },
    {
        ["name"] = "special1",
        ["coords"] = vector3(3194.11121337885, 906.8347851562501, 442.03224151611005),
        ["radius"] = 10.0,
        ["secret"] = true,
    },
    {
        ["name"] = "special2",
        ["coords"] = vector3(-3081.5139697266004, 4007.4116894532, 201.00122415304185),
        ["radius"] = 10.0,
        ["secret"] = true,
    },
    {
        ["name"] = "special3",
        ["coords"] = vector3(-2523.3720629883, 7160.87897460945, 200.27662748873234),
        ["radius"] = 10.0,
        ["secret"] = true,
    },
    {
        ["name"] = "special4",
        ["coords"] = vector3(250.32162254333554, 1483.387672119135, 496.65704315185496),
        ["radius"] = 10.0,
        ["secret"] = true,
    }
}

Config.SellItems = {
    ['fish-1'] = {
      ['Type'] = 'money',
      ['Amount'] = math.random(50, 75),
    },
    ['fish-2'] = {
      ['Type'] = 'money',
      ['Amount'] = math.random(75, 95),
    },
    ['fish-3'] = {
      ['Type'] = 'money',
      ['Amount'] = math.random(95, 115),
    },
    ['plasticbag'] = {
      ['Type'] = 'item',
      ['Item'] = 'plastic',
      ['Amount'] = math.random(13, 21),
    },
    ['shoe'] = {
      ['Type'] = 'item',
      ['Item'] = 'recycle-mats',
      ['Amount'] = math.random(7, 13),
    },
   }
   
Config.PremiumItems = {
    --'snspistol_part_2',
    'goldbar',
    'sandwich',
    'water_bottle',
}
      
Config.NormalItems = {
    --'snspistol_part_3',
    'rolex',
    'sandwich',
    'water_bottle',
}

-- Scrap etc

Config.ScrapyardLocations = {
    [1] = {['Name'] = 'Yellow Jack', ['X'] = 2352.27, ['Y'] = 3133.19, ['Z'] = 48.20},
   -- [2] = {['Name'] = 'Secret Location', ['X'] = 2352.27, ['Y'] = 3133.19, ['Z'] = 48.20}
}

Config.Dumpsters = {
    [1] = {['Model'] = 666561306,    ['Name'] = 'Blauwe Bak'},
    [2] = {['Model'] = 218085040,    ['Name'] = 'Licht Blauwe Bak'},
    [3] = {['Model'] = -58485588,    ['Name'] = 'Grijze Bak'},
    [4] = {['Model'] = 682791951,    ['Name'] = 'Grote Blauwe Bak'},
    [5] = {['Model'] = -206690185,   ['Name'] = 'Grote Groene Bak'},
    [6] = {['Model'] = 364445978,    ['Name'] = 'Grote Groene Bak'},
    [7] = {['Model'] = 143369,       ['Name'] = 'Kleine Bak'},
    [8] = {['Model'] = -2140438327,  ['Name'] = 'Unknow Bak'},
    [9] = {['Model'] = -1851120826,  ['Name'] = 'Unknow Bak'},
    [10] = {['Model'] = -1543452585, ['Name'] = 'Unknow Bak'},
    [11] = {['Model'] = -1207701511, ['Name'] = 'Unknow Bak'},
    [12] = {['Model'] = -918089089,  ['Name'] = 'Unknow Bak'},
    [13] = {['Model'] = 1511880420,  ['Name'] = 'Unknow Bak'},
    [14] = {['Model'] = 1329570871,  ['Name'] = 'Unknow Bak'},
  }
  
  Config.BinItems = {
   'plastic',  
   'metalscrap',  
   'copper', 
   'aluminum',
   'iron',
   'steel',
   'rubber',
   'glass',
  }
  
  Config.CarItems = {
    'plastic',  
    'metalscrap',  
    'copper', 
    'aluminum',
    'iron',
    'steel',
    'rubber',
    'glass',
  }
  
  Config.RecycleProps = {
   'prop_boxpile_05a',
   'prop_boxpile_06b',
   'prop_boxpile_02b',
   'prop_boxpile_09a',
   'prop_boxpile_08a',
  }
  
  Config.Recycle = {
      ['Outside'] = vector3(-322.24, -1545.86, 31.01),
      ['Inside'] = vector3(992.35, -3097.83, -38.99),
      ['Deliver'] = vector3(997.61, -3091.91, -38.99),
      ['Props'] = {
          [1] = {
              ['Prop'] = 'prop_toolchest_05',
              ['Coords'] = vector3(996.64, -3099.46, -38.99),
              ['Heading'] = 88.97,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = false,
          },
          [2] = {
              ['Prop'] = 'v_ind_meatwash',
              ['Coords'] = vector3(995.09, -3100.01, -39.45),
              ['Heading'] = 269.77,
              ['FixGround'] = false,
              ['Visible'] = false,
              ['IsBox'] = false,
          },
          [3] = {
              ['Coords'] = vector3(1026.73, -3096.39, -38.99), -- Begaande
              ['Heading'] = 268.64,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [4] = {
              ['Coords'] = vector3(1026.55, -3093.98, -38.99), -- Begaande
              ['Heading'] = 271.68,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [5] = {
              ['Coords'] = vector3(1026.56, -3091.65, -38.99), -- Begaande
              ['Heading'] = 267.11,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [6] = {
              ['Coords'] = vector3(1018.07, -3091.46, -38.99), -- Begaande
              ['Heading'] = 90.68,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [7] = {
              ['Coords'] = vector3(1015.80, -3091.54, -38.99), -- Begaande
              ['Heading'] = 90.68,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [8] = {
              ['Coords'] = vector3(1013.41, -3091.54, -38.99), -- Begaande
              ['Heading'] = 90.68,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [9] = {
              ['Coords'] = vector3(1010.86, -3091.59, -38.99), -- Begaande
              ['Heading'] = 90.68,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [10] = {
              ['Coords'] = vector3(1008.54, -3091.57, -38.99), -- Begaande
              ['Heading'] = 90.68,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [11] = {
              ['Coords'] = vector3(1006.09, -3091.62, -38.99), -- Begaande
              ['Heading'] = 90.68,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [12] = {
              ['Coords'] = vector3(1003.64, -3091.62, -38.99), -- Begaande
              ['Heading'] = 90.68,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [13] = {
              ['Coords'] = vector3(1003.70, -3096.96, -38.99), -- Begaande
              ['Heading'] = 354.04,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [14] = {
              ['Coords'] = vector3(1006.10, -3097.20, -38.99), -- Begaande
              ['Heading'] = 354.04,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [15] = {
              ['Coords'] = vector3(1008.49, -3097.17, -38.99), -- Begaande
              ['Heading'] = 354.04,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [16] = {
              ['Coords'] = vector3(1011.00, -3096.95, -38.99), -- Begaande
              ['Heading'] = 354.04,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [17] = {
              ['Coords'] = vector3(1013.37, -3097.01, -38.99), -- Begaande
              ['Heading'] = 354.04,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [18] = {
              ['Coords'] = vector3(1015.71, -3096.91, -38.99), -- Begaande
              ['Heading'] = 354.04,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [19] = {
              ['Coords'] = vector3(1018.05, -3097.07, -38.99), -- Begaande
              ['Heading'] = 354.04,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [20] = {
              ['Coords'] = vector3(1026.77, -3106.49, -38.99), -- Begaande
              ['Heading'] = 268.64,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [21] = {
              ['Coords'] = vector3(1026.85, -3109.09, -38.99), -- Begaande
              ['Heading'] = 268.64,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [22] = {
              ['Coords'] = vector3(1026.73, -3111.37, -38.99), -- Begaande
              ['Heading'] = 268.64,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [23] = {
              ['Coords'] = vector3(1015.72, -3103.12, -38.99), -- Begaande
              ['Heading'] = 354.04,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [24] = {
              ['Coords'] = vector3(1013.39, -3102.85, -38.99), -- Begaande
              ['Heading'] = 354.04,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [25] = {
              ['Coords'] = vector3(1010.89, -3103.10, -38.99), -- Begaande
              ['Heading'] = 354.04,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [26] = {
              ['Coords'] = vector3(1008.51, -3102.85, -38.99), -- Begaande
              ['Heading'] = 354.04,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [27] = {
              ['Coords'] = vector3(1005.89, -3102.80, -38.99), -- Begaande
              ['Heading'] = 354.04,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [28] = {
              ['Coords'] = vector3(1003.71, -3102.89, -38.99), -- Begaande
              ['Heading'] = 354.04,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [29] = {
              ['Coords'] = vector3(993.17, -3106.48, -38.99), -- Begaande
              ['Heading'] = 268.64,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [30] = {
              ['Coords'] = vector3(993.22, -3108.88, -38.99), -- Begaande
              ['Heading'] = 268.64,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [31] = {
              ['Coords'] = vector3(993.30, -3111.29, -38.99), -- Begaande
              ['Heading'] = 268.64,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
  
          [32] = {
              ['Coords'] = vector3(1018.08, -3102.62, -38.99), -- Begaande
              ['Heading'] = 357.01,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [33] = {
              ['Coords'] = vector3(1018.22, -3108.46, -38.99), -- Begaande
              ['Heading'] = 357.01,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [34] = {
              ['Coords'] = vector3(1015.78, -3108.64, -38.99), -- Begaande
              ['Heading'] = 357.01,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [35] = {
              ['Coords'] = vector3(1013.28, -3108.43, -38.99), -- Begaande
              ['Heading'] = 357.01,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [36] = {
              ['Coords'] = vector3(1010.99, -3108.61, -38.99), -- Begaande
              ['Heading'] = 357.01,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [37] = {
              ['Coords'] = vector3(1008.59, -3108.45, -38.99), -- Begaande
              ['Heading'] = 357.01,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [38] = {
              ['Coords'] = vector3(1006.10, -3108.68, -38.99), -- Begaande
              ['Heading'] = 357.01,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
          [39] = {
              ['Coords'] = vector3(1003.72, -3108.43, -38.99), -- Begaande
              ['Heading'] = 357.01,
              ['FixGround'] = true,
              ['Visible'] = true,
              ['IsBox'] = true,
          },
      },
  }
  
  Config.RecycleCrafting = {
      [1] = {
          ['Label'] = 'Metaal Schroot',
          ['ItemName'] = 'metalscrap',
          ['Slot'] = 1,
          ['Amount'] = 100,
          ['Info'] = '',
          ['Weight'] = 1000,
          ['Image'] = 'metalscrap.png',
          ['AddingPoints'] = 0,
          ['PointsNeeded'] = 0,
          ['Cost'] = {
              [1] = {
                  ['Label'] = 'Recycle Materiaal',
                  ['ItemName'] = 'recycle-mats',
                  ['Image'] = 'recycle-mats.png',
                  ['Amount'] = 1,
              },
          },
      },
      [2] = {
          ['Label'] = 'Staal',
          ['ItemName'] = 'steel',
          ['Slot'] = 2,
          ['Amount'] = 100,
          ['Info'] = '',
          ['Weight'] = 100,
          ['Image'] = 'steel.png',
          ['AddingPoints'] = 0,
          ['PointsNeeded'] = 0,
          ['Cost'] = {
              [1] = {
                  ['Label'] = 'Recycle Materiaal',
                  ['ItemName'] = 'recycle-mats',
                  ['Image'] = 'recycle-mats.png',
                  ['Amount'] = 1,
              },
          },
      },
      [3] = {
          ['Label'] = 'Koper',
          ['ItemName'] = 'copper',
          ['Slot'] = 3,
          ['Amount'] = 100,
          ['Info'] = '',
          ['Weight'] = 100,
          ['Image'] = 'copper.png',
          ['AddingPoints'] = 0,
          ['PointsNeeded'] = 0,
          ['Cost'] = {
              [1] = {
                  ['Label'] = 'Recycle Materiaal',
                  ['ItemName'] = 'recycle-mats',
                  ['Image'] = 'recycle-mats.png',
                  ['Amount'] = 1,
              },
          },
      },
      [4] = {
          ['Label'] = 'Ijzer',
          ['ItemName'] = 'iron',
          ['Slot'] = 4,
          ['Amount'] = 100,
          ['Info'] = '',
          ['Weight'] = 100,
          ['Image'] = 'ironplate.png',
          ['AddingPoints'] = 0,
          ['PointsNeeded'] = 0,
          ['Cost'] = {
              [1] = {
                  ['Label'] = 'Recycle Materiaal',
                  ['ItemName'] = 'recycle-mats',
                  ['Image'] = 'recycle-mats.png',
                  ['Amount'] = 1,
              },
          },
      },
      [5] = {
          ['Label'] = 'Aluminium',
          ['ItemName'] = 'aluminum',
          ['Slot'] = 5,
          ['Amount'] = 100,
          ['Info'] = '',
          ['Weight'] = 100,
          ['Image'] = 'aluminum.png',
          ['AddingPoints'] = 0,
          ['PointsNeeded'] = 0,
          ['Cost'] = {
              [1] = {
                  ['Label'] = 'Recycle Materiaal',
                  ['ItemName'] = 'recycle-mats',
                  ['Image'] = 'recycle-mats.png',
                  ['Amount'] = 1,
              },
          },
      },
      [6] = {
          ['Label'] = 'Plastic',
          ['ItemName'] = 'plastic',
          ['Slot'] = 6,
          ['Amount'] = 100,
          ['Info'] = '',
          ['Weight'] = 100,
          ['Image'] = 'plastic.png',
          ['AddingPoints'] = 0,
          ['PointsNeeded'] = 0,
          ['Cost'] = {
              [1] = {
                  ['Label'] = 'Recycle Materiaal',
                  ['ItemName'] = 'recycle-mats',
                  ['Image'] = 'recycle-mats.png',
                  ['Amount'] = 1,
              },
          },
      },
      [7] = {
          ['Label'] = 'Glasplaat',
          ['ItemName'] = 'glass',
          ['Slot'] = 7,
          ['Amount'] = 100,
          ['Info'] = '',
          ['Weight'] = 100,
          ['Image'] = 'glassplate.png',
          ['AddingPoints'] = 0,
          ['PointsNeeded'] = 0,
          ['Cost'] = {
              [1] = {
                  ['Label'] = 'Recycle Materiaal',
                  ['ItemName'] = 'recycle-mats',
                  ['Image'] = 'recycle-mats.png',
                  ['Amount'] = 1,
              },
          },
      },
      [8] = {
          ['Label'] = 'Rubber',
          ['ItemName'] = 'rubber',
          ['Slot'] = 8,
          ['Amount'] = 100,
          ['Info'] = '',
          ['Weight'] = 100,
          ['Image'] = 'rubber.png',
          ['AddingPoints'] = 0,
          ['PointsNeeded'] = 0,
          ['Cost'] = {
              [1] = {
                  ['Label'] = 'Recycle Materiaal',
                  ['ItemName'] = 'recycle-mats',
                  ['Image'] = 'recycle-mats.png',
                  ['Amount'] = 1,
              },
          },
      },
  }
-- Tacos

Config.JobStart = {
	{ ["x"] = -1160.196, ["y"] = -1260.968, ["z"] = 6.3267846, ["h"] = 117.41931 },
}

Config.JobStartGreen = {
	{ ["x"] = 11.24, ["y"] = -1605.64, ["z"] = 29.39, ["h"] = 0 },
}

Config.PickUpStuff = {
	{ ["x"] = 12.669981, ["y"] = -1605.582, ["z"] = 29.396999, ["h"] = 0 },
}

Config.PaymentTaco = math.random(100, 140)

Config.JobBusy = false

Config.JobData = {
 ['tacos'] = 0,
 ['register'] = 0,
 ['stock-lettuce'] = 0,
 ['stock-meat'] = 0,
 ['green-tacos'] = 110,
 ['locations'] = {
    [1] = {
	  ['name'] = 'Lettuce', 
	  x = -1160.401,
	  y = -1256.052,
	  z = 6.3267889,
	},
	[2] = {
	  ['name'] = 'Meat', 
	  x = -1160.31,
	  y = -1251.64,
	  z = 6.3267879,
	},
	[3] = { 
	  ['name'] = 'Shell', 
	  x = -1162.02,
	  y = -1253.178,
	  z = 6.3267831,
	},
	[4] = {
		['name'] = 'Register', 
		x = -1165.114,
		y = -1260.139,
		z = 6.4575552,
	  },
	[5] = {
		['name'] = 'GiveTaco',
		x = -1163.113,
		y = -1256.111,
		z = 6.3267874,
	  },
	  [6] = {
		['name'] = 'Stock',  
		x = -1158.481,
		y = -1255.042,
		z = 6.3267874,
	  },
  },
}