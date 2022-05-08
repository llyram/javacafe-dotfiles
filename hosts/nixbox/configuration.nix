{ lib, pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    home-manager
    vim
  ];

  users.users.meems = {
    isNormalUser = true;
    home = "/home/meems";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };
}
