local CB_MANAGER = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Zirmith/CB-Manager/main/create.lua"))()

local config = CB_MANAGER:Configuration({
    ['prefix'] = "?",
    ['bot'] = "Server",
    ['owner'] = "Your_User",
    ['admins'] = {"User","Names","Here"},
    ['mods'] = {"User","Names","Here"},
    ['config_name'] = "Save#1"
})

CB_MANAGER:downloadPlugin('example') -- This is used to download plugins

CB_MANAGER:runPlugin('example', {
  ['args1'] = "Hello",
  ['args2'] = "World"
}) -- This is used to run bot plugins downloaded
