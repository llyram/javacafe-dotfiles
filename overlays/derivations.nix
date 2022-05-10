final: prev:
{
  luaFormatter = prev.callPackage ../derivations/luaFormatter.nix {
    src = prev.luaFormatter-src;
    version = "999-master";
  };

  #  wezterm-git = prev.callPackage ../derivations/wezterm-git.nix {
  #    src = prev.wezterm-git-src;
  #    version = "999-master";
  #    naersk-lib = prev.naersk-lib;
  #  };
}
