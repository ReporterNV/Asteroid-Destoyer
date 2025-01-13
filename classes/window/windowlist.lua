local Window = require("classes.window.window");
local option = require("classes.window.windowoptions");
local vars = require("vars");
Windows = {}
--order of windows right now is important. need fix it.
Windows.Settings = Window:new({
	x = vars.config.SCREEN_W/3;
	w = vars.config.SCREEN_W/3;
	h = vars.config.SCREEN_H/2;
	visible = true;
	title = "Settings";
	options = {
		{name = "Continue", callback = option.Resume},
		{name = "BGM", style = "slider", callbackL = option.updateVolume, callbackR = option.updateVolume, args = {variable = "MasterSoundLV", max=1, min=0, step = 0.1}},
		{name = "Sounds", callback = option.OpenPreviousWindow},
		{name = "Vsync",
			style = "slider",
			callbackL = option.setVsync,
			callbackR = option.setVsync,
			args = {variable = "Vsync", max = 4, min = 0, step = 1},
		},
		{name = "Back", callback = option.OpenPreviousWindow},
	}
})
--]]

Windows.Pause = Window:new({
	x = vars.config.SCREEN_W/3;
	w = vars.config.SCREEN_W/3;
	h = vars.config.SCREEN_H/3;
	visible = true;
	title = "Pause";
	options = {
		{name = "Continue", callback = option.Resume},
		{name = "Settings", callback = option.OpenWindow, args = {NewWindow = Windows.Settings}},
		{name = "Exit", callback = option.ExitGame}
	}
})

Windows.Start = Window:new({
	x = vars.config.SCREEN_W/3;
	y = vars.config.SCREEN_H/5;
	w = vars.config.SCREEN_W/3;
	h = vars.config.SCREEN_H/3;
	visible = true;
	title = love.window.getTitle(),
	options = {
		{name = "Start", callback = option.Resume},
		{name = "Settings", callback = option.OpenWindow, args = {NewWindow = Windows.Settings}},
		{name = "Exit", callback = option.ExitGame}
	}
})


return Windows;
