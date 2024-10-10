local window = require("classes.window");
Windows = {}

Windows.Start = Window:new({
		x = SCREEN_W/3;
		w = SCREEN_W/3;
		h = SCREEN_H/2;
		visible = true;
		title = love.window.getTitle(),
		options = {
			{name = "Start", callback = function(window) window.visible = false; Pause:ToggleUserPause() end},
			{name = "Settings"},
			{name = "Exit", callback = function() love.event.quit() end}
		}
	})


return Windows;
