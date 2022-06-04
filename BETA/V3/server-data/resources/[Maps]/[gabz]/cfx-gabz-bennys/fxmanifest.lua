fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Gabz'
description 'Bennys'
version '5.0.0s'

this_is_a_map 'yes'

dependencies {
    '/server:4960',
    '/gameBuild:2189'
}

escrow_ignore {
    'stream/**/*.ytd',
    'bennys.lua',
}

data_file 'TIMECYCLEMOD_FILE' 'gabz_bennys_timecycle.xml'

files {
	'gabz_bennys_timecycle.xml',
}

dependency '/assetpacks'