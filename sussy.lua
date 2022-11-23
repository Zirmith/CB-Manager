local CB_Manager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Zirmith/CB-Manager/main/client.lua"))() -- This is a loadstring silly .,.

local config = CB_Manager:Configuration({
    ['prefix'] = "?",
    ['bot'] = "Server",
    ['owner'] = "Your_User",
    ['admins'] = {"User","Names","Here"},
    ['mods'] = {"User","Names","Here"},
    ['config_name'] = "Save#1"
}) -- This is the bot config, that will be used / saved



local client = CB_Manager:init(config) -- this is to create the bot

local plugin = client:getPlugin('owoifyv3')  --Example to get the chat plugin, only use this once per get

CB_Manager['Client'].Chatted:Connect(function(msg)
 if msg:sub(1,3) == "/e " then
     client:usePlugin('owoifyv3', msg, 'All')
 end  -- Send a message using it
end)

