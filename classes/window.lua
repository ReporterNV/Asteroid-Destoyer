Window = {}

function Window:new(args)
	if args == nil then
		args = {};
	end
	self.x = args.x or 100;
	self.y = args.y or 100;
	self.width = args.width or 400;
	self.height = args.height or 300;
	self.title = args.title or "Menu";
	self.options = args.options or {"ERROR"};
	self.selectedOption = 1;
	self.__index = self;
	local self = setmetatable({}, Window)
	return self
end

function Window:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.printf(self.title, self.x, self.y + 10, self.width, "center")
    for i, option in ipairs(self.options) do
        local optionY = self.y + 50 + (i - 1) * 40
        if i == self.selectedOption then
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.printf(option, self.x, optionY, self.width, "center")
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
		print("var Reseted")
	end

	if self.selectedOption > #self.options then
		self.selectedOption = #self.options;
	elseif self.selectedOption < 1 then
		self.selectedOption = 1;
	end

	if Keys["enter"] then
		--self.options[self.selectedOption].callback();
	end

end
return Window
