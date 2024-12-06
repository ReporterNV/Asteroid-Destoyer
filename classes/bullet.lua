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
	ChildObj.img = ImageBullet;
	ChildObj.spawnSound = SndAttack;
	ChildObj.callback = nil;
	self.__index = self;
	return setmetatable(ChildObj, self);
end

Bullet:setWHfromImage();
function Bullet:init()
end

function Bullet:spawn()
	local bullet = Bullet:new()
	bullet.x = Player.x + Player.w/2 - bullet.w/2;
	bullet.y = Player.y
	bullet.spawnSound:play();
	return bullet;
end

function Bullet:draw()
	love.graphics.draw(self.img, self.x, self.y);
	--love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Bullet
