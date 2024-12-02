SCREEN_H = 600
SCREEN_W = 400
Vsync = 1

CanPressPause = true;
--UserPause = true;
--AFKPause = false;

ImagesDir = "images/"
ImagePlayer = ImagesDir.."spaceship.png"
ImageBullet = ImagesDir.."bullet.png"
ImageAsteroid = ImagesDir.."asteroid.png"
ImageAsteroidDestroy = ImagesDir.."asteroidDestroy.png"--make separate dir for anim?
ImageBackground = ImagesDir.."background.png"
ImageShield = ImagesDir.."shield.png"

SoundsDir = "sounds/"
SndDestoyAsteroidPath = SoundsDir.."destroy.wav"
SndAttackPath = SoundsDir.."attack.wav"
SndBackgroundMusic = SoundsDir.."The Story Continues.ogg"
MasterSoundLV = 0
BGM = 0
SoundsLv = 0
love.audio.setVolume(MasterSoundLV);
SndDestroy = love.audio.newSource(SndDestoyAsteroidPath, "static");
