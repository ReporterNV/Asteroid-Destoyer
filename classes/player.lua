print("Hi from player.lua")
local Object = require("classes.object")
Player = Object:new({
	x = 200,
	y = 500,
	speedX = 200,
	speedY = 100,
	img = love.graphics.newImage(ImagePlayer);
});
Player:setWHfromImage();

function Player:draw()
	love.graphics.draw(Player.img, Player.x, Player.y);
end

function Player:update(dt, Keys)

		if Keys["left"] == true or Keys["a"] == true then
			if Player.x - Player.speedX*dt < 0 then
				Player.x = 0;
			else
				Player.x = Player.x - Player.speedX*dt;
			end
		end

		if Keys["right"] == true or Keys["d"] == true then
			if Player.x + Player.speedX*dt > SCREEN_W - Player.w then
				Player.x = SCREEN_W - Player.w;
			else
				Player.x = Player.x + Player.speedX*dt;
			end
		end

		if Keys["up"] == true or Keys["w"] == true then
			if Player.y - Player.speedY*dt < 0 then
				Player.y = 0;
			else
				Player.y = Player.y - Player.speedY*dt;
			end
		end

		if Keys["down"] == true or Keys["s"] == true then
			if Player.y + Player.speedY*dt + Player.h > SCREEN_H then
				Player.y = SCREEN_H - Player.h;
			else
				Player.y = Player.y + Player.speedY*dt;
			end
		end

		AttackTimer = AttackTimer + dt;
		if AttackTimer > AttackInterval then
			if Keys["space"] == true then
				AttackTimer = 0;
				NewBullet = Bullet:spawn();
			end
		end


end



return Player
