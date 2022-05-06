local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local ruled = require("ruled")
local dpi = xresources.apply_dpi

local playerctl = require("module.bling").signal.playerctl.lib()

local art = wibox.widget {
    image = gears.filesystem.get_configuration_dir() .. "images/no_music.png",
    resize = true,
    forced_height = dpi(250),
    widget = wibox.widget.imagebox
}

local create_button = function(symbol, color, command, playpause)

    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        font = beautiful.icon_font_name .. "20",
        align = "center",
        valigin = "center",
        widget = wibox.widget.textbox()
    }

    local button = wibox.widget {
        icon,
        forced_height = dpi(40),
        forced_width = dpi(40),
        bg = beautiful.xcolor0 .. 55,
        shape = gears.shape.squircle,
        widget = wibox.container.background
    }

    playerctl:connect_signal("playback_status", function(_, playing, _)
        if playpause then
            if playing then
                icon.markup = helpers.colorize_text("", color)
            else
                icon.markup = helpers.colorize_text("", color)
            end
        end
    end)

    button:buttons(gears.table.join(
                       awful.button({}, 1, function() command() end)))

    button:connect_signal("mouse::enter", function()
        icon.markup = helpers.colorize_text(icon.text, beautiful.xforeground)
    end)

    button:connect_signal("mouse::leave", function()
        icon.markup = helpers.colorize_text(icon.text, color)
    end)

    return button
end

-- Get Song Info
playerctl:connect_signal("metadata", function(_, _, _, art_path, _, _, _)
    -- Set art widget
    art:set_image(gears.surface.load_uncached(art_path))
end)

local play_command = function() playerctl:play_pause() end
local prev_command = function() playerctl:previous() end
local next_command = function() playerctl:next() end

local playerctl_play_symbol = create_button("", beautiful.xcolor4,
                                            play_command, true)

local playerctl_prev_symbol = create_button("玲", beautiful.xcolor4,
                                            prev_command, false)
local playerctl_next_symbol = create_button("怜", beautiful.xcolor4,
                                            next_command, false)

local music_tb = function(c)

    awful.titlebar(c,
                   {position = "bottom", size = 60, bg = beautiful.xbackground}):setup{
            {

                playerctl_prev_symbol,
                playerctl_play_symbol,
                playerctl_next_symbol,
                spacing = dpi(10),
                layout = wibox.layout.fixed.horizontal
            },
            halign = "center",
            widget = wibox.container.place
        }

    awful.titlebar(c,
                   {position = "left", size = 300, bg = beautiful.xbackground}):setup{
        {
            art,
            bg = beautiful.xcolor0,
            shape = helpers.rrect(20),
            forced_width = dpi(200),
            forced_height = dpi(200),
            widget = wibox.container.background
        },
        halign = "center",
        valign = "center",
        widget = wibox.container.place
    }
end

ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rule {
        id = "music",
        rule = {instance = "music"},
        callback = music_tb
    }
end)
