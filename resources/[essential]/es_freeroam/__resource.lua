resource_type 'gametype' { name = 'French5 RP Mode' }

description 'FiveM es_freeroam'

-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

-- Requiring essentialmode
dependency 'essentialmode'

-- General
client_scripts {
    'client.lua',
    -- 'events/smoke.lua',
    'player/map.lua',
    'player/scoreboard.lua',
    'stores/stripclub.lua',
    'stores/vehshop.lua'
}

server_scripts {
    'server.lua',
    'player/commands.lua',
    'stores/vehshop_s.lua',
}
