local anim8 = require("anim8.anim8");
local SCREEN_H = 600
local SCREEN_W = 400
local PAUSE = false;

function love.load()
	love.window.setTitle("Asteroid destroyer")
	love.window.setMode(SCREEN_W, SCREEN_H)
	keys = {};

	player = {
		x = 200, 
		y = 500,
		speed = 200,
		img = love.graphics.newImage("spaceship.png")
	}


	asteroids = {}
	bullets = {}

	destroy = love.audio.newSource("destroy.wav", "static")
	attack = love.audio.newSource("attack.wav", "static")
	asteroidImg = love.graphics.newImage("asteroid.png")




	score = 0;
	asteroidTimer = 0
	asteroidInterval = 1
	attackTimer = 0;
	attackInterval = 0.5; 

end

function love.keypressed(key)
	keys[key] = true
end

function love.keyreleased(key)
	keys[key] = false
end

function love.quit()
  print("Спасибо за игру!")
  print("SCORE: " .. tostring(score))
end

function love.focus(f)
	if not f then
		PAUSE = true
	else
		PAUSE = false;
	end
end

function love.update(dt)
	if PAUSE == false then

		-- Move the player's spaceship
		if keys["left"] == true or keys["a"] == true then
			if player.x - player.speed*dt < 0 then
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

		attackTimer = attackTimer + dt
		if attackTimer > attackInterval then
			if keys["space"] == true then
				attackTimer = 0
				NewBullet = {x = player.x, y = player.y, speed = -500, img = love.graphics.newImage("bullet.png")}
				table.insert(bullets, NewBullet);
				attack:play();
			end
		end


		-- Create new asteroids
		asteroidTimer = asteroidTimer + dt
		if asteroidTimer > asteroidInterval then
			asteroidTimer = 0;
			newAsteroid = {x = math.random(0, SCREEN_W-asteroidImg:getWidth()), y = -50, speed = math.random(50, 200), img = asteroidImg}
			table.insert(asteroids, newAsteroid)
		end

		-- Move the asteroids
		for i, asteroid in ipairs(asteroids) do
			asteroid.y = asteroid.y + asteroid.speed*dt
			if asteroid.y > SCREEN_H then
				table.remove(asteroids, i)
				score = score-1;
			end
		end
		for i, bullet in ipairs(bullets) do
			bullet.y = bullet.y + bullet.speed*dt
			if bullet.y > SCREEN_H then
				table.remove(bullet, i)
				score = score-1;
			end
		end



		for i, asteroid in ipairs(asteroids) do
			if checkCollision(player.x, player.y, player.img:getWidth(), player.img:getHeight(), asteroid.x, asteroid.y, asteroid.img:getWidth(), asteroid.img:getHeight()) then
				--love.window.close()
				love.event.quit()
				--love.load()
			end
		end

		for i, asteroid in ipairs(asteroids) do
			for j, bullet in ipairs(bullets) do 
				if checkCollision(bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight(), asteroid.x, asteroid.y, asteroid.img:getWidth(), asteroid.img:getHeight()) then
					score = score+1;
					table.remove(bullets, j)
					table.remove(asteroids, i)
					destroy:play();
				end
			end
		end
	end
end

function love.draw()
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), SCREEN_W - 60, 10)
	love.graphics.print("X: " .. tostring(player.x), 10, 30)
	love.graphics.print("Y: " .. tostring(player.y), 10, 50)
	love.graphics.printf("SCORE: " .. tostring(score), 10, 10, 60, "left")

	if PAUSE == true then
		love.graphics.printf("PAUSE", SCREEN_W/2-20, SCREEN_H/2-50, 60, "left");
	end

	-- Draw the player's spaceship

	love.graphics.setColor(0, 1, 0) -- set color to red
	love.graphics.rectangle("line", player.x, player.y, player.img:getWidth(), player.img:getHeight())
	love.graphics.setColor(1, 1, 1) -- set color to red

	love.graphics.draw(player.img, player.x, player.y)

	for i, bullet in ipairs(bullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end

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

function love.quit()
  print("Спасибо за игру!")
  print("SCORE: " .. tostring(score))
end
