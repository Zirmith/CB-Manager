
local CB_Manager = {
    ['StandardFolder'] = "CBM-CONFIG",
    ['fileExtension'] = "lua",
    ['Client'] = game:GetService("Players").LocalPlayer
}

CB_Manager._index = CB_Manager



if syn and DrawingImmediate then
    CB_Manager['fileExtension'] = "txt"
end
local fileExLen = #CB_Manager['fileExtension'] + 1

function CB_Manager:Configuration(options)
    local config = options or {}
    local s_self = {}
    setmetatable(s_self, CB_Manager)
    s_self.prefix = config['prefix']
    s_self.bot = config['bot']
    s_self.owner = config['owner']
    s_self.admins = config['admins']
    s_self.mods = config['mods']
    s_self.configName = config['config_name']
    s_self.plugins = {}
    s_self.commands = {}

    if not isfolder(CB_Manager['StandardFolder']) then
        makefolder(CB_Manager['StandardFolder'])
    end

    if not isfolder(CB_Manager['StandardFolder'] .. "/saved_configs") then
        makefolder(CB_Manager['StandardFolder'] .. "/saved_configs")
        writefile(CB_Manager['StandardFolder'] .. "/saved_configs/" .. s_self.configName .. ".txt",
            game:GetService("HttpService"):JSONEncode(s_self))
    else
        if isfolder(CB_Manager['StandardFolder'] .. "/saved_configs") then
            writefile(CB_Manager['StandardFolder'] .. "/saved_configs/" .. s_self.configName .. ".txt",
                game:GetService("HttpService"):JSONEncode(s_self))
        end
    end

    if not isfolder(CB_Manager['StandardFolder'] .. "/saved_admins") then
        makefolder(CB_Manager['StandardFolder'] .. "/saved_admins")
        for i, v in pairs(s_self.admins) do
            writefile(CB_Manager['StandardFolder'] .. "/saved_admins/" .. v .. ".txt", "This player is a admin.")
        end
    end

    if not isfolder(CB_Manager['StandardFolder'] .. "/saved_mods") then
        makefolder(CB_Manager['StandardFolder'] .. "/saved_mods")
        for i, v in pairs(s_self.mods) do
            writefile(CB_Manager['StandardFolder'] .. "/saved_mods/" .. v .. ".txt", "This player is a mod.")
        end
    end

    if not isfolder(CB_Manager['StandardFolder'] .. "/saved_owner") then
        makefolder(CB_Manager['StandardFolder'] .. "/saved_owner")
        writefile(CB_Manager['StandardFolder'] .. "/saved_owner/" .. s_self.owner .. ".txt", "This player is the owner.")
    end
    warn('Saved Config')
    warn('Check on file: ' .. CB_Manager['StandardFolder'])
    return s_self
end

function CB_Manager:requestGET(url)
    local rhttp = game:GetService('HttpService')
    local req = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or
                    getgenv().request or request
    if req then
        local response = req({
            Url = url,
            Method = 'GET'
        })
        return response.Body
    else
        warn("CBM | PluginDownloader Exploit does not support request. This plugin will not work.")
    end
end

function CB_Manager:getFileName(attemptName, RAW)
    local fileName
    if attemptName then
        if attemptName:sub(-fileExLen) == '.' .. CB_Manager['fileExtension'] then
            fileName = attemptName
        else
            fileName = attemptName .. '.' .. CB_Manager['fileExtension']
        end
        if not isfile(CB_Manager['StandardFolder'] .. "/saved_plugins/" .. fileName) then
            return fileName
        else
            warn("CBM | PluginDownloader Provided file name already exists.")
        end
    else
        fileName = loadstring(RAW)().PluginName .. "." .. CB_Manager['fileExtension']
        if not isfile(CB_Manager['StandardFolder'] .. "/saved_plugins/" .. fileName) then
            return fileName
        end
        repeat
            fileName = CB_Manager:randomStringP() .. "." .. CB_Manager['fileExtension']
        until not isfile(CB_Manager['StandardFolder'] .. "/saved_plugins/" .. fileName)
        return fileName
    end
end

function CB_Manager:randomStringP()
    local min, max, final = ("A"):byte(), ("Z"):byte(), "CBMPluginDownloader-"
    for i = 1, math.random(5, 10) do
        final = final .. string.char(math.random(min, max))
    end
    return final
end

function CB_Manager:downloadPlugin(plugin)
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    local url = "https://raw.githubusercontent.com/Zirmith/CB-Manager/main/Plugins/" .. plugin .. '.lua'
    if not isfolder(CB_Manager['StandardFolder'] .. "/saved_plugins") then
        makefolder(CB_Manager['StandardFolder'] .. "/saved_plugins")
        if not plugin then
            warn("CBM | PluginDownloader Plugin not specified.")
        end
        local pluginRaw = CB_Manager:requestGET(url)
        local pluginName = CB_Manager:getFileName(plugin, pluginRaw)
        writefile(CB_Manager['StandardFolder'] .. "/saved_plugins/" .. pluginName, pluginRaw)
        warn("CBM | PluginDownloader Saved plugin as " .. pluginName)
    end
end

function CB_Manager:addCommand(command, options)
    local json;
    local https = game:GetService 'HttpService'
    if not command then
        warn("CBM | CommandHandler Command not specified.")
    end
    if command then
        local core = options or {}
        local setup = {
            ['Command'] = command,
            ['execute'] = core['execute']
        }
        json = https:JSONEncode(setup)
        if not isfolder(CB_Manager['StandardFolder'] .. "/saved_commands") then
            makefolder(CB_Manager['StandardFolder'] .. "/saved_commands")
            writefile(CB_Manager['StandardFolder'] .. "/saved_commands/" .. command .. ".lua", json, null, 2)
            warn('Saved command: '..command)
        end
    end
end

function CB_Manager:runPlugin(plugin, options)
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    local ci = options or {}
    local path = CB_Manager['StandardFolder'] .. "/saved_plugins/" .. plugin .. '.lua'
    if not plugin then
        warn("CBM | PluginDownloader Plugin not specified.")
    end
    local func = loadstring(readfile(path))()
    pcall(plugin,
        func['Commands'](ci['args1'],ci['args2'])
    )
    warn("CBM | PluginDownloader Ran plugin: " .. plugin)
end

function CB_Manager:init(config)
    local c1 = config
    local self = {}
    self.Name = c1['bot']
    self.Owner = c1['owner']
    self.prefix = c1['prefix']
    self.mods = c1['mods']
    self.admins = c1['admins']
    self.plugins = config['plugins']
    self.commands = config['commands']

    for i,v in pairs(self.plugins) do
        CB_Manager:downloadPlugin(v)
    end

    if not config['plugins'] then
        self.plugins = {}
    end

    if not config['commands'] then
        self.commands = {}
    end

    function self:usePlugin(p,a,b)
        CB_Manager:runPlugin(p, {
            ['args1'] = a,
            ['args2'] = b
        })
    end

    function self:getPlugin(p)
        CB_Manager:downloadPlugin(p)
    end

    return self
end



getgenv().CB_Manager = CB_Manager

return getgenv().CB_Manager
