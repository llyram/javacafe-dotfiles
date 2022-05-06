local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

local create_profile = function()
    local profile_imagebox = wibox.widget {
        {
            id = 'icon',
            image = beautiful.me,
            widget = wibox.widget.imagebox,
            resize = true,
            forced_height = dpi(50),
            clip_shape = gears.shape.circle
        },
        layout = wibox.layout.align.horizontal
    }

    local profile_name = wibox.widget {
        font = beautiful.font_name .. '12',
        markup = 'User',
        align = 'left',
        valign = 'center',
        widget = wibox.widget.textbox
    }

    awful.spawn.easy_async_with_shell("echo $(whoami)", function(stdout1)
        local stdout1 = stdout1:gsub('%\n', '')
        awful.spawn.easy_async_with_shell("echo $(hostname)", function(stdout2)
            local stdout2 = stdout2:gsub('%\n', '')
            profile_name:set_markup(helpers.colorize_text(stdout1,
                                                          beautiful.xcolor2) ..
                                        helpers.colorize_text("@",
                                                              beautiful.xcolor15) ..
                                        helpers.colorize_text(stdout2,
                                                              beautiful.xcolor4))

        end)
    end)

    local user_profile = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(10),
        {
            layout = wibox.layout.align.vertical,
            expand = 'none',
            nil,
            profile_imagebox,
            nil
        },
        profile_name
    }

    return user_profile
end

return create_profile
