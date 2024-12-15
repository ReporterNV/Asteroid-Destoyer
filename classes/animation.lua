require("vars")
local anim8 = require("anim8.anim8")
local Object = require("classes.object")
if table.unpack then
	unpack = table.unpack
end
--old better perf: 6a690650a9f62f583d0be0fda271beec977eec0a
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
		scalex = 1,
		scaley = 1,
		onLoop = "pauseAtEnd",
	},
	["ShieldUp"] =  {
		img = ImageShield,
		frameW = 480,
		frameH = 480,
		frames = {'1-5', '1-4'},
		durations = 0.08,
		scalex = 0.1,
		scaley = 0.1,
		onLoop = "pauseAtEnd",
		callbacks = {"setOffsetCenterObject","setWHfromFrameWithScale"};
	}
}

local Animation = Object:new({})

function Animation:init() --should be called after object for follow

	for key, value in pairs(AnimationDescription) do
		local grid = anim8.newGrid(value.frameW, value.frameH, value.img:getWidth(), value.img:getHeight())
		local animation = anim8.newAnimation(grid(unpack(value.frames)), value.durations, value.onLoop);
		AnimationList[key] = {
			img = value.img,
			animation = animation,
			offsetx = value.offsetx or 0,
			offsety = value.offsety or 0,
			scalex = value.scalex or 1,
			scaley = value.scaley or 1,
		}
		if value.callbacks ~= nil then
			
		end

	end


end

function Animation:fromDescriptionToAnimation(AnimationType)
	local desc = AnimationDescription[AnimationType]
	if type(desc) ~= "table" then
		error("Need set animation in AnimationDescription before call it")
		return;
	end
	local grid = anim8.newGrid(desc.frameW, desc.frameH, desc.img:getWidth(), desc.img:getHeight()) --rewrite it on already exist table
	local animation = anim8.newAnimation(grid(unpack(desc.frames)), desc.durations, desc.onLoop);
	AnimationList[AnimationType] = animation;
	return AnimationList[AnimationType];
end

function Animation:spawn(args)
	args = args or error("Animation:spawn used with nil args. Args should have: type=\"animName\", x and y or followedObject!")

	if (args.x == nil or args.y == nil) and args.followedObject == nil then
		error("x and y or followed object not set");
		return
	end

	if type(AnimationList[args.type]) ~= "table" then
		print("Anaimtion not exist!");
		Animation:fromDescriptionToAnimation(args.type); --rewrite with using preset without use description?
	end

	local desc = AnimationDescription[args.type];
	local ret = {
		img = desc.img,
		x = args.x,
		y = args.y,
		followedObject = args.followedObject,
		animation = AnimationList[args.type]:clone(),
		offsetx = desc.offsetx or 0,
		offsety = desc.offsety or 0,
		scalex = desc.scalex or 1,
		scaley = desc.scaley or 1,
	};
	return Animation:new(ret);
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
	if FollowedObject == nil then
		if Animation.followedObject ~= nil then
			FollowedObject = self.followedObject;
		else
			error("Animation:setOffsetCenterObject Object for Center is nil");
		end
	end
	if self.w ~= nil then
		self.offsetx = (self.w - FollowedObject.w) / 2 / self.scalex;
	end

	if self.h ~= nil then
		self.offsety = (self.h - FollowedObject.h) / 2 / self.scaley;
	end
end


function Animation:update(dt)
	if self.followedObject ~= nil then
		self.x = self.followedObject.x;
		self.y = self.followedObject.y;
	end

	if self.animation then
		self.animation:update(dt);
	end
end


function Animation:draw()
	if self.animation then
		self.animation:draw(self.img, self.x, self.y, nil, self.scalex,self.scaley, self.offsetx, self.offsety);
	end
end

return Animation
