{
  inputs,
  pkgs,
  lib,
  config,
  settings,
  ...
}:
let
  ruleToString = name: value: (builtins.map (v: "${v}, ${name}") value);
  convertWindowRules = windowRules: windowRules |> lib.mapAttrsToList ruleToString |> lib.concatLists;
in
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

      exec-once = lib.getExe config.programs.waybar.package;

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

      windowrule =
        (convertWindowRules {
          # Automatically resize and move Picture-in-Picture windows
          "class: firefox, title:Picture-in-Picture" = [
            "float"
            "size 25% 25%"
            "move 100%-w-20 100%-w-20"
            "keepaspectratio"
            "opaque"
          ];
          "class: qalculate.*" = [
            "float"
            "size 30% 30%"
            "move 100%-w-20 100%-w-20"
          ];
        })
        # Disable unfocus transparency for some applications
        ++ builtins.map (e: "opaque, " + e) [
          "class:firefox, title:(.*)(- YouTube)(.*)"
          # For some reason the title here uses a "no-break space" so use . to specify any character
          "class:firefox, title:(.*)(Apple.Music)(.*)"
          "class:firefox, title:(.*)(\\.pdf)(.*)"
          "class:zathura"
          "class:discord"
          "class:Code"
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
        # vrr = 1;
      };
    };
  };
}
