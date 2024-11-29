--[[
--TODO:
--[ ] setting + control sound
--[ ] add event after reach end of background 
--[ ] add progress in weapon
--[x] fix bullet remove early. only after they leave screen. not remove after top left screen.
--[ ] add spectre bullet? destroy random asteroid
--[ ] make windows looks better
--[ ] add ally fallen ships which one we should not destroy bcz pilots inside still alive
--[x] add reload bar
--[ ] move relaod bar in other class for not recalc percent. just calc once and then step by step add delta?
--[ ] Need rewrite animation for rows. bcz need takes args in (...) format.
--[ ] rename Windows in WindowList; add function for init them
--[ ] add special interation when hold fire
--[ ] add shield if dont fire?
--[ ] add settings save
--[ ] fix reload bar if reload time is small
--[ ] check fps problem; UPD: looks like mem problem; maybe dont remove animation?
--[ ] Now if spawnrate lower then update game will spawn asteroid with spawnrate. Need fix it?
--[x] fix double enter for WindowManager
--[x] add option for back to prev window;
--[x] add build for windows and linux
--[ ] add this object type ? like type == "asteroid"
--[ ] move editable vars by menu in separate table?
--]]

_G.love = love;
require("vars")
local LoadTimer, UpdateTimer, DrawTimer;


function love.load()
	--local startTimer = os.clock();
	love.window.setTitle("Asteroid destroyer");
	love.window.setMode(SCREEN_W, SCREEN_H);
	love.window.setVSync(0);

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

	--Animation = require("classes.animation")
	--Bullet = require("classes.bullet");

	EventManager:init({
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

function love.update(dt)
	--local startTimer = os.clock();
	--StartMenu:update(dt, Keys);
	WindowManager:update(dt, Keys);

	Pause:update(dt, Keys);
	if not Pause:IsOnPause() then
		Player:update(dt, Keys)
		EventManager:update(dt)
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


	if Pause:IsOnPause() then
		love.graphics.printf("PAUSE", SCREEN_W/2-20, SCREEN_H/2-50, 60, "left");
	end

	WindowManager:draw();

	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), SCREEN_W - 60, 10);
	--uncomment if need dbg. ADD DBG MODE?
	--love.graphics.print("MEM: " .. collectgarbage("count") .. "KB", 10, 40);
	love.graphics.printf("SCORE: " .. tostring(Score), 10, 10, 60, "left");

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
	DrawTimer = os.time() - startTimer;
	love.graphics.printf("LoadTimer: " .. tostring(LoadTimer), 10, 25, 90, "left");
	love.graphics.printf("UpdateTimer: " .. tostring(UpdateTimer), 10, 55, 90, "left");
	love.graphics.printf("DrawTimer: " .. tostring(DrawTimer), 10, 95, 90, "left");
	--]]
end

