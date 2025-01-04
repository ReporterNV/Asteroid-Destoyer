require("vars")
local Object = require("classes.object")
local AsteroidType= {
	["default"] = {
		speedY = -500;
		img = ImageAsteroid;
		spawnSound = SndAttack;
		destroySound = SndDestoyAsteroid;
	},
	["strong"] = {
		hp = 2;
		speedY = -250;
		img = ImageBullet;
		spawnSound = SndAttack;
	}
}
local Asteroid = Object:new();

function Asteroid:spawn(AsteroidTypeName)
	local asteroid;
	if type(AsteroidType[AsteroidTypeName]) ~= "table" then
		AsteroidTypeName = "default";
	end

	asteroid = Asteroid:new(AsteroidType[AsteroidTypeName]);

	if asteroid.h == nil or asteroid.w == nil then
		asteroid:setWHfromImage();
		AsteroidType[AsteroidTypeName].h = asteroid.h;
		AsteroidType[AsteroidTypeName].w = asteroid.w;
	end

	asteroid.x = math.random(Player.w, SCREEN_W - (asteroid.w or 0))
	asteroid.y = -asteroid.h;
	asteroid.speedY = math.random(50, 200)
	return asteroid;
	--table.insert(Asteroids, asteroid)
end

function Asteroid:update(dt)
	self.y = self.y + self.speedY*dt;
end

function Asteroid:draw()
	if self.img ~= nil then -- should check before allow to spawn
		love.graphics.draw(self.img, self.x, self.y);
	end
	--love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Asteroid
