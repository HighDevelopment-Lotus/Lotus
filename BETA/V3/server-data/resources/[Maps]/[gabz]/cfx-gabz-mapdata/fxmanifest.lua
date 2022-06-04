fx_version 'cerulean'
game 'gta5'

author 'Gabz'
description 'Mapdata'
version '5.0.0'

lua54 'yes'

this_is_a_map 'yes'

data_file 'TIMECYCLEMOD_FILE' 'gabz_timecycle_mods1.xml'

files {
    'gabz_timecycle_mods1.xml',
}

client_script {
    'gabz_entityset_mods1.lua',
}

dependencies {
    '/server:4960',
    '/gameBuild:2189'
}

escrow_ignore {
    'gabz-doorlocks/*.lua',
    'gabz_entityset_mods1.lua',
}
dependency '/assetpacks'