local anim8 = require("anim8.anim8")
local SCREEN_H = 600
local SCREEN_W = 400
local PAUSE = false

function love.load()
	love.window.setTitle("Asteroid destroyer");
	love.window.setMode(SCREEN_W, SCREEN_H);
	keys = {};

	player = {
		x = 200, 
		y = 500,
		speed = 200,
		img = love.graphics.newImage("spaceship.png");
	}

	asteroids = {};
	bullets = {};

	destroy = love.audio.newSource("destroy.wav", "static");
	attack = love.audio.newSource("attack.wav", "static");
	love.audio.setVolume(0.5);

	asteroidImg = love.graphics.newImage("asteroid.png");

	destroyImg = love.graphics.newImage("asteroidDestroy.png");
	destroyGrid = anim8.newGrid(96, 96, destroyImg:getWidth(), destroyImg:getHeight());
	destroyAnim = anim8.newAnimation(destroyGrid('2-5', 1), 0.06, "pauseAtEnd");

	score = 0;
	asteroidTimer = 0;
	asteroidInterval = 1;
	attackTimer = 0;
	attackInterval = 0.5; 
end

function love.keypressed(key)
	keys[key] = true;
end

function love.keyreleased(key)
	keys[key] = false;
end

function love.quit()
  print("GAME OVER");
  print("SCORE: " .. tostring(score));
end

function love.focus(f)
	if not f then
		PAUSE = true;
	else
		PAUSE = false;
	end
end

function love.update(dt)
	if PAUSE == false then

		if keys["left"] == true or keys["a"] == true then
			if player.x - player.speed*dt < 0 then
				player.x = 0;
			else
				player.x = player.x - player.speed*dt;
			end
		end

		if keys["right"] == true or keys["d"] == true then
			if player.x + player.speed*dt > SCREEN_W - player.img:getWidth() then
				player.x = SCREEN_W - player.img:getWidth();
			else
				player.x = player.x + player.speed*dt;
			end
		end

		if keys["up"] == true or keys["w"] == true then
			if player.y - player.speed*dt < 0 then
				player.y = 0;
			else
				player.y = player.y - player.speed*dt;
			end
		end

		if keys["down"] == true or keys["s"] == true then
			if player.y + player.speed*dt + player.img:getHeight() > SCREEN_H then
				player.y = SCREEN_H - player.img:getHeight();
			else
				player.y = player.y + player.speed*dt;
			end
		end

		attackTimer = attackTimer + dt;
		if attackTimer > attackInterval then
			if keys["space"] == true then
				attackTimer = 0;
				NewBullet = {x = player.x, y = player.y, speed = -500, img = love.graphics.newImage("bullet.png")};
				table.insert(bullets, NewBullet);
				attack:play();
			end
		end

		asteroidTimer = asteroidTimer + dt;
		if asteroidTimer > asteroidInterval then
			asteroidTimer = 0;
			newAsteroid = {x = math.random(0, SCREEN_W-asteroidImg:getWidth()), y = -50, speed = math.random(50, 200), img = asteroidImg};
			table.insert(asteroids, newAsteroid);
		end

		for i, asteroid in ipairs(asteroids) do
			asteroid.y = asteroid.y + asteroid.speed*dt;

			if asteroid.y > SCREEN_H then
				table.remove(asteroids, i);
				love.event.quit();
			end

			if checkCollision(player.x, player.y, player.img:getWidth(), player.img:getHeight(), asteroid.x, asteroid.y, asteroid.img:getWidth(), asteroid.img:getHeight()) then
				love.event.quit();
			end	

			if asteroid.speed == 0 then
				if  asteroid.prevframe == 4 then -- use 4 insted of 5 bcz we skip 1 frame.
					table.remove(asteroids, i);
				end

				asteroid.prevframe = asteroid.anim.position;
				asteroid.anim:update(dt);
			end

			if asteroid.speed ~= 0 then
				for j, bullet in ipairs(bullets) do 
					if checkCollision(bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight(),
							  asteroid.x, asteroid.y, asteroid.img:getWidth(), asteroid.img:getHeight()) then
						
						score = score+1;
						table.remove(bullets, j);
						asteroid.speed = 0;
						asteroid.timer = 0;
						asteroid.anim = destroyAnim:clone();
						asteroid.anim.looping = false;
	
						destroy:play();
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
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), SCREEN_W - 60, 10);
	love.graphics.print("X: " .. tostring(player.x), 10, 30);
	love.graphics.print("Y: " .. tostring(player.y), 10, 50);
	love.graphics.printf("SCORE: " .. tostring(score), 10, 10, 60, "left");

	if PAUSE == true then
		love.graphics.printf("PAUSE", SCREEN_W/2-20, SCREEN_H/2-50, 60, "left");
	end

	love.graphics.draw(player.img, player.x, player.y);

	for i, bullet in ipairs(bullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y);
	end

	for i, asteroid in ipairs(asteroids) do
		if asteroid.speed == 0 then
			--This const from image for sync size asteroid and destroy asset.
			asteroid.anim:draw(destroyImg, asteroid.x-29, asteroid.y-32);
		else
			love.graphics.draw(asteroid.img, asteroid.x, asteroid.y);
		end
	end
end

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
	x2 < x1+w1 and
	y1 < y2+h2 and
	y2 < y1+h1
end

