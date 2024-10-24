local Object = require("classes.object")
require("vars")

local background = Object:new({
	img = love.graphics.newImage(ImageBackground);
	x = 0,
	y = 0,
	speedY = 10,
})

function background:init()
	background:setWHfromImage();
	background.Music = love.audio.newSource(SndBackgroundMusic, "stream");
end
function background:pause()
	background.Music:pause();
end

function background:draw()
	--love.graphics.draw(self.img, self.x, self.y);
	love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, (SCREEN_W-self.w)/2,SCREEN_H);
end


function background:update(dt)
	if not background.Music:isPlaying() then
		background.Music:play();
	end
local NewY = self.y + self.speedY * dt;
	if (background.h - SCREEN_H > NewY) then
		self.y = NewY;
	else
		self.y = background.h - SCREEN_H;
	end
end


return background;
