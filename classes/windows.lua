local Window = require("classes.window");
local option = require("classes.windowoptions");
Windows = {}
--order of windows right now is important. need fix it.
Windows.Pause = Window:new({
	x = SCREEN_W/3;
	w = SCREEN_W/3;
	h = SCREEN_H/3;
	visible = true;
	title = "Pause";
	options = {
		{name = "Continue", callback = option.Resume},
		--{name = "Settings", callback = option.OpenWindow, args = {NewWindow = Windows.Pause}},
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
		{name = "Start", callback = option.CloseAllWindows},
		{name = "Settings", callback = option.OpenWindow, args = {NewWindow = Windows.Pause}},
		{name = "Settings", callback = option.OpenWindow, args = {NewWindow = "a"}},
		{name = "Exit", callback = option.ExitGame}
	}
})
--[ [

--]]
--[ [
Windows.Settings = Window:new({
	x = SCREEN_W/3;
	w = SCREEN_W/3;
	h = SCREEN_H/3;
	visible = true;
	title = "Settings";
	options = {
		{name = "Continue", callback = option.Resume},
		{name = "Settings", callback = option.OpenWindow, args = {NewWindow = Windows.Pause}},
		{name = "Exit", callback = option.ExitGame}
	}
})
--]]


return Windows;
