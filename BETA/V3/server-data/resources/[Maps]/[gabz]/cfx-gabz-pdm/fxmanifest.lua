fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Gabz'
description 'PDM'
version '5.0.0s'

this_is_a_map 'yes'

dependencies {
    '/server:4960',
    '/gameBuild:2189'
}

escrow_ignore {
    'stream/**/*.ytd',
    'stream/ydr/gabz_pdm_flag1.yft',
    'stream/ydr/gabz_pdm_flag2.yft',
    'pdm.lua',
}

data_file 'TIMECYCLEMOD_FILE' 'gabz_pdm_timecycle.xml'

files {
	'gabz_pdm_timecycle.xml',
}

dependency '/assetpacks'