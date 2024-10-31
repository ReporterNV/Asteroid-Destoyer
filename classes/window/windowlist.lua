local Window = require("classes.window.window");
local option = require("classes.window.windowoptions");
Windows = {}
--order of windows right now is important. need fix it.
Windows.Settings = Window:new({
	x = SCREEN_W/3;
	w = SCREEN_W/3;
	h = SCREEN_H/3;
	visible = true;
	title = "Settings";
	options = {
		{name = "Continue", callback = option.Resume},
		{name = "BGM", style = "slider", callbackL = option.updateVolume, callbackR = option.updateVolume, args = {variable = "MasterSoundLV", max=1, min=0, step = 0.1}},
		{name = "Sounds", callback = option.OpenPreviousWindow},
		{name = "Back", callback = option.OpenPreviousWindow},
	}
})
--]]

Windows.Pause = Window:new({
	x = SCREEN_W/3;
	w = SCREEN_W/3;
	h = SCREEN_H/3;
	visible = true;
	title = "Pause";
	options = {
		{name = "Continue", callback = option.Resume},
		{name = "Settings", callback = option.OpenWindow, args = {NewWindow = Windows.Settings}},
		{name = "Exit", callback = option.ExitGame}
	}
})

Windows.Start = Window:new({
	x = SCREEN_W/3;
	w = SCREEN_W/3;
	h = SCREEN_H/2;
	visible = true;
	title = love.window.getTitle(),
	options = {
		{name = "Start", callback = option.Resume},
		{name = "Settings", callback = option.OpenWindow, args = {NewWindow = Windows.Settings}},
		{name = "Exit", callback = option.ExitGame}
	}
})


return Windows;
