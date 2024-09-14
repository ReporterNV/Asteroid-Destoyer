Object = {
	x = 0,
	y = 0,
	w = 0,
	h = 0,
	speedX = 0,
	speedY = 0,
	img = nil,
	collision = true;
}

function Object:new(args)
	local ChildObj = {}
	if args == nil then
		args = {}
	end
	ChildObj.x = args.x or 0;
	ChildObj.y = args.y or 0;
	ChildObj.w = args.w or 0;
	ChildObj.h = args.h or 0;
	ChildObj.speedX = args.speedX or 0;
	ChildObj.speedY = args.speedY or 0;
	ChildObj.img = args.img or nil;
	ChildObj.collision = true;
	self.__index = self;
	return setmetatable(ChildObj, self);
end

function Object:setWHfromImage()
	if self.img ~= nil then
		self.h = self.img:getHeight();
		self.w = self.img:getWidth();
	else
		print("image not set");
	end
end

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
	x2 < x1+w1 and
	y1 < y2+h2 and
	y2 < y1+h1
end

function Object:checkCollisionObj(Obj2)
	if self == nil then
		print("func checkCollision _self is nil? HOW?")
	end
	local Obj1 = self
	if Obj2 == nil then
		print("func checkCollision Obj2 is nil")
	end
	return checkCollision(
	Obj1.x, Obj1.y, Obj1.w, Obj1.h,
	Obj2.x, Obj2.y, Obj2.w, Obj2.h
	);
end

return Object;
