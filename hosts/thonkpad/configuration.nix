# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  theme = import ../../theme/theme.nix { };
in
{

  boot = {
    initrd = {
      availableKernelModules = [ "battery" ];
      kernelModules = [ "i915" ];
    };

    kernelModules = [
      "acpi_call"
      "iwlwifi"
    ];

    kernelParams = [
      "acpi_backlight=native"
      "psmouse.synaptics_intertouch=0"
      "i915.enable_psr=0"
      "i915.enable_guc=2"
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    resumeDevice = "/dev/nvme0n1p5";
  };

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
      __GL_MaxFramesAllowed = "0";
      VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };

    enableRedistributableFirmware = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    trackpoint = {
      enable = true;
      device = "TPPS/2 Elan TrackPoint";
      emulateWheel = true;
    };
  };

  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix

    # Shared configuration across all machines
    ../shared/configuration.nix
  ];

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

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    seahorse.enable = true;
  };

  services = {
    acpid.enable = true;
    blueman.enable = true;

    dbus = {
      enable = true;
      packages = with pkgs; [ dconf ];
    };

    fprintd.enable = true;
    fstrim.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    logind.lidSwitch = "suspend";

    picom = {
      enable = true;
      experimentalBackends = true;
      backend = "glx";
      vSync = true;
      shadow = true;
      shadowOffsets = [ (-40) (-40) ];
      shadowOpacity = 0.50;

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
        shadow-radius = 40;
        use-damage = true;

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

    throttled.enable = true;

    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 0;
        STOP_CHARGE_THRESH_BAT0 = 85;
      };
    };

    upower.enable = true;

    xserver = {
      enable = true;

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

      dpi = 216;
      exportConfiguration = true;
      layout = "us";

      libinput = {
        enable = true;

        touchpad = {
          accelSpeed = "0.4";
          naturalScrolling = true;
        };
      };

      useGlamor = true;

      windowManager = {
        awesome = {
          enable = true;

          luaModules = lib.attrValues {
            inherit (pkgs.luaPackages)
              lgi
              ldbus
              luadbi-mysql
              luaposix;
          };
        };
      };
    };
  };

  system.stateVersion = "22.05";
}
