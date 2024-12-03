require("vars")
local Object = require("classes.object")
local Asteroid = require("classes.asteroid")
local Animation = require("classes.animation")
local Bullet = require("classes.bullet")
local EventManager = {};

local AsteroidTimer = 1;
local AsteroidInterval = 0.1;
Objects = {};
Asteroids = {};
Bullets = {};
Animations = {};

function EventManager:init(args)
	if args == nil then
		args = {};
	end
end

function SpawnAsteroid()

end

function GameOver()
	love.event.quit();
end

function EventManager:playerShoot()
	NewBullet = Bullet:spawn();
	table.insert(Bullets, NewBullet)
end

function EventManager:update(dt)
	AsteroidTimer = AsteroidTimer + dt;

	if AsteroidTimer > AsteroidInterval then
		AsteroidTimer = 0;
		Asteroid:spawn();
	end

	for _, animation in ipairs(Animations) do
		if animation.animation.status == "paused" then
			table.remove(Animations, _)
		end
		animation:update(dt);
	end

	for i, asteroid in ipairs(Asteroids) do
		asteroid:update(dt);
		if asteroid:checkCollisionObj(Player) then
			Player:takeHit();
			table.remove(Asteroids, i);
			DestroyAnimation = Animation:new({
				img = ImageAsteroidDestroy,
				frameW = 96,
				frameH = 96,
				frames = {'2-8', 1},
				durations = 0.08,
				x = asteroid.x,
				y = asteroid.y,
				offsetx = 29,
				offsety = 32,
				onLoop = "pauseAtEnd",
			})

			table.insert(Animations, DestroyAnimation)
		end

		if asteroid.y > SCREEN_H then
			table.remove(Asteroids, i);
		end

		if asteroid.speedY ~= 0 then
			for j, bullet in ipairs(Bullets) do
				if asteroid:checkCollisionObj(bullet) then
					Score = Score + 1;
					Player.Shield = Player.Shield + 1;
					if asteroid.destroySound ~= nil then
						asteroid.destroySound:play();
					end
					DestroyAnimation = Animation:new({
						img = ImageAsteroidDestroy,
						frameW = 96,
						frameH = 96,
						frames = {'2-8', 1},
						durations = 0.08,
						x = asteroid.x,
						y = asteroid.y,
						offsetx = 29,
						offsety = 32,
						onLoop = "pauseAtEnd",
					})
					table.insert(Animations, DestroyAnimation)
					table.remove(Asteroids, i);
					table.remove(Bullets, j);
				end
			end
		end
	end

	for i, bullet in ipairs(Bullets) do
		bullet.y = bullet.y + bullet.speedY*dt;
		if bullet.y + bullet.h < 0 then
			table.remove(Bullets, i);
		end
	end
end


return EventManager;
