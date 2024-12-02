SCREEN_H = 600
SCREEN_W = 400
Vsync = 1

CanPressPause = true;
--UserPause = true;
--AFKPause = false;

ImagesDir = "images/"
PathPlayer = ImagesDir.."spaceship.png"
PathBullet = ImagesDir.."bullet.png"
PathAsteroid = ImagesDir.."asteroid.png"
PathAsteroidDestroy = ImagesDir.."asteroidDestroy.png"--make separate dir for anim?
PathBackground = ImagesDir.."background.png"
PathShield = ImagesDir.."shield.png"

ImagePlayer = love.graphics.newImage(PathPlayer)
ImageBullet = love.graphics.newImage(PathBullet)
ImageAsteroid = love.graphics.newImage(PathAsteroid)
ImageAsteroidDestroy = love.graphics.newImage(PathAsteroidDestroy) --animation separate dir?
ImageBackground = love.graphics.newImage(PathBackground)
ImageShield = love.graphics.newImage(PathShield)

SoundsDir = "sounds/"
SndDestoyAsteroidPath = SoundsDir.."destroy.wav"
SndAttackPath = SoundsDir.."attack.wav"
SndBackgroundMusic = SoundsDir.."The Story Continues.ogg"
MasterSoundLV = 0
BGM = 0
SoundsLv = 0
love.audio.setVolume(MasterSoundLV);
SndDestroy = love.audio.newSource(SndDestoyAsteroidPath, "static");
