{ config, nixos-hardware, nixpkgs, overlays, discocss, inputs, ... }:

nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";

  modules = [
    {
      nix = import ../../nix-settings.nix { inherit inputs system nixpkgs; };
      nixpkgs = { inherit config overlays; };
    }

    nixos-hardware.nixosModules.framework

    ./configuration.nix
  ];

  specialArgs = { };
}
