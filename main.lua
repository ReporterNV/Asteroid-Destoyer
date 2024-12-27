--[[
--TODO:
--[ ] setting + control sound
--[ ] Try fix animatio
--[ ] fix SCORE count multiple times when player shoot fast
--[ ] add bullet type like mine?
--[ ] add event after reach end of background 
--[ ] add progress in weapon
--[ ] unbreakable asteroid(but for shield they will be add as reward if player find it)
--[ ] add spectre bullet? destroy random asteroid
--[ ] make windows looks better
--[ ] fix asteroid destroy method
--[ ] add ally fallen ships which one we should not destroy bcz pilots inside still alive
--[ ] add asteroids rotated on 90 and 180 ^0?
--[ ] move relaod bar in other class for not recalc percent. just calc once and then step by step add delta?
--[x] Need rewrite animation for rows. bcz need takes args in (...) format.
--[ ] rename Windows in WindowList; add function for init them
--[ ] add special interation when hold fire
--[ ] add shield if dont fire?
--[ ] add settings save
--[ ] rewrite vars
--[ ] fix reload bar if reload time is small
--[ ] Fix coord in separate table and use it as link on table for followed object
--[ ] REMAKE TODO LIST 
--[ ] FIX ASTEROID OBJECT. Dont need keep link for image inside every object. Bcz need keep coord and other diff attr.
--[ ] add this object type ? like type == "asteroid"
--[ ] move editable vars by menu in separate table?
--[ ] CLEAN CODE!!!!! 
--]]

_G.love = love;
local DEBUG = true; --Texture memory: 20172KB
if DEBUG then
	FUNC_TIME = {}
end
require("vars")
local LoadTimer, UpdateTimer, DrawTimer;


function love.load()
	if DEBUG == true then
		StartTimer = os.clock();
	end
	love.window.setTitle("Asteroid destroyer");
	love.window.setMode(SCREEN_W, SCREEN_H);
	love.window.setVSync(Vsync);

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
	Animation = require("classes.animation");
	--Animation:init();
	WindowManager = require("classes.window.windowmanager");
	WindowManager:SetActiveWindow(Windows.Start);

	--Animation = require("classes.animation")
	--Bullet = require("classes.bullet");

	EventManager:init({
		["Objects"] = Objects,
		["Asteroids"] = Asteroids,
		["Bullets"] = Bullets,
		["Animations"] = Animations,
		["Player"] = Player,
		--Bullets,
		--Animations,
	})

	Background:init();

	Score = 0;
	if DEBUG == true then
		LoadTimer = os.clock() - StartTimer;
	end
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

	local res_max = 0;
function love.update(dt)
	if DEBUG == true then
		StartTimer = os.clock();
	end
	WindowManager:update(dt, Keys);

	Pause:update(dt, Keys);
	if not Pause:IsOnPause() then
		Player:update(dt, Keys)
		local start_tick = GetCPUCycles();
		EventManager:update(dt)
		local end_tick = GetCPUCycles();
		local result = end_tick - start_tick;
		print("Load time: "..Ticks_in_form(string.format(tostring(result))));
		if result > (res_max or 0) then
			res_max = result
		end
		print("Max: "..tostring(res_max));
		Background:update(dt)
		--[[
		-]]
	end
	collectgarbage("collect");
--[[
		for name, val in pairs(FUNC_TIME) do
			print(name..": "..val);
		end
--]]
	if DEBUG ==true then
		UpdateTimer = os.clock() - StartTimer;
	end

end

--local NeedPrintDBG = true;
function love.draw()
	if DEBUG == true then
		StartTimer = os.time();
	end
	Background:draw();

	for _, bullet in ipairs(Bullets) do
		bullet:draw();
	end

	Player:draw();

	for _, animation in ipairs(Animations) do
		animation:draw();
	end

	for _, asteroid in ipairs(Asteroids) do
		asteroid:draw()
	end

	--print("Animation: "..#Animations);

	if Pause:IsOnPause() then
		love.graphics.printf("PAUSE", SCREEN_W/2-20, SCREEN_H/2-50, 60, "left");
	end

	if Pause:IsOnPause() then
		WindowManager:draw();
	end

	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), SCREEN_W - 60, 10);

	--uncomment if need dbg. ADD DBG MODE?
	love.graphics.printf("SCORE: " .. tostring(Score), 10, 10, 60, "left");
	local stats = love.graphics.getStats();
	love.graphics.printf("Shield: " .. tostring(Player.Shield), 10, 40, 60, "left");
	--
	if DEBUG ~= true then
		love.graphics.print("MEM: " .. collectgarbage("count") .. "KB", 10, 140);
		love.graphics.print("Texture MEM: " ..  stats.texturememory / 1024 .. "KB", 10, 160);
		DrawTimer = os.time() - StartTimer;
		love.graphics.printf("LoadTimer: " .. tostring(LoadTimer), 10, 25, 90, "left");
		love.graphics.printf("UpdateTimer: " .. tostring(UpdateTimer), 10, 55, 90, "left");
		love.graphics.printf("DrawTimer: " .. tostring(DrawTimer), 10, 95, 90, "left");
	end
end

