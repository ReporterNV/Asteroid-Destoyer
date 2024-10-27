local WindowManager = require("classes.windowmanager");
--local Pause = require("classes.pause");
local option = {};


function option.ExitGame()
	love.event.quit();
end

function option.Resume()
	WindowManager:RemoveActiveWindow();
	local Pause = (require("classes.pause")):Resume(); --i don't like this solution
	--Pause:Resume()
end

function option.ToggleVisible(args)
	args.window.visible = not args.window.visible;
end

function option.CloseAllWindows()
	WindowManager:RemoveActiveWindow();
end

function option.OpenPreviousWindow()
	WindowManager:BackToPreviousWindow();
end

function option.slider()
	WindowManager:slider();
end


function option.updateVolume()
	love.audio.setVolume(MasterSoundLV);
end



function option.OpenWindow(args)
	if args.window == nil then
		print("OpenWindow: ERROR! Expected window got nil")
		return;
	end
	if args.NewWindow == nil then
		print("Mistake. Forget set NewWindow in args for OpenWindow")
		return;
	end

	WindowManager:SetActiveWindow(args.NewWindow);
end


function option.ERROR()
	print("ERROR! ERROR in window system! options not set!");
end

return option;
