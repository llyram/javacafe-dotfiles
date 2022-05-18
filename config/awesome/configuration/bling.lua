local awful = require("awful")
local beautiful = require("beautiful")
local bling = require("module.bling")

bling.widget.tag_preview.enable {
    show_client_content = true,
    placement_fn = function(c)
        awful.placement.top_left(c, {
            margins = {left = beautiful.wibar_width + 10, top = 10}
        })
    end,
    scale = 0.15,
    honor_padding = true,
    honor_workarea = false
}

awful.keyboard.append_global_keybindings({
    awful.key({modkey}, "d", function() awful.spawn(launcher) end,
              {description = "show app launcher", group = "launcher"}),
    awful.key({modkey}, "e", function() awful.spawn(emoji_launcher) end,
              {description = "show emoji launcher", group = "launcher"})
})

require('ui.pop.window_switcher').enable()
