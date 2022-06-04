fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Gabz'
description 'Impound Lot'
version '5.0.0s'

this_is_a_map 'yes'

dependencies {
    '/server:4960',
    '/gameBuild:2189'
}

escrow_ignore {
    'stream/**/*.ytd',
    'impound.lua',
}

data_file 'TIMECYCLEMOD_FILE' 'gabz_impound_timecycle.xml'

files {
	'gabz_impound_timecycle.xml',
}

dependency '/assetpacks'