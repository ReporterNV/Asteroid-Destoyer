--[[ TODO:
--General Features
[ ] Sound settings and control
[ ] Add settings saving
[ ] Fix asteroid destruction method
[x] Rewrite vars
[ ] Do base shield mechanic
[ ] Store coordinates in a separate table and use them as references for objects that follow them. --not sure
[ ] Refactor the asteroid object to remove the image link inside every object, keeping only the coordinates and other necessary attributes.
[ ] Move editable variables to a separate table via the menu --not sure
[ ] Clean the code
[ ] use TREE FOR REMOVE Asteroid
[ ] use prepared table for Asteroids instead of change origin table;
[ ] Add normal state instead pause;

Gameplay Features
[ ] Add bullet types (e.g., mines)
[ ] Add shield when not firing
[ ] Add spectre bullets that destroy random asteroids
[ ] Add unbreakable asteroids (with shield rewards) ????
[ ] Add fallen ally ships that should not be destroyed
[ ] Add event when reaching the end of the background
[ ] Add weapon progression
[ ] Add asteroids rotated at 90° and 180°
[ ] Add special interaction when holding fire

--UI
[ ] Improve window appearance
[ ] Rename "Windows" to "WindowList" and add initialization function
[ ] Add update window
--]]

_G.love = love;
--Texture memory: 20172KB
local DEBUG = false; --After use quad it reduced to 20167KB;
local vars = require("vars");

if DEBUG then
	love.profiler = require("libs.profile-2dengine")
	love.frame = 0;
	love.profiler.start();
end



function love.load()
	if DEBUG then
		love.profiler.start();
	end
	vars:init();
	love.window.setTitle("Asteroid destroyer");
	love.window.setMode(vars.config.SCREEN_W, vars.config.SCREEN_H);
	love.window.setVSync(vars.editable.Vsync);

	Keys = {};
	OnceKey = {};
	Objects = {}; --add for every object callback function?
	Asteroids = {};
	Bullets = {};
	Animations = {};

	EventManager = require("classes.eventmanager")
	Pause = require("classes.pause")
	Background = require("classes.background")
	Player = require("classes.player")
	WindowManager = require("classes.window.windowmanager");
	WindowManager:SetActiveWindow(Windows.Start);

	EventManager:init({ --all this object global. Need to change it to local. Add draw manager?
		Objects = Objects,
		Asteroids = Asteroids,
		Bullets = Bullets,
		Animations = Animations,
		Player = Player
	})

	Background:init();

	Score = 0;
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

function love.update(dt)
	if DEBUG then
		love.frame = love.frame + 1
		if love.frame%100 == 0 then
			love.report = love.profiler.report(20)
			print(love.report)
			love.profiler.reset()
		end
	end
	--print(love.report or "Please wait...")
	WindowManager:update(dt, Keys);

	Pause:update(dt, Keys);
	if not Pause:IsOnPause() then
		Player:update(dt, Keys)
		EventManager:update(dt)
		Background:update(dt)
	end
	--collectgarbage("collect");
end

--local NeedPrintDBG = true;
function love.draw()
	--[[Попробовать
	local spriteBatch = love.graphics.newSpriteBatch(asteroidImage, 1000)

	function love.draw()
		spriteBatch:clear()
		for _, asteroid in ipairs(Asteroids) do
			spriteBatch:add(asteroid.x, asteroid.y)
		end
		love.graphics.draw(spriteBatch)
	end
	--]]

	Background:draw();--Узнать про canvas
	Player:draw();

	for _, animation in ipairs(Animations) do
		animation:draw();
	end

	for _, bullet in ipairs(Bullets) do
		bullet:draw();
	end
	local N = vars.config.Asteroids_split;
	for i = 0, N do
		local area = Asteroids[i];
		print(i.."Asteroids: ", area[0]);
		--for _, asteroid in ipairs(area) do
		for j = 1, area[0] do
			--local asteroid_area = Asteroids[i];
			local asteroid = area[j];
			asteroid:draw()
		end
	end
	print("");
	print("");
	for i = 0, N do
		love.graphics.line(vars.config.SCREEN_W / N * i, 0, vars.config.SCREEN_W / N * i, vars.config.SCREEN_H);
	end
	--print("Asteroids: "..#Asteroids);

	if Pause:IsOnPause() then
		love.graphics.printf("PAUSE", vars.config.SCREEN_W/2-20, vars.config.SCREEN_H/2-50, 60, "left");
	end
	if Pause:IsOnPause() then
		WindowManager:draw();
	end

	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), vars.config.SCREEN_W - 60, 10);

	love.graphics.printf("SCORE: " .. tostring(Score), 10, 10, 60, "left");
	local stats = love.graphics.getStats();
	love.graphics.printf("Shield: " .. tostring(Player.Shield), 10, 40, 60, "left");
	if DEBUG then
		love.graphics.print("MEM: " .. collectgarbage("count") .. "KB", 10, 140);
		love.graphics.print("Texture MEM: " ..  stats.texturememory / 1024 .. "KB", 10, 160);
	end
end

