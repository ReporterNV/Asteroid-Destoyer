local window = require("classes.window");
local windows = require("classes.windows");

WindowManager = {};
local ActiveWindow = windows.Start;

local prevButton = "up";
function WindowManager:update(dt, Keys)
	if Keys["up"] and prevButton ~= "up" then
		ActiveWindow.selectedOption = ActiveWindow.selectedOption - 1
		prevButton = "up"
	elseif Keys["down"] and prevButton ~= "down" then
		ActiveWindow.selectedOption = ActiveWindow.selectedOption + 1
		prevButton = "down"
	end

	if Keys[prevButton] == false then
		prevButton = "";
	end

	if ActiveWindow.selectedOption > #ActiveWindow.options then
		ActiveWindow.selectedOption = #ActiveWindow.options;
	elseif ActiveWindow.selectedOption < 1 then
		ActiveWindow.selectedOption = 1;
	end

	if Keys["return"] then
		print (ActiveWindow.options[ActiveWindow.selectedOption].name)
		ActiveWindow.options[ActiveWindow.selectedOption].callback(ActiveWindow);
	end

end


function WindowManager:draw()
	ActiveWindow:draw();
end


return WindowManager;
