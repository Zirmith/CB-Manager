
return {
    ["PluginName"] = "Health Notification v2",
    ["PluginDescription"] = "made by example.com",
    ["Commands"] = function(f1,f2)
        local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()
        local client = CB_Manager['Client'].Character
        local hum = client:FindFirstChild('Humanoid')

        Notification.Notify("Character Info | Health", hum.Health , "rbxasset://textures/ui/GuiImagePlaceholder.png", {
            Duration = 2,       
            Main = {
                Rounding = true,
            }
        });
        
        Notification.WallNotification("Character Info | Max Health", hum.MaxHealth, {
                Duration = 3,
        
                TitleSettings = {
                    Enabled = false
                }
            });
    end
}
