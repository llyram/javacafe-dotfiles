{ stdenv
, rustPlatform
, lib
, fetchFromGitHub
, pkg-config
, fontconfig
, python3
, openssl
, perl
, dbus
, libX11
, xcbutil
, libxcb
, xcbutilimage
, xcbutilkeysyms
, xcbutilwm # contains xcb-ewmh among others
, libxkbcommon
, libglvnd # libEGL.so.1
, egl-wayland
, wayland
, libGLU
, libGL
, freetype
, zlib
}:
let
  runtimeDeps = [
    zlib
    fontconfig
    freetype
    libX11
    xcbutil
    libxcb
    xcbutilimage
    xcbutilkeysyms
    xcbutilwm
    libxkbcommon
    dbus
    libglvnd
    egl-wayland
    wayland
    libGLU
    libGL
    openssl
  ];

in
rustPlatform.buildRustPackage rec {
  pname = "wezterm-nightly";
  version = "999-master";

  src = fetchFromGitHub {
    owner = "wez";
    repo = "wezterm";
    rev = "dc0fde7ae001b5210d2cd4752c71429af08d8ac4";
    sha256 = "sha256-XLp9RhgLGgqs+iu7purxIVn+FsISUD3NoBLydSY7lyY=";
    fetchSubmodules = true;
  };

  postPatch = ''
    echo ${version} > .tag
  '';

  cargoSha256 = "sha256-2Lt2b77iRbhdOinQxYriAZC4nyAwV1mwWHctXB0hnm8=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config python3 perl ];

  buildInputs = runtimeDeps;

  preFixup = lib.optionalString stdenv.isLinux ''
    for artifact in wezterm wezterm-gui wezterm-mux-server strip-ansi-escapes; do
      patchelf --set-rpath "${
        lib.makeLibraryPath runtimeDeps
      }" $out/bin/$artifact
    done
  '';

  # prevent further changes to the RPATH
  dontPatchELF = true;

  meta = with lib; {
    description =
      "A GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust";
    homepage = "https://wezfurlong.org/wezterm";
    license = licenses.mit;
    maintainers = with maintainers; [ steveej SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
