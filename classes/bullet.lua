require("vars")
require("classes.object")

Bullet = Object:new();
function Bullet:new(args)
	local ChildObj = {};
	if args == nil then
		args = {};
	end
	ChildObj.x = args.x or 0;
	ChildObj.y = args.y or 0;
	ChildObj.w = args.w or 0;
	ChildObj.h = args.h or 0;
	ChildObj.speedX = 0;
	ChildObj.speedY = args.speedY or -500;
	ChildObj.img = love.graphics.newImage(ImageBullet);
	ChildObj.spawnSound = love.audio.newSource(SndAttackPath, "static");
	ChildObj.callback = nil;
	self.__index = self;
	return setmetatable(ChildObj, self);
end

function Bullet:spawn()
	local bullet = Bullet:new()
	bullet:setWHfromImage();
	bullet.x = Player.x + Player.w/2 - bullet.w/2;
	bullet.y = Player.y
	bullet.spawnSound:play();
	table.insert(Bullets, bullet)
end

function Bullet:draw()
	love.graphics.draw(self.img, self.x, self.y);
end

return Bullet
