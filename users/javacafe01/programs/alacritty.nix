{ theme }:

with theme.colors; {
  env.TERM = "xterm-256color";

  font = {
    normal = { family = "BlexMono Nerd Font Mono"; };

    bold = {
      family = "BlexMono Nerd Font Mono";
      style = "Bold";
    };

    italic = {
      family = "BlexMono Nerd Font Mono";
      style = "Italic";
    };

    bold_italic = {
      family = "BlexMono Nerd Font Mono";
      style = "Bold Italic";
    };

    size = 10;

    offset = {
      x = 0;
      y = 0;
    };
  };

  window = {
    dynamic_padding = true;

    padding = {
      x = 40;
      y = 40;
    };
  };

  cursor.style = "Underline";

  colors = {
    primary = {
      background = "0x${bg}";
      foreground = "0x${fg}";
    };

    cursor = { cursor = "0x${c8}"; };

    normal = {
      black = "0x${c0}";
      red = "0x${c1}";
      green = "0x${c2}";
      yellow = "0x${c3}";
      blue = "0x${c4}";
      magenta = "0x${c5}";
      cyan = "0x${c6}";
      white = "0x${c7}";
    };

    bright = {
      black = "0x${c8}";
      red = "0x${c9}";
      green = "0x${c10}";
      yellow = "0x${c11}";
      blue = "0x${c12}";
      magenta = "0x${c13}";
      cyan = "0x${c14}";
      white = "0x${c15}";
    };
  };
}
