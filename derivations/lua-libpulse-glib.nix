{ buildLuarocksPackage
, luaOlder
, luaAtLeast
, fetchgit
, lua
, src
, version
}:

buildLuarocksPackage {
  pname = "lua-libpulse-glib";
  
  inherit version;
  inherit src;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/sclu1034/lua-libpulse-glib";
    description = "Lua bindings for PulseAudio's libpulse, using the GLib Main Loop.";
    license.fullName = "GPLv3";
  };
}
