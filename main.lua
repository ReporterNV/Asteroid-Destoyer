--[[
--TODO:
--[x] Separate logic in modules
--[x] Update main.lua
--[x] Add new obj for anim death
--[x] Move assets to other dir
--[x] Create event manager:
--[x] add Player event for spawn bullets
--[x] add atr fire speed
--[x] add animation class
--[x] add background
--[ ] add ingame class for windows for menu setting etc
--[ ] control sound
--[ ] add spectre bullet? destroy random asteroid
--[ ] add this?
--function setDefaults(obj, defaults, args)
    for k, v in pairs(defaults) do
        obj[k] = args[k] or v
    end
end
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

	Keys = {};
	OnceKey = {};
	CanPressPause = true;
	Objects = {}; --add for every object callback function?
	Asteroids = {};
	Bullets = {};
	Animations = {};

	Eventmanager = require("classes.eventmanager")
	Object = require("classes.object")
	Background = require("classes.background")
	Animation = require("classes.animation")
	Player = require("classes.player")
	Bullet = require("classes.bullet");

	Eventmanager:init({
		Objects,
		Asteroids,
		Bullets,
		Animations,
		Player
	})

	Background:init();

	Score = 0;

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
		Eventmanager:update(dt)
		Background:update(dt)
	end

	--UpdateTimer = os.clock() - startTimer;
end

--local NeedPrintDBG = true;
function love.draw()
	--local startTimer = os.time();
	Background:draw();

	Player:draw();

	for _, animation in ipairs(Animations) do
		animation:draw();
	end

	for _, bullet in ipairs(Bullets) do
		bullet:draw();
	end

	for _, asteroid in ipairs(Asteroids) do
		asteroid:draw()
	end

	if UserPause or AFKPause then
		love.graphics.printf("PAUSE", SCREEN_W/2-20, SCREEN_H/2-50, 60, "left");
	end

	--[[
	if UserPause or AFKPause then
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
	DrawTimer = os.time() - startTimer;
	love.graphics.printf("LoadTimer: " .. tostring(LoadTimer), 10, 25, 90, "left");
	love.graphics.printf("UpdateTimer: " .. tostring(UpdateTimer), 10, 55, 90, "left");
	love.graphics.printf("DrawTimer: " .. tostring(DrawTimer), 10, 95, 90, "left");
	--]]
end

