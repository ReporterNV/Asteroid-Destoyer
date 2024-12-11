require("vars")
local Object = require("classes.object")
local BulletList = { --use it in future?
	["default"] = {
		speedY = -500;
		img = ImageBullet;
		spawnSound = SndAttack;
	},
	["slow"] = {
		speedY = -100;
		img = ImageBullet;
		spawnSound = SndAttack;
	}
}
local Bullet = Object:new(BulletList["default"]);

function Bullet:init()
end

function Bullet:spawn(BulletType)
	local bullet;
	if type(BulletList[BulletType]) == "table" then
		bullet = Bullet:new(BulletList[type]);
	else
		bullet = Bullet:new(BulletList["default"]);
	end

	bullet.x = Player.x + Player.w/2 - bullet.w/2;
	bullet.y = Player.y

	if bullet.spawnSound ~= nil then -- should i do it if spawn a lot?
		bullet.spawnSound:play();
	end
	return bullet;
end

function Bullet:draw()
	love.graphics.draw(self.img, self.x, self.y);
	--love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Bullet
