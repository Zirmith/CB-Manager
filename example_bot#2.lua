local CB_Manager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Zirmith/CB-Manager/main/core.lua"))() -- This is a loadstring silly .,.

local config = CB_Manager:Configuration({
    ['prefix'] = "?",
    ['bot'] = "Server",
    ['owner'] = "Your_User",
    ['admins'] = {"User","Names","Here"},
    ['mods'] = {"User","Names","Here"},
    ['config_name'] = "Save#1"
}) -- This is the bot config, that will be used / saved

local client = CB_Manager:init(config) -- this is to create the bot

local example_plugin = client:getPlugin('example') -- This is used to download plugins

client:usePlugin(example_plugin, {
  ['args1'] = "",
  ['args2'] = ""
}) -- this is if you want to use a plugin , max args are currently [2]
