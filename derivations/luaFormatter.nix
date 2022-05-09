{ stdenv, pkgs, src, version, ... }:

stdenv.mkDerivation rec {
  name = "lua-format";
  inherit version;
  inherit src;
  nativeBuildInputs = [ pkgs.cmake ];
}
