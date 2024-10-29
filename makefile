#this should be cmd for make exe.
#this for future rn i dont need it
GAME_NAME = Asteroid-Destroyer
BUILD_DIR = builds

LOVE_FILES_DIR = love-win64
LOVE_REQUIRES = SDL2.dll \
    OpenAL32.dll\
    license.txt\
    love.dll\
    lua51.dll\
    mpg123.dll\
    msvcp120.dll\
    msvcr120.dll

LOVE_FILES = $(addprefix $(LOVE_FILES_DIR)/, $(LOVE_REQUIRES))

windows: $(GAME_NAME).exe $(BUILD_DIR)/windows $(LOVE_FILES)
	cp $(LOVE_FILES) $(BUILD_DIR)/windows/




$(GAME_NAME).exe: $(BUILD_DIR)/$(GAME_NAME).love $(BUILD_DIR)/windows love-win64/love.exe
	cat love-win64/love.exe $(BUILD_DIR)/$(GAME_NAME).love > $(BUILD_DIR)/windows/$(GAME_NAME).exe


$(BUILD_DIR)/$(GAME_NAME).love: main.lua vars.lua $(BUILD_DIR) anim8 classes images sounds
	zip -9 -r $(BUILD_DIR)/$(GAME_NAME).love main.lua vars.lua anim8 classes images sounds

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/windows:
	mkdir -p $(BUILD_DIR)/windows

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
