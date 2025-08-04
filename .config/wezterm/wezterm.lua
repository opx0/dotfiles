local wezterm = require 'wezterm'

-- GPU Selection with error handling
local function select_gpu()
    local success, gpus = pcall(wezterm.gui.enumerate_gpus)
    if not success or not gpus then
        wezterm.log_warn('Failed to enumerate GPUs, falling back to default')
        return nil
    end

    for _, gpu in ipairs(gpus) do
        if gpu.device_type == 'DiscreteGpu' then
            wezterm.log_info('Selected discrete GPU: ' .. (gpu.name or 'Unknown'))
            return gpu
        end
    end

    wezterm.log_warn('No discrete GPU found, using default')
    return nil
end

local gpu_preference = select_gpu()

-- Configuration with consistent formatting
local config = {}

-- Graphics settings
if gpu_preference then
    config.front_end = "WebGpu"
    config.webgpu_preferred_adapter = gpu_preference
    config.webgpu_power_preference = "HighPerformance"
else
    config.front_end = "OpenGL" -- Fallback
end

-- Window and display settings
config.enable_wayland = false
config.adjust_window_size_when_changing_font_size = true
config.max_fps = 120
config.animation_fps = 1
config.window_background_opacity = 1.0
config.window_decorations = 'NONE'

-- Appearance
config.color_scheme = 'Tokyo Night'
config.enable_tab_bar = false

-- Font configuration
config.font_size = 14
config.font = wezterm.font_with_fallback({
    'JetBrains Mono',
    'Noto Color Emoji',
    'Dank Mono',
})
config.font_shaper = 'Harfbuzz'

-- Terminal behavior
config.enable_scroll_bar = false
config.scrollback_lines = 1000
config.use_dead_keys = false
config.force_reverse_video_cursor = true
config.term = "wezterm"

config.window_padding = {
  left = 1,
  right = 1,
  top = 1,
  bottom = 0,
}

return config
