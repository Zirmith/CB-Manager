
return {
            ["PluginName"] = "owoify",
            ["PluginDescription"] = "made by example.com",
            ["Commands"] = function(f1)
                


                local response = request(
			{
				Url = "https://uwuaas.herokuapp.com/api",  -- This website helps debug HTTP requests
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json"  -- When sending JSON, set this!
				},
				Body = game:GetService("HttpService"):JSONEncode({text = ""..f1})
			}
		)

        local uwuified

		for i,v in pairs(response) do
			if type(v) == "string" and v:find("text") then
			local g = v:gsub([[{"text":"]],"")
			local f = g:gsub("}","")
			local z = f:gsub([["]],"")
			uwuified = z
            warn(uwuified)
			end
		end

        local A_1 = uwuified
        local A_2 = 'All'

        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(A_1, A_2)
     end
}
            
