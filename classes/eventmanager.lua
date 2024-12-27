require("vars")
local Object = require("classes.object")
local Asteroid = require("classes.asteroid")
local Animation = require("classes.animation")
local Bullet = require("classes.bullet")
local EventManager = {};

local AsteroidTimer = 1;
local AsteroidInterval = 0.0001;

local Objects;
local ObjectsL;
local Asteroids;
local AsteroidsL;
local Bullets;
local BulletsL;
local Animations;
local AnimationsL;
local Player;

function EventManager:init(args)
	args = args or {};
	Objects = args.Objects or {};
	Asteroids = args.Asteroids or {};
	AsteroidsL = #Asteroids;
	Bullets = args.Bullets or {};
	BulletsL = #Bullets;
	Animations = args.Animations or Animations;
	AnimationsL = #Animations;
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
	--table.insert(Bullets, NewBullet)
	Bullets[BulletsL] = NewBullet;
	BulletsL = BulletsL + 1;
end

function EventManager:update(dt)
	local name = Print_table_method(self);
	AsteroidTimer = AsteroidTimer + dt;

	if AsteroidTimer > AsteroidInterval then
		--Spawn depend on FPS. Should i fix it?
		AsteroidTimer = 0;
		--table.insert(Asteroids, Asteroid:spawn())
		Asteroids[AsteroidsL+1] = Asteroid:spawn()
		AsteroidsL = AsteroidsL + 1;
	end

	for _, animation in ipairs(Animations) do
		if animation.animation.status == "paused" then
			table.remove(Animations, _)
		end
		animation:update(dt);
	end
	--avg fps 400
	for i = #Asteroids, 1, -1 do
		local asteroid = Asteroids[i]
		asteroid:update(dt);
		if asteroid:checkCollisionObj(Player) then
			Player:takeHit();
			--table.remove(Asteroids, i);
			if i ~= AsteroidsL then
				Asteroids[i] = Asteroids[AsteroidsL];
			end

			Asteroids[AsteroidsL] = nil;
			AsteroidsL = AsteroidsL - 1;

			table.insert(Animations, Animation:spawn({type = "AsteroidDestroy", x = asteroid.x, y = asteroid.y}))

		elseif asteroid.y > SCREEN_H then
			if i ~= AsteroidsL then
				Asteroids[i] = Asteroids[AsteroidsL];
			end

			Asteroids[AsteroidsL] = nil;
			AsteroidsL = AsteroidsL - 1;
			--table.remove(Asteroids, i);
		end
	end

	for i = BulletsL, 1, -1 do
		local bullet = Bullets[i];
		if bullet == nil then
			print("leng: "..BulletsL);
			print("i: "..i)
		else
			bullet.y = bullet.y + bullet.speedY*dt;

			if bullet.y + bullet.h < 0 then
				--table.remove(Bullets, i); --change it for "optimization". but this break order but ok; bcz instead i take almost x4 profit in tick
				--[ [
				if i ~= BulletsL then
					Bullets[i] = Bullets[BulletsL];
				end
				Bullets[BulletsL] = nil;
				BulletsL = BulletsL - 1;
				--]]
				--[ [
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

						if j ~= AsteroidsL then --not sure if need do it.
							Asteroids[j] = Asteroids[AsteroidsL];
						end

						Asteroids[AsteroidsL] = nil;
						AsteroidsL = AsteroidsL - 1;	
						--table.remove(Asteroids, j)


						--table.remove(Bullets, i) --sorry but i need profit
						if i ~= BulletsL then
							Bullets[i] = Bullets[BulletsL];
						end
						Bullets[BulletsL] = nil;
						BulletsL = BulletsL - 1;
						break;
					end
				end
			end
			--]]
		end
	end
end

return EventManager;
