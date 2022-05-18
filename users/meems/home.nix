{ config, lib, pkgs, ... }:

/*
  home-manager configuration
  Useful links:
  - Home Manager Manual: https://rycee.gitlab.io/home-manager/
  - Appendix A. Configuration Options: https://rycee.gitlab.io/home-manager/options.html
*/
let
  customNodePackages = pkgs.callPackage ../../derivations/customNodePackages { };
  theme = import ../../theme/theme.nix { };
in
{

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

      ".local/bin/preview.sh" = {
        # Preview script for fzf tab
        executable = true;
        text = import ../javacafe01/bin/preview.nix { inherit pkgs; };
      };

    };

    packages = with pkgs; [
      fd
      neofetch
      neovim
      nixpkgs-fmt
      trash-cli

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
      sumneko-lua-language-server

      # Formatters
      black
      ktlint
      luaFormatter
      nixfmt
      nixpkgs-fmt
      rustfmt
      shfmt

      (ripgrep.override { withPCRE2 = true; })
    ];

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];

    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
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
      } // (with config.lib.htop; leftMeters [
        (bar "AllCPUs")
        (bar "Memory")
        (bar "Swap")
      ]) // (with config.lib.htop; rightMeters [
        (text "Tasks")
        (text "LoadAverage")
        (text "Uptime")
      ]);
    };

    exa = {
      enable = true;
      enableAliases = false;
    };

    starship = {
      enable = true;
      settings = import ../javacafe01/programs/starship.nix;
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
        export PATH="''${HOME}/.local/bin:''${HOME}/go/bin:''${HOME}/.npm/bin:''${HOME}/.cargo/bin:''${PATH}"
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
}

