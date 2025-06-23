local wezterm = require 'wezterm'
local gpus = wezterm.gui.enumerate_gpus()


for _, gpu in ipairs(gpus) do
    if gpu.device_type == 'DiscreteGpu' then
        gpu_preference = gpu
        break
    end
end

return {
	front_end = "WebGpu",
	webgpu_preferred_adapter = gpu_preference,
	webgpu_power_preference = "HighPerformance",

	enable_wayland = false,
	adjust_window_size_when_changing_font_size = true,
	max_fps = 120,
	animation_fps = 1,

	color_scheme = 'Tokyo Night',
	enable_tab_bar = false,
	font_size = 14,
	font = wezterm.font_with_fallback({
		'JetBrains Mono',
		'Noto Color Emoji',
    'Dank Mono'
	}),
  font_shaper = 'Harfbuzz',

	window_background_opacity = 1,
	window_decorations = 'NONE',

	enable_scroll_bar = false,
	scrollback_lines = 1000,
	use_dead_keys = false,
	force_reverse_video_cursor = true,
	term = "wezterm",



}
