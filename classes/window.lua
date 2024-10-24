Window = {}

function Window:new(args)
	if args == nil then
		args = {};
	end

	NewWindow = setmetatable({}, Window)
	self.__index = self;
	NewWindow.x = args.x or 100;
	NewWindow.y = args.y or 100;
	NewWindow.w = args.w or 400;
	NewWindow.h = args.h or 300;
	NewWindow.visible = args.visible or false;
	NewWindow.title = args.title or "Menu";
	NewWindow.options = args.options or {{name = "ERROR", style = "simple", callback = function() print("ERROR! Option not set!") end}};
	NewWindow.selectedOption = 1;
	NewWindow.prevWindow = nil;
	return NewWindow
end

function Window:callback()
	local CurrentOption = self.options[self.selectedOption]
	if CurrentOption.callback == nil then
		print("Window: Try call nil callback!");
		return;
	end

	if CurrentOption.args == nil then
		CurrentOption.args = {window = self};
	else
		CurrentOption.args.window = self;
	end

	CurrentOption.callback(CurrentOption.args)
end

function Window:checkSliderArgs()
	local CurrentOption = self.options[self.selectedOption]

	if CurrentOption.args == nil then
		print("Window: Try call slider with nil args!");
		return false, "Window: Try call slider with nil args!";
	end

	if CurrentOption.args.variable == nil then
		print("Window: variable name for slider is nil!");
		return false, "Window: variable name for slider is nil!";
	end

	if CurrentOption.args.step == nil then
		print("Window: arg step for slider is nil!");
		return false, "Window: arg step for slider is nil!";
	end

	if CurrentOption.args.max == nil then
		print("Window: arg max for slider args is nil!");
		return false, "Window: arg max for slider args is nil!";
	end

	if CurrentOption.args.min == nil then
		print("Window: arg min for slider args is nil!");
		return false, "Window: arg min for slider args is nil!";
	end

	return true, "Window args exist"
end


function Window:sliderL() --copy-paste not good
	local args = self.options[self.selectedOption].args;

	if self:checkSliderArgs() then
		if _G[args.variable] - args.step < args.min then
			_G[args.variable] = args.min;
		else
			_G[args.variable] = _G[args.variable] - args.step;
		end
	end
end

function Window:sliderR() --copy-paste not good
	local CurrentOption = self.options[self.selectedOption]
	if self:checkSliderArgs() then
		if _G[CurrentOption.args.variable] + CurrentOption.args.step > CurrentOption.args.max then
			_G[CurrentOption.args.variable] = CurrentOption.args.max;
		else
			_G[CurrentOption.args.variable] = _G[CurrentOption.args.variable] + CurrentOption.args.step;
		end
	end
end

function Window:draw()
	if self.visible then
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf(self.title, self.x, self.y + 10, self.w, "center")

		for i, option in ipairs(self.options) do

			local optionY = self.y + 50 + (i - 1) * 40
			if i == self.selectedOption then
				love.graphics.setColor(1, 0, 0)
			end

			if option.style == nil or option.style == "simple" then
				love.graphics.printf(option.name, self.x, optionY, self.w, "center")
			elseif option.style == "slider" then
				if option.args == nil then
					print("ERROR. Need set args for style slide")
				end
				if option.args.min == nil or
					option.args.max == nil or
					option.args.variable == nil or
					option.args.step == nil then
					print("ERROR. Need set args for style slide(min, max, variable, step)")
				end
				love.graphics.printf(option.name..": ".._G[option.args.variable], self.x, optionY, self.w, "center")
			end
			love.graphics.setColor(1, 1, 1)
		end
	end
end
return Window
