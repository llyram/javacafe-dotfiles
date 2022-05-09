{ config, nixpkgs, home, discocss, overlays, inputs }:

home.lib.homeManagerConfiguration rec {
  system = "x86_64-linux";
  username = "javacafe01";
  homeDirectory = "/home/${username}";

  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    inherit overlays;
  };

  configuration.imports = [
    # { nixpkgs = { inherit config overlays; }; }
    ./home.nix
  ];

  # Default nixpkgs for home.nix
  # pkgs = nixpkgs.outputs.legacyPackages.${system};

  # Extra home-manager modules that aren't upstream
  extraModules = [
    discocss.hmModule
  ];

  # Extra arguments passed to home.nix
  extraSpecialArgs = { };

  /*
    NOTE: DO NOT CHANGE THIS IF YOU DON'T KNOW WHAT YOU'RE DOING.

    Only change this if you are ABSOLUTELY 100% SURE that you don't have stateful data.
  */
  stateVersion = "22.05";
}
