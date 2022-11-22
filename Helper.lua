getgenv().CB_Manager = {
    ['StandardFolder'] = "CBM-CONFIG",
    ['Client'] = game:GetService("Players").LocalPlayer
}
CB_Manager._index = CB_Manager

function CB_Manager:Configuration(options)
    local config = options or {}
    local s_self = {}
    setmetatable(s_self, CB_Manager)
    s_self.prefix = config['prefix']
    s_self.bot = config['bot']
    s_self.owner = config['owner']
    s_self.admins =  config['admins'] 
    s_self.mods = config['mods']
    s_self.configName = config['config_name']
    s_self.plugins = {}
    s_self.commands = {}

    if not isfolder(CB_Manager['StandardFolder']) then
        makefolder(CB_Manager['StandardFolder'])
    end

    if not isfolder(CB_Manager['StandardFolder'].."/saved_configs") then
        makefolder(CB_Manager['StandardFolder'].."/saved_configs")
            writefile(CB_Manager['StandardFolder'].."/saved_configs/"..s_self.configName..".txt",  game:GetService("HttpService"):JSONEncode(s_self))
    end

    if not isfolder(CB_Manager['StandardFolder'].."/saved_admins") then
        makefolder(CB_Manager['StandardFolder'].."/saved_admins")
        for i,v in ipairs(s_self.admins) do
            writefile(CB_Manager['StandardFolder'].."/saved_admins/"..v..".txt", "This player is a admin.")
        end
    end

    if not isfolder(CB_Manager['StandardFolder'].."/saved_mods") then
        makefolder(CB_Manager['StandardFolder'].."/saved_mods")
        for i,v in ipairs(s_self.mods) do
            writefile(CB_Manager['StandardFolder'].."/saved_mods/"..v..".txt", "This player is a mod.")
        end
    end

    if not isfolder(CB_Manager['StandardFolder'].."/saved_owner") then
        makefolder(CB_Manager['StandardFolder'].."/saved_owner")
        for i,v in ipairs(s_self.owner) do
            writefile(CB_Manager['StandardFolder'].."/saved_owner/"..v..".txt", "This player is the owner.")
        end
    end

    return s_self
end

function CB_Manager:loadPlugin(plugin)
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    local url = ""
end



return getgenv().CB_Manager


