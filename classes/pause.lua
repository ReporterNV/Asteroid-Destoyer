--require("vars")
local WindowManager = require("classes.windowmanager")-- Pause control window manager ?????
local Windows = require("classes.windows")

local Pause = {
UserPause = true;
AFKPause = false;
CanPressPause = true;
};

function love.focus(f)
	if f then
		AFKPause = false;
	else
		AFKPause = true;
	end
end

function Pause:update(dt, Keys)
	if Keys["escape"] and self.CanPressPause then
		self.UserPause = not self.UserPause;
		self.CanPressPause = false;
		if self.UserPause == true then
			WindowManager:SetActiveWindow(Windows.Pause)
			Background:pause();
		else
			WindowManager:RemoveActiveWindow()
		end
	elseif Keys["escape"] == false then
		self.CanPressPause = true;
	end
end

function Pause:ToggleUserPause()
	self.UserPause = not self.UserPause;
end

function Pause:Resume()
	self.UserPause = false;
end


function Pause:Continue()
	return not (self.UserPause or self.AFKPause)
end

function Pause:IsOnPause()
	return self.UserPause or self.AFKPause
end

return Pause;
