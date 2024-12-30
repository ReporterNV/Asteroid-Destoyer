require("vars")
local anim8 = require("libs.anim8.anim8")
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
		durations = {0.08},
		offsetx = 29,
		offsety = 32,
		scalex = 1,
		scaley = 1,
		onLoop = "pauseAtEnd",
	}, -- i WANT REWRITE THIS AAGAIN!!!!!
	["ShieldUp"] =  {
		img = ImageShield,
		imgAlpha = 0.6,
		frameW = 480,
		frameH = 480,
		frames = {'1-5', '1-2', '1-2', 3},
		durations = {0.1},
		scalex = 0.11,
		scaley = 0.11,
		onLoop = function (self)
			self.position = #self.frames
			self.timer = self.totalDuration
			self.status = "stoped"
		end,
		callbacks = {
			{"setOffsetCenterObject", {w = ImagePlayer:getWidth(), h = ImagePlayer:getHeight()}},
			--{"setOffsetCenterObject", Player},
		},
		["ShieldDown"] = {
			img = ImageShield,
			imgAlpha = 0.6,
			frameW = 480,
			frameH = 480,
			frames = {3, '1-2', '1-2', '1-5'},
		}
	}
}

local Animation = Object:new({})

function Animation:init() --should be called after object for follow
	for key, value in pairs(AnimationDescription) do
		local grid = anim8.newGrid(value.frameW, value.frameH, value.img:getWidth(), value.img:getHeight())
		local animation = anim8.newAnimation(grid(unpack(value.frames)), unpack(value.durations), value.onLoop);
		AnimationList[key] = {
			img = value.img,
			animation = animation,
			frameW = value.frameW,
			frameH = value.frameH,
			offsetx = value.offsetx or 0,
			offsety = value.offsety or 0,
			scalex = value.scalex or 1,
			scaley = value.scaley or 1,
		}
		if value.callbacks ~= nil then
			for _, callbackName in ipairs(value.callbacks) do
				Animation[callbackName[1]](AnimationList[key],unpack(value.callbacks[2]))
			end
		end

	end
end

local function FromDescriptionToAnimation(AnimationType)
	local desc = AnimationDescription[AnimationType]
	if type(desc) ~= "table" then --add check other attr
		error("Need set animation in AnimationDescription before call it")
		return; --why i use return here?
	end
	local grid = anim8.newGrid(desc.frameW, desc.frameH, desc.img:getWidth(), desc.img:getHeight()) --rewrite it on already exist table
	local animation = anim8.newAnimation(grid(unpack(desc.frames)), unpack(desc.durations), desc.onLoop);
	local NewAnimation = Animation:new({
		img = desc.img,
		imgAlpha = desc.imgAlpha or nil,
		frameW = desc.frameW,
		frameH = desc.frameH,
		animation = animation,
		scalex = desc.scalex or 1,
		scaley = desc.scaley or 1,
		offsetx = desc.offsetx or 0,
		offsety = desc.offsety or 0,
	})

	NewAnimation:setWHfromFrameWithScale();
	if type(desc.callbacks) == "table" then
		for _, callback in ipairs(desc.callbacks)
			do
				NewAnimation[callback[1]](NewAnimation, unpack(callback, 2))
			end
	end
	AnimationList[AnimationType] = NewAnimation;
	return AnimationList[AnimationType];
end

function Animation:spawn(args)
	args = args or error("Animation:spawn used with nil args. Args should have: type=\"animName\", x and y or followedObject!")

	if (args.x == nil or args.y == nil) and args.followedObject == nil then
		error("x and y or followed object not set");
		return --why i use return here?
	end

	if type(AnimationList[args.type]) ~= "table" then
		print("Warning: Animation not exist!");
		FromDescriptionToAnimation(args.type); --rewrite with using preset without use description?
	end

	--[[local desc = AnimationDescription[args.type];
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
	--]]
	local ret = AnimationList[args.type];
	--print(AnimationList[args.type].offsetx);
	--print("offsetx: "..ret.offsetx);
	--print("offsety: "..ret.offsety);
	if args.followedObject ~= nil then
		ret.x = args.followedObject.x;
		ret.y = args.followedObject.y;
		ret.followedObject = args.followedObject;
	else
		ret.x = args.x;
		ret.y = args.y;
	end
	ret.animation = AnimationList[args.type].animation:clone();
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
	FollowedObject = FollowedObject or self.followedObject
	if FollowedObject == nil then
		error("Animation:setOffsetCenterObject Object for Center is nil");
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
		--love.drawmode()
		if self.imgAlpha ~= nil then --bcz idk how much time need for love.graphics.setColor so better do it once
			love.graphics.setColor(1, 1, 1, self.imgAlpha)
			self.animation:draw(self.img, self.x, self.y, nil, self.scalex,self.scaley, self.offsetx, self.offsety);
			love.graphics.setColor(1, 1, 1, 5)
		else
			self.animation:draw(self.img, self.x, self.y, nil, self.scalex,self.scaley, self.offsetx, self.offsety);
		end
	end
end

return Animation
