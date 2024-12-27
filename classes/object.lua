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

function Object:checkCollisionObj(Obj2)
	if self == nil then
		print("func checkCollision _self is nil? HOW?");
		return;
	end

	local Obj1 = self;

	if Obj2 == nil then
		print("Warn: checkCollisionObj second Object is nil. Check code!") -- rewrite to selfwrited func ?like log?
		return; --change to assert --Maybe not. just warn about it 
	end

	--Object should in init set x, y, w, h;
	return self.collision and Obj2.collision and --yes. need set collision = true. And this not happend by default.
	self:checkCollision(
	Obj1.x, Obj1.y, Obj1.w, Obj1.h,
	Obj2.x, Obj2.y, Obj2.w, Obj2.h
	);
end

function Object:insert(table)
	local length = table[0] or #table;
	length = length + 1;
	table[length] = self;
	table[0] = length;
end

function Object:remove(table, index)
	local length = table[0] or #table;
	if index ~= length then
		table[index]= table[length];
	end
	table[length] = nil;
	table[0] = length - 1;
end


return Object;
