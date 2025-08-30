{ lib, config, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Remap power button to lock session
  services.logind.settings.Login.HandlePowerKey = "lock";

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Host specific configuration options, disables/enables config within FLAKE/modules/nixos
  hostConfig = {
    username = "kerfuzzle";
    hostname = "kamabo";

    hyprland = {
      enable = true;
      monitors = [
        {
          # Laptop built-in display
          output = "eDP-1";
          # Run at 60Hz to save battery
          # When plugged in its usually a secondary monitor so doesn't need to run at 144hz
          mode = "1920x1080@60";
          position = "0x0";
          scale = 1;
        }
        {
          # External 4K display
          output = "desc:Microstep MAG274UPF CC2H974200553";
          mode = "3840x2160@144";
          # Position to the right of the laptop display when plugged in
          position = "1920x0";
          # Increase scale so everything isn't tiny
          scale = 1.5;
        }
        # Rule for picking up random monitors
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];
    };

    sops.enable = true;

    restic.enable = true;

    impermanence = {
      enable = true;
      oldRootCount = 10;
    };

    lanzaboote.enable = true;

    nvidia = {
      enable = true;
      hybrid = {
        # Use offload hybrid graphics, use `nvidia-offload COMMAND` to run on dGPU
        enable = true;
        # BDF bus IDs obtained from `lspci -d ::03xx' in format `domain:bus:device.function`
        nvidiaBdfBusId = "0000:01:00.0";
        intelBdfBusId = "0000:00:02.0";
      };
    };

    droidcam.enable = false;

    iosSupport.enable = true;

    # For theming in system level programs
    theming = {
      enable = true;
      stylix.enable = true;
      base16.name = "catppuccin-frappe";
    };

    gaming = {
      steam.enable = true;
      gamemode.enable = true;
    };

    tailscale = {
      enable = true;
      devices = import (lib.custom.configRoot + /resources/tailscale-devices.nix);
    };

    smbClient = {
      enable = true;
      shares = [
        {
          name = "kerfuzzle-nas";
          # Uses tailscale ip
          device = "//${config.hostConfig.tailscale.devices.inkline.ipv4}/kerfuzzle-nas";
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
        "flat"
      ];
      eapWirelessNetworks = [
        "ducks"
      ];
    };

    batteryControl = {
      enable = true;
      chargeLimit = 80;
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # DON'T CHANGE APART FROM BEFORE A FRESH INSTALL!!!
  system.stateVersion = "25.05"; # Did you read the comment?
}
