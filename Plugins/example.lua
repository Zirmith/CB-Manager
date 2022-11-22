return {
    ["PluginName"] = "Example_Plugin",
    ["PluginDescription"] = "made by example.com",
    ["Commands"] = function(f1,f2)
        print('Hello world')
        warn("Hello, " ..f1.. ", and "..f2)
    end
}
