{ config, nixpkgs, home, discocss, overlays, inputs }:

home.lib.homeManagerConfiguration rec {
  modules = [
    ./home.nix
    discocss.hmModule
    
    {
      home = {
        username = "javacafe01";
        homeDirectory = "/home/javacafe01";
        stateVersion = "22.05";
      };
    }
  ];

  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    inherit overlays;
  };
}
