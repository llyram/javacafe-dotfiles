{ config, nixpkgs, nixos-wsl, overlays, inputs }:

nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";

  modules = [
    nixos-wsl.nixosModules.wsl

    {
      wsl = {
        enable = true;
        automountPath = "/mnt";
        defaultUser = "meems";
        startMenuLaunchers = true;
      };

      nix = import ../../nix-settings.nix { inherit inputs system nixpkgs; };
      nixpkgs = { inherit config overlays; };
    }

    ./configuration.nix
  ];

  specialArgs = { };
}
