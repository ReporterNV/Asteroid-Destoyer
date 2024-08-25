local anim8 = require("anim8.anim8")
local SCREEN_H = 600
local SCREEN_W = 400
local UserPause = false

local function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
	x2 < x1+w1 and
	y1 < y2+h2 and
	y2 < y1+h1
end

function love.load()
	love.window.setTitle("Asteroid destroyer");
	love.window.setMode(SCREEN_W, SCREEN_H);

	Keys = {};
	OnceKey = {};
	CanPressPause = true;
	SoundsDir = "sounds/"
	SndDestoyAsteroidPath = SoundsDir.."destroy.wav"
	SndAttackPath = SoundsDir.."attack.wav"

	Object = {
		x = 0,
		y = 0,
		w = 0,
		h = 0,
		speedX = 0,
		speedY = 0,
		img = nil,
	}
	function Object:new(args)
		ChildObj = {}
		ChildObj.x = args.x or 0;
		ChildObj.y = args.y or 0;
		ChildObj.w = args.w or 0;
		ChildObj.h = args.h or 0;
		ChildObj.speedX = args.speedX or 0;
		ChildObj.speedY = args.speedY or 0;
		ChildObj.img = args.img or nil;
		self.__index = self;
		return setmetatable(ChildObj, self);
	end
	Player = Object:new({x = 200, y = 500, speedX = 200, speedY = 100});
	Player.img = love.graphics.newImage("spaceship.png");
--[[
	Player = {
		x = 200, 
		y = 500,
		speed = 200,
		img = love.graphics.newImage("spaceship.png");
	}
	--]]

	asteroids = {};
	bullets = {};

	SndDestroy = love.audio.newSource(SndDestoyAsteroidPath, "static");
	attack = love.audio.newSource(SndAttackPath, "static");
	love.audio.setVolume(0.333)

	asteroidImg = love.graphics.newImage("asteroid.png");

	destroyImg = love.graphics.newImage("asteroidDestroy.png");
	destroyGrid = anim8.newGrid(96, 96, destroyImg:getWidth(), destroyImg:getHeight());
	destroyAnim = anim8.newAnimation(destroyGrid('2-5', 1), 0.06, "pauseAtEnd");

	Score = 0;
	AsteroidTimer = 0;
	AsteroidInterval = 1;
	AttackTimer = 0;
	AttackInterval = 0.5;
end

function love.keypressed(key)
	Keys[key] = true;
--[[
	OnceKey[key].prev = OnceKey[key].curr;
	OnceKey[key].curr = true;
	--]]
end

function love.keyreleased(key)
	Keys[key] = false;
end

function love.quit()
  print("GAME OVER");
  print("SCORE: " .. tostring(Score));
end

function love.focus(f)
	if not f then
		AFKPause = true;
	else
		AFKPause = false;
	end
end

function love.update(dt)
	if Keys["escape"] and CanPressPause then
		UserPause = not UserPause;
		CanPressPause = false;
	elseif Keys["escape"] == false then
		CanPressPause = true;
	end

	--[[
	if Keys["escape"] then
		UserPause = not UserPause;
		Keys["escape"] = false; --bad code pattern
	end
	--]]

	if UserPause == false and AFKPause == false then

		if Keys["left"] == true or Keys["a"] == true then
			if Player.x - Player.speedX*dt < 0 then
				Player.x = 0;
			else
				Player.x = Player.x - Player.speedX*dt;
			end
		end

		if Keys["right"] == true or Keys["d"] == true then
			if Player.x + Player.speedX*dt > SCREEN_W - Player.img:getWidth() then
				Player.x = SCREEN_W - Player.img:getWidth();
			else
				Player.x = Player.x + Player.speedX*dt;
			end
		end

		if Keys["up"] == true or Keys["w"] == true then
			if Player.y - Player.speedY*dt < 0 then
				Player.y = 0;
			else
				Player.y = Player.y - Player.speedY*dt;
			end
		end

		if Keys["down"] == true or Keys["s"] == true then
			if Player.y + Player.speedY*dt + Player.img:getHeight() > SCREEN_H then
				Player.y = SCREEN_H - Player.img:getHeight();
			else
				Player.y = Player.y + Player.speedY*dt;
			end
		end

		AttackTimer = AttackTimer + dt;
		if AttackTimer > AttackInterval then
			if Keys["space"] == true then
				AttackTimer = 0;
				NewBullet = {
					speed = -500,
					img = love.graphics.newImage("bullet.png"),
				};
				NewBullet.x = Player.x + Player.img:getWidth()/2 - NewBullet.img:getWidth()/2;
				NewBullet.y = Player.y;
				table.insert(bullets, NewBullet);
				attack:play();
			end
		end

		AsteroidTimer = AsteroidTimer + dt;
		if AsteroidTimer > AsteroidInterval then
			AsteroidTimer = 0;
			NewAsteroid = {
				x = math.random(0, SCREEN_W - asteroidImg:getWidth()),
				y = -50,
				speed = math.random(50, 200),
				img = asteroidImg
			};
			table.insert(asteroids, NewAsteroid);
		end

		for i, asteroid in ipairs(asteroids) do
			asteroid.y = asteroid.y + asteroid.speed*dt;

			if asteroid.y > SCREEN_H then
				love.event.quit();
			end

			if checkCollision(Player.x,
				Player.y,
				Player.img:getWidth(),
				Player.img:getHeight(),
				asteroid.x,
				asteroid.y,
				asteroid.img:getWidth(),
				asteroid.img:getHeight()
				) then
				love.event.quit();
			end

			if asteroid.speed == 0 then
				if  asteroid.prevframe == 4 then -- use 4 insted of 5 bcz we skip 1 frame.
					table.remove(asteroids, i);
				end
			-- Use change object. when bullet hit asteroid change asteroid to animated obj?
				asteroid.prevframe = asteroid.anim.position;
				asteroid.anim:update(dt);
			end

			if asteroid.speed ~= 0 then
				for j, bullet in ipairs(bullets) do
					if checkCollision ( --rewrite this to 2 obj
						bullet.x,
						bullet.y,
						bullet.img:getWidth(),
						bullet.img:getHeight(),
						asteroid.x,
						asteroid.y,
						asteroid.img:getWidth(),
						asteroid.img:getHeight()
						) then
					Score = Score+1;
					table.remove(bullets, j);
					asteroid.speed = 0;
					asteroid.timer = 0;
					asteroid.anim = destroyAnim:clone();
					asteroid.anim.looping = false;
					SndDestroy:play();
					end
				end
			end
		end


		for i, bullet in ipairs(bullets) do
			bullet.y = bullet.y + bullet.speed*dt;
			if bullet.y < 0 then
				table.remove(bullets, i);
			end
		end

	end

end

function love.draw()

	love.graphics.draw(Player.img, Player.x, Player.y);

	for i, bullet in ipairs(bullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y);
	end

	for i, asteroid in ipairs(asteroids) do
		if asteroid.speed == 0 then
			--This const from image for sync size asteroid and SndDestroyasset.
			asteroid.anim:draw(destroyImg, asteroid.x-29, asteroid.y-32);
		else
			love.graphics.draw(asteroid.img, asteroid.x, asteroid.y);
		end
	end

	if UserPause or AFKPause then
		love.graphics.printf("PAUSE", SCREEN_W/2-20, SCREEN_H/2-50, 60, "left");
	end
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), SCREEN_W - 60, 10);
	love.graphics.printf("SCORE: " .. tostring(Score), 10, 10, 60, "left");
end

