fx_version 'cerulean'
game 'gta5'

author 'github/dominikvatoo'

description 'Sorgt dafür, dass Team-Mitglieder den "dein"-Tag im Namen tragen müssen, außer sie sind auf der Bypass-Liste.'

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua'
}