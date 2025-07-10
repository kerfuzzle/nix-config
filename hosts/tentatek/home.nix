{
  config,
  inputs,
  settings,
  pkgs,
  lib,
  ...
}:
{
  home = {
    username = settings.username;
    homeDirectory = "/home/${settings.username}";
    stateVersion = "24.05";
  };

  wayland.windowManager.hyprland.settings = {
    env = [
      "LIBVA_DRIVER_NAME,nvidia"
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    ];

    cursor = {
      no_hardware_cursors = true;
    };
  };

  services.hypridle.enable = lib.mkForce false;
}
