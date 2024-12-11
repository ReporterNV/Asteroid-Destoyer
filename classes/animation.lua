require("vars")
local anim8 = require("anim8.anim8")
local Object = require("classes.object")
if table.unpack then
	unpack = table.unpack
end
local AnimationList= {};
local AnimationDescription = {
	["AsteroidDestroy"] = {
			img = ImageAsteroidDestroy,
			frameW = 96,
			frameH = 96,
			frames = {'2-8', 1},
			durations = 0.08,
			offsetx = 29,
			offsety = 32,
			onLoop = "pauseAtEnd",
	}
}

local Animation = Object:new({})
--[[
function Animation:new(args)
	if args == nil then
		args = {}
	end
	local ChildObj = {}
	ChildObj.x = args.x or 0;
	ChildObj.y = args.y or 0;
	ChildObj.w = args.w or 0;
	ChildObj.h = args.h or 0;
	--why i remove speedX and speedY for anim? Now all objects should have inv other obj?

	ChildObj.img = args.img or error("Animation: arg img not valid!")
	ChildObj.frameW = args.frameW or nil;
	ChildObj.frameH = args.frameH or nil; --looks like i need rewrite it.
	ChildObj.grid = args.grid or anim8.newGrid(ChildObj.frameW, ChildObj.frameH,
				ChildObj.img:getWidth(), ChildObj.img:getHeight());
	ChildObj.frames = args.frames or {1,1};
	ChildObj.onLoop = args.onLoop or "pauseAtEnd";
	ChildObj.durations = args.durations or 1;
	ChildObj.animation = args.animation or anim8.newAnimation(
		ChildObj.grid(unpack(ChildObj.frames)),
		ChildObj.durations,
		ChildObj.onLoop
	);
	ChildObj.offsetx = args.offsetx or 0;
	ChildObj.offsety = args.offsety or 0;
	ChildObj.scalex = args.scalex or 1;
	ChildObj.scaley = args.scaley or 1;
	ChildObj.collision = false;
	ChildObj.followedObject = args.followedObject or nil;
	self.__index = self;
	return setmetatable(ChildObj, self);
end
--]]

function Animation:spawn(args)
	args = args or error("Animation spawn args is nil!")
	if (args.x == nil and args.y == nil) or args.followedObject == nil then
		error("x and y or followed object not set");
		return
	end
	local desc = AnimationDescription[args.type];

	if type(desc) == "table" then
		error("Need set animation in AnimationDescription before call it")
	end
	local grid = anim8.newGrid(desc.frameW, desc.frameH, desc.img:getWidth(), desc.img:getHeight()) --rewrite it on already exist table
	local animation = anim8.newAnimation(grid(unpack(desc.frames)), desc.durations, desc.onLoop)
	return {
		img = desc.img,
		animation = animation,
		offsetx = desc.offsetx or 0,
		offsety = desc.offsety or 0,
		scalex = 1,
		scaley = 1,
	}
end

function Animation:setWHfromFrameWithScale()
	if self.frameW ~= nil then
		self.w = self.frameW * self.scalex;
	end

	if self.frameH ~= nil then
		self.h = self.frameH * self.scaley;
	end

end


function Animation:setOffsetCenterObject(FollowedObject)
	if self.w ~= nil then
		self.offsetx = (self.w - FollowedObject.w) / 2 / self.scalex;
	end

	if self.h ~= nil then
		self.offsety = (self.h - FollowedObject.h) / 2 / self.scaley;
	end
end


function Animation:update(dt)
	if self.animation then
		self.animation:update(dt);
	end
	if self.followedObject ~= nil then
		self.x = self.followedObject.x;
		self.y = self.followedObject.y;
	end
end


function Animation:draw()
	if self.animation then
		self.animation:draw(self.img, self.x, self.y, nil, self.scalex,self.scaley, self.offsetx, self.offsety);
	end
end

return Animation
