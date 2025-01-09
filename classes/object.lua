local Object = {
	collision = true;
}

function Object:new(args)
	local NewObj = setmetatable({}, self);
	self.__index = self;
	args = args or {};
	for key, value in pairs(args) do
		NewObj[key] = value
	end
	if self.img ~= nil then
		self:setWHfromImage();
	end
	if type(NewObj.callback) == "function" then
		NewObj:callback();
	end
	return NewObj;
end

function Object:setWHfromImage()
	if self.img == nil then
		print("Warn: image not set for setWHfromImage! Now set 0");
		self.h = 0;
		self.w = 0;
	else
		self.h = self.img:getHeight();
		self.w = self.img:getWidth();
	end
end

function Object:checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
	x2 < x1+w1 and
	y1 < y2+h2 and
	y2 < y1+h1
end

function Object:checkCollisionObj(Obj)
	if Obj == nil then
		print("Warn: checkCollisionObj second Object is nil. Check code!") -- rewrite to selfwrited func ?like log?
		return; --change to assert --Maybe not. just warn about it 
	end
	--Object should in init set x, y, w, h;
	return self.collision and --don't use Object:checkCollision is slower then inline;
	Obj.collision and
	self.x < Obj.x + Obj.w and
	Obj.x < self.x + self.w and
	self.y < Obj.y + Obj.h and
	Obj.y < self.y + self.h
end

return Object;
