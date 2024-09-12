local anim8 = require("anim8.anim8")
require("vars")

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
function Asteroid:destroyAnimation()
	self.destroySound:play();
	table.remove(Asteroids, self)
end

function Asteroid:destroy(numberObj)
	self.destroySound:play();
	table.remove(Asteroids, numberObj)
end

return Asteroid
