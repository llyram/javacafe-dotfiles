local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Set Autostart Applications
require("configuration.autostart")

-- Default Applications
terminal = "wezterm"
editor = "neovide"
editor_cmd = editor
browser = "firefox"
filemanager = "nautilus"
discord = "discocss"
launcher = "rofi -show drun"
music = terminal .. " start ncmpcpp --class music"
emoji_launcher = "rofi -show emoji"

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
-- Load the module
local awesome_wallpaper = require("module.awesome-wallpaper")

-- Create the wallpaper instance and set your options
local wallpaper = awesome_wallpaper {

    -- These are all the options available and the default values
    
    -- The background color of the wallpaper
    background_color = beautiful.xbackground,
    -- The colors of the letters in order
    letter_colors = {
        beautiful.xcolor1, beautiful.xcolor2, beautiful.xcolor3, beautiful.xcolor4, beautiful.xcolor5, beautiful.xcolor6,
        beautiful.xcolor7, beautiful.xcolor8, beautiful.xcolor8
    },
    -- The font size
    font_size = 50,
    -- If the letters should be colored in or not
    solid_letters = true,
    -- Letter spacing
    spacing = 15
}

-- Draw the wallpaper
wallpaper:draw_wallpaper()
]]--

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
