local CB_MANAGER = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Zirmith/CB-Manager/main/create.lua"))()

local config = CB_MANAGER:Configuration({
    ['prefix'] = "?",
    ['bot'] = "Server",
    ['owner'] = "Your_User",
    ['admins'] = {"User","Names","Here"},
    ['mods'] = {"User","Names","Here"},
    ['config_name'] = "Save#1"
})

CB_Manager:downloadPlugin('start') -- This is used to download plugins

CB_Manager:runPlugin('start', {
  ['args1'] = "",
  ['args2'] = ""
}) -- This is used to run bot plugins downloaded
