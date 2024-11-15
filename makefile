GAME_NAME = Asteroid-Destroyer
BUILD_DIR = builds

GAME_FILES = main.lua vars.lua anim8 classes images sounds

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

.PHONY: all linux windows web clean

all: linux windows web

linux: squashfs-root squashfs-root/bin/love $(BUILD_DIR)/$(GAME_NAME).love
	mkdir -p $(BUILD_DIR)/linux
	cat squashfs-root/bin/love $(BUILD_DIR)/$(GAME_NAME).love > $(BUILD_DIR)/linux/$(GAME_NAME)
	chmod +x $(BUILD_DIR)/linux/$(GAME_NAME)
	cp squashfs-root/* $(BUILD_DIR)/linux -r
	mv $(BUILD_DIR)/linux/$(GAME_NAME) $(BUILD_DIR)/linux/bin
	ln -s bin/$(GAME_NAME) $(BUILD_DIR)/linux/$(GAME_NAME)

windows: $(LOVE_FILES) $(BUILD_DIR)/$(GAME_NAME).love love-win64/love.exe
	mkdir -p $(BUILD_DIR)/windows
	cp $(LOVE_FILES) $(BUILD_DIR)/windows/
	cat love-win64/love.exe $(BUILD_DIR)/$(GAME_NAME).love > $(BUILD_DIR)/windows/$(GAME_NAME).exe
	chmod +x $(BUILD_DIR)/windows/$(GAME_NAME).exe

$(BUILD_DIR)/$(GAME_NAME).love: $(BUILD_DIR) $(GAME_FILES)
	zip -9 -r $(BUILD_DIR)/$(GAME_NAME).love $(GAME_FILES)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
