local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("helpers")

-- Bling Module
local bling = require("module.bling")

-- Better mouse resizing on tiled
-- Not mine
-- https://github.com/larkery/awesome/blob/master/better-resize.lua
require("module.better-resize")

client.connect_signal("request::manage", function(c, _)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end
  if awesome.startup and not c.size_hints.user_position and
    not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end

  -- Fallback icon for clients
  if c.icon == nil then
    local i = gears.surface(beautiful.theme_assets.awesome_icon(256, beautiful.xcolor8, beautiful.darker_bg))
    c.icon = i._native
  end

  --[[
  if c.maximized or c.fullscreen then
    c.shape = gears.shape.rectangle
  else
    c.shape = helpers.rrect(beautiful.border_radius)
  end
  --]]
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus",
function(c) c.border_color = beautiful.border_focus end)

client.connect_signal("unfocus",
function(c) c.border_color = beautiful.border_normal end)

-- Custom Layouts -------------------------------------------------------------

local mstab = bling.layout.mstab
local centered = bling.layout.centered
local horizontal = bling.layout.horizontal
local equal = bling.layout.equalarea
local deck = bling.layout.deck

-- Set the layouts

tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    awful.layout.suit.tile, awful.layout.suit.floating, centered, mstab,
    horizontal, equal, deck
  })
end)

-- Layout List Widget ---------------------------------------------------------

-- List
local ll = awful.widget.layoutlist {
  source = awful.widget.layoutlist.source.default_layouts, -- DOC_HIDE
  spacing = dpi(24),
  base_layout = wibox.widget {
    spacing = dpi(24),
    forced_num_cols = 4,
    layout = wibox.layout.grid.vertical
  },
  widget_template = {
    {
      {
        id = "icon_role",
        forced_height = dpi(68),
        forced_width = dpi(68),
        widget = wibox.widget.imagebox
      },
      margins = dpi(24),
      widget = wibox.container.margin
    },
    id = "background_role",
    forced_width = dpi(68),
    forced_height = dpi(68),
    widget = wibox.container.background
  }
}

-- Popup
local layout_popup = awful.popup {
  widget = wibox.widget 
  {ll, margins = dpi(24), widget = wibox.container.margin},
  placement = awful.placement.centered,
  ontop = true,
  visible = false,
  shape = helpers.rrect(beautiful.border_radius),
  border_color = beautiful.widget_border_color,
  border_width = beautiful.widget_border_width,
  bg = beautiful.xbackground
}

-- Key Bindings for Widget ----------------------------------------------------

-- Make sure you remove the default `Mod4+Space` and `Mod4+Shift+Space`
-- keybindings before adding this.
function gears.table.iterate_value(t, value, step_size, filter, start_at)
  local k = gears.table.hasitem(t, value, true, start_at)
  if not k then return end

  step_size = step_size or 1
  local new_key = gears.math.cycle(#t, k + step_size)

  if filter and not filter(t[new_key]) then
    for i = 1, #t do
      local k2 = gears.math.cycle(#t, new_key + i)
      if filter(t[k2]) then return t[k2], k2 end
    end
    return
  end

  return t[new_key], new_key
end

awful.keygrabber {
  start_callback = function() layout_popup.visible = true end,
  stop_callback = function() layout_popup.visible = false end,
  export_keybindings = true,
  stop_event = "release",
  stop_key = {"Escape", "Super_L", "Super_R", "Mod4"},
  keybindings = {
    {
      {modkey, "Shift"}, " ", function()
        awful.layout.set(gears.table.iterate_value(ll.layouts,
        ll.current_layout, -1),
        nil)
      end
    }, {
      {modkey}, " ", function()
        awful.layout.set(gears.table.iterate_value(ll.layouts,
        ll.current_layout, 1),
        nil)
      end
    }
  }
}

-- Hide all windows when a splash is shown
awesome.connect_signal("widgets::splash::visibility", function(vis)
  local t = screen.primary.selected_tag
  if vis then
    for idx, c in ipairs(t:clients()) do c.hidden = true end
  else
    for idx, c in ipairs(t:clients()) do c.hidden = false end
  end
end)

-- EOF ------------------------------------------------------------------------
