require("vars")
local Object = require("classes.object")
local AsteroidType= {
	["default"] = {
		speedY = -500;
		img = ImageAsteroidDestroy;
		spawnSound = SndAttack;
		destroySound = SndDestoyAsteroid;
		scalex = 1;
		scaley = 1;
		offsetx = 29,
		offsety = 32,
	},
	["strong"] = {
		hp = 2;
		speedY = -250;
		img = ImageBullet;
		spawnSound = SndAttack;
	}
}
local Asteroid = Object:new();

function Asteroid:init() --THIS ALWAYS SHOULD BE CALLED BEFORE USING!
	print("Call Asteroid:init");
	for _, v in pairs(AsteroidType) do
		for _, n in pairs(v) do
			print(n);
		end
		print("Type: " .. v.img:type());
		if v.img:type() == "Image" then
			v.h = v.img:getHeight();
			v.w = v.img:getWidth();
		else
			error("AsteroidType: img not exist!")
		end
	end
end
function Asteroid:spawn(AsteroidTypeName)
	local asteroid;
	if type(AsteroidType[AsteroidTypeName]) ~= "table" then
		AsteroidTypeName = "default";
	end

	asteroid = Asteroid:new(AsteroidType[AsteroidTypeName]);

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
		--love.graphics.draw(self.img, self.x, self.y);
	end

	--we will take exception on init phase if something not exist
	love.graphics.draw(ImageAsteroidDestroy, QuadAsteroid, self.x, self.y, nil, self.scalex, self.scaley, self.offsetx, self.offsety);
	--love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Asteroid
