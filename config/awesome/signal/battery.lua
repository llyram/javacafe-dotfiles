-- This uses UPowerGlib.Device (https://lazka.github.io/pgi-docs/UPowerGlib-1.0/classes/Device.html)
-- Provides:
-- signal::battery
--      percentage
--      state
local upower_widget = require("module.battery_widget")
local battery_listener = upower_widget {
    device_path = '/org/freedesktop/UPower/devices/battery_BAT1',
    instant_update = true
}

battery_listener:connect_signal("upower::update", function(_, device)
    local time_to_empty = device.time_to_empty / 60
    local time_to_full = device.time_to_full / 60
    awesome.emit_signal("signal::battery",
                        tonumber(string.format("%.0f", device.percentage)),
                        device.state,
                        tonumber(string.format("%.0f", time_to_empty)),
                        tonumber(string.format("%.0f", time_to_full)),
                        device.battery_level)
end)
