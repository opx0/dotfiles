local wezterm = require 'wezterm'
local gpus = wezterm.gui.enumerate_gpus()
--
--if os.getenv("XDG_CURRENT_DESKTOP") == "Hyprland" then
--	config.enable_wayland = false
--else
--	config.enable_wayland = true
--end
return {
	enable_wayland = false,
	-- color_scheme = 'termnial.sexy',
	color_scheme = 'Catppuccin Mocha',
	enable_tab_bar = false,
	font_size = 13.0,
	font = wezterm.font('JetBrainsMono Nerd Font'),
	-- window_background_image = '/Users/omerhamerman/Downloads/3840x1080-Wallpaper-041.jpg',
	-- window_background_image_hsb = {
	-- 	brightness = 0.01,
	-- 	hue = 1.0,
	-- 	saturation = 0.5,
	-- },
	-- window_background_opacity = 0.92,
	window_background_opacity = 1.0,
	-- window_background_opacity = 0.78,
	-- window_background_opacity = 0.20,
	window_decorations = 'RESIZE',
	keys = {
		{
			key = 'f',
			mods = 'CTRL',
			action = wezterm.action.ToggleFullScreen,
		},
	},
	mouse_bindings = {
	  -- Ctrl-click will open the link under the mouse cursor
	  {
	    event = { Up = { streak = 1, button = 'Left' } },
	    mods = 'CTRL',
	    action = wezterm.action.OpenLinkAtMouseCursor,
	  },
	},
	-- Spawn a tmux  in login mode
	--default_prog = { "tmux",'-l'} --big flaw:> creating new session but it should attach 
}
