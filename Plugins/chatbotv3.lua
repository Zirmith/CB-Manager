return {
    ["PluginName"] = "C_Plugin",
    ["PluginDescription"] = "made by example.com",
    ["Commands"] = function(key)

repeat wait() until game:IsLoaded();

-- // SETTINGS \\ --



local SECRET_KEY  = key; --https://beta.openai.com/account/api-keys
local CLOSE_RANGE_ONLY = true;

_G.MESSAGE_SETTINGS = {
	["MINIMUM_CHARACTERS"] = 10,
	["MAXIMUM_CHARACTERS"] = 50,
	["MAXIMUM_STUDS"] = 10.5,
};

_G.WHITELISTED = { --Only works if CLOSE_RANGE_ONLY is disabled
	["seem2006"] = true,
};

_G.BLACKLISTED = { --Only works if CLOSE_RANGE_ONLY is enabled
	["Builderman"] = true,
};

-- // DO NOT CHANGE BELOW \\ --

if _G.OpenAI or SECRET_KEY == "secret key here" then return end;

_G.OpenAI = true;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
local LocalPlayer = Players.LocalPlayer;
local SayMessageRequest = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest");
local OnMessageDoneFiltering = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering");
local Debounce = false;

function MakeRequest(Prompt)
local pre = ""
	pre =  request({
		Url = "https://api.openai.com/v1/completions", 
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] =  "Bearer " .. SECRET_KEY
		},
		Body = HttpService:JSONEncode({
			model = "text-davinci-002",
			prompt = Prompt,
			temperature = 0.9,
  			max_tokens = 47, --150
  			top_p = 1,
  			frequency_penalty = 0.0,
  			presence_penalty = 0.6,
  			stop = {" Human:", " AI:"}
		});
	});
    return pre
end

OnMessageDoneFiltering.OnClientEvent:Connect(function(Table)
	local Message, Instance = Table.Message, Players:FindFirstChild(Table.FromSpeaker);
	local Character = Instance and Instance.Character;
	
	if Instance == LocalPlayer or string.match(Message, "#") or not Character or not Character:FindFirstChild("Head") or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return end;
	if Debounce or #Message < _G.MESSAGE_SETTINGS["MINIMUM_CHARACTERS"] or #Message > _G.MESSAGE_SETTINGS["MAXIMUM_CHARACTERS"] then return end;
	if CLOSE_RANGE_ONLY then if _G.BLACKLISTED[Instance.Name] or (Character.Head.Position - LocalPlayer.Character.Head.Position).Magnitude > _G.MESSAGE_SETTINGS["MAXIMUM_STUDS"] then return end elseif not _G.WHITELISTED[Instance.Name] then return end;

	Debounce = true;

	local HttpRequest = MakeRequest("Human: " .. Message .. "\n\nAI:");
	local Response = Instance.Name .. ": " .. string.gsub(string.sub(HttpService:JSONDecode(HttpRequest["Body"]).choices[1].text, 2), "[%p%c]", "");

	if #Response < 128 then --200
		SayMessageRequest:FireServer(Response, "All");
		wait(5);
		Debounce = false;
	else
		warn("Response (> 128): " .. Response);
		if #Response - 128 < 128 then
			SayMessageRequest:FireServer(string.sub(Response, 1, 128), "All");
			delay(0.7, function()
				SayMessageRequest:FireServer(string.sub(Response, 129), "All");
				wait(5);
				SayMessageRequest:FireServer('Sorry, Im on Cooldown',"All")
				Debounce = false;
			end)	
		else
			SayMessageRequest:FireServer("Sorry, I couldn't understand.", "All");
			wait(2.5);
			Debounce = false;
		end
	end
end)

warn("Script has been executed with success.");                  
    end
}
