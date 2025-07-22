{
  inputs,
  pkgs,
  lib,
  config,
  settings,
  ...
}:
{
  imports = [
    ./binds.nix
    ./input.nix
    ./plugins.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

    settings = {
      env = [
        "XCURSOR_SIZE,24"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      exec-once = "waybar";

      monitor = settings.monitors;

      general = {
        gaps_out = 7;
        gaps_in = 3;
        border_size = 2;
      };

      decoration = {
        rounding = 5;
        inactive_opacity = 0.8;
      };

      # Disable unfocus transparency for some applications
      windowrulev2 = builtins.map (e: "opacity 1.0 1.0 override, " + e) [
        "title:(.*)(- YouTube)(.*)"
        "title:(.*)(Apple Music)(.*)"
        "title:(.*)(.pdf)(.*)"
        "title:(Picture-in-Picture)"
        "class:^(discord)"
        "class:^(Code)"
      ];

      animation = [
        "specialWorkspace, 1, 7, default, slidevert"
      ];

      gestures = {
        workspace_swipe = true;
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
        vrr = 1;
      };
    };
  };
}
