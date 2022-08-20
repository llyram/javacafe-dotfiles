local awful = require("awful")
local client = client

local activate_dynamic_titlebars = function(c)
  if c ~= nil then
    if not c.bling_tabbed then
      if c.class ~= "music" and c.floating then
        if c.width > c.height then
          awful.titlebar.hide(c, "top")
          require("ui.decorations.left")(c)
        else
          awful.titlebar.hide(c, "left")
          require("ui.decorations.top")(c)
        end
      else
        awful.titlebar.hide(c, "top")
        awful.titlebar.hide(c, "left")
      end
    end
  end
end

client.connect_signal("property::width", activate_dynamic_titlebars)
client.connect_signal("property::height", activate_dynamic_titlebars)
client.connect_signal("property::floating", activate_dynamic_titlebars)

client.connect_signal("request::manage", function(c, _)
  if c.maximized or c.fullscreen then
    awful.titlebar.hide(c)
  else
    activate_dynamic_titlebars(c)
  end
end)
