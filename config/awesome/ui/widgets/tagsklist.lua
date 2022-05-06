local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")

local function generate_filter(t)
    return function(c, scr)
        local ctags = c:tags()
        for _, v in ipairs(ctags) do if v == t then return true end end
        return false
    end
end

local tasklist_buttons = gears.table.join(
                             awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end), awful.button({}, 4, function() awful.client.focus.byidx(1) end),
                             awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

-- Function to update the tags
local update_tags = function(self, c3)
    local bgbox = self:get_children_by_id('background_role')[1]
    local taskbox = self:get_children_by_id('tasklist_margin_role')[1]

    if c3.selected then
        bgbox.visible = true
        taskbox.visible = true
    elseif #c3:clients() == 0 then
        bgbox.visible = false
        taskbox.visible = false
    else
        bgbox.visible = true
        taskbox.visible = true
    end
end

function get_taglist(s)
    local screen_for_taglist = s or awful.screen.focused()

    local tagsklist = awful.widget.taglist {
        screen = screen_for_taglist,
        filter = awful.widget.taglist.filter.all,
        layout = {spacing = 8, layout = wibox.layout.fixed.vertical},
        widget_template = {
            {
                {
                    {
                        {
                            {id = 'text_role', widget = wibox.widget.textbox},
                            halign = "center",
                            valign = "center",
                            widget = wibox.container.place
                        },
                        margins = {top = 8, bottom = 0, left = 1},
                        widget = wibox.container.margin
                    },
                    {
                        {
                            id = "tasklist_role",
                            layout = wibox.layout.fixed.vertical
                        },
                        id = "tasklist_margin_role",
                        margins = {top = 2, left = 6, right = 6, bottom = 6},
                        widget = wibox.container.margin
                    },
                    spacing = 0,
                    layout = wibox.layout.fixed.vertical
                },
                widget = wibox.container.background
            },
            id = "background_role",
            widget = wibox.container.background,
            create_callback = function(self, c3, index, _)
                update_tags(self, c3)
                local t = screen_for_taglist.tags[index]
                self:get_children_by_id("tasklist_role")[1]:add(awful.widget
                                                                    .tasklist {
                    screen = screen_for_taglist,
                    filter = generate_filter(t),
                    buttons = tasklist_buttons,
                    layout = {spacing = 0, layout = wibox.layout.fixed.vertical},
                    widget_template = {
                        {
                            {
                                id = "clienticon",
                                widget = awful.widget.clienticon
                            },
                            top = 5,
                            widget = wibox.container.margin
                        },
                        create_callback = function(self, c, _, _)
                            self:get_children_by_id("clienticon")[1]:connect_signal(
                                'mouse::enter', function()
                                    awesome.emit_signal(
                                        "bling::task_preview::visibility",
                                        screen_for_taglist, true, c)
                                end)
                            self:get_children_by_id("clienticon")[1]:connect_signal(
                                'mouse::leave', function()
                                    awesome.emit_signal(
                                        "bling::task_preview::visibility",
                                        screen_for_taglist, false, c)
                                end)
                        end,
                        layout = wibox.layout.align.vertical
                    }
                })
                self:get_children_by_id("text_role")[1]:connect_signal(
                    'mouse::enter', function()
                        if #c3:clients() > 0 then
                            awesome.emit_signal("bling::tag_preview::update", c3)
                            awesome.emit_signal(
                                "bling::tag_preview::visibility", s, true)
                        end
                    end)
                self:get_children_by_id("text_role")[1]:connect_signal(
                    'mouse::leave', function()
                        awesome.emit_signal("bling::tag_preview::visibility", s,
                                            false)
                    end)
            end,
            update_callback = function(self, c3, index, objects)
                update_tags(self, c3)
            end
        }
    }

    return tagsklist
end

return get_taglist
