

return {
    ["PluginName"] = "Example_C",
    ["PluginDescription"] = "made by example.com",
    ["Commands"] = function(f1,f2)
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(f1,f2)
    end
}
