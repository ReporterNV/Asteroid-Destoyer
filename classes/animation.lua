require("vars")
local anim8 = require("anim8.anim8")
local Object = require("classes.object")

Animation = Object:new()
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

	ChildObj.img = args.img or nil;--change it for exception. need error on Love2d lv
	ChildObj.frameW = args.frameW or nil;
	ChildObj.frameH = args.frameH or nil; --looks like i need rewrite it.
	ChildObj.grid = args.grid or anim8.newGrid(ChildObj.frameW, ChildObj.frameH,
				ChildObj.img:getWidth(), ChildObj.img:getHeight());

	ChildObj.framesColumns = args.framesColumns or 1;
	ChildObj.framesRow = args.framesRow or 1;
	ChildObj.durations = args.durations or 0.1;
	ChildObj.onLoop = args.onLoop or "pauseAtEnd";
	ChildObj.animation = args.animation or anim8.newAnimation(ChildObj.grid(ChildObj.framesColumns, ChildObj.framesRow), ChildObj.durations, ChildObj.onLoop);
	ChildObj.offsetx = args.offsetx or 0;
	ChildObj.offsety = args.offsety or 0;
	ChildObj.collision = false;
	ChildObj.followedObject = args.followedObject or nil;
	self.__index = self;
	return setmetatable(ChildObj, self);
end

function Animation:update(dt)
	self.animation:update(dt);
	if self.followedObject ~= nil then
		self.x = self.followedObject.x;
		self.y = self.followedObject.y;
	end
end


function Animation:draw()
	self.animation:draw(self.img, self.x, self.y, nil, 1,1, self.offsetx, self.offsety);
end

return Animation
