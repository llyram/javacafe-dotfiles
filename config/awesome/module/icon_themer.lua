-- AUTHOR: creator of rubato
-- SOURCE: https://discord.com/channels/702548301299580939/893586726885425163/947173452073287722

local gears = require("gears")
local beautiful = require("beautiful")
local cairo = require("lgi").cairo
local GLib = require("lgi").GLib

local M = {}

local function determine_icon_dir()
    local dir = GLib.build_filenamev({GLib.get_home_dir(), ".icons"}) .. "/" ..
                    beautiful.icon_theme
    if gears.filesystem.dir_readable(dir) then return dir end

    dir = GLib.build_filenamev({GLib.get_user_data_dir(), "icons"}) .. "/" ..
              beautiful.icon_theme
    if gears.filesystem.dir_readable(dir) then return dir end

    for _, v in ipairs(GLib.get_system_data_dirs()) do
        dir = GLib.build_filenamev({v, "icons"}) .. "/" .. beautiful.icon_theme
        if gears.filesystem.dir_readable(dir) then return dir end
    end
end

local icon_dir = determine_icon_dir()

M.set_icon = function(c)
    -- TODO: do this a little smarter, but might not be necessary since they're svgs
    -- TODO: size intelligently (however awesome wants me to do it)
    local icon_path = icon_dir .. "/128x128/apps/" .. c.class:lower() .. ".svg"
    if not io.open(icon_path, "r") then return end -- ensure that it exists

    -- create a surface from the icon path
    local s = gears.surface(icon_path)
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, s:get_width(),
                                          s:get_height())
    local cr = cairo.Context(img)
    cr:set_source_surface(s, 0, 0)
    cr:paint()

    -- update the client's icon
    c.icon = img._native
end

return M
