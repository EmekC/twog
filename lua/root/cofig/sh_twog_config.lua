myConfig = {}

// === hud === //
myConfig.scrw = ScrW()
myConfig.scrh = ScrH()

hook.Add("OnScreenSizeChanged", "update_twog_config", function()
    myConfig.scrw = ScrW()
    myConfig.scrh = ScrH()
end)