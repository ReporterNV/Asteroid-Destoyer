local Object = require("classes.object")
local vars = require("vars")

local background = Object:new({
	img = vars.image.Background,
	x = 0,
	y = 0,
	speedY = 10,
})

function background:init()
	background:setWHfromImage();
	background.Music = vars.audio.BackgroundMusic;
end
function background:pause()
	background.Music:pause();
end

function background:draw()
	--love.graphics.draw(self.img, self.x, self.y);
	love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, (vars.config.SCREEN_W-self.w)/2, vars.config.SCREEN_H);
end


function background:update(dt)
	if not background.Music:isPlaying() then
		background.Music:play();
	end
local NewY = self.y + self.speedY * dt;
	if (background.h - vars.config.SCREEN_H > NewY) then
		self.y = NewY;
	else
		self.y = background.h - vars.config.SCREEN_H;
	end
end


return background;
