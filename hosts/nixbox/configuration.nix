{ lib, pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    cmake
    coreutils
    curl
    ffmpeg
    fzf
    gcc
    git
    glib
    gnumake
    gnutls
    home-manager
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
    xarchiver
    xclip
    zip
  ];

  programs = {
    bash.promptInit = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';
    dconf.enable = true;
  };

  users.users.meems = {
    isNormalUser = true;
    home = "/home/meems";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };
}
