-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

-- Requiring essentialmode
dependency 'essentialmode'

-- Emergency
client_scripts {
    "client/cl_healthplayer.lua",
    "client/cl_emergency.lua",
    "client/menu.lua"
}

server_scripts {
    "server/sv_emergency.lua"
}
