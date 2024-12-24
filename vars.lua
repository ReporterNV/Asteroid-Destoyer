SCREEN_H = 600
SCREEN_W = 400
Vsync = 1

CanPressPause = true;
--UserPause = true;
--AFKPause = false;

function Print_func_name()
	local info = debug.getinfo(2,"n")
	if info and info.name then
		--print(info.name);
		return(info.name);
	end
end

function Print_table_name(table)
	for name, pointer in pairs(_G) do
		if pointer == table then
			--print(name);
			return name;
		end
	end
end

ImagesDir = "images/"
PathPlayer          = ImagesDir .. "spaceship.png"
PathBullet          = ImagesDir .. "bullet.png"
PathAsteroid        = ImagesDir .. "asteroid.png"
PathAsteroidDestroy = ImagesDir .. "asteroidDestroy.png"--make separate dir for anim?
PathBackground      = ImagesDir .. "background.png"
PathShield          = ImagesDir .. "shield.png"

ImagePlayer          = love.graphics.newImage(PathPlayer)
ImageBullet          = love.graphics.newImage(PathBullet)
ImageAsteroid        = love.graphics.newImage(PathAsteroid)
ImageAsteroidDestroy = love.graphics.newImage(PathAsteroidDestroy) --animation separate dir?
ImageBackground      = love.graphics.newImage(PathBackground)
ImageShield          = love.graphics.newImage(PathShield)

SoundsDir = "sounds/"
PathDestoyAsteroid  = SoundsDir .. "destroy.wav"
PathAttack          = SoundsDir .. "attack.wav"
PathBackgroundMusic = SoundsDir .. "The Story Continues.ogg"

SndDestoyAsteroid     = love.audio.newSource(PathDestoyAsteroid, "static");
SndAttack             = love.audio.newSource(PathAttack, "static");
SndBackgroundMusic    = love.audio.newSource(PathBackgroundMusic, "stream");



MasterSoundLV = 0
BGM = 0
SoundsLv = 0
love.audio.setVolume(MasterSoundLV);
