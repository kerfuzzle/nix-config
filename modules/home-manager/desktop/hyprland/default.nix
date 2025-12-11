{
  inputs,
  pkgs,
  lib,
  hostConfig,
  ...
}:
{
  imports = lib.custom.importAll ./.;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = {
      env = [
        "XCURSOR_SIZE,24"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      monitorv2 = hostConfig.hyprland.monitors;

      general = {
        gaps_out = 7;
        gaps_in = 3;
        border_size = 2;
      };

      decoration = {
        rounding = 5;
        inactive_opacity = 0.8;
      };

      animation = [
        # Make the special workspace slide in from the bottom
        "specialWorkspace, 1, 7, default, slidevert"
      ];

      gesture = [
        "3, horizontal, workspace"
        "3, up, special, magic"
      ];

      gestures = {
        workspace_swipe_distance = 100;
        workspace_swipe_create_new = true;
        workspace_swipe_min_speed_to_force = 15;
      };

      cursor = {
        inactive_timeout = 15;
      };

      # Disable launch popups
      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      misc = {
        # Disable builtin wallpapers
        disable_hyprland_logo = true;
        # Enable variable refresh rate
        # vrr = 1;
      };
    };
  };
}
