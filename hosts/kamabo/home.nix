{
  config,
  inputs,
  settings,
  pkgs,
  ...
}:
{
  home = {
    username = settings.username;
    homeDirectory = "/home/${settings.username}";
    stateVersion = "24.05";
  };

  batteryNotifier.enable = true;

  wayland.windowManager.hyprland.settings = {
    env = [
      "AQ_DRM_DEVICES,${config.lib.file.mkOutOfStoreSymlink "/dev/dri/by-path/pci-0000:00:02.0-card"}"
    ];

    misc.vfr = true;
  };
}
