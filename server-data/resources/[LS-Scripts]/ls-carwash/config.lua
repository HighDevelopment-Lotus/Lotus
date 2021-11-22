Config = Config or {}

Config.Keys = {['G'] = 47}

Config.CarWashLocations = {
 [1] = {
   ['Price'] = 50,
   ['Busy'] = false,
   ['Wait'] = 11500,
   ['Particle'] = 'CoPietjes',
   ['Coords'] = {
       ['Marker'] = {
        ['X'] = 47.27041,
        ['Y'] = -1391.78,
        ['Z'] = 29.40707,
       },
       ['GoTo'] = {
        ['X'] = -3.804,
        ['Y'] = -1391.698,
        ['Z'] = 28.302, 
       },
   },
 },
--  [2] = {
--     ['Cost'] = 50,
--     ['Coords'] = {
--         ['X'] = 1,
--         ['Y'] = 1,
--         ['Z'] = 1,
--         ['H'] = 1,
--     },
--   },
--   [3] = {
--     ['Cost'] = 50,
--     ['Coords'] = {
--         ['X'] = 1,
--         ['Y'] = 1,
--         ['Z'] = 1,
--         ['H'] = 1,
--     },
--   },
}

Config.Particles = {
  ['CoPietjes'] = {
    [1] = {['X'] = 37.440, ['Y'] = -1390.143, ['Z'] = 29.500, ['particle'] = 'ent_amb_car_wash_jet', ['rotation'] = 90.0},
    [2] = {['X'] = 37.440, ['Y'] = -1390.143, ['Z'] = 30.500, ['particle'] = 'ent_amb_car_wash_jet', ['rotation'] = 90.0},
    [3] = {['X'] = 37.430, ['Y'] = -1393.497, ['Z'] = 29.500, ['particle'] = 'ent_amb_car_wash_jet', ['rotation'] = -90.0},
    [4] = {['X'] = 37.430, ['Y'] = -1393.497, ['Z'] = 30.500, ['particle'] = 'ent_amb_car_wash_jet', ['rotation'] = -90.0},
    [5] = {['X'] = 14.305, ['Y'] = -1390.107, ['Z'] = 29.500, ['particle'] = 'ent_amb_car_wash_jet', ['rotation'] = 90.0},
    [6] = {['X'] = 14.305, ['Y'] = -1390.107, ['Z'] = 30.500, ['particle'] = 'ent_amb_car_wash_jet', ['rotation'] = 90.0},
    [7] = {['X'] = 14.213, ['Y'] = -1393.546, ['Z'] = 29.500, ['particle'] = 'ent_amb_car_wash_jet', ['rotation'] = -90.0},
    [8] = {['X'] = 14.213, ['Y'] = -1393.546, ['Z'] = 30.500, ['particle'] = 'ent_amb_car_wash_jet', ['rotation'] = -90.0},
  },
}