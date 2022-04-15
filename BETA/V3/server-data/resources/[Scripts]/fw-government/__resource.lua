resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    -- 'config.lua',
    -- 'client/client.lua',
    'client/police/client.lua',
    'client/police/cams.lua',
    'client/police/disco.lua',
    'client/police/alerts.lua',
    'client/police/evidence.lua',
    'client/police/vehicles.lua',
    'client/police/functions.lua',
    'client/police/interactions.lua',
    'client/police/zuluCamera.lua',
    -- Ambulance
    'client/ambulance/dead.lua',
    'client/ambulance/wounds.lua',
    'client/ambulance/client.lua',
    'client/ambulance/vehicles.lua',
    -- Pawnshop
    'client/pawnshop/client.lua',
    'client/pawnshop/pawnshop.lua',
    'client/pawnshop/smelting.lua',
    'client/pawnshop/witwas.lua',
    -- Crafting
    'client/crafting/client.lua',
    -- Prison
    'client/prison/mugshot.lua',
    'client/prison/job.lua',
    'client/prison/client.lua',
    -- Cityhall
    'client/cityhall/client.lua',
}

ui_page "html/index.html"

server_scripts {
    -- 'config.lua',
    'server/server.lua',
}

shared_scripts {
    'config.lua',

}

exports {
    'IsNearGarage',
    'IsNearHeli',
    'GetGarageShit',
    'GetDeathStatus',
    'NearCheckin',
    'CanRespawn',
    'GetInJailStatus',
    'InPrisonHouse',
    'NearCityHall',
}

files {
    "html/index.html",
    "html/script.js",
    "html/main.css",
    "html/vcr-ocd.ttf",
}