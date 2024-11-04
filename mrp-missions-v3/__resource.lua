resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'
--resource_manifest_version 'f15e72ec-3972-4fe4-9c7d-afc5394ae207'
--resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
--resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9 (2017-06-04)'

resource_type 'map' { gameTypes = { fivem = true } }

map 'map.lua'

client_script 'basic_client.lua'
client_script 'client.lua'
client_script 'missions.lua'

-- temporary!
ui_page 'html/scoreboard.html'

client_script 'scoreboard.lua'

files {
    'html/scoreboard.html',
    'html/style.css',
    'html/reset.css',
    'html/listener.js',
    'html/res/futurastd-medium.css',
    'html/res/futurastd-medium.eot',
    'html/res/futurastd-medium.woff',
    'html/res/futurastd-medium.ttf',
    'html/res/futurastd-medium.svg',
}

server_script 'server.lua'
server_script 'missions.lua'
