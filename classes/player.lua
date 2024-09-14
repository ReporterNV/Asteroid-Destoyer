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
return Player
