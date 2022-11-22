
getgenv().CB_Manager = {
    ['StandardFolder'] = "CBM-CONFIG",
    ['fileExtension'] = "lua",
    ['Client'] = game:GetService("Players").LocalPlayer
}

getgenv().CB_Manager._index = CB_Manager

if syn and DrawingImmediate then
    getgenv().CB_Manager['fileExtension'] = "txt"
end
local fileExLen = #getgenv().CB_Manager['fileExtension'] + 1

function getgenv().CB_Manager:Configuration(options)
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

    if not isfolder(getgenv().CB_Manager['StandardFolder']) then
        makefolder(getgenv().CB_Manager['StandardFolder'])
    end

    if not isfolder(getgenv().CB_Manager['StandardFolder'] .. "/saved_configs") then
        makefolder(getgenv().CB_Manager['StandardFolder'] .. "/saved_configs")
        writefile(getgenv().CB_Manager['StandardFolder'] .. "/saved_configs/" .. s_self.configName .. ".txt",
            game:GetService("HttpService"):JSONEncode(s_self))
    else
        if isfolder(getgenv().CB_Manager['StandardFolder'] .. "/saved_configs") then
            writefile(getgenv().CB_Manager['StandardFolder'] .. "/saved_configs/" .. s_self.configName .. ".txt",
                game:GetService("HttpService"):JSONEncode(s_self))
        end
    end

    if not isfolder(getgenv().CB_Manager['StandardFolder'] .. "/saved_admins") then
        makefolder(getgenv().CB_Manager['StandardFolder'] .. "/saved_admins")
        for i, v in pairs(s_self.admins) do
            writefile(getgenv().CB_Manager['StandardFolder'] .. "/saved_admins/" .. v .. ".txt", "This player is a admin.")
        end
    end

    if not isfolder(getgenv().CB_Manager['StandardFolder'] .. "/saved_mods") then
        makefolder(getgenv().CB_Manager['StandardFolder'] .. "/saved_mods")
        for i, v in pairs(s_self.mods) do
            writefile(getgenv().CB_Manager['StandardFolder'] .. "/saved_mods/" .. v .. ".txt", "This player is a mod.")
        end
    end

    if not isfolder(getgenv().CB_Manager['StandardFolder'] .. "/saved_owner") then
        makefolder(getgenv().CB_Manager['StandardFolder'] .. "/saved_owner")
        writefile(getgenv().CB_Manager['StandardFolder'] .. "/saved_owner/" .. s_self.owner .. ".txt", "This player is the owner.")
    end
    warn('Saved Config')
    warn('Check on file: ' .. getgenv().CB_Manager['StandardFolder'])
    return s_self
end

function getgenv().CB_Manager:requestGET(url)
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

function getgenv().CB_Manager:getFileName(attemptName, RAW)
    local fileName
    if attemptName then
        if attemptName:sub(-fileExLen) == '.' .. getgenv().CB_Manager['fileExtension'] then
            fileName = attemptName
        else
            fileName = attemptName .. '.' .. getgenv().CB_Manager['fileExtension']
        end
        if not isfile(getgenv().CB_Manager['StandardFolder'] .. "/saved_plugins/" .. fileName) then
            return fileName
        else
            warn("CBM | PluginDownloader Provided file name already exists.")
        end
    else
        fileName = loadstring(RAW)().PluginName .. "." .. getgenv().CB_Manager['fileExtension']
        if not isfile(getgenv().CB_Manager['StandardFolder'] .. "/saved_plugins/" .. fileName) then
            return fileName
        end
        repeat
            fileName = getgenv().CB_Manager:randomStringP() .. "." .. getgenv().CB_Manager['fileExtension']
        until not isfile(getgenv().CB_Manager['StandardFolder'] .. "/saved_plugins/" .. fileName)
        return fileName
    end
end

function getgenv().CB_Manager:randomStringP()
    local min, max, final = ("A"):byte(), ("Z"):byte(), "CBMPluginDownloader-"
    for i = 1, math.random(5, 10) do
        final = final .. string.char(math.random(min, max))
    end
    return final
end

function getgenv().CB_Manager:downloadPlugin(plugin)
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    local url = "https://raw.githubusercontent.com/Zirmith/CB-Manager/main/Plugins/" .. plugin .. '.lua'
    if not isfolder(getgenv().CB_Manager['StandardFolder'] .. "/saved_plugins") then
        makefolder(getgenv().CB_Manager['StandardFolder'] .. "/saved_plugins")
        if not plugin then
            warn("CBM | PluginDownloader Plugin not specified.")
        end
        local pluginRaw = getgenv().CB_Manager:requestGET(url)
        local pluginName = getgenv().CB_Manager:getFileName(plugin, pluginRaw)
        writefile(getgenv().CB_Manager['StandardFolder'] .. "/saved_plugins/" .. pluginName, pluginRaw)
        warn("CBM | PluginDownloader Saved plugin as " .. pluginName)
    end
end

function getgenv().CB_Manager:addCommand(command, options)
    local json;
    local https = game:GetService 'HttpService'
    if not command then
        warn("CBM | CommandHandler Command not specified.")
    end
    if command then
        local core = options or {}
        local func = core['execute']
        local setup = {
            ['Command'] = command,
            ['execute'] = func
        }
        json = https:JSONEncode(setup)
        if not isfolder(getgenv().CB_Manager['StandardFolder'] .. "/saved_commands") then
            makefolder(getgenv().CB_Manager['StandardFolder'] .. "/saved_commands")
            writefile(getgenv().CB_Manager['StandardFolder'] .. "/saved_commands/" .. command .. ".lua", json, null, 2)
        end
    end
end

function getgenv().CB_Manager:runPlugin(plugin, options)
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    local ci = options or {}
    local path = getgenv().CB_Manager['StandardFolder'] .. "/saved_plugins/" .. plugin .. '.lua'
    if not plugin then
        warn("CBM | PluginDownloader Plugin not specified.")
    end
    local func = loadstring(readfile(path))()
    pcall(plugin,
        func['Commands'](ci['args1'],ci['args2'])
    )
    warn("CBM | PluginDownloader Ran plugin: " .. plugin)
end


return getgenv().CB_Manager
