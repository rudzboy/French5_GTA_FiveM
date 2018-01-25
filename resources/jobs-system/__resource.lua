resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'ui.html'

files {
    'ui.html',
    'job-icon.png',
    'pricedown.ttf'
}

client_script "client.lua"
client_script "gui.lua"
server_script "server.lua"
