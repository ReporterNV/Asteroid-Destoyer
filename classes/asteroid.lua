local vars = require("vars")
local Object = require("classes.object")
local AsteroidType= {
	["default"] = {
		hp = 1;
		speedY = -500;
		img = vars.image.Asteroid;
		quad = { -- for quad need set w, h by hand or it will use Dimensions of quad
			x = 0;
			y = 0;
			w = 96;
			h = 96; };
		w = 38;
		h = 33;
		destroySound = vars.audio.AsteroidDestroy;
		scalex = 1;
		scaley = 1;
		offsetx = 29,
		offsety = 32,
	},
	["strong"] = {
		hp = 2;
		speedY = -250;
		scalex = 1;
		scaley = -1;
		img = vars.image.Bullet;
		spawnSound = vars.audio.AsteroidDestroy
	}
}
local Asteroid = Object:new();

function Asteroid:init() --THIS ALWAYS SHOULD BE CALLED BEFORE USING!
	--Also validate all data
	for _, v in pairs(AsteroidType) do
		if v.img:type() == "Image" then
			if v.quad then
				v.h = v.h or v.quad.h;
				v.w = v.w or v.quad.w;
				v.quad = love.graphics.newQuad(v.quad.x, v.quad.y, v.quad.w, v.quad.h, v.img:getDimensions());
			else
				v.h = v.img:getHeight();
				v.w = v.img:getWidth();
			end
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

	asteroid.x = math.random(Player.w, vars.config.SCREEN_W - (asteroid.w or 0))
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
	if self.quad then
		love.graphics.draw(self.img, self.quad, self.x, self.y, nil, self.scalex, self.scaley, self.offsetx, self.offsety);
	else
		love.graphics.draw(self.img, self.x, self.y, nil, self.scalex, self.scaley, self.offsetx, self.offsety);
	end
	--Draw hitbox
	--love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Asteroid
