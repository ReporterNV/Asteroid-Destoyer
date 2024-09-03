#this should be cmd for make exe.
#this for future rn i dont need it
game.exe: zip -9 -r SuperGame.love .
	zip -9 -r SuperGame.love . && cat love.exe SuperGame.love > SuperGame.exe
