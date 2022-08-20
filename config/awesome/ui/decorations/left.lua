local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local bling = require("module.bling")

local get_titlebar = function(c, width, tb_bg)

    local tabbed_misc = bling.widget.tabbed_misc

    local buttons = gears.table.join(awful.button({}, 1, function()
        client.focus = c
        c:raise()
        awful.mouse.client.move(c)
    end), awful.button({}, 3, function()
        client.focus = c
        c:raise()
        awful.mouse.client.resize(c)
    end))

    awful.titlebar(c, {
        size = width,
        position = "left",
        bg_normal = tb_bg,
        bg_focus = tb_bg
    }):setup{
        {
            awful.titlebar.widget.iconwidget(c),
            margins = dpi(12),
            widget = wibox.container.margin
        },
        nil,
        nil,
        expand = "none",
        buttons = buttons,
        layout = wibox.layout.align.vertical
    }
end

local left = function(c)
    local titlebar_width = beautiful.titlebar_size
    local tb_bg = beautiful.darker_bg
    if c.class ~= nil and c.class:find("gnome") then
        tb_bg = beautiful.xcolor0
    end
    get_titlebar(c, titlebar_width, tb_bg)
end

return left
