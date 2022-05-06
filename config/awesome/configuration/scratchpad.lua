local bling = require("module.bling")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local rubato = require("module.rubato")

local chat_anim = {
    x = rubato.timed {
        pos = -1090,
        rate = 120,
        easing = rubato.quadratic,
        intro = 0.1,
        duration = 0.4,
        awestore_compat = true
    }
}

local chat_scratch = bling.module.scratchpad:new{
    -- command = [[ firefox -P chat --new-tab -url https://discord.com/channels/@me --class chat ]],
    command = discord,
    rule = {
        -- class = "chat"
        class = "discord"
    },
    sticky = false,
    autoclose = false,
    floating = true,
    geometry = {x = screen_width / 2 - dpi(500), y = screen_height / 2 - dpi(450), height = dpi(900), width = dpi(1000)},
    reapply = true,
    rubato = chat_anim
}

awesome.connect_signal("scratch::chat", function() chat_scratch:toggle() end)
