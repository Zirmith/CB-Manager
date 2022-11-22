local CB_Manager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Zirmith/CB-Manager/main/require.lua"))()

local config = CB_Manager:Configuration({
    ['prefix'] = "?",
    ['bot'] = "Server",
    ['owner'] = "Your_User",
    ['admins'] = {"User","Names","Here"},
    ['mods'] = {"User","Names","Here"},
    ['config_name'] = "Save#1"
})

local client = CB_Manager:init(config) -- This is used to download plugins

local example_plugin = client:getPlugin('example')

client:usePlugin(example_plugin, {
  ['args1'] = "",
  ['args2'] = ""
})

