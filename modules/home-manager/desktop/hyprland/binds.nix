{
  pkgs,
  lib,
  config,
  ...
}:
{
  wayland.windowManager.hyprland.settings =
    let
      alacritty = lib.getExe config.programs.alacritty.package;
      fuzzel = lib.getExe config.programs.fuzzel.package;
      # Gets HM wrapped version of firefox otherwise config is not used
      firefox = lib.getExe config.programs.firefox.finalPackage;
      wlogout = lib.getExe config.programs.wlogout.package;
      yazi = lib.getExe config.programs.yazi.package;
      unipicker = lib.getExe pkgs.unipicker;
      wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
      screenshot-copy = lib.getExe pkgs.custom.screenshot-copy;
      screenshot-swappy = lib.getExe pkgs.custom.screenshot-swappy;
      screen-record = lib.getExe pkgs.custom.screen-record;
      hyprpicker = lib.getExe pkgs.hyprpicker;
      wpctl = lib.getExe' pkgs.wireplumber "wpctl";
      playerctl = lib.getExe pkgs.playerctl;
      brightnessctl = lib.getExe pkgs.brightnessctl;
    in
    {
      "$mainMod" = "SUPER";

      bind =
        [
          # -- Programs
          # Terminal
          "$mainMod, Q, exec, ${alacritty}"
          # Launcher
          "$mainMod, R, exec, pidof fuzzel | ${fuzzel}"
          # firefox
          "$mainMod, E, exec, ${firefox}"
          "$mainMod, L, exec, pidof wlogout || ${wlogout} -b 1 -L 500 -R 500"
          "$mainMod, F, togglefloating"
          "$mainMod, W, exec, ${yazi}"
          "$mainMod, U, exec, ${unipicker} --command '${fuzzel} --dmenu' --copy-command ${wl-copy}"

          # -- Screenshots and screen recording
          "$mainMod, A, exec, ${screenshot-copy}"
          "$mainMod SHIFT, A, exec, ${screenshot-swappy}"
          "$mainMod SHIFT, P, exec, ${screen-record}"
          "$mainMod SHIFT, C, exec, ${hyprpicker} -a -t"

          # -- Audio
          ",XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioPrev, exec, ${playerctl} previous"
          ",XF86AudioNext, exec, ${playerctl} next"
          ",XF86AudioPlay, exec, ${playerctl} play-pause"

          # -- Window/Workspace management
          # Fullscreen
          "$mainMod SHIFT, F, fullscreen"
          # Close focused window
          "$mainMod, c, killactive"
          # Code 49 is `, toggle hyprspace overview
          "$mainMod, code:49, overview:toggle"
          # Move focus between windows
          "$mainMod, Tab, cyclenext, visible"
          # Move focus between monitors
          "$mainMod SHIFT, Tab, focusmonitor, +1"
          # Move window to and from scratchpad
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"
          # Bind to move windows from unplugged monitors onto current monitor
          "$mainMod SHIFT, G, split:grabroguewindows"
        ] # Adding binds to switch/move windows between workspaces
        ++ (builtins.concatLists (
          builtins.genList (
            x:
            let
              ws = toString (x + 1);
            in
            [
              "$mainMod, ${ws}, split:workspace, ${toString ws}"
              "$mainMod SHIFT, ${ws}, split:movetoworkspace, ${toString ws}"
            ]
          ) 5
        ));

      # Repeating binds
      binde = [
        # Brightness control, + CTRL for fine adjustment
        ",XF86MonBrightnessDown, exec, ${brightnessctl} s 5%-"
        "CTRL,XF86MONBrightnessDown, exec, ${brightnessctl} s 1%-"
        ",XF86MonBrightnessUp, exec, ${brightnessctl} s 5%+"
        "CTRL,XF86MONBrightnessUp, exec, ${brightnessctl} s 1%+"
        # Volume control, + CTRL for fine adjustment
        ",XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "CTRL,XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%-"
        ",XF86AudioRaiseVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        "CTRL,XF86AudioRaiseVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%+"
      ];

      # Mouse binds
      bindm = [
        # MOD + left click to move windows
        "$mainMod, mouse:272, movewindow"
        # MOD + right click to resoze windows
        "$mainMod SHIFT, mouse:272, resizewindow"
      ];
    };
}
