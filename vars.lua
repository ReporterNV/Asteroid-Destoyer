SCREEN_H = 600
SCREEN_W = 400
Vsync = 1

CanPressPause = true;
--UserPause = true;
--AFKPause = false;

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
