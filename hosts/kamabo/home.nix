{
  config,
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
      wallpaper = lib.custom.configRoot + /assets/walls/nix-frappe.png;
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
        dimScreen = 180;
        dimKeyboard = 180;
        lock = 300;
        disableDisplay = 330;
        hibernate = 600;
      };
    };

    gaming = {
      olympus.enable = false;
      minecraft.enable = false;
      heroic.enable = true;
    };
  };

  wayland.windowManager.hyprland.settings = {
    misc.vfr = true;
  };
}
