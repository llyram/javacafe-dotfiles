{ config, lib, pkgs, ... }:

let
  customNodePackages = pkgs.callPackage ../../derivations/customNodePackages { };
  theme = import ../../theme/theme.nix { };
in
{
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font.name = "Sarasa Gothic J";

    gtk3.extraConfig = { gtk-decoration-layout = "menu:"; };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "phocus";
      package = pkgs.phocus.override {

        colors = with theme.colors; {
          base00 = "${bg}";
          base01 = "${lbg}";
          base02 = "${c0}";
          base03 = "${c8}";
          base04 = "${c8}";
          base05 = "${c15}";
          base06 = "${c15}";
          base07 = "${c7}";
          base08 = "${c7}";
          base09 = "${c1}";
          base0A = "${c11}";
          base0B = "${c2}";
          base0C = "${c12}";
          base0D = "${c4}";
          base0E = "${c5}";
          base0F = "${c9}";
        };

        primary = "${theme.colors.c6}";
        secondary = "${theme.colors.c4}";
      };
    };
  };

  home = {
    file = {
      # Amazing Phinger Icons
      ".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors";

      # Bin Scripts
      ".local/bin/jeff" = {
        # X11 Recorder
        executable = true;
        text = import ./bin/jeff.nix { inherit pkgs; };
      };

      ".local/bin/updoot" = {
        # Upload and get link
        executable = true;
        text = import ./bin/updoot.nix { inherit pkgs; };
      };

      ".local/bin/preview.sh" = {
        # Preview script for fzf tab
        executable = true;
        text = import ./bin/preview.nix { inherit pkgs; };
      };
    };

    username = "javacafe01";
    homeDirectory = "/home/javacafe01";

    packages = with pkgs; [
      # Programs
      arandr
      evince
      feh
      gimp
      glxinfo
      maim
      manix
      matlab
      matlab-mlint
      gnome.eog
      gnome.nautilus
      google-chrome
      mpc_cli
      neovim-nightly
      pandoc
      playerctl
      sqlite
      tectonic
      trash-cli
      wezterm-git
      xdg-user-dirs
      zoom-us

      # Custom node packages from node2nix
      # Contains: [ prettierd ] 
      myNodePackages

      # Language servers
      ccls
      nodePackages.bash-language-server
      nodePackages.pyright
      nodePackages.vim-language-server
      python-language-server
      rnix-lsp
      rust-analyzer
      shellcheck
      # sumneko-lua-language-server

      # Formatters
      black
      ktlint
      luaFormatter
      nixfmt
      nixpkgs-fmt
      rustfmt
      shfmt

      # Emacs Specific
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      editorconfig-core-c
      fd
      git
      gnuplot
      gnutls
      imagemagick
      languagetool
      pandoc
      python39Packages.jupyter
      sdcv
      sqlite
      tectonic
      (ripgrep.override { withPCRE2 = true; })
    ];

    sessionPath = [
      "${config.xdg.configHome}/emacs/bin"
      "${config.home.homeDirectory}/.local/bin"
    ];

    sessionVariables = {
      BROWSER = "${pkgs.firefox}/bin/firefox";
      EDITOR = "${pkgs.neovim}/bin/nvim";
      GOPATH = "${config.home.homeDirectory}/Extras/go";
      RUSTUP_HOME = "${config.home.homeDirectory}/.local/share/rustup";
    };
  };

  programs = {
    bat = {
      enable = true;
      config = {
        pager = "never";
        style = "plain";
        theme = "base16";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    discocss = {
      enable = true;
      discord = pkgs.master.discord;
      discordAlias = true;
      css = import ./programs/discord-css.nix { inherit theme; };
    };

    emacs = {
      enable = false;
      package = pkgs.emacsGit;
      extraPackages = epkgs: [ epkgs.vterm ];
    };

    exa = {
      enable = true;
      enableAliases = false;
    };

    firefox = {
      enable = true;

      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        stylus
        honey
        reddit-moderator-toolbox
        octotree
      ];

      package = pkgs.firefox;

      profiles = {
        myprofile = {
          id = 0;
          settings = {
            "browser.startup.homepage" = "https://gs.is-a.dev/startpage/";
            "general.smoothScroll" = true;
          };

          userChrome =
            import ./programs/firefox/userChrome-css.nix { inherit theme; };
          userContent =
            import ./programs/firefox/userContent-css.nix { inherit theme; };

          extraConfig = ''
            user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
            user_pref("full-screen-api.ignore-widgets", true);
          '';
        };
      };
    };

    git = {
      enable = true;
      userName = "Gokul Swaminathan";
      userEmail = "gokulswamilive@gmail.com";
    };

    home-manager.enable = true;

    htop = {
      enable = true;

      settings = {
        detailed_cpu_time = true;
        hide_kernel_threads = false;
        show_cpu_frequency = true;
        show_cpu_usage = true;
        show_program_path = false;
        show_thread_names = true;

        fields = with config.lib.htop.fields; [
          PID
          USER
          PRIORITY
          NICE
          M_SIZE
          M_RESIDENT
          M_SHARE
          STATE
          PERCENT_CPU
          PERCENT_MEM
          TIME
          COMM
        ];
      } // (with config.lib.htop;
        leftMeters [ (bar "AllCPUs") (bar "Memory") (bar "Swap") ])
      // (with config.lib.htop;
        rightMeters [
          (bar "Zram")
          (text "Tasks")
          (text "LoadAverage")
          (text "Uptime")
        ]);
    };

    mpv.enable = true;

    ncmpcpp = {
      enable = true;
      mpdMusicDir = "${config.home.homeDirectory}/Music";
      settings = import ./programs/ncmpcpp.nix;
    };

    ncspot = {
      enable = false;
      settings =
        {
          notify = false;
        };
    };

    rofi = {
      enable = true;
      package = pkgs.rofi.override {
        plugins = [ pkgs.rofi-emoji ];
      };

      extraConfig = {
        display-drun = "";
        drun-display-format = "{name}";
        show-icons = true;
      };

      theme = import ./programs/rofi-theme.nix { inherit config theme; };
    };

    starship = {
      enable = true;
      settings = import ./programs/starship.nix;
    };

    urxvt = {
      enable = true;

      extraConfig = {
        internalBorder = 40;
        "perl-ext-common" = "default,resize-font";
        "perl-lib" = "${pkgs.master.rxvt-unicode}/lib/urxvt/perl";
        scrollColor = "#${theme.colors.lbg}";
      };

      fonts = [ "xft:BlexMono Nerd Font Mono:size=10" ];
      package = pkgs.master.rxvt_unicode;

      scroll.bar = {
        enable = false;
        floating = true;
      };
    };

    zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      dotDir = ".config/zsh";

      shellAliases = {
        ls = "exa --color=auto --icons";
        l = "ls -l";
        la = "ls -a";
        lla = "ls -la";
        lt = "ls --tree";
        cat = "bat --color always --plain";
        grep = "grep --color=auto";
        c = "clear";
        v = "nvim";
        xwin = "Xephyr -br -ac -noreset -screen 960x600 :1";
        xdisp = "DISPLAY=:1";
        rm = "${pkgs.trash-cli}/bin/trash-put";
      };

      initExtra = ''
        set -k
        setopt auto_cd
        export PATH="''${HOME}/.local/bin:''${HOME}/go/bin:''${HOME}/.emacs.d/bin:''${HOME}/.npm/bin:''${HOME}/.cargo/bin:''${PATH}"
        setopt NO_NOMATCH   # disable some globbing

        function run() {
          nix run nixpkgs#$@
        }

        precmd() {
          printf '\033]0;%s\007' "$(dirs)"
        }

        command_not_found_handler() {
          printf 'Command not found ->\033[32;05;16m %s\033[0m \n' "$0" >&2
          return 127
        }

        export SUDO_PROMPT=$'Password for ->\033[32;05;16m %u\033[0m  '

        export FZF_DEFAULT_OPTS='
        --color fg:#${theme.colors.fg},bg:#${theme.colors.bg},hl:#${theme.colors.c4},fg+:#${theme.colors.c15},bg+:#${theme.colors.bg},hl+:#${theme.colors.c4},border:#${theme.colors.c8}
        --color pointer:#${theme.colors.c9},info:#${theme.colors.lbg},spinner:#${theme.colors.lbg},header:#${theme.colors.lbg},prompt:#${theme.colors.c2},marker:#${theme.colors.c10}
        '

        FZF_TAB_COMMAND=(
          ${pkgs.fzf}/bin/fzf
          --ansi
          --expect='$continuous_trigger' # For continuous completion
          --nth=2,3 --delimiter='\x00'  # Don't search prefix
          --layout=reverse --height="''${FZF_TMUX_HEIGHT:=50%}"
          --tiebreak=begin -m --bind=tab:down,btab:up,change:top,ctrl-space:toggle --cycle
          '--query=$query'   # $query will be expanded to query string at runtime.
          '--header-lines=$#headers' # $#headers will be expanded to lines of headers at runtime
          )
          zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND

          zstyle ':completion:complete:*:options' sort false
          zstyle ':fzf-tab:complete:_zlua:*' query-string input

          zstyle ':fzf-tab:complete:*:*' fzf-preview 'preview.sh $realpath'
      '';

      history = {
        expireDuplicatesFirst = true;
        extended = true;
        save = 50000;
      };

      plugins = with pkgs; [
        {
          name = "zsh-completions";
          src = pkgs.zsh-completions-src;
        }
        {
          name = "fzf-tab";
          src = pkgs.fzf-tab-src;
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.zsh-syntax-highlighting-src;
          file = "zsh-syntax-highlighting.zsh";
        }
      ];
    };
  };

  services = {
    flameshot = {
      enable = true;
      package = pkgs.master.flameshot;

      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          savePath = config.xdg.userDirs.pictures;
        };
      };
    };

    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    mpd = {
      enable = false;
      package = pkgs.master.mpd;
      musicDirectory = config.xdg.userDirs.music;
      extraConfig = import ./programs/mpd.nix { };
    };

    mpdris2 = {
      enable = config.services.mpd.enable;
      multimediaKeys = true;
    };

    playerctld.enable = true;
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      documents = "${config.home.homeDirectory}/Documents";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  xresources.extraConfig = import ./x/resources.nix { inherit theme; };
}
