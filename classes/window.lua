Window = {}

function Window:new(args)
	if args == nil then
		args = {};
	end
	self.x = args.x or 100;
	self.y = args.y or 100;
	self.w = args.w or 400;
	self.h = args.h or 300;
	self.visible = args.visible or false;
	self.title = args.title or "Menu";
	self.options = args.options or {name = "ERROR"};
	self.selectedOption = 1;
	self.__index = self;
	local self = setmetatable({}, Window)
	return self
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

local prevButton = "up";
function Window:update(dt, Keys)
	if Keys["up"] and prevButton ~= "up" then
		self.selectedOption = self.selectedOption - 1
		prevButton = "up"
	elseif Keys["down"] and prevButton ~= "down" then
		self.selectedOption = self.selectedOption + 1
		prevButton = "down"
	end

	if Keys[prevButton] == false then
		prevButton = "";
	end

	if self.selectedOption > #self.options then
		self.selectedOption = #self.options;
	elseif self.selectedOption < 1 then
		self.selectedOption = 1;
	end

	if Keys["return"] then
		print (self.options[self.selectedOption].name)
		self.options[self.selectedOption].callback();
	end

end
return Window
