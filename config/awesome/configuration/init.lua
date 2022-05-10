local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Set Autostart Applications
require("configuration.autostart")

-- Default Applications
terminal = "wezterm start --always-new-process"
editor = "neovide"
editor_cmd = editor
browser = "firefox"
filemanager = "nautilus"
discord = "discocss"
launcher = "rofi -show drun"
music = terminal .. " start ncmpcpp --class music"
emoji_launcher = "rofi -show emoji"

--[[
require("module.nice") {
  button_size = 15,
  close_color = beautiful.xcolor1,
  minimize_color = beautiful.xcolor2,
  maximize_color = beautiful.xcolor3,
  titlebar_height = 40,
  titlebar_radius = 12,
  titlebar_font = beautiful.font_name .. "9",
  no_titlebar_maximized = true,
  titlebar_items = {
    left = {},
    middle = "title",
    right = {"close", "minimize", "maximize"},
  }
}
]]

-- Global Vars
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"
shift = "Shift"
ctrl = "Control"

-- Set Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        -- bg = beautiful.lighter_bg
        widget = {
            horizontal_fit_policy = "fit",
            vertical_fit_policy = "fit",
            image = beautiful.wallpaper,
            widget = wibox.widget.imagebox
        }
    }
end)

--[[
local wall = require("module.awesome-wallpaper")

local g = require('gears').timer {
    timeout = 0.01,
    call_now = false,
    autostart = true
}

local size = 2
local factor = 1
g:connect_signal("timeout", function()
    if size >= 30 or size <= 1 then factor = factor * -1 end
    wall = wall {font_size = size}
    wall:draw_wallpaper()
    size = size + (1 * factor)
end)
--]]

-- Get Bling Config
require("configuration.bling")

-- Get Keybinds
require("configuration.keys")

-- Get Rules
require("configuration.ruled")

-- Layouts and Window Stuff
require("configuration.window")

-- Scratchpad
require("configuration.scratchpad")
