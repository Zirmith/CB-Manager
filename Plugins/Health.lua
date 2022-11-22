return {
    ["PluginName"] = "Health_Example",
    ["PluginDescription"] = "made by example.com",
    ["Commands"] = function(f1,f2)
        local client = CB_Manager['Client'].Character
        local hum = client:FindFirstChild('Humanoid')
        return(hum.Health)                    
    end
}
