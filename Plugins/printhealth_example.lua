return {
    ["PluginName"] = "Health_Example",
    ["PluginDescription"] = "made by example.com",
    ["Commands"] = function(f1,f2)
        local client = CB_Manager['Client']
        local hum = client:FindFirstChild('Humanoid')
        print(hum.Health)
    end
}
