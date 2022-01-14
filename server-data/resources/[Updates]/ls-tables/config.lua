Config = Config or {}

Config.Tables = {
    ['Crack'] = {
        ['TableProp'] = 'bkr_prop_coke_table01a',
        ['ItemAfterProcess'] = 'sandwich', -- Item which you'll receive after processing.
        ['ProcessTime'] = math.random(10000, 25000),
    },
    ['Meth'] = {
        ['TableProp'] = 'bkr_prop_meth_table01a',
        ['ItemAfterProcess'] = 'water', -- Item which you'll receive after processing.
        ['ProcessTime'] = math.random(12000, 35000),
    },
    ['Weed'] = {
        ['TableProp'] = 'bkr_prop_weed_table_01a',
        ['ItemAfterProcess'] = 'sandwich', -- Item which you'll receive after processing.
        ['ProcessTime'] = math.random(15000, 20000),
    },
}