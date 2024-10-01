local Object = require("classes.object")
local Asteroid = require("classes.asteroid")
local EventManager = {};

local AsteroidTimer = 1;
local AsteroidInterval = 1;
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


	for i, asteroid in ipairs(Asteroids) do
		asteroid:update(dt);
		if asteroid:checkCollisionObj(Player) then
			if asteroid.speedY ~= 0 then
				GameOver();
			end
		end

		if asteroid.speed == 0 then
			if  asteroid.animation.status == "paused" then
				table.remove(Asteroids, i);
			end
			asteroid.animation:update(dt);
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


return EventManager;
