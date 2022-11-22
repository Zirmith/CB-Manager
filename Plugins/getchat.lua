

return {
    ["PluginName"] = "Example_C",
    ["PluginDescription"] = "made by example.com",
    ["Commands"] = function(f1,f2)
        local A_1 = f1
        local A_2 = f2
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(A_1, A_2)
    end
}
