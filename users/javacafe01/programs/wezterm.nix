{ theme }:

with theme.colors;

''
  local wezterm = require('wezterm')

  --[[
  wezterm.on("update-right-status", function(window, pane)
      local pad = {left = '45pt', right = '45pt', top = '45pt', bottom = '45pt'}
      local no_pad = {left = 0, right = 0, top = 0, bottom = 0}

      local process = pane:get_foreground_process_name()
      local overrides = window:get_config_overrides() or {}
      overrides.window_padding = string.match(process, "nvim") and no_pad or pad
      window:set_config_overrides(overrides)
      window:set_right_status("")
  end)
  --]]

  function font_with_fallback(name, params)
      local names = {name, "Twitter Color Emoji"}
      return wezterm.font_with_fallback(names, params)
  end

  local font_name = "BlexMono Nerd Font Mono"

  return {
      -- OpenGL for GPU acceleration, Software for CPU
      front_end = "OpenGL",

      -- No updates, bleeding edge only
      check_for_updates = false,

      -- Font Stuff
      font = font_with_fallback(font_name),
      font_rules = {
          {italic = true, font = font_with_fallback(font_name, {italic = true})},
          {
              italic = true,
              intensity = "Bold",
              font = font_with_fallback(font_name, {bold = true, italic = true})
          },
          {
              intensity = "Bold",
              font = font_with_fallback(font_name, {bold = true})
          },
          {intensity = "Half", font = font_with_fallback(font_name .. " Light")}
      },
      font_size = 10.0,
      line_height = 1.0,

      -- Cursor style
      default_cursor_style = "SteadyUnderline",

      -- X Good
      enable_wayland = false,

      -- Keys
      disable_default_key_bindings = true,

      keys = {
          {
              mods = "CTRL|SHIFT",
              key = [[\]],
              action = wezterm.action {
                  SplitHorizontal = {domain = "CurrentPaneDomain"}
              }
          }, {
              mods = "CTRL",
              key = [[\]],
              action = wezterm.action {
                  SplitVertical = {domain = "CurrentPaneDomain"}
              }
          }, -- browser-like bindings for tabbing
          {
              key = "t",
              mods = "CTRL",
              action = wezterm.action {SpawnTab = "CurrentPaneDomain"}
          }, {
              key = "w",
              mods = "CTRL",
              action = wezterm.action {CloseCurrentTab = {confirm = false}}
          },
          {
              mods = "CTRL",
              key = "Tab",
              action = wezterm.action {ActivateTabRelative = 1}
          }, {
              mods = "CTRL|SHIFT",
              key = "Tab",
              action = wezterm.action {ActivateTabRelative = -1}
          }, -- standard copy/paste bindings
          {key = "x", mods = "CTRL", action = "ActivateCopyMode"}, {
              key = "v",
              mods = "CTRL|SHIFT",
              action = wezterm.action {PasteFrom = "Clipboard"}
          }, {
              key = "c",
              mods = "CTRL|SHIFT",
              action = wezterm.action {CopyTo = "ClipboardAndPrimarySelection"}
          }
      },

      -- Pretty Colors
      bold_brightens_ansi_colors = false,

      colors = {
          foreground = "#${fg}",
          background = "#${bg}",
          cursor_bg = "#${c4}",
          cursor_fg = "#${c4}",
          cursor_border = "#${c4}",
          split = "#${lbg}",

          ansi = {
              "#${c0}", "#${c1}", "#${c2}", "#${c3}", "#${c4}", "#${c5}",
              "#${c6}", "#${c7}"
          },
          brights = {
              "#${c8}", "#${c9}", "#${c10}", "#${c11}", "#${c12}", "#${c13}",
              "#${c14}", "#${c15}"
          },

          tab_bar = {
              active_tab = {
                  bg_color = "#${bg}",
                  fg_color = "#${c8}",
                  italic = true
              },
              inactive_tab = {bg_color = "#${dbg}", fg_color = "#${c8}"},
              inactive_tab_hover = {bg_color = "#${c0}", fg_color = "#${bg}"}
          }

      },

      -- Get rid of close prompt
      window_close_confirmation = "NeverPrompt",

      -- Padding
      window_padding = {left = '40pt', right = '40pt', top = '40pt', bottom = '40pt'},

      -- No opacity
      inactive_pane_hsb = {saturation = 1.0, brightness = 1.0},

      window_frame = {active_titlebar_bg = "#${dbg}"},

      enable_tab_bar = true,
      hide_tab_bar_if_only_one_tab = true,
      show_tab_index_in_tab_bar = false
  }''

