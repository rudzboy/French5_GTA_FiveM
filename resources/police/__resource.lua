-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

-- Requiring essentialmode
dependency 'essentialmode'

-- General
client_scripts {
    'client.lua',
    'vestpolice.lua',
    'menupolice.lua',
    'policeveh.lua',
    'policearmory.lua'
}

server_scripts {
    'server.lua'
}

export 'getIsInService'
