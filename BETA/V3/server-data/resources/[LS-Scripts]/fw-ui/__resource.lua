resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

ui_page {'html/index.html'}

client_scripts {
    'config.lua',
    -- 'client/eye.lua',
    'client/hud.lua',
    'client/target.lua',
    'client/client.lua',
    'client/blocks.lua',
    -- 'client/compass.lua',
    -- 'client/modes.lua',
    'client/context.lua',
    'client/board.lua',
    'client/binds.lua',
    'client/skilltask.lua',
    'client/functions.lua',
}

server_scripts {
    'config.lua',
    'server/server.lua'
}

exports {
    'HideHud',
    'OpenMenu',
    'ShowInfo',
    'ShowInfoLong',
    'HideInfo',
    'EditInfo',
    'AddNotify',
    'OpenInput',
    'RemoveInfo',
    'SetSeatbelt',
    'ToggleScope',
    -- 'ImportEyeData',
    'ForceStopSkill',
    'StartSkillTest',
    'ShowInteraction',
    'EditInteraction',
    'HideInteraction',
    'DoorInteraction',
    'HideDoorInteraction',
    'EditDoorInteraction',
    'StartBlocksGame',
    'OpenPoliceTablet',
    'OpenPoliceFinger',
    'GetEntityPlayerIsLookingAt',
}

files {
    'html/index.html',
    'html/js/*.js',
    'html/js/lib/*.js',
    'html/css/*.css',
    'html/img/*.png',
    'html/css/fonts/*.otf',
    'html/css/fonts/*.ttf',
}