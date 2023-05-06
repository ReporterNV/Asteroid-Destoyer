local anim8 = require ("anim8.anim8")
SCREEN_H = 600
SCREEN_W = 400
PAUSE = false;
SCORE = 0;

function love.load()
	-- Initialize the player's spaceship and asteroids
	SCORE = 0;
	player = {
		x = 200, 
		y = 500,
		speed = 200,
		img = love.graphics.newImage("spaceship.png")
	}
	obj = {
		x = 0,
		y = 0,
		speed = 0,
		img_name = "",
		image = "",
		Grid,
		CurrentAnim,
		Anim = {},
		look;
	}

	RedHood = obj;
	RedHood.speed = 100;
	RedHood.img_name = "RedHood.png";
	RedHood.image = love.graphics.newImage(RedHood.img_name);
	RedHood.Grid = anim8.newGrid(112, 133, RedHood.image:getWidth(), RedHood.image:getHeight())
	
	RedHood.Anim.all = anim8.newAnimation(RedHood.Grid('1-12', '1-11'), 0.05);
	RedHood.CurrentAnim = RedHood.Anim.all

	asteroids = {}
	asteroidTimer = 0
	asteroidInterval = 2
	keys = {};
	-- Set up the game window
	love.window.setTitle("Asteroid Dodge")
	love.window.setMode(SCREEN_W, SCREEN_H)


	--Create Grid

end

function love.keypressed(key)
	keys[key] = true
end

function love.keyreleased(key)
	keys[key] = false
end

function love.focus(f)
	if not f then
		print("ФОКУС ПОТЕРЯН")
		PAUSE = true
	else
		print("ФОКУС ПОЛУЧЕН")
		PAUSE = false;
	end
end

function love.update(dt)
	if PAUSE == false then

		RedHood.CurrentAnim:update(dt)
		-- Move the player's spaceship

		if keys["q"] == true then
			RedHoodAnim:flipH();
		end

		if keys["left"] == true or keys["a"] == true then
			--if player.x - player.speed*dt < 0 then
			if checkCollision( player.x, player.y, player.img:getWidth(), player.img:getHeight(), 0,0, 1, SCREEN_H) then
				player.x = 0
			else
				player.x = player.x - player.speed*dt
			end
		end

		if keys["right"] == true or keys["d"] == true then
			if player.x + player.speed*dt > SCREEN_W - player.img:getWidth() then
				player.x = SCREEN_W - player.img:getWidth()
			else
				player.x = player.x + player.speed*dt
			end
		end

		if keys["up"] == true or keys["w"] == true then
			if player.y - player.speed*dt < 0 then
				player.y = 0
			else
				player.y = player.y - player.speed*dt
			end
		end

		if keys["down"] == true or keys["s"] == true then
			if player.y + player.speed*dt + player.img:getHeight() > SCREEN_H then
				player.y = SCREEN_H - player.img:getHeight()
			else
				player.y = player.y + player.speed*dt
			end
		end

		-- Create new asteroids
		asteroidTimer = asteroidTimer + dt
		if asteroidTimer > asteroidInterval then
			asteroidTimer = 0
			newAsteroid = {x = math.random(0, 400), y = -50, speed = math.random(50, 200), img = love.graphics.newImage("asteroid.png")}
			table.insert(asteroids, newAsteroid)
		end

		-- Move the asteroids
		for i, asteroid in ipairs(asteroids) do
			asteroid.y = asteroid.y + asteroid.speed*dt
			if asteroid.y > 600 then
				table.remove(asteroids, i)
				SCORE = SCORE+10000;
			end
		end

		-- Check for collisions between the player's spaceship and asteroids
		for i, asteroid in ipairs(asteroids) do
			if checkCollision(player.x, player.y, player.img:getWidth(), player.img:getHeight(), asteroid.x, asteroid.y, asteroid.img:getWidth(), asteroid.img:getHeight()) then
				love.load()
			end
		end
		-- Check for collisions between the player's spaceship and asteroids
		for i, asteroid in ipairs(asteroids) do
			if checkCollision(player.x, player.y, player.img:getWidth(), player.img:getHeight(), asteroid.x, asteroid.y, asteroid.img:getWidth(), asteroid.img:getHeight()) then
				love.load()
			end
		end
	end
end

function love.draw()
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), SCREEN_W - 60, 10)
	love.graphics.print("X: " .. tostring(player.x), 10, 30)
	love.graphics.print("Y: " .. tostring(player.y), 10, 50)
	love.graphics.printf("SCORE: " .. tostring(SCORE), 10, 10, 60, "left")
	RedHood.CurrentAnim:draw(RedHood.image, RedHood.x, RedHood.y);

	if PAUSE == true then
		love.graphics.printf("PAUSE", SCREEN_W/2-20, SCREEN_H/2-50, 60, "left");
	end

	-- Draw the player's spaceship
	
	love.graphics.setColor(0, 1, 0) -- set color to red
	love.graphics.rectangle("line", player.x, player.y, player.img:getWidth(), player.img:getHeight())
	love.graphics.setColor(1, 1, 1) -- set color to red
	love.graphics.draw(player.img, player.x, player.y)

	-- Draw the asteroids
	for i, asteroid in ipairs(asteroids) do
		love.graphics.setColor(0, 1, 0) -- set color to red
		love.graphics.rectangle("line", asteroid.x, asteroid.y, asteroid.img:getWidth(), asteroid.img:getHeight())
		love.graphics.setColor(1, 1, 1) -- set color to red
		love.graphics.draw(asteroid.img, asteroid.x, asteroid.y)
	end
end

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
	x2 < x1+w1 and
	y1 < y2+h2 and
	y2 < y1+h1
end
