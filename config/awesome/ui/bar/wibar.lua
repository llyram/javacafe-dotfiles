-- wibar.lua
-- Wibar (top bar)
local awful = require("awful")
local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

-- Grab bling playerctl
local playerctl = require("module.bling").signal.playerctl.lib()

-- Helper function to create media buttons
local create_button = function(symbol, color, command, playpause)

    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        font = beautiful.icon_font_name .. "14",
        align = "center",
        valigin = "center",
        widget = wibox.widget.textbox()
    }

    local button = wibox.widget {
        icon,
        forced_height = dpi(15),
        forced_width = dpi(15),
        shape = gears.shape.circle,
        bg = beautiful.lighter_bg,
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

    button:connect_signal("button::press", function()
        icon.markup = helpers.colorize_text(icon.text, beautiful.xforeground)
        button.bg = beautiful.darker_bg
    end)

    button:connect_signal("button::release", function()
        command()
        icon.markup = helpers.colorize_text(icon.text, color)
        button.bg = beautiful.lighter_bg
    end)

    return button
end

-- Awesome Panel -----------------------------------------------------------

--[[ local unclicked = gears.surface.load_uncached(
                      gfs.get_configuration_dir() .. "icons/ghosts/awesome.png")

local clicked = gears.color.recolor_image(
                    gears.surface.load_uncached(
                        gfs.get_configuration_dir() ..
                            "icons/ghosts/awesome.png"), beautiful.xcolor8)

                            --]]

local awesome_icon = wibox.widget {
    {
        widget = wibox.widget.imagebox,
        --       image = gears.surface(beautiful.theme_assets.awesome_icon(512,
        --                                                                 beautiful.xcolor8,
        --                                                                beautiful.wibar_bg)),
        image = gears.surface(gfs.get_configuration_dir() .. "images/distro.png"),
        resize = true
    },
    margins = dpi(10),
    widget = wibox.container.margin
}

local awesome_icon_container = wibox.widget {
    awesome_icon,
    bg = beautiful.wibar_bg,
    widget = wibox.container.background
}

awesome_icon_container:connect_signal("button::press", function()
    awesome_icon_container.bg = beautiful.lighter_bg
    awesome_icon.top = dpi(11)
    awesome_icon.left = dpi(11)
    awesome_icon.right = dpi(9)
    awesome_icon.bottom = dpi(9)
end)

awesome_icon_container:connect_signal("button::release", function()
    awesome_icon.margins = dpi(10)
    awesome_icon_container.bg = beautiful.wibar_bg
end)

-- Change cursor
helpers.add_hover_cursor(awesome_icon_container, "hand2")

-- Notifs Panel ---------------------------------------------------------------

local notif_icon = wibox.widget {
    {
        widget = wibox.widget.textbox,
        font = beautiful.icon_font_name .. "16",
        markup = "<span foreground='" .. beautiful.xcolor4 .. "'>" .. "" ..
            "</span>",
        resize = true
    },
    margins = {top = dpi(9), bottom = dpi(10), left = dpi(12), right = dpi(12)},
    widget = wibox.container.margin
}

local notif_icon_container = wibox.widget {
    notif_icon,
    bg = beautiful.wibar_bg,
    widget = wibox.container.background
}

local notif_popup = awful.popup {
    widget = {
        require("ui.notifs.notif-center"),
        margins = dpi(20),
        widget = wibox.container.margin
    },
    visible = false,
    ontop = true,
    maximum_height = screen_height - beautiful.wibar_height - dpi(20),
    maximum_width = dpi(500),
    placement = function(c)
        awful.placement.top_right(c, {
            margins = {top = beautiful.wibar_height + dpi(10), right = dpi(10)}
        })
    end,
    border_color = beautiful.widget_border_color,
    border_width = beautiful.widget_border_width,
}

notif_icon_container:connect_signal("button::press", function()
    notif_icon_container.bg = beautiful.lighter_bg
    notif_icon.top = dpi(11)
    notif_icon.left = dpi(13)
    notif_icon.right = dpi(11)
    notif_icon.bottom = dpi(8)
end)

notif_icon_container:connect_signal("button::release", function()
    notif_popup.visible = not notif_popup.visible
    notif_icon.margins = {
        top = dpi(10),
        bottom = dpi(9),
        left = dpi(12),
        right = dpi(12)
    }
    notif_icon_container.bg = beautiful.wibar_bg
end)

-- Change cursor
helpers.add_hover_cursor(notif_icon_container, "hand2")

--[[awesome.connect_signal("widgets::notif_panel::status", function(status)
    if not status then
        icon2.markup = "<span foreground='" .. beautiful.xcolor4 .. "'>" ..
                           "" .. "</span>"
    else
        icon2.markup = "<span foreground='" .. beautiful.xcolor8 .. "'>" ..
                           "" .. "</span>"

    end
end)--]]

-- Battery Bar Widget ---------------------------------------------------------

local battery_bar = wibox.widget {
    max_value = 100,
    value = 70,
    forced_width = dpi(100),
    shape = helpers.rrect(beautiful.border_radius - 3),
    bar_shape = helpers.rrect(beautiful.border_radius - 3),
    color = beautiful.xcolor10,
    background_color = beautiful.xcolor0,
    border_width = dpi(0),
    border_color = beautiful.border_color,
    widget = wibox.widget.progressbar
}

local battery_bar_container = wibox.widget {
    {
        battery_bar,
        margins = {
            left = dpi(10),
            right = dpi(10),
            top = dpi(14),
            bottom = dpi(14)
        },
        widget = wibox.container.margin
    },
    bg = beautiful.wibar_bg,
    widget = wibox.container.background
}

local battery_icon = wibox.widget {
    markup = " " .. "<span foreground='" .. beautiful.xcolor12 .. "'></span>",
    font = beautiful.icon_font_name .. "40",
    widget = wibox.widget.textbox
}

local battery_text = wibox.widget {
    markup = "No data available",
    widget = wibox.widget.textbox
}

local battery_empty = wibox.widget {
    markup = "No data available",
    widget = wibox.widget.textbox
}

local a = wibox.widget {
    {battery_icon, left = dpi(20), widget = wibox.container.margin},
    {
        helpers.vertical_pad(dpi(10)),
        {
            markup = helpers.bold_text(helpers.colorize_text("Power Manager",
                                                             beautiful.xcolor12)),
            widget = wibox.widget.textbox
        },
        helpers.vertical_pad(dpi(10)),
        battery_text,
        battery_empty,
        layout = wibox.layout.fixed.vertical
    },
    layout = wibox.layout.ratio.horizontal
}

a:adjust_ratio(2, 0.30, 0.70, 0)

local battery_popup = awful.popup {
    widget = {
        a,
        margins = dpi(10),
        forced_width = dpi(300),
        forced_height = dpi(100),
        widget = wibox.container.margin
    },
    visible = false,
    ontop = true,
    maximum_height = dpi(450),
    maximum_width = dpi(500),
    placement = function(c)
        awful.placement.top_right(c, {
            margins = {top = beautiful.wibar_height + dpi(10), right = dpi(10)}
        })
    end,
    border_color = beautiful.widget_border_color,
    border_width = beautiful.widget_border_width,
}

battery_bar_container:connect_signal("button::press", function()
    battery_bar_container.bg = beautiful.lighter_bg
end)

battery_bar_container:connect_signal("button::release", function()
    battery_popup.visible = not battery_popup.visible
    battery_bar_container.bg = beautiful.wibar_bg
end)

-- Change cursor
helpers.add_hover_cursor(battery_bar_container, "hand2")

awesome.connect_signal("signal::battery",
                       function(value, state, time_to_empty, time_to_full,
                                battery_level)
    battery_bar.value = value
    battery_bar.color = beautiful.xcolor10

    local bat_icon = ''

    if value >= 90 and value <= 100 then
        bat_icon = ''
    elseif value >= 70 and value < 90 then
        bat_icon = ''
    elseif value >= 60 and value < 70 then
        bat_icon = ''
    elseif value >= 50 and value < 60 then
        bat_icon = ''
    elseif value >= 30 and value < 50 then
        bat_icon = ''
    elseif value >= 15 and value < 30 then
        bat_icon = ''
    else
        bat_icon = ''
        battery_bar.color = beautiful.xcolor1
    end

    battery_empty.markup = helpers.colorize_text(
                               "Time till empty: " .. time_to_empty .. " min",
                               beautiful.xcolor15)

    -- if charging
    if state == 1 then
        bat_icon = ""
        battery_bar.color = beautiful.xcolor4

        battery_empty.markup = helpers.colorize_text(
                                   "Time till full: " .. time_to_full .. " min",
                                   beautiful.xcolor15)
    end

    battery_icon.markup = helpers.colorize_text(bat_icon, beautiful.xcolor12)
    battery_text.markup = helpers.colorize_text(
                              "Battery level: " .. value .. "%",
                              beautiful.xcolor15)
end)

-- Tasklist Buttons -----------------------------------------------------------

local tasklist_buttons = gears.table.join(
                             awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end), awful.button({}, 3, function()
        awful.menu.client_list({theme = {width = 250}})
    end), awful.button({}, 4, function() awful.client.focus.byidx(1) end),
                             awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

-- Playerctl Bar Widget -------------------------------------------------------

-- Title Widget
local song_title = wibox.widget {
    markup = 'Nothing Playing',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local song_artist = wibox.widget {
    markup = 'nothing playing',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local song_logo = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.icon_font,
    markup = "<span foreground='" .. beautiful.xcolor4 .. "'>" .. "" ..
        "</span>",
    resize = true
}

local playerctl_bar = wibox.widget {
    {
        {
            song_logo,
            right = dpi(10),
            top = dpi(0),
            bottom = dpi(0),
            widget = wibox.container.margin
        },
        {
            {
                song_title,
                expand = "outside",
                layout = wibox.layout.align.vertical
            },
            left = dpi(10),
            right = dpi(10),
            widget = wibox.container.margin
        },
        {
            {
                song_artist,
                expand = "outside",
                layout = wibox.layout.align.vertical
            },
            left = dpi(10),
            widget = wibox.container.margin
        },
        spacing = dpi(1),
        spacing_widget = {
            bg = beautiful.xcolor8,
            widget = wibox.container.background
        },
        layout = wibox.layout.fixed.horizontal
    },
    left = dpi(10),
    right = dpi(10),
    widget = wibox.container.margin
}

local playerctl_bar_container = wibox.widget {
    {
        playerctl_bar,
        margins = {top = dpi(9), bottom = dpi(9), left = dpi(7), right = dpi(7)},
        widget = wibox.container.margin
    },
    bg = beautiful.wibar_bg,
    widget = wibox.container.background
}

-- Stuff for popup

local music_title = wibox.widget {
    markup = 'Nothing Playing',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local music_artist = wibox.widget {
    markup = 'nothing playing',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local music_logo = wibox.widget {
    image = gfs.get_configuration_dir() .. "images/no_music.png",
    resize = true,
    clip_shape = helpers.rrect(beautiful.border_radius),
    widget = wibox.widget.imagebox
}

local play_command = function() playerctl:play_pause() end
local prev_command = function() playerctl:previous() end
local next_command = function() playerctl:next() end

local playerctl_play_symbol = create_button("", beautiful.xcolor4,
                                            play_command, true)

local playerctl_prev_symbol = create_button("玲", beautiful.xcolor4,
                                            prev_command, false)
local playerctl_next_symbol = create_button("怜", beautiful.xcolor4,
                                            next_command, false)

local music_slider = wibox.widget {
    forced_height = dpi(3),
    bar_shape = helpers.rrect(beautiful.border_radius),
    shape = helpers.rrect(beautiful.border_radius),
    background_color = beautiful.xcolor0 .. 55,
    color = beautiful.xcolor6,
    value = 25,
    max_value = 100,
    widget = wibox.widget.progressbar
}

playerctl:connect_signal("position", function(_, pos, length, _)
    music_slider.value = (pos / length) * 100
end)

local w = wibox.widget {
    music_logo,
    {
        {
            {
                music_title,
                helpers.vertical_pad(10),
                music_artist,
                widget = wibox.layout.fixed.vertical
            },
            top = dpi(20),
            bottom = dpi(5),
            widget = wibox.container.margin
        },
        {
            {
                playerctl_prev_symbol,
                playerctl_play_symbol,
                playerctl_next_symbol,
                spacing = dpi(10),
                layout = wibox.layout.flex.horizontal
            },
            top = dpi(15),
            bottom = dpi(5),
            widget = wibox.container.margin
        },
        {
            music_slider,
            margins = {top = dpi(30), bottom = dpi(0)},
            widget = wibox.container.margin
        },
        widget = wibox.layout.flex.vertical
    },
    widget = wibox.layout.ratio.horizontal
}
w:adjust_ratio(2, 0.35, 0.55, 0)

local playerctl_popup = awful.popup {
    widget = {
        w,
        margins = dpi(10),
        forced_width = dpi(500),
        forced_height = dpi(200),
        widget = wibox.container.margin
    },
    visible = false,
    ontop = true,
    maximum_height = dpi(450),
    maximum_width = dpi(600),
    placement = function(c)
        awful.placement.top(c, {
            margins = {top = beautiful.wibar_height + dpi(10)}
        })
    end,
    border_color = beautiful.widget_border_color,
    border_width = beautiful.widget_border_width,
}

playerctl_bar_container:connect_signal("button::press", function()
    playerctl_bar_container.bg = beautiful.lighter_bg
end)

playerctl_bar_container:connect_signal("button::release", function()
    playerctl_bar_container.bg = beautiful.wibar_bg
    playerctl_popup.visible = not playerctl_popup.visible
end)

-- Change cursor
helpers.add_hover_cursor(playerctl_bar_container, "hand2")

playerctl_bar.visible = false

playerctl:connect_signal("no_players", function()
    playerctl_bar.visible = false

    music_logo.image = gfs.get_configuration_dir() .. "images/no_music.png"

    music_title.markup = '<span foreground="' .. beautiful.xcolor5 .. '">' ..
                             "Nothing Playing" .. '</span>'

    music_artist.markup = '<span foreground="' .. beautiful.xcolor4 .. '">' ..
                              "nothing playing" .. '</span>'
end)

-- Get Song Info
playerctl:connect_signal("metadata",
                         function(_, title, artist, art, _, _, player)

    playerctl_bar.visible = true

    music_logo.image = art

    song_title.markup = '<span foreground="' .. beautiful.xcolor5 .. '">' ..
                            title .. '</span>'
    music_title.markup = '<span foreground="' .. beautiful.xcolor5 .. '">' ..
                             title .. '</span>'

    song_artist.markup = '<span foreground="' .. beautiful.xcolor4 .. '">' ..
                             artist .. '</span>'
    music_artist.markup = '<span foreground="' .. beautiful.xcolor4 .. '">' ..
                              artist .. '</span>'
end)

-- Clock Widget ---------------------------------------------------------------

local hourtextbox = wibox.widget.textclock("%I")
hourtextbox.markup = helpers.colorize_text(hourtextbox.text, beautiful.xcolor5)

local minutetextbox = wibox.widget.textclock("%M")
minutetextbox.markup = helpers.colorize_text(minutetextbox.text,
                                             beautiful.xforeground)

hourtextbox:connect_signal("widget::redraw_needed", function()
    hourtextbox.markup = helpers.colorize_text(hourtextbox.text,
                                               beautiful.xcolor5)
end)

minutetextbox:connect_signal("widget::redraw_needed", function()
    minutetextbox.markup = helpers.colorize_text(minutetextbox.text,
                                                 beautiful.xforeground)
end)

local clock_container = wibox.widget {
    {
        {
            hourtextbox,
            minutetextbox,
            spacing = dpi(5),
            layout = wibox.layout.fixed.horizontal
        },
        margins = {
            top = dpi(9),
            bottom = dpi(9),
            left = dpi(11),
            right = dpi(11)
        },
        widget = wibox.container.margin
    },
    bg = beautiful.wibar_bg,
    widget = wibox.container.background
}

local datetooltip = awful.tooltip {};
datetooltip.preferred_alignments = {"middle", "front", "back"}
datetooltip.mode = "outside"
datetooltip:add_to_object(clock_container)
datetooltip.text = os.date("%m/%d/%y")

-- Create the Wibar -----------------------------------------------------------

local mysystray = wibox.widget.systray()
mysystray.base_size = beautiful.systray_icon_size

screen.connect_signal("request::desktop_decoration", function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create layoutbox widget
    s.mylayoutbox = awful.widget.layoutbox(s)

    -- Create the wibox
    s.mywibox = awful.wibar({position = beautiful.wibar_position, screen = s})

    -- Remove wibar on full screen
    local function remove_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.mywibox.visible = false
        else
            c.screen.mywibox.visible = true
        end
    end

    -- Remove wibar on full screen
    local function add_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.mywibox.visible = true
        end
    end

    --[[
    -- Hide bar when a splash widget is visible
    awesome.connect_signal("widgets::splash::visibility", function(vis)
        screen.primary.mywibox.visible = not vis
    end)
    ]] --

    client.connect_signal("property::fullscreen", remove_wibar)

    client.connect_signal("request::unmanage", add_wibar)

    -- Create the taglist widget
    s.mytaglist = require("ui.widgets.tagsklist")(s)

    -- Add widgets to the wibox
    s.mywibox:setup{
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            layout = wibox.layout.fixed.horizontal,
            awesome_icon_container,
            s.mytaglist,
            s.mypromptbox
        },
        playerctl_bar_container,
        {
            {
                mysystray,
                top = dpi(10),
                left = dpi(10),
                right = dpi(10),
                widget = wibox.container.margin
            },
            clock_container,
            battery_bar_container,
            {
                s.mylayoutbox,
                top = dpi(9),
                bottom = dpi(9),
                right = dpi(11),
                left = dpi(11),
                widget = wibox.container.margin
            },
            notif_icon_container,
            layout = wibox.layout.fixed.horizontal
        }
    }
end)

-- EOF ------------------------------------------------------------------------
