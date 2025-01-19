local vars = require("vars")
local Asteroid = require("classes.asteroid")
local Animation = require("classes.animation")
local Bullet = require("classes.bullet")
local EventManager = {};
local screen_h = vars.config.SCREEN_H;
local screen_w = vars.config.SCREEN_W;

local AsteroidTimer = 1;
local AsteroidInterval = 1/4000;
--81 при 1000
--8 при 10000

local Objects = {};
local Asteroids = {};
local Bullets = {};
local Animations = {};

local Asteroids_areas_number = vars.config.Asteroids_split;
local Asteroids_area_max_elem = vars.config.Asteroids_split_max;
local function Asteroids_spliter(Asteroids)
	--[[
	How this works. Split screen to N sectors. 
	The bigger objet should be fully sized in one sector.
	If not make sector bigger. or update it separately.
	--]]
	for i = 0, Asteroids_areas_number do
		Asteroids[i] = {};
		Asteroids[i][0] = 0;
		for j = 1, Asteroids_areas_number do
			Asteroids[i][j] = nil;
		end
	end
end
local function Asteroids_clear_table(area)
	print("Asteroids_clear_table");
	local NewTable = {};
	local size = 0;
	for i = 1, Asteroids_area_max_elem do
		if area[i] ~= nil then
			size = size + 1;
			NewTable[size] = area[i];
		end
	end
	print("size: ", size);
	NewTable[0] = size;
	return NewTable;
end

--use subscribe
function EventManager:init(args)
	args = args or {};
	Bullets = args.Bullets or Bullets;
	Asteroids = args.Asteroids or Asteroids;
	Asteroids_spliter(Asteroids);
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
	--[[
	function EventManager:generateShield()
		self:trigger("generateShield", {type = "ShieldUp", followedObject = Player})
	end
	--]]
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
		local asteroid;
		if math.random(1, 1) == 1 then
 			asteroid = Asteroid:spawn();
		else
 			asteroid = Asteroid:spawn("strong");
		end

		local area_index = math.floor(asteroid.x / (screen_w / Asteroids_areas_number));
		local area = Asteroids[area_index];
		local area_size = area[0] + 1
		area[0] = area_size;
		area[area_size] = asteroid;
		if area_size > Asteroids_area_max_elem then
			local clear_table = Asteroids_clear_table(area);
			area = nil;
			Asteroids[area_index] = clear_table;
			--print("new area_size: ", area[0]);
		end

		--print("asteroid.x: ", asteroid.x);
		--print("area_index: ", area_index);
		--table.insert(Asteroids[area_index], asteroid)
		--table.insert(Asteroids, Asteroid:spawn())
	end

	for i = #Animations, 1, -1 do
		local animation = Animations[i];
		if animation.animation.status == "paused" then
			table.remove(Animations, i)
		end
		animation:update(dt);
	end

	--for _, asteroid_area in ipairs(Asteroids) do
	for i = 0, Asteroids_areas_number do
		local area = Asteroids[i];
		local area_size = area[0];
		for j = area_size, 1, -1 do
			local asteroid = area[j]
			if asteroid ~= nil then
				asteroid:update(dt);
				if asteroid:checkCollisionObj(Player) then
					Player:takeHit();
					--table.remove(asteroid_area, i);
					table.insert(Animations, Animation:spawn({type = "ShieldBreak", followedObject = Player}))
					table.insert(Animations, Animation:spawn({type = "AsteroidDestroy", x = asteroid.x, y = asteroid.y}))
					area[j] = nil;
				elseif asteroid.y > screen_h then
					--table.remove(asteroid_area, i); --reuse instead of remove
					area[j] = nil;
					--set speedY = 0 and y = 0 - self.h
				end
			end
		end
	end

	for i = #Bullets, 1, -1 do
		local bullet = Bullets[i];
		bullet.y = bullet.y + bullet.speedY*dt;

		if bullet.y + bullet.h < 0 then
			table.remove(Bullets, i);
		else
			--local area_index = math.floor(bullet.x / (screen_w / Asteroids_areas_number));
			local area = Asteroids[bullet.area_index];
			local area_size = area[0];
			for j = area_size, 1, -1 do
				local asteroid = area[j];
				if asteroid ~= nil then
					if asteroid:checkCollisionObj(bullet) then
						Score = Score + 1;
						if asteroid.destroySound ~= nil then
							asteroid.destroySound:play();
						end
						table.insert(Animations, Animation:spawn({type = "AsteroidDestroy", x = asteroid.x, y = asteroid.y}));
						--table.remove(asteroids, j)
						area[j] = nil;
						table.remove(Bullets, i)
						break;
					end
				end
			end
		end
	end
end

return EventManager;
