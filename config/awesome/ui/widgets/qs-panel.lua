-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Widget library
local wibox = require("wibox")

-- Rubato
local rubato = require("module.rubato")

-- Helpers
local helpers = require("helpers")

-- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

-- Helpers
-------------

local format_item = function(widget)
    return wibox.widget {
        {
            {
                layout = wibox.layout.align.vertical,
                expand = "none",
                nil,
                widget,
                nil
            },
            margins = dpi(10),
            widget = wibox.container.margin
        },
        forced_height = dpi(88),
        bg = beautiful.control_center_widget_bg,
        shape = helpers.rrect(beautiful.control_center_widget_radius),
        widget = wibox.container.background
    }
end

local format_item_no_fix_height = function(widget)
    return wibox.widget {
        {
            {
                layout = wibox.layout.align.vertical,
                expand = "none",
                nil,
                widget,
                nil
            },
            margins = dpi(10),
            widget = wibox.container.margin
        },
        bg = beautiful.control_center_widget_bg,
        shape = helpers.rrect(beautiful.control_center_widget_radius),
        widget = wibox.container.background
    }
end

local function format_progress_bar(bar, image)
    local image = wibox.widget {
        image = image,
        widget = wibox.widget.imagebox,
        resize = true
    }
    image.forced_height = dpi(8)
    image.forced_width = dpi(8)

    local w = wibox.widget {
        {image, margins = dpi(30), widget = wibox.container.margin},
        bar,
        layout = wibox.layout.stack
    }

    return w
end

local function create_boxed_widget(widget_to_be_boxed, width, height, radius,
                                   bg_color)
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(radius)

    local boxed_widget = wibox.widget {
        {
            nil,
            {
                widget_to_be_boxed,
                layout = wibox.layout.align.vertical,
                expand = "none"
            },
            layout = wibox.layout.align.horizontal
        },
        widget = box_container
    }
    return boxed_widget
end

local function create_arc_container(markup, widget)
    local text = wibox.widget {
        font = beautiful.font_name .. "Bold 10",
        markup = helpers.colorize_text(markup, beautiful.xforeground),
        valign = "center",
        widget = wibox.widget.textbox
    }

    local arc_container = wibox.widget {
        {
            {text, expand = "none", layout = wibox.layout.align.horizontal},
            top = dpi(10),
            left = dpi(10),
            widget = wibox.container.margin
        },
        {
            widget,
            left = dpi(15),
            right = dpi(15),
            top = dpi(10),
            widget = wibox.container.margin
        },
        layout = wibox.layout.fixed.vertical
    }

    return arc_container
end

local function create_buttons(icon, color)
    local button = wibox.widget {
        id = "icon",
        markup = helpers.colorize_text(icon, color),
        font = beautiful.icon_font_name .. "16",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local button_container = wibox.widget {
        {
            {
                button,
                margins = dpi(15),
                forced_height = dpi(48),
                forced_width = dpi(48),
                widget = wibox.container.margin
            },
            widget = require("ui.widgets.clickable")
        },
        bg = beautiful.control_center_button_bg,
        shape = gears.shape.circle,
        widget = wibox.container.background
    }

    return button_container
end

-- Control Center
--------------------

-- widgets
-------------

-- color indicator
local off = beautiful.control_center_button_bg
local on = beautiful.accent

-- wifi button
local wifi = create_buttons("", beautiful.xforeground)
local wifi_status = false -- off

awesome.connect_signal("signal::network", function(status, ssid)
    wifi_status = status
    local w, fill_color
    if wifi_status == true then
        fill_color = on
        wifi:buttons{
            awful.button({}, 1, function()
                awful.spawn.with_shell("nmcli radio wifi off")
            end)
        }
    else
        fill_color = off
        wifi:buttons{
            awful.button({}, 1, function()
                awful.spawn.with_shell("nmcli radio wifi on")
            end)
        }
    end

    wifi.bg = fill_color
end)

-- bluetooth button
local bluetooth = create_buttons("", beautiful.xforeground)
local bluetooth_status = true

bluetooth:buttons{
    awful.button({}, 1, function()
        bluetooth_status = not bluetooth_status
        if bluetooth_status then
            bluetooth.bg = off
            awful.spawn "bluetoothctl power off"
        else
            bluetooth.bg = on
            awful.spawn "bluetoothctl power on"
        end
    end)
}

-- screenrecorder button
local screenrec = require("ui.widgets.jeff")()

-- screenshot button
local screenshot = create_buttons("", beautiful.xforeground)
screenshot:buttons{
    awful.button({}, 1, function()
        -- awful.spawn.with_shell("screensht area")
    end)
}

-- user profile
local user_profile = wibox.widget {
    layout = wibox.layout.align.horizontal,
    forced_height = dpi(60),
    nil,
    format_item(require("ui.widgets.user-profile")()),
    {
        format_item({
            layout = wibox.layout.fixed.horizontal,
            require("ui.widgets.end-session")()
        }),
        left = dpi(10),
        widget = wibox.container.margin
    }
}

-- wifi, bluetooth, screenrec, screenshot
local control_center_row_four = wibox.widget {
    {
        {
            wifi,
            bluetooth,
            screenrec,
            screenshot,
            spacing = dpi(6),
            layout = wibox.layout.flex.horizontal
        },
        margins = dpi(12),
        widget = wibox.container.margin
    },
    shape = helpers.rrect(beautiful.control_center_widget_radius),
    bg = beautiful.control_center_widget_bg,
    widget = wibox.container.background
}

-- Control Center
--------------------

return wibox.widget {
    {
        {
            layout = wibox.layout.align.vertical,
            expand = "none",
            {
                user_profile,
                control_center_row_four,
                spacing = dpi(15),
                layout = wibox.layout.fixed.vertical
            }
        },
        margins = dpi(20),
        widget = wibox.container.margin
    },
    bg = beautiful.control_center_bg,
    shape = helpers.rrect(beautiful.control_center_radius),
    widget = wibox.container.background
}
