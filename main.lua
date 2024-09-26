--[[
--TODO:
--[ ] Separate logic in modules
--[ ] Update main.lua
--[ ] Add new obj for anim death
--[x] Move assets to other dir
--[ ] Create event manager:
-- EVENT MANAGER:
-- __________
-- |        | <- Control objects (add, remove)
-- |        | <- Control events (SPAWN NEW ASTEROIDS, collision obj)
-- |        |
-- |        |
-- __________
-- add type object? like type == "asteroid"
--]]

local anim8 = require("anim8.anim8")
local vars = require("vars")
local UserPause = false
local LoadTimer, UpdateTimer, DrawTimer;


function love.load()
	--local startTimer = os.clock();
	love.window.setTitle("Asteroid destroyer");
	love.window.setMode(SCREEN_W, SCREEN_H);
	--require("player.lua")

	Keys = {};
	OnceKey = {};
	CanPressPause = true;
	Object = require("classes.object")

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
		ChildObj.speedX = args.speedX or 0;
		ChildObj.speedY = args.speedY or 0;
		ChildObj.grid = args.grid
		ChildObj.img = args.img or nil;
		ChildObj.frames = args.frames or nil;
		ChildObj.animation = anim8.newAnimation(ChildObj.grid(ChildObj.frames, 1), 0.1, "pauseAtEnd");
		ChildObj.collision = false;
		self.__index = self;
		return setmetatable(ChildObj, self);
	end
	Player = require("classes.player")
	Bullet = require("classes.bullet");
	destroyImg = love.graphics.newImage(ImageAsteroidDestroy);
	destroyGrid = anim8.newGrid(96, 96, destroyImg:getWidth(), destroyImg:getHeight());
	destroyAnim = anim8.newAnimation(destroyGrid('2-8', 1), 0.1, "pauseAtEnd");
	Asteroid = require("classes.asteroid")

	Objects = {}; --add for every object callback function?
	Asteroids = {};
	Bullets = {};
	Animations = {};


	Score = 0;
	AsteroidTimer = 1;
	AsteroidInterval = 1;
	AttackTimer = 0;
	AttackInterval = 0.5;
	--LoadTimer = os.clock() - startTimer;
end

function love.keypressed(key)
	Keys[key] = true;
end

function love.keyreleased(key)
	Keys[key] = false;
end

function love.quit()
	print("GAME OVER");
	print("SCORE: " .. tostring(Score));
end

function love.focus(f)
	if f then
		AFKPause = false;
	else
		AFKPause = true;
	end
end

function love.update(dt)
	--local startTimer = os.clock();
	if Keys["escape"] and CanPressPause then
		UserPause = not UserPause;
		CanPressPause = false;
	elseif Keys["escape"] == false then
		CanPressPause = true;
	end

	if UserPause == false and AFKPause == false then

		Player:update(dt, Keys)

		AsteroidTimer = AsteroidTimer + dt;
		if AsteroidTimer > AsteroidInterval then
			AsteroidTimer = 0;
			Asteroid:spawn();
		end

		for i, asteroid in ipairs(Asteroids) do
			asteroid:update(dt);
			--if checkCollisionObj(Player, asteroid) then
			if asteroid:checkCollisionObj(Player) then
				if asteroid.speedY ~= 0 then
					love.event.quit();
				end
			end

			if asteroid.speed == 0 then
				if  asteroid.animation.status == "paused" then -- use 4 insted of 5 bcz we skip 1 frame.
					table.remove(Asteroids, i);
				end
				asteroid.animation:update(dt);
				-- Use change object. when bullet hit asteroid change asteroid to animated obj?
			end

			if asteroid.speedY ~= 0 then
				for j, bullet in ipairs(Bullets) do
					if asteroid:checkCollisionObj(bullet) then
						Score = Score+1;
						table.remove(Bullets, j);
						asteroid.speedY = 0;
						asteroid.speed = 0;
						asteroid.animation:resume()
						SndDestroy:play();
					end
				end
			end
		end

		for i, bullet in ipairs(Bullets) do
			bullet.y = bullet.y + bullet.speedY*dt;
			if bullet.y < 0 then
				table.remove(Bullets, i);
			end
		end

	end

	--UpdateTimer = os.clock() - startTimer;
end

local NeedPrintDBG = true;
function love.draw()
	--local startTimer = os.time();
	Player:draw();

	for _, bullet in ipairs(Bullets) do
		bullet:draw();
	end


	for _, asteroid in ipairs(Asteroids) do
		asteroid:draw()
	end

	if UserPause or AFKPause then
		love.graphics.printf("PAUSE", SCREEN_W/2-20, SCREEN_H/2-50, 60, "left");
		if NeedPrintDBG == true then
			for i, asteroid in ipairs(Asteroids) do
				print("id:"..i.." X:"..asteroid.x.." Y:"..asteroid.y.." SPEED:".. asteroid.speedY )
			end
			NeedPrintDBG = false
			print("");
		end
	end
	if not (UserPause or AFKPause) then
		NeedPrintDBG = true;
		--os.execute("clear")
	end
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), SCREEN_W - 60, 10);
	love.graphics.printf("SCORE: " .. tostring(Score), 10, 10, 60, "left");
--[[
	DrawTimer = os.time() - startTimer;
	love.graphics.printf("LoadTimer: " .. tostring(LoadTimer), 10, 25, 90, "left");
	love.graphics.printf("UpdateTimer: " .. tostring(UpdateTimer), 10, 55, 90, "left");
	love.graphics.printf("DrawTimer: " .. tostring(DrawTimer), 10, 95, 90, "left");
	--]]
end

