local Object = require("classes.object")
require("vars")

local background = Object:new({
	img = love.graphics.newImage(ImageBackground);
	x = 0,
	y = 0,
	speedY = 0.1,
})

function background:init()
	background:setWHfromImage();
end


function background:draw()
	--love.graphics.draw(self.img, self.x, self.y);
	love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, (SCREEN_W-self.w)/2,SCREEN_H);
end


function background:update()
	self.y = self.y + self.speedY;
end



return background;
