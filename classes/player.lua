local Object = require("classes.object")
local vars = require("vars")
local eventmanager = require("classes.eventmanager")
local Player = Object:new({
	x = vars.config.SCREEN_W / 2,
	y = 500,
	a = 1,
	speedX = 200,
	speedY = 100,
	--ShootTimer = 0,
	--ShootReload = 0.1,
	img = vars.image.Player,
});

Player:setWHfromImage();
Player.x = vars.config.SCREEN_W / 2 - Player.w/2
Player.ShootReload = 0.6;
Player.ShootTimer = 0;
Player.ShootOverflow = 0;
Player.ShootExtra = 0;

Player.ShieldImg = vars.image.Shield;
Player.Shield = 0;
Player.ShieldMax = 10;
Player.ShieldTimer = 1;
Player.ShieldReload = 1;

--[[
ShieldDown =  Animation:new({
	img = ImageShield,
	frameW = 480,
	frameH = 480,
	frames = {'1-5', '1-4'},
	onLoop = function () end,
	durations = 0.08,
	x = Player.x,
	y = Player.y,
	scalex = 0.1,
	scaley = 0.1,
	offsetx = 90,--need fix this var
	offsety = 110, --and this
	followedObject = Player;
})
--]]


--[[
ShieldUp =  Animation:new({
	img = ImageShield,
	frameW = 480,
	frameH = 480,
	frames = {'1-5', '1-4'},
	onLoop = function ()
		ShieldUp.animation:getDimensions();
		ShieldUp.animation:resume();
	end;
	durations = 0.08,
	scalex = 0.1,
	scaley = 0.1,
	followedObject = Player;
})
--]]

function Player:takeHit()
	if self.Shield == 0 then
		GameOver();
	else
		self.Shield = self.Shield - 1;
	end
end


function Player:draw()
	love.graphics.draw(self.img, self.x, self.y);
	--reload bar
	love.graphics.rectangle("line", self.x , self.y + self.h, self.w, self.h * 0.1)
	local percent = self.ShootTimer / self.ShootReload;
	love.graphics.rectangle("fill", self.x , self.y + self.h, self.w * percent, self.h * 0.1)

end

function Player:update(dt, Keys)
	if Keys["left"] == true or Keys["a"] == true then
		if self.x - self.speedX*dt < 0 then
			self.x = 0;
		else
			self.x = self.x - self.speedX*dt;
		end
	end

	if Keys["right"] == true or Keys["d"] == true then
		if self.x + self.speedX*dt > vars.config.SCREEN_W - self.w then
			self.x = vars.config.SCREEN_W - self.w;
		else
			self.x = self.x + self.speedX*dt;
		end
	end

	if Keys["up"] == true or Keys["w"] == true then
		if self.y - self.speedY*dt < 0 then
			self.y = 0;
		else
			self.y = self.y - self.speedY*dt;
		end
	end

	if Keys["down"] == true or Keys["s"] == true then
		if self.y + self.speedY*dt + self.h > vars.config.SCREEN_H then
			self.y = vars.config.SCREEN_H - self.h;
		else
			self.y = self.y + self.speedY*dt;
		end
	end

	self.ShootTimer = self.ShootTimer + dt;

	if Keys["space"] == true then
		while self.ShootTimer >= self.ShootReload do
			self.ShootTimer = self.ShootTimer - self.ShootReload;
			--eventmanager:trigger("PlayerShoot");
			eventmanager:playerShoot();
		end
	else
		self.ShootTimer = math.min(self.ShootTimer, self.ShootReload)
	end


	--ShieldUp:setWHfromFrameWithScale()
	--ShieldUp:setOffsetCenterObject(Player)

	--ShieldUp:update(dt);
	--[[
	Img = love.graphics.newImage("Shield.png")
	q = love.graphics.newQuad(480, 480*2, 480, 480, Img:getWidth(), Img:getHeight());
	love.graphics.draw(Img, q, 10, 10);
	love.graphics.rectangle("line", 10 ,10, 480, 480);

	--]]
	if self.Shield < self.ShieldMax  then --need rewrite
		self.ShieldTimer = self.ShieldTimer + dt;
		if self.ShieldTimer >= self.ShieldReload then
			self.Shield = self.Shield + 1;
			eventmanager:generateShield();
			self.ShieldTimer = self.ShieldTimer - self.ShieldReload;
		end
	end
end

return Player
