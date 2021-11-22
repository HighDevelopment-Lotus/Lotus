Config = Config or {}

Config.GamesData = {}

Config.Dealers = {
    [1] = {
        ['Started'] = false,
        ['TableBet'] = 250,
        ['TableTimer'] = 20,
        ['GameId'] = math.random(111,9999),
        ['TableCoords'] = vector3(1151.75, 266.80, -51.84),
        ['PedCoords'] = vector4(1151.25, 267.31, -51.84, 221.90),
        ['TableProp'] = 'vw_prop_casino_blckjack_01',
        ['PedModel'] = 's_m_y_casino_01',
        ['PedId'] = nil,
        ['Chairs'] = {
            [1] = {['Coords'] = {['Sit'] = vector3(1152.57, 267.53, -51.84), ['Heading'] = 200.0}, ['Player'] = nil, ['Id'] = 'Table-1-1', ['Busy'] = false, ['Animation'] = 'sit_enter_right'},
            [2] = {['Coords'] = {['Sit'] = vector3(1152.56, 266.64, -51.84), ['Heading'] = 155.0}, ['Player'] = nil, ['Id'] = 'Table-1-2', ['Busy'] = false, ['Animation'] = 'sit_enter_right'},
            [3] = {['Coords'] = {['Sit'] = vector3(1151.94, 266.02, -51.84), ['Heading'] = 106.0}, ['Player'] = nil, ['Id'] = 'Table-1-3', ['Busy'] = false, ['Animation'] = 'sit_enter_left'},
            [4] = {['Coords'] = {['Sit'] = vector3(1151.00, 266.00, -51.84), ['Heading'] = 58.0},  ['Player'] = nil, ['Id'] = 'Table-1-4', ['Busy'] = false, ['Animation'] = 'sit_enter_left'},
        }
    },
    
    [2] = {
        ['Started'] = false,
        ['TableBet'] = 500,
        ['TableTimer'] = 20,
        ['GameId'] = math.random(111,9999),
        ['TableCoords'] = vector3(1148.97, 269.62, -51.84),
        ['PedCoords'] = vector4(1149.40, 269.17, -51.84, 46.24),
        ['TableProp'] = 'vw_prop_casino_blckjack_01',
        ['PedModel'] = 's_m_y_casino_01',
        ['PedId'] = nil,
        ['Chairs'] = {
            [1] = {['Coords'] = {['Sit'] = vector3(1148.07, 268.94, -51.84), ['Heading'] = 20.0},  ['Player'] = nil, ['Id'] = 'Table-2-1', ['Busy'] = false, ['Animation'] = 'sit_enter_right'},
            [2] = {['Coords'] = {['Sit'] = vector3(1148.09, 269.85, -51.84), ['Heading'] = 335.0}, ['Player'] = nil, ['Id'] = 'Table-2-2', ['Busy'] = false, ['Animation'] = 'sit_enter_right'},
            [3] = {['Coords'] = {['Sit'] = vector3(1148.70, 270.52, -51.84), ['Heading'] = 290.0}, ['Player'] = nil, ['Id'] = 'Table-2-3', ['Busy'] = false, ['Animation'] = 'sit_enter_left'},
            [4] = {['Coords'] = {['Sit'] = vector3(1149.67, 270.53, -51.84), ['Heading'] = 240.0}, ['Player'] = nil, ['Id'] = 'Table-2-4', ['Busy'] = false, ['Animation'] = 'sit_enter_left'},
        }
    },
}

