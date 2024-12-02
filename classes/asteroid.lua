require("vars")
local Object = require("classes.object")

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
	ChildObj.img = ImageAsteroid
	ChildObj.destroySound = love.audio.newSource(SndDestoyAsteroidPath, "static");
	ChildObj.callback = nil;
	self.__index = self;
	return setmetatable(ChildObj, self);
end

function Asteroid:spawn()
	local asteroid = Asteroid:new()
	asteroid:setWHfromImage();
	asteroid.x = math.random(110, SCREEN_W - (asteroid.w or 0))
	asteroid.y = -asteroid.h;
	asteroid.speedY = math.random(50, 200)
	table.insert(Asteroids, asteroid)
end

function Asteroid:destroy(numberObj)
	--self.destroySound:play();
	--table.remove(Asteroids, numberObj)
end

function Asteroid:update(dt, numberObj)
	self.y = self.y + self.speedY*dt;
end


function Asteroid:draw()
	love.graphics.draw(self.img, self.x, self.y);
	--love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Asteroid
