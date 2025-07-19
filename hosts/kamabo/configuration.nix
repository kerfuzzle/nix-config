# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  settings,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    #./asus.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.logind.powerKey = "ignore";

  hostConfig = {
    username = "kerfuzzle";

    sops.enable = true;

    impermanence = {
      enable = true;
      oldRootCount = 10;
    };

    lanzaboote.enable = true;

    nvidia = {
      enable = true;
      hybrid = {
        enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };

    droidcam = {
      enable = true;
      iosUSBSupport = true;
    };

    theming = {
      stylix = {
        enable = true;
      };
      base16Scheme = "catppuccin-frappe";
    };

    gaming = {
      steam.enable = true;
      gamemode.enable = true;
    };

    tailscale.enable = true;

    smbClient = {
      enable = true;
      shares = [
        {
          name = "kerfuzzle-nas";
          # Uses tailscale ip
          device = "//100.93.207.105/kerfuzzle-nas";
        }
      ];
    };

    graphicsTablet.enable = true;

    networkmanager = {
      enable = true;
      standardWirelessNetworks = [
        "home"
        "tether"
        "cafe"
      ];
    };

    batteryControl = {
      enable = true;
      chargeLimit = 80;
    };
  };

  hardware.bluetooth.enable = true;

  networking.hostName = settings.hostname; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
    earlySetup = true;
  };

  #services.power-profiles-daemon.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
