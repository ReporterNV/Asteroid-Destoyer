local anim8 = require("anim8.anim8")
require("vars")
require("classes.object")

Asteroid = Object:new();
function Asteroid:new(args)
	local ChildObj = {}; -- looks like i do it wrong
	if args == nil then
		args = {};
	end
	ChildObj.x = args.x or 0;
	ChildObj.y = args.y or 0;
	ChildObj.w = args.w or 0;
	ChildObj.h = args.h or 0;
	ChildObj.speedX = 0;
	ChildObj.speedY = args.speedY or 0;
	ChildObj.img = love.graphics.newImage(ImageAsteroid)
	ChildObj.animation =  anim8.newAnimation(destroyGrid('1-8', 1), 0.1, "pauseAtEnd");
	ChildObj.destroySound = love.audio.newSource(SndDestoyAsteroidPath, "static");
	ChildObj.callback = nil;
	self.__index = self;
	return setmetatable(ChildObj, self);
end
function Asteroid:spawn()
	local asteroid = Asteroid:new()
	asteroid:setWHfromImage();
	asteroid.x = math.random(0, SCREEN_W - (asteroid.w or 0))
	asteroid.y = -asteroid.h;
	asteroid.speedY = math.random(50, 200)
	asteroid.animation:pauseAtStart();
	table.insert(Asteroids, asteroid)
end
--[[
function Asteroid:destroyAnimation()
	self.destroySound:play();
	table.remove(Asteroids, self)
end
--]]

function Asteroid:destroy(numberObj)
	--self.destroySound:play();
	--table.remove(Asteroids, numberObj)
end

function Asteroid:draw()
	self.animation:draw(destroyImg, self.x, self.y, nil, 1,1, 29, 32); --offset 29 for original animation
	--love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

function Asteroid:update(dt, numberObj)
	self.y = self.y + self.speedY*dt;
	if self.y > SCREEN_H then
		love.event.quit();
	end
	if self.speed == 0 then
		if  self.animation.status == "paused" then -- use 4 insted of 5 bcz we skip 1 frame.
			self.destroy(numberObj)
		else
			self.animation:update(dt);
			-- Use change object. when bullet hit asteroid change asteroid to animated obj?
		end
	end

end

return Asteroid
