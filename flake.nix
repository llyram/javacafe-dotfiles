{
  description = "JavaCafe's NixOS configuration";

  inputs = {
    # Flake inputs
    discocss.url = "github:mlvzk/discocss/flake";
    home.url = "github:nix-community/home-manager";
    naersk.url = "github:nix-community/naersk";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nix-matlab.url = "gitlab:doronbehar/nix-matlab";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    nur.url = "github:nix-community/NUR";

    # Nixpkgs branches
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-21.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Non Flakes
    luaFormatter = {
      type = "git";
      url = "https://github.com/Koihik/LuaFormatter.git";
      submodules = true;
      flake = false;
    };

    fzf-tab = { url = "github:Aloxaf/fzf-tab"; flake = false; };
    zsh-completions = { url = "github:zsh-users/zsh-completions"; flake = false; };
    zsh-syntax-highlighting = { url = "github:zsh-users/zsh-syntax-highlighting"; flake = false; };

    # Default branch
    nixpkgs.follows = "nixos-unstable";

    discocss.inputs.nixpkgs.follows = "nixpkgs";
    home.inputs.nixpkgs.follows = "nixpkgs";
    naersk.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    nix-matlab.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-f2k.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, home, nixpkgs, discocss, naersk, nixpkgs-f2k, nixos-wsl, ... }@inputs:
      with nixpkgs.lib;
      let
        config = {
          allowBroken = true;
          allowUnfree = true;
          tarball-ttl = 0;
        };

        filterNixFiles = k: v: v == "regular" && hasSuffix ".nix" k;

        importNixFiles = path:
          (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
            (filterAttrs filterNixFiles (builtins.readDir path)))) import;

        overlays = with inputs;
          [
            (final: _:
              let inherit (final) system;
              in
              {
                # Packages provided by flake inputs
                discocss = discocss.defaultPackage.${system};
                naersk-lib = naersk.lib."${system}";
                neovim-nightly = neovim.packages."${system}".neovim;
              } // (with nixpkgs-f2k.packages.${system}; {
                # Overlays with f2k's repo
                awesome = awesome-git;
                picom = picom-git;
                wezterm = wezterm-git;
              }) // {
                # Non Flakes
                fzf-tab-src = fzf-tab;
                luaFormatter-src = luaFormatter;
                zsh-completions-src = zsh-completions;
                zsh-syntax-highlighting-src = zsh-syntax-highlighting;

                /* Nixpkgs branches

                  One can access these branches like so:

                  `pkgs.stable.mpd'
                  `pkgs.master.linuxPackages_xanmod'
                */
                master = import master { inherit config system; };
                unstable = import unstable { inherit config system; };
                stable = import stable { inherit config system; };
              })
            nur.overlay
            neovim-nightly.overlay
            nix-matlab.overlay
            nixpkgs-f2k.overlay
          ]
          # Overlays from ./overlays directory
          ++ (importNixFiles ./overlays);
      in
      {
        nixosConfigurations = {
          thonkpad = import ./hosts/thonkpad {
            inherit config nixpkgs overlays discocss inputs;
          };

          nixbox = import ./hosts/nixbox {
            inherit config nixpkgs nixos-wsl overlays inputs;
          };
        };

        homeConfigurations = {
          javacafe01 = import ./users/javacafe01 {
            inherit config nixpkgs home discocss overlays inputs;
          };

          meems = import ./users/meems {
            inherit config nixpkgs home overlays;
          };
        };

        thonkpad = self.nixosConfigurations.thonkpad.config.system.build.toplevel;
        nixbox = self.nixosConfigurations.nixbox.config.system.build.toplevel;
      };
}
