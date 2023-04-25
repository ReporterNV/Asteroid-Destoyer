SCREEN_H = 600
SCREEN_W = 400
PAUSE = false;

function love.load()
   -- Initialize the player's spaceship and asteroids
   player = {x = 200, y = 500, speed = 300, img = love.graphics.newImage("spaceship.png")}
   asteroids = {}
   asteroidTimer = 0
   asteroidInterval = 2
   keys = {};
   -- Set up the game window
   love.window.setTitle("Asteroid Dodge")
   love.window.setMode(SCREEN_W, SCREEN_H)
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
   
	-- Move the player's spaceship
   if love.keyboard.isDown("left") and player.x > 0 then
      player.x = player.x - player.speed*dt
   end
   if love.keyboard.isDown("right") and player.x < 300 then
      player.x = player.x + player.speed*dt
   end
   if love.keyboard.isDown("up") and player.y > 0 then
      player.y = player.y - player.speed*dt
   end
   if love.keyboard.isDown("down") then
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
   -- Draw the player's spaceship
   love.graphics.draw(player.img, player.x, player.y)

   -- Draw the asteroids
   for i, asteroid in ipairs(asteroids) do
      love.graphics.draw(asteroid.img, asteroid.x, asteroid.y)
   end
end

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
   return x1 < x2+w2 and
          x2 < x1+w1 and
          y1 < y2+h2 and
          y2 < y1+h1
end
