local vars = {};

local ImagesDir = "images/"
local SoundsDir = "sounds/"
local path = {
	["image"] = {
		Player     = ImagesDir .. "spaceship.png";
		Bullet     = ImagesDir .. "bullet.png";
		Asteroid   = ImagesDir .. "asteroidDestroy.png"; --make separate dir for anim?
		Shield     = ImagesDir .. "shield.png";
		Background = ImagesDir .. "background.png";
	};
	["audio"]= {
		DestroyAsteroid  = SoundsDir .. "destroy.wav";
		Attack           = SoundsDir .. "attack.wav";
		BackgroundMusic  = SoundsDir .. "The Story Continues.ogg";
	};
};

vars.config = {
	SCREEN_H = 600;
	SCREEN_W = 400;
	Asteroids_split = 3;
	Asteroids_split_max = 2000--20000
}

vars.editable = {
	MasterSoundLV = 0;
	BGM = 0;
	SoundsLv = 0;
	Vsync = 1;
}

CanPressPause = true;

--UserPause = true;
--AFKPause = false;
function vars:init()
	love.window.setMode(self.config.SCREEN_W, self.config.SCREEN_H, {vsync = Vsync});
	love.graphics.setDefaultFilter("nearest", "nearest");
	love.mouse.setVisible(true);

	vars.image = { --if use same name maybe should update to function and generate table by name;
		Player          = love.graphics.newImage(path.image.Player);
		Bullet          = love.graphics.newImage(path.image.Bullet);
		Asteroid        = love.graphics.newImage(path.image.Asteroid); --animation separate dir?
		Background      = love.graphics.newImage(path.image.Background);
		Shield          = love.graphics.newImage(path.image.Shield);
	};
	vars.quad = {
		QuadAsteroid    = love.graphics.newQuad(0, 0, 96, 96, self.image.Asteroid:getDimensions());
	};
	vars.audio = {
		DestoyAsteroid     = love.audio.newSource(path.audio.DestroyAsteroid, "static");
		Attack             = love.audio.newSource(path.audio.Attack, "static");
		BackgroundMusic    = love.audio.newSource(path.audio.BackgroundMusic, "stream");
	};
	love.audio.setVolume(vars.editable.MasterSoundLV);
end

return vars;
