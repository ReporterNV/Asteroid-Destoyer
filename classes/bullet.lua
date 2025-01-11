local vars = require("vars")
local Object = require("classes.object")
local BulletType = { --use it in future?
	["default"] = {
		speedY = -500;
		img = vars.image.Bullet;
		spawnSound = vars.audio.Attack;
	},
	["slow"] = {
		speedY = -250;
		img = vars.image.Bullet;
		spawnSound = vars.audio.Attack;
	}
}
local Bullet = Object:new(BulletType["default"]);

function Bullet:init()
end

function Bullet:spawn(BulletTypeName)
	local bullet;
	if type(BulletType[BulletTypeName]) == "table" then
		bullet = Bullet:new(BulletType[BulletTypeName]);
	else
		bullet = Bullet:new(BulletType["default"]);
	end

	bullet.x = Player.x + Player.w/2 - bullet.w/2;
	bullet.y = Player.y

	if bullet.spawnSound then -- should i do it if spawn a lot?
		bullet.spawnSound:play();
	end
	return bullet;
end

function Bullet:draw()
	love.graphics.draw(self.img, self.x, self.y);
	--love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Bullet
