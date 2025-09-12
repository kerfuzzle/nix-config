{
  pkgs,
  lib,
  config,
  ...
}:
{
  wayland.windowManager.hyprland.settings =
    let
      mod = "SUPER";

      alacritty = lib.getExe config.programs.alacritty.package;
      fuzzel = lib.getExe config.programs.fuzzel.package;
      # Gets HM wrapped version of firefox otherwise config is not used
      firefox = lib.getExe config.programs.firefox.finalPackage;
      wlogout = lib.getExe config.programs.wlogout.package;
      yazi = lib.getExe config.programs.yazi.package;
      qalculate = lib.getExe pkgs.qalculate-gtk;
      unipicker = lib.getExe pkgs.unipicker;
      wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
      screenshot-copy = lib.getExe pkgs.custom.screenshot-copy;
      screenshot-swappy = lib.getExe pkgs.custom.screenshot-swappy;
      screen-record = lib.getExe pkgs.custom.screen-record;
      hyprpicker = lib.getExe pkgs.hyprpicker;
      wpctl = lib.getExe' pkgs.wireplumber "wpctl";
      playerctl = lib.getExe pkgs.playerctl;
      brightnessctl = lib.getExe pkgs.brightnessctl;

      mkTerminalLaunch = app: "${alacritty} -e ${app}";
    in
    {
      bind = [
        # -- Programs
        # Terminal
        "${mod}, Q, exec, ${alacritty}"
        # Launcher
        "${mod}, R, exec, pidof fuzzel | ${fuzzel}"
        # Firefox
        "${mod}, E, exec, ${firefox}"
        # Calculator
        "${mod}, X, exec, ${qalculate}"
        # Power menu
        "${mod}, Escape, exec, pidof wlogout || ${wlogout} -b 1 -L 500 -R 500"
        # File manager
        "${mod}, W, exec, ${mkTerminalLaunch yazi}"
        # Unicode character picker
        "${mod}, U, exec, ${unipicker} --command '${fuzzel} --dmenu' --copy-command ${wl-copy}"

        # -- Screenshots and screen recording
        "${mod}, A, exec, ${screenshot-copy}"
        "${mod} SHIFT, A, exec, ${screenshot-swappy}"
        "${mod} SHIFT, P, exec, ${screen-record}"
        "${mod} SHIFT, C, exec, ${hyprpicker} -a -t"

        # -- Window/Workspace management
        # Float window
        "${mod}, F, togglefloating"
        # Fullscreen
        "${mod} SHIFT, F, fullscreen"
        # Close focused window
        "${mod}, c, killactive"
        # Move focus between windows
        "${mod}, Tab, cyclenext"
        # Move focus between monitors
        "${mod} SHIFT, Tab, focusmonitor, +1"
        # Move focus between windows
        "${mod}, H, movefocus, l"
        "${mod}, J, movefocus, d"
        "${mod}, K, movefocus, u"
        "${mod}, L, movefocus, r"
        # Move windows
        "${mod} SHIFT, H, movewindow, l"
        "${mod} SHIFT, J, movewindow, d"
        "${mod} SHIFT, K, movewindow, u"
        "${mod} SHIFT, L, movewindow, r"
        # Move windows between monitors
        "${mod} CTRL, H, movewindow, mon:l"
        "${mod} CTRL, J, movewindow, mon:d"
        "${mod} CTRL, K, movewindow, mon:u"
        "${mod} CTRL, L, movewindow, mon:r"
        # Move window to and from special workspace
        "${mod}, S, togglespecialworkspace, magic"
        "${mod} SHIFT, S, movetoworkspace, special:magic"
        # Bind to move windows from unplugged monitors onto current monitor
        "${mod} SHIFT, G, split:grabroguewindows"
      ] # Adding binds to switch/move windows between workspaces
      ++ (builtins.concatLists (
        builtins.genList (
          x:
          let
            ws = toString (x + 1);
          in
          [
            "${mod}, ${ws}, split:workspace, ${toString ws}"
            "${mod} SHIFT, ${ws}, split:movetoworkspace, ${toString ws}"
          ]
        ) 5
      ));

      # Binds that still work when locked
      bindl = [
        # -- Audio
        ",XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioPrev, exec, ${playerctl} previous"
        ",XF86AudioNext, exec, ${playerctl} next"
        ",XF86AudioPlay, exec, ${playerctl} play-pause"
      ];

      # Repeating binds
      binde = [
        # Brightness control, + CTRL for fine adjustment
        ",XF86MonBrightnessDown, exec, ${brightnessctl} s 5%- -n 1"
        "CTRL,XF86MONBrightnessDown, exec, ${brightnessctl} s 1%- -n 1"
        ",XF86MonBrightnessUp, exec, ${brightnessctl} s 5%+ -n 1"
        "CTRL,XF86MONBrightnessUp, exec, ${brightnessctl} s 1%+ -n 1"
        # Volume control, + CTRL for fine adjustment
        ",XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "CTRL,XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%-"
        ",XF86AudioRaiseVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        "CTRL,XF86AudioRaiseVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%+"
      ];

      # Mouse binds
      bindm = [
        # MOD + left click to move windows
        "${mod}, mouse:272, movewindow"
        # MOD + right click to resoze windows
        "${mod} SHIFT, mouse:272, resizewindow"
      ];
    };
}
