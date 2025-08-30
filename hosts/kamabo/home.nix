{
  pkgs,
  lib,
  hostConfig,
  ...
}:
{
  homeConfig = {
    theming = {
      enable = true;
      stylix.enable = true;
      # Follow system colour scheme
      base16.name = hostConfig.theming.base16.name;
      wallpaper = lib.custom.configRoot + /resources/walls/nix-frappe.png;
    };

    batteryNotifier.enable = true;

    hyprsunset = {
      enable = true;
      sunsetTime = "21:00";
      sunriseTime = "6:00";
    };

    hypridle = {
      enable = true;
      keyboardDeviceName = "asus::kbd_backlight";
      timeouts = {
        dimScreen = {
          ac = 300;
          bat = 180;
        };
        dimKeyboard = {
          ac = 300;
          bat = 180;
        };
        lock = {
          ac = 300;
          bat = 300;
        };
        disableDisplay = {
          ac = 600;
          bat = 330;
        };
        hibernate = {
          ac = 1200;
          bat = 600;
        };
      };
    };

    gaming = {
      olympus.enable = false;
      minecraft.enable = false;
      heroic.enable = true;
    };

    media = {
      libreoffice.enable = true;
      gimp.enable = true;
      xournal.enable = false;
    };

    sops.enable = true;
  };

  wayland.windowManager.hyprland.settings =
    let
      playerctl = lib.getExe pkgs.playerctl;
    in
    {
      # Laptop doesn't have media keys so these work as substitutes
      # bindl allows the binds to work when the session is locked
      bindl = [
        # "Next" is PgDn
        ",Next, exec, ${playerctl} play-pause"
        ",Home, exec, ${playerctl} previous"
        ",End, exec, ${playerctl} next"
      ];
      misc.vfr = true;
    };
}
