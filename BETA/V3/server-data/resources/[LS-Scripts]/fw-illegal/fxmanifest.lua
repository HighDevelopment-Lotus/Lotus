fx_version 'cerulean'
game 'gta5'

author 'High Development'
description 'Drugs'
version '3.0.1'

shared_scripts{
    'config.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

ui_page 'ui/index.html'
files {
    'ui/index.html',
    'ui/script.js',
    'ui/style.css',
}
exports {
    'CanDeliverOxyBox',
    'CanStartOxy',
    'NearNpc',
    'IsDealing',
    'NearNpcSell',
    'Talk2Npc',
    'CanRobItems'
}

lua54 'yes'