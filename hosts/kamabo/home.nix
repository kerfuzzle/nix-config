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
  };

  wayland.windowManager.hyprland.settings = {
    env = [
      "AQ_DRM_DEVICES,${config.lib.file.mkOutOfStoreSymlink "/dev/dri/by-path/pci-0000:00:02.0-card"}"
    ];

    misc.vfr = true;
  };
}
