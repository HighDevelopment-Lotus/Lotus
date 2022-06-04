fx_version 'cerulean'
game 'gta5'

author 'High Development'

ui_page "html/index.html"

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

exports {
    'IsNearHunting',
    'ReturnTrashVehicle',
    'HasBrevet',
    'GetActiveRegister',
    'IsNearRestaurant',
    'IsInsideBurgershot',
    'IsInsideWeedshop',
    'IsNearScrapYard',
    'InsideRecycle',
}

server_exports {
    'GetRecycleCrafting',
}

files {
    'html/index.html',
    'html/js/script.js',
    'html/css/style.css',
    'html/img/meter.png',
}