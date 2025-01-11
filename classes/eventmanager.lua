local vars = require("vars")
local Asteroid = require("classes.asteroid")
local Animation = require("classes.animation")
local Bullet = require("classes.bullet")
local EventManager = {};
local screen_h = vars.config.SCREEN_H;

local AsteroidTimer = 1;
local AsteroidInterval = 1/10;

local Objects = {};
local Asteroids = {};
local Bullets = {};
local Animations = {};

--use subscribe
function EventManager:init(args)
	args = args or {};
	Bullets = args.Bullets or Bullets;
	Asteroids = args.Asteroids or Asteroids;
	Animations = args.Animations or Animations;
	Objects = args.Objects or Objects;
	Asteroid:init();
end
--Реализовать возможность подписки на события
function SpawnAsteroid()

end

local listeners = {};
function EventManager:subscribe(event, callback) --not sure if i need it
	if listeners[event] == nil then
		listeners[event] = {};
	end
	table.insert(listeners[event], callback);
end
function EventManager:unsubscribe(event, callback)
	if listeners[event] == nil then
		return;
	end
	for i, listener in ipairs(listeners[event]) do
		if listener == callback then
			table.remove(listeners[event], i);
			return;
		end
	end
end
function EventManager:trigger(event, ...)
	if listeners[event] == nil then
		return;
	end
	for _, listener in ipairs(listeners[event]) do
		listener(...);
	end
end

function GameOver()
	love.event.quit();
end

function EventManager:generateShield()
	print("Call generateShield");
 	--change it to subscribe and allow only one played animation?
	table.insert(Animations, Animation:spawn({type = "ShieldUp", followedObject = Player}))
end

function EventManager:playerShoot()
	NewBullet = Bullet:spawn();
	table.insert(Bullets, NewBullet)
end

function EventManager:update(dt)
	AsteroidTimer = AsteroidTimer + dt;
	while AsteroidTimer >= AsteroidInterval do --change it back?
		AsteroidTimer = AsteroidTimer - AsteroidInterval;
		if math.random(0, 1) == 1 then
			table.insert(Asteroids, Asteroid:spawn("strong"))
		else
			table.insert(Asteroids, Asteroid:spawn())
		end
		--table.insert(Asteroids, Asteroid:spawn())
	end

	for i = #Animations, 1, -1 do
		local animation = Animations[i];
		if animation.animation.status == "paused" then
			table.remove(Animations, i)
		end
		animation:update(dt);
	end

	for i = #Asteroids, 1, -1 do
		local asteroid = Asteroids[i]
		asteroid:update(dt);
		if asteroid:checkCollisionObj(Player) then
			Player:takeHit();
			table.remove(Asteroids, i);
			table.insert(Animations, Animation:spawn({type = "ShieldBreak", followedObject = Player}))
			table.insert(Animations, Animation:spawn({type = "AsteroidDestroy", x = asteroid.x, y = asteroid.y}))
		elseif asteroid.y > screen_h then
			table.remove(Asteroids, i); --reuse instead of remove
			--set speedY = 0 and y = 0 - self.h
		end
	end

	for i = #Bullets, 1, -1 do
		local bullet = Bullets[i];
		bullet.y = bullet.y + bullet.speedY*dt;

		if bullet.y + bullet.h < 0 then
			table.remove(Bullets, i);
		else
			for j = #Asteroids, 1, -1 do --looks like O(n^2) change it to ?collision tree? slice screen and calculate only in that area
				local asteroid = Asteroids[j];
				if asteroid:checkCollisionObj(bullet) then
					Score = Score + 1;
						if asteroid.destroySound ~= nil then
							asteroid.destroySound:play();
						end
						table.insert(Animations, Animation:spawn({type = "AsteroidDestroy", x = asteroid.x, y = asteroid.y}));
						table.remove(Asteroids, j)
						table.remove(Bullets, i)
						break;
				end
			end
		end
	end
end

return EventManager;
