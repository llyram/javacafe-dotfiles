{ config, lib, pkgs, ... }:

let theme = import ../../theme/theme.nix { };
in
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  console =
    let
      normal = with theme.colors; [ bg c1 c2 c3 c4 c5 c6 c7 ];
      bright = with theme.colors; [ lbg c9 c10 c11 c12 c13 c14 c15 ];
    in
    {
      colors = normal ++ bright;
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    shells = with pkgs; [ zsh ];

    systemPackages = lib.attrValues {
      inherit (pkgs)
        alsaTools
        alsaUtils
        cmake
        coreutils
        curl
        fd
        ffmpeg
        fzf
        gcc
        git
        glib
        gnumake
        gnutls
        home-manager
        imagemagick
        iw
        libtool
        lm_sensors
        man-pages
        man-pages-posix
        nodejs
        pamixer
        psmisc
        ripgrep
        unrar
        unzip
        vim
        wget
        wirelesstools
        xarchiver
        xclip
        zip;
    };

    variables = { "EDITOR" = "${pkgs.vim}/bin/vim"; };
  };

  fonts = {
    fonts = lib.attrValues {
      inherit (pkgs)
        cantarell-fonts
        emacs-all-the-icons-fonts
        liberation_ttf
        noto-fonts-emoji-blob-bin
        sarasa-gothic
        twemoji-color-font;

      nerdfonts = pkgs.nerdfonts.override { fonts = [ "FiraCode" "IBMPlexMono" ]; };
    };

    fontconfig = {
      enable = true;

      defaultFonts = {
        serif = [
          "Sarasa Gothic C"
          "Sarasa Gothic J"
          "Sarasa Gothic K"
        ];

        sansSerif = [
          "Sarasa Gothic C"
          "Sarasa Gothic J"
          "Sarasa Gothic K"
        ];

        monospace = [
          "BlexMono Nerd Font Mono"
        ];

        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  programs = {
    bash.promptInit = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    npm = {
      enable = true;
      npmrc = ''
        prefix = ''${HOME}/.npm
        color = true
      '';
    };

    java = {
      enable = true;
      package = pkgs.jdk;
    };
  };

  sound.enable = true;

  systemd = {
    services.rtkit-daemon = import ./services/rtkit-daemon.nix { inherit pkgs; };
  };

  time = {
    hardwareClockInLocalTime = true;
    timeZone = "America/Los_Angeles";
  };

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;

    users.javacafe01 = {
      description = "Gokul Swaminathan";
      isNormalUser = true;
      home = "/home/javacafe01";

      extraGroups =
        [ "wheel" "networkmanager" "sudo" "video" "audio" "adbusers" ];
    };
  };
}
