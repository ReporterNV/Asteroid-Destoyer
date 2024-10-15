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
	NewWindow.options = args.options or {{name = "ERROR", callback = function() print("ERROR! Option not set!") end}};
	NewWindow.selectedOption = 1;
	NewWindow.prevWindow = nil;
	return NewWindow
end

function Window:callback()
	local CurrentOption = self.options[self.selectedOption]
	if CurrentOption.callback == nil then
		print("Try call nil callback!");
		return;
	end

	if CurrentOption.args == nil then
		CurrentOption.args = {window = self};
	else
		CurrentOption.args.window = self;
	end

	CurrentOption.callback(self.args)
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
			love.graphics.printf(option.name, self.x, optionY, self.w, "center")
			love.graphics.setColor(1, 1, 1)
		end
	end
end

return Window
