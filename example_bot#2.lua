local CB_Manager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Zirmith/CB-Manager/main/client.lua"))() -- This is a loadstring silly .,.

local config = CB_Manager:Configuration({
    ['prefix'] = "?",
    ['bot'] = "Server",
    ['owner'] = "Your_User",
    ['admins'] = {"User","Names","Here"},
    ['mods'] = {"User","Names","Here"},
    ['config_name'] = "Save#1",
    ['plugins'] = {'gethealth','example'}
}) -- This is the bot config, that will be used / saved



local client = CB_Manager:init(config) -- this is to create the bot

local plugin = client:getPlugin('getchat')  --Example to get the chat plugin, only use this once per get

client:usePlugin(plugin, 'Hello', 'All')  -- Send a message using it
