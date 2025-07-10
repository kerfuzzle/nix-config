{
  config,
  inputs,
  settings,
  pkgs,
  ...
}:
{
  imports = [ ./battery.nix ];
  home = {
    username = settings.username;
    homeDirectory = "/home/${settings.username}";
    stateVersion = "24.05";
  };

  wayland.windowManager.hyprland.settings = {
    env = [
      "AQ_DRM_DEVICES,${config.lib.file.mkOutOfStoreSymlink "/dev/dri/by-path/pci-0000:00:02.0-card"}"
    ];

    misc.vfr = true;
  };
}
