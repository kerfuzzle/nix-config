{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.niri.settings.binds =
    let
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
    lib.mapAttrs (_: value: value // { repeat = false; }) (
      {
        # Terminal
        "Mod+Q".action.spawn = alacritty;
        # Launcher
        "Mod+R".action.spawn = fuzzel;
        # Browser
        "Mod+E".action.spawn = firefox;
        # Calculator
        "Mod+X".action.spawn = qalculate;
        # Power menu
        "Mod+Escape".action.spawn-sh = "pidof wlogout || ${wlogout} -b 1 -L 500 -R 500";
        # File manager
        "Mod+W".action.spawn = mkTerminalLaunch yazi;
        # Unicode picker
        "Mod+U".action.spawn-sh = "${unipicker} --command '${fuzzel} --dmenu' --copy-command ${wl-copy}";

        # -- Screenshots and screen recording
        "Mod+A".action.spawn = screenshot-copy;
        "Mod+Shift+A".action.spawn = screenshot-swappy;
        "Mod+Shift+P".action.spawn = screen-record;
        "Mod+Shift+C".action.spawn-sh = "${hyprpicker} -a -t";

        # -- Window/Workspace management
        # Float window
        "Mod+F".action.toggle-window-floating = [ ];
        # Fullscreen
        "Mod+Shift+F".action.fullscreen-window = [ ];
        # Close focused window
        "Mod+C".action.close-window = [ ];
      }
      // (lib.mergeAttrsList (
        builtins.genList (
          x:
          let
            ws = x + 1;
          in
          {
            "Mod+${toString ws}".action.focus-workspace = ws;
            "Mod+Shift+${toString ws}".action.move-column-to-workspace = ws;
          }
        ) 5
      ))
      // (lib.mapAttrs (_: value: value // { allow-when-locked = true; }) {
        # --- Binds that work when locked
        XF86AudioMicMute.action.spawn-sh = "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        XF86AudioMute.action.spawn-sh = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
        XF86AudioPrev.action.spawn-sh = "${playerctl} previous";
        XF86AudioNext.action.spawn-sh = "${playerctl} next";
        XF86AudioPlay.action.spawn-sh = "${playerctl} play-pause";
      })
    )
    // {
      # --- Repeating binds
      # Brightness control, + CTRL for fine adjustment
      XF86MONBrightnessDown.action.spawn-sh = "${brightnessctl} s 5%- -n 1";
      "Ctrl+XF86MonBrightnessDown".action.spawn-sh = "${brightnessctl} s 1%- -n 1";
      XF86MONBrightnessUp.action.spawn-sh = "${brightnessctl} s 5%+ -n 1";
      "Ctrl+XF86MonBrightnessUp".action.spawn-sh = "${brightnessctl} s 1%+ -n 1";
      XF86AudioLowerVolume.action.spawn-sh = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      "Ctrl+XF86AudioLowerVolume".action.spawn-sh = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%-";
      XF86AudioRaiseVolume.action.spawn-sh = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+";
      "Ctrl+XF86AudioRaiseVolume".action.spawn-sh = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%+";
    };
}