Config.Cards = {
    [1] = {['Model'] = 'vw_prop_vw_club_char_a_a',  ['Type'] = 'Ace',   ['Value'] = 11, ['Soft'] = 1},
    [2] = {['Model'] = 'vw_prop_vw_club_char_02a',  ['Type'] = 'Two',   ['Value'] = 2},
    [3] = {['Model'] = 'vw_prop_vw_club_char_03a',  ['Type'] = 'Three', ['Value'] = 3},
    [4] = {['Model'] = 'vw_prop_vw_club_char_04a',  ['Type'] = 'Four',  ['Value'] = 4},
    [5] = {['Model'] = 'vw_prop_vw_club_char_05a',  ['Type'] = 'Five',  ['Value'] = 5},
    [6] = {['Model'] = 'vw_prop_vw_club_char_06a',  ['Type'] = 'Six',   ['Value'] = 6},
    [7] = {['Model'] = 'vw_prop_vw_club_char_07a',  ['Type'] = 'Seven', ['Value'] = 7},
    [8] = {['Model'] = 'vw_prop_vw_club_char_08a',  ['Type'] = 'Eight', ['Value'] = 8},
    [9] = {['Model'] = 'vw_prop_vw_club_char_09a',  ['Type'] = 'Nine',  ['Value'] = 9},
    [10] = {['Model'] = 'vw_prop_vw_club_char_10a', ['Type'] = 'Ten',   ['Value'] = 10},
    [11] = {['Model'] = 'vw_prop_vw_club_char_j_a', ['Type'] = 'Jacks', ['Value'] = 10},
    [12] = {['Model'] = 'vw_prop_vw_club_char_k_a', ['Type'] = 'King',  ['Value'] = 10},
    [13] = {['Model'] = 'vw_prop_vw_club_char_q_a', ['Type'] = 'Queen', ['Value'] = 10},

    [14] = {['Model'] = 'vw_prop_vw_dia_char_a_a',  ['Type'] = 'Ace',   ['Value'] = 11, ['Soft'] = 1},
    [15] = {['Model'] = 'vw_prop_vw_dia_char_02a',  ['Type'] = 'Two',   ['Value'] = 2},
    [16] = {['Model'] = 'vw_prop_vw_dia_char_03a',  ['Type'] = 'Three', ['Value'] = 3},
    [17] = {['Model'] = 'vw_prop_vw_dia_char_04a',  ['Type'] = 'Four',  ['Value'] = 4},
    [18] = {['Model'] = 'vw_prop_vw_dia_char_05a',  ['Type'] = 'Five',  ['Value'] = 5},
    [19] = {['Model'] = 'vw_prop_vw_dia_char_06a',  ['Type'] = 'Six',   ['Value'] = 6},
    [20] = {['Model'] = 'vw_prop_vw_dia_char_07a',  ['Type'] = 'Seven', ['Value'] = 7},
    [21] = {['Model'] = 'vw_prop_vw_dia_char_08a',  ['Type'] = 'Eight', ['Value'] = 8},
    [22] = {['Model'] = 'vw_prop_vw_dia_char_09a',  ['Type'] = 'Nine',  ['Value'] = 9},
    [23] = {['Model'] = 'vw_prop_vw_dia_char_10a',  ['Type'] = 'Ten',   ['Value'] = 10},
    [24] = {['Model'] = 'vw_prop_vw_dia_char_j_a',  ['Type'] = 'Jacks', ['Value'] = 10},
    [25] = {['Model'] = 'vw_prop_vw_dia_char_k_a',  ['Type'] = 'King',  ['Value'] = 10},
    [26] = {['Model'] = 'vw_prop_vw_dia_char_q_a',  ['Type'] = 'Queen', ['Value'] = 10},

    [27] = {['Model'] = 'vw_prop_vw_hrt_char_a_a',  ['Type'] = 'Ace',   ['Value'] = 11, ['Soft'] = 1},
    [28] = {['Model'] = 'vw_prop_vw_hrt_char_02a',  ['Type'] = 'Two',   ['Value'] = 2},
    [29] = {['Model'] = 'vw_prop_vw_hrt_char_03a',  ['Type'] = 'Three', ['Value'] = 3},
    [30] = {['Model'] = 'vw_prop_vw_hrt_char_04a',  ['Type'] = 'Four',  ['Value'] = 4},
    [31] = {['Model'] = 'vw_prop_vw_hrt_char_05a',  ['Type'] = 'Five',  ['Value'] = 5},
    [32] = {['Model'] = 'vw_prop_vw_hrt_char_06a',  ['Type'] = 'Six',   ['Value'] = 6},
    [33] = {['Model'] = 'vw_prop_vw_hrt_char_07a',  ['Type'] = 'Seven', ['Value'] = 7},
    [34] = {['Model'] = 'vw_prop_vw_hrt_char_08a',  ['Type'] = 'Eight', ['Value'] = 8},
    [35] = {['Model'] = 'vw_prop_vw_hrt_char_09a',  ['Type'] = 'Nine',  ['Value'] = 9},
    [36] = {['Model'] = 'vw_prop_vw_hrt_char_10a',  ['Type'] = 'Ten',   ['Value'] = 10},
    [37] = {['Model'] = 'vw_prop_vw_hrt_char_j_a',  ['Type'] = 'Jacks', ['Value'] = 10},
    [38] = {['Model'] = 'vw_prop_vw_hrt_char_k_a',  ['Type'] = 'King',  ['Value'] = 10},
    [39] = {['Model'] = 'vw_prop_vw_hrt_char_q_a',  ['Type'] = 'Queen', ['Value'] = 10},

    [40] = {['Model'] = 'vw_prop_vw_spd_char_a_a',  ['Type'] = 'Ace',   ['Value'] = 11, ['Soft'] = 1},
    [41] = {['Model'] = 'vw_prop_vw_spd_char_02a',  ['Type'] = 'Two',   ['Value'] = 2},
    [42] = {['Model'] = 'vw_prop_vw_spd_char_03a',  ['Type'] = 'Three', ['Value'] = 3},
    [43] = {['Model'] = 'vw_prop_vw_spd_char_04a',  ['Type'] = 'Four',  ['Value'] = 4},
    [44] = {['Model'] = 'vw_prop_vw_spd_char_05a',  ['Type'] = 'Five',  ['Value'] = 5},
    [45] = {['Model'] = 'vw_prop_vw_spd_char_06a',  ['Type'] = 'Six',   ['Value'] = 6},
    [46] = {['Model'] = 'vw_prop_vw_spd_char_07a',  ['Type'] = 'Seven', ['Value'] = 7},
    [47] = {['Model'] = 'vw_prop_vw_spd_char_08a',  ['Type'] = 'Eight', ['Value'] = 8},
    [48] = {['Model'] = 'vw_prop_vw_spd_char_09a',  ['Type'] = 'Nine',  ['Value'] = 9},
    [49] = {['Model'] = 'vw_prop_vw_spd_char_10a',  ['Type'] = 'Ten',   ['Value'] = 10},
    [50] = {['Model'] = 'vw_prop_vw_spd_char_j_a',  ['Type'] = 'Jacks', ['Value'] = 10},
    [51] = {['Model'] = 'vw_prop_vw_spd_char_k_a',  ['Type'] = 'King',  ['Value'] = 10},
    [52] = {['Model'] = 'vw_prop_vw_spd_char_q_a',  ['Type'] = 'Queen', ['Value'] = 10},
}