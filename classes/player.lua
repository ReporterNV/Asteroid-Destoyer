local Object = require("classes.object")
local Animation = require("classes.animation")
require("vars")
local eventmanager = require("classes.eventmanager")

Player = Object:new({
	x = SCREEN_W / 2,
	y = 500,
	a = 1,
	speedX = 200,
	speedY = 100,
	ShootTimer = 2,
	ShootReload = 0.5,
	img = love.graphics.newImage(ImagePlayer),
});

Player:setWHfromImage();
Player.x = SCREEN_W / 2 - Player.w/2
Player.shield = love.graphics.newImage(ImageShield)
Player.Shield = 0;
Player.ShootTimer = 0;
Player.ShootReload = 0.6;

--[ [
ShieldDown =  Animation:new({
	img = love.graphics.newImage(ImageShield),
	frameW = 480,
	frameH = 480,
	framesColumns='1-5',
	framesRow ='1-4',
	onLoop = function ()
		ShieldDown.animation:getDimensions();
		ShieldDown.animation:resume();
	end;
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


--[ [
ShieldUp =  Animation:new({
	img = love.graphics.newImage(ImageShield),
	frameW = 480,
	frameH = 480,
	framesColumns='1-5', '1-3',
	framesRow ='1-4',
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
	if self.Shield < 1 then
		GameOver();
	else
		self.Shield = self.Shield - 1;
	end
end


function Player:draw()
	love.graphics.draw(Player.img, Player.x, Player.y);
	ShieldUp:draw();
	--reload bar
	love.graphics.rectangle("line", self.x , self.y + self.h, self.w, self.h * 0.1)
	local percent = 1 - self.ShootTimer / self.ShootReload;
	love.graphics.rectangle("fill", self.x , self.y + self.h, self.w * percent, self.h * 0.1)

end

function Player:update(dt, Keys)
	if Keys["left"] == true or Keys["a"] == true then
		if Player.x - Player.speedX*dt < 0 then
			Player.x = 0;
		else
			Player.x = Player.x - Player.speedX*dt;
		end
	end

	if Keys["right"] == true or Keys["d"] == true then
		if Player.x + Player.speedX*dt > SCREEN_W - Player.w then
			Player.x = SCREEN_W - Player.w;
		else
			Player.x = Player.x + Player.speedX*dt;
		end
	end

	if Keys["up"] == true or Keys["w"] == true then
		if Player.y - Player.speedY*dt < 0 then
			Player.y = 0;
		else
			Player.y = Player.y - Player.speedY*dt;
		end
	end

	if Keys["down"] == true or Keys["s"] == true then
		if Player.y + Player.speedY*dt + Player.h > SCREEN_H then
			Player.y = SCREEN_H - Player.h;
		else
			Player.y = Player.y + Player.speedY*dt;
		end
	end
	if Player.ShootTimer > 0 then
		self.ShootTimer = self.ShootTimer - dt;
	else
		if Keys["space"] == true then
			self.ShootTimer = self.ShootReload;
			eventmanager:playerShoot();
		end
	end

	ShieldUp:setWHfromFrameWithScale()
	ShieldUp:setOffsetCenterObject(Player)

	ShieldUp:update(dt);
end

return Player
