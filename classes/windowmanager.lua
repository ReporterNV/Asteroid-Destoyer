local window = require("classes.window");

WindowManager = {};
WindowManager.ActiveWindow = nil;

function WindowManager:RemoveActiveWindow()
	WindowManager.ActiveWindow = nil;
end

function WindowManager:SetActiveWindow(NewWindow)
	if WindowManager.ActiveWindow ~= nil then
		NewWindow.prevWindow = WindowManager.ActiveWindow;
	end
	WindowManager.ActiveWindow = NewWindow;
end

function WindowManager:BackToPreviousWindow()
	if WindowManager.ActiveWindow.prevWindow ~= nil then
		WindowManager.ActiveWindow = WindowManager.ActiveWindow.prevWindow;
	else
		print("Error! Previous Window not set. Check if this window exist.");
	end
end



local prevButton = "up";
local CanPressEnter = true;

function WindowManager:update(dt, Keys)

	ActiveWindow = WindowManager.ActiveWindow;
	if ActiveWindow ~= nil then

		if Keys["up"] and prevButton ~= "up" then
			ActiveWindow.selectedOption = ActiveWindow.selectedOption - 1
			prevButton = "up"
		elseif Keys["down"] and prevButton ~= "down" then
			ActiveWindow.selectedOption = ActiveWindow.selectedOption + 1
			prevButton = "down"
		end

		if ActiveWindow.options[ActiveWindow.selectedOption].style == "slider" then
			if ActiveWindow:checkSliderArgs() then
				if Keys["left"] and prevButton ~= "left" then
					prevButton = "left"
					ActiveWindow:sliderL();
					if ActiveWindow.selectedOption[ActiveWindow.selectedOption].callbackL ~= nil then
						ActiveWindow:callbackL();
					end
				elseif Keys["right"] and prevButton ~= "right" then
					prevButton = "right"
					ActiveWindow:sliderR();
					if ActiveWindow.selectedOption[ActiveWindow.selectedOption].callbackR ~= nil then
						ActiveWindow:callbackR();
					end
				end
			end
		end

		if Keys[prevButton] == false then
			prevButton = "";
		end

		if ActiveWindow.selectedOption > #ActiveWindow.options then
			ActiveWindow.selectedOption = #ActiveWindow.options;
		elseif ActiveWindow.selectedOption < 1 then
			ActiveWindow.selectedOption = 1;
		end

		if Keys["return"] and CanPressEnter then
			CanPressEnter = false;
			if ActiveWindow.options[ActiveWindow.selectedOption].callback ~= nil then
				ActiveWindow:callback();
			end
		elseif not Keys["return"] then
			CanPressEnter = true;
		end
	end
end

function WindowManager:draw()
	if ActiveWindow ~= nil then
		ActiveWindow:draw();
	end
end

return WindowManager;
