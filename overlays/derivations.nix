final: prev:
{
  luaFormatter = prev.callPackage ../derivations/luaFormatter.nix {
    src = prev.luaFormatter-src;
    version = "999-master";
  };
}
