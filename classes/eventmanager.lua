require("vars")
local Object = require("classes.object")
local Asteroid = require("classes.asteroid")
local Animation = require("classes.animation")
local Bullet = require("classes.bullet")
local EventManager = {};

local AsteroidTimer = 1;
local AsteroidInterval = 0.0001;

local Objects;
local Asteroids;
local Bullets;
local Animations;
local Player;

function EventManager:init(args)
	args = args or {};
	Objects = args.Objects or {};
	Asteroids = args.Asteroids or {};
	Bullets = args.Bullets or {};
	Animations = args.Animations or Animations;
	Player = args.Player;
end

function SpawnAsteroid()

end

function GameOver()
	love.event.quit();
end

function EventManager:generateShield()
	table.insert(Animations, Animation:spawn({type = "ShieldUp", followedObject = Player}))
end

function EventManager:playerShoot()
	local NewBullet = Bullet:spawn();
	table.insert(Bullets, NewBullet)
end

function EventManager:update(dt)
	for _, animation in ipairs(Animations) do
		if animation.animation.status == "paused" then
			table.remove(Animations, _)
		end
		animation:update(dt);
	end
	for i = #Asteroids, 1, -1 do
		local asteroid = Asteroids[i]
		asteroid:update(dt);
		if asteroid:checkCollisionObj(Player) then
			Player:takeHit();
			table.remove(Asteroids, i);
			table.insert(Animations, Animation:spawn({type = "AsteroidDestroy", x = asteroid.x, y = asteroid.y}))
		elseif asteroid.y > SCREEN_H then
			table.remove(Asteroids, i);
		end
	end

	for i = #Bullets, 1, -1 do
		local bullet = Bullets[i];
		bullet.y = bullet.y + bullet.speedY*dt;

		if bullet.y + bullet.h < 0 then
			table.remove(Bullets, i);
		else
			for j, asteroid in ipairs(Asteroids) do
				if asteroid:checkCollisionObj(bullet) then
					Score = Score + 1;
					if asteroid.destroySound ~= nil then
						asteroid.destroySound:play();
					end
					local anim = Animation:spawn({
						type = "AsteroidDestroy",
						x = asteroid.x,
						y = asteroid.y,
					})

					table.insert(Animations, anim);
					table.remove(Asteroids, j)
					table.remove(Bullets, i)
					break;
				end
			end
		end
	end
	AsteroidTimer = AsteroidTimer + dt;

	if AsteroidTimer >= AsteroidInterval then
		--Spawn depend on FPS. Should i fix it?
		AsteroidTimer = 0;
		table.insert(Asteroids, Asteroid:spawn())
	end
end


return EventManager;
