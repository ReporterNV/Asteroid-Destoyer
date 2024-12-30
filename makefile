GAME_NAME = Asteroid-Destroyer
BUILD_DIR = builds
DEPS_DIR = deps

GAME_FILES = main.lua vars.lua libs/anim8 classes images sounds

WINDOWS_DEPENDENCIES = SDL2.dll \
    OpenAL32.dll \
    license.txt \
    love.dll \
    lua51.dll \
    mpg123.dll \
    msvcp120.dll \
    msvcr120.dll

LOVE_FILES_WINDOWS = $(addprefix $(DEPS_DIR)/love-win64/, $(WINDOWS_DEPENDENCIES))
LOVE_FILES_LINUX = $(DEPS_DIR)/squashfs-root
LOVE_JS = $(DEPS_DIR)/node_modules/.bin/love.js

.PHONY: all linux windows web deps clean

all: linux windows web

linux: $(LOVE_FILES_LINUX) love
	mkdir -p $(BUILD_DIR)/linux
	cat $(DEPS_DIR)/squashfs-root/bin/love $(BUILD_DIR)/$(GAME_NAME).love > $(BUILD_DIR)/linux/$(GAME_NAME)
	chmod +x $(BUILD_DIR)/linux/$(GAME_NAME)
	cp -r $(DEPS_DIR)/squashfs-root/* $(BUILD_DIR)/linux
	mv $(BUILD_DIR)/linux/$(GAME_NAME) $(BUILD_DIR)/linux/bin
	ln -s bin/$(GAME_NAME) $(BUILD_DIR)/linux/$(GAME_NAME)

windows: $(LOVE_FILES_WINDOWS) $(DEPS_DIR)/love-win64/love.exe love
	mkdir -p $(BUILD_DIR)/windows
	cp $(LOVE_FILES_WINDOWS) $(BUILD_DIR)/windows/
	cat $(DEPS_DIR)/love-win64/love.exe $(BUILD_DIR)/$(GAME_NAME).love > $(BUILD_DIR)/windows/$(GAME_NAME).exe
	chmod +x $(BUILD_DIR)/windows/$(GAME_NAME).exe

web: $(LOVE_JS) love
	mkdir -p $(BUILD_DIR)/web
	$(LOVE_JS) -c $(BUILD_DIR)/$(GAME_NAME).love $(BUILD_DIR)/web
	#python -m http.server 8000

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

love: $(BUILD_DIR) $(GAME_FILES)
	zip -9 -r $(BUILD_DIR)/$(GAME_NAME).love $(GAME_FILES)

clean:
	rm -rf $(BUILD_DIR)
