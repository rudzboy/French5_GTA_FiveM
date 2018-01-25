-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'EssentialMode by Kanersps.'

ui_page 'ui.html'

-- NUI Files
files {
    'ui.html',
    'pdown.ttf'
}

-- Server
server_script 'server/classes/player.lua'
server_script 'server/classes/groups.lua'
server_script 'server/player/login.lua'
server_script 'server/main.lua'
server_script 'server/util.lua'

-- Client
client_script 'client/main.lua'
client_script 'client/player.lua'