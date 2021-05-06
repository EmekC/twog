local conf = conf or {}

local x = myConfig.scrw * 0.9 
local margin = 16

surface.CreateFont( "myFont", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
} )

local fontHeight = draw.GetFontHeight("myFont")

local time = time or 0

net.Receive("timeplayed", function(len, ply)
    time = net.ReadUInt(21)

end)

timer.Create("client_timer", 1, 0, function() 
    time = time + 1
    print("client time " .. time)
end)

hook.Add("HUDPaint", "draw_timer_hud", function()
    draw.RoundedBox(0, x, margin, myConfig.scrw - x - margin, 40, Color(70,70,70))

    surface.SetFont( "myFont" )
    surface.SetTextColor( 255, 255, 255 )
    surface.SetTextPos( x, margin + (fontHeight/2) ) 
    local fTime = string.FormattedTime(time)

    surface.DrawText( fTime["h"] .. ":" .. fTime["m"] .. "," .. fTime["s"] )

end)
