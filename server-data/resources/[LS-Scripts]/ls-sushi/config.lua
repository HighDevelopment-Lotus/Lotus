Config = Config or {}

Config.RegisterData = {}

Config.InteriorId = 122626

Config.RestaurantCoords = vector3(-161.78, 293.22, 93.0)

Config.FoodCooker = {
    [1] = {
      ['FoodName'] = 'Sushi Onigiri',
      ['Food'] = 'sushi',
      ['Desc'] = '1x Rijst, 1x Water',
    },
    [2] = {
      ['FoodName'] = 'Ramen',
      ['Food'] = 'sushi-ramen',
      ['Desc'] = '1x Water, 1x Rauw Vlees, 1x Noodles',
    },
    [3] = {
      ['FoodName'] = 'Rund Schotel',
      ['Food'] = 'sushi-beef',
      ['Desc'] = '1x Rauw Vlees, 1x Noodles',
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