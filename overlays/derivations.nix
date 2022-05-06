final: prev: {
  luaFormatter = prev.callPackage ../derivations/luaFormatter.nix {
    src = prev.luaFormatter-src;
  };

  wezterm-nightly = prev.callPackage ../derivations/wezterm-nightly.nix {
  };
}
