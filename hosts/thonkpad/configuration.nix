# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let theme = import ../../theme/theme.nix { };
in
{

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

    initrd.kernelModules = [ "i915" ];

    kernelModules = [ "acpi_call" "iwlwifi" ];

    kernelParams = [
      "acpi_backlight=native"
      "i915.enable_psr=0"
    ];

    kernel.sysctl."vm.swappiness" = 1;

    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        configurationLimit = 2;
        enable = true;
        version = 2;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };

    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        vaapiIntel
        libvdpau-va-gl
        intel-media-driver
        vaapiVdpau
      ];
    };

    pulseaudio = {
      enable = true;
      daemon.config.avoid-resampling = "yes";
      support32Bit = true;

      tcp = {
        enable = true;
        anonymousClients.allowedIpRanges = [ "127.0.0.1" ];
      };

      package = pkgs.pulseaudioFull;
      extraConfig = "\n    load-module module-switch-on-connect\n    ";
    };

    sensor.iio.enable = true;

    trackpoint = {
      enable = true;
      emulateWheel = true;
    };
  };

  imports = [
    ./hardware-configuration.nix

    # Shared configuration across all machines
    ../shared/configuration.nix
  ];

  environment = {
    sessionVariables = with pkgs; { _JAVA_AWT_WM_NONREPARENTING = "1"; };

    systemPackages = with pkgs; [
      acpi
      brightnessctl
      firefox
      inotify-tools
      iwgtk
      libnotify
      librsvg
      pavucontrol
      polkit_gnome
      slop
      rxvt_unicode
    ];

    variables = {
      VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    };
  };

  networking = {
    hostName = "thonkpad";

    interfaces = {
      enp0s31f6.useDHCP = true;
      wlan0.useDHCP = true;
    };

    networkmanager.enable = false;

    useDHCP = false;

    wireless.iwd.enable = true;
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    acpid.enable = true;
    blueman.enable = true;

    dbus = {
      enable = true;

      packages =
        let
          mopidyDbusServiceFile = pkgs.writeTextFile rec {
            name = "org.mpris.MediaPlayer2.mopidy.conf";
            destination = "/share/dbus-1/system.d/${name}";
            text = ''
              <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
              "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
              <busconfig>
              <!-- Allow mopidy user to publish the Mopidy-MPRIS service -->
              <policy user="mopidy">
              <allow own="org.mpris.MediaPlayer2.mopidy"/>
              </policy>
              <!-- Allow anyone to invoke methods on the Mopidy-MPRIS service -->
              <policy context="default">
              <allow send_destination="org.mpris.MediaPlayer2.mopidy"/>
              <allow receive_sender="org.mpris.MediaPlayer2.mopidy"/>
              </policy>
              </busconfig>
            '';
          };
        in
        with pkgs; [ dconf mopidyDbusServiceFile ];
    };

    fprintd.enable = true;
    fstrim.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;

    mopidy = {
      enable = true;
      extensionPackages = with pkgs; [ mopidy-spotify mopidy-mpris mopidy-mpd ];
      configuration = ''
        [mpris]
        bus_type = system

        [audio]
        output = pulsesink server=127.0.0.1
        
        [spotify]
        enabled = true
        client_id = <client_id>
        client_secret = <client_secret>
        username = <username>
        password = <password>
        bitrate = 320
      '';
    };

    picom = {
      enable = true;
      experimentalBackends = true;
      backend = "glx";
      vSync = true;
      shadow = true;
      shadowOffsets = [ (-12) (-12) ];
      shadowOpacity = 0.75;

      shadowExclude = [
        "class_g = 'slop'"
        "window_type = 'menu'"
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "class_g = 'Firefox' && window_type *= 'utility'"
        "_GTK_FRAME_EXTENTS@:c"
      ];

      opacityRules = [
        "70:class_g = 'splash'"
      ];

      wintypes = {
        popup_menu = { full-shadow = true; };
        dropdown_menu = { full-shadow = true; };
        notification = { full-shadow = true; };
        normal = { full-shadow = true; };
      };

      settings = {
        shadow-radius = 12;

        # corner-radius = 10;
        rounded-corners-exclude = [
          "!window_type = 'normal'"
        ];

        blur-method = "dual_kawase";
        blur-strength = 7.0;
        kernel = "11x11gaussian";
        blur-background = false;
        blur-background-frame = true;
        blur-background-fixed = true;

        blur-background-exclude = [
          "!window_type = 'splash'"
        ];
      };

    };

    thermald.enable = true;
    tlp.enable = lib.mkDefault ((lib.versionOlder (lib.versions.majorMinor lib.version) "21.05")
      || !config.services.power-profiles-daemon.enable);
    upower.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      libinput.enable = true;
      dpi = 144;
      wacom.enable = true;
      videoDrivers = [ "modesetting" ];
      deviceSection = ''
        Option "DRI" "3"
      '';
      useGlamor = true;

      displayManager = {
        autoLogin = {
          enable = true;
          user = "javacafe01";
        };

        defaultSession = "none+awesome";

        lightdm = {
          enable = true;
        };
      };

      windowManager = {
        awesome = {
          enable = true;

          luaModules = with pkgs.luaPackages; [
            lgi
            ldbus
            luadbi-mysql
            luaposix
          ];
        };
      };
    };
  };

  system.stateVersion = "22.05";
}
