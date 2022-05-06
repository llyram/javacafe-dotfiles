{ stdenv, pkgs, src, ... }:

stdenv.mkDerivation rec {
  name = "lua-format";
  version = "999-master";
  inherit src;
  nativeBuildInputs = [ pkgs.cmake ];
}
