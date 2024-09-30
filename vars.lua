SCREEN_H = 600
SCREEN_W = 400

ImagesDir = "images/"
ImagePlayer = ImagesDir.."spaceship.png"
ImageBullet = ImagesDir.."bullet.png"
ImageAsteroid = ImagesDir.."asteroid.png"
ImageAsteroidDestroy = ImagesDir.."asteroidDestroy.png"--make separate dir for anim?
ImageBackground = ImagesDir.."background.png"

SoundsDir = "sounds/"
SndDestoyAsteroidPath = SoundsDir.."destroy.wav"
SndAttackPath = SoundsDir.."attack.wav"

love.audio.setVolume(0.333)
SndDestroy = love.audio.newSource(SndDestoyAsteroidPath, "static");
