{
  pkgs,
  lib,
  config,
  nixosConfig,
  ...
}:
{
  wayland.windowManager.niri.settings.binds =
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
      loginctl = lib.getExe' nixosConfig.systemd.package "loginctl";

      mkTerminalLaunch = app: {
        _args = [
          (toString alacritty)
          "-e"
          (toString app)
        ];
      };

      mkBrightness = value: {
        _args = [
          (toString brightnessctl)
          "s"
          value
          "-n"
          "1"
        ];
      };

      mkWirePlumber = args: {
        _args = [ (toString wpctl) ] ++ args;
      };

      mkVolume =
        value:
        mkWirePlumber [
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          value
        ];

      mkPlayer = action: {
        _args = [
          (toString playerctl)
          action
        ];
      };

      addProp =
        name: value: bind:
        lib.recursiveUpdate bind { _props.${name} = value; };
    in
    lib.mapAttrs (_: addProp "repeat" false) (
      {
        # Terminal
        "Mod+Q".spawn = alacritty;
        # Launcher
        "Mod+R".spawn = fuzzel;
        # Browser
        "Mod+E".spawn = firefox;
        # Calculator
        "Mod+X".spawn = qalculate;
        # Power menu
        "Mod+Escape".spawn-sh = "pidof wlogout || ${wlogout} -b 1 -L 500 -R 500";
        # Lock session
        "XF86MenuKB".spawn._args = [
          (toString loginctl)
          "lock-session"
        ];
        # File manager
        "Mod+W".spawn = mkTerminalLaunch yazi;
        # Unicode picker
        "Mod+U".spawn._args = [
          (toString unipicker)
          "--command"
          "${fuzzel} --dmenu"
          "--copy-command"
          (toString wl-copy)
        ];
        # Toggle Overview
        "Mod+grave".toggle-overview = { };

        # -- Screenshots and screen recording
        "Mod+A".screenshot = { };
        "Mod+Shift+A".spawn = screenshot-swappy;
        "Mod+Shift+S".screenshot-window = { };
        "Mod+Shift+P".spawn = screen-record;
        "Mod+Shift+C".spawn._args = [
          (toString hyprpicker)
          "-a"
          "-t"
        ];

        # -- Window/Workspace management
        "Mod+F".maximize-column = { };
        "Mod+Shift+F".fullscreen-window = { };
        "Mod+Shift+V".toggle-window-floating = { };
        "Mod+V".switch-focus-between-floating-and-tiling = { };
        "Mod+C".close-window = { };

        "Mod+0".expand-column-to-available-width = { };
        "Mod+BracketLeft".consume-or-expel-window-left = { };
        "Mod+BracketRight".consume-or-expel-window-right = { };
        "Mod+Shift+BracketLeft".swap-window-left = { };
        "Mod+Shift+BracketRight".swap-window-right = { };
      }
      // (lib.mergeAttrsList (
        builtins.genList (
          x:
          let
            ws = x + 1;
          in
          {
            "Mod+${toString ws}".focus-workspace = ws;
            "Mod+Shift+${toString ws}".move-column-to-workspace = ws;
          }
        ) 9
      ))
      // (lib.mapAttrs (_: addProp "allow-when-locked" true) {
        # --- Binds that work when locked
        XF86AudioMicMute.spawn = mkWirePlumber [
          "set-mute"
          "@DEFAULT_AUDIO_SOURCE@"
          "toggle"
        ];
        XF86AudioMute.spawn = mkWirePlumber [
          "set-mute"
          "@DEFAULT_AUDIO_SINK@"
          "toggle"
        ];
        XF86AudioPrev.spawn = mkPlayer "previous";
        XF86AudioNext.spawn = mkPlayer "next";
        XF86AudioPlay.spawn = mkPlayer "play-pause";

        # Laptop doesn't have media keys so these work as substitutes
        Home.spawn = mkPlayer "previous";
        End.spawn = mkPlayer "next";
        Next.spawn = mkPlayer "play-pause";
      })
    )
    // {
      # --- Repeating binds
      "Mod+H".focus-column-left-or-last = { };
      "Mod+L".focus-column-right-or-first = { };
      "Mod+J".focus-window-or-workspace-down = { };
      "Mod+K".focus-window-or-workspace-up = { };
      "Mod+Shift+H".move-column-left-or-to-monitor-left = { };
      "Mod+Shift+L".move-column-right-or-to-monitor-right = { };
      "Mod+Shift+J".move-window-down-or-to-workspace-down = { };
      "Mod+Shift+K".move-window-up-or-to-workspace-up = { };

      "Mod+M".focus-monitor-next = { };
      "Mod+Shift+M".move-column-to-monitor-next = { };

      "Mod+Minus".set-column-width = "-10%";
      "Mod+Equal".set-column-width = "+10%";
      "Mod+Shift+Minus".set-window-height = "-10%";
      "Mod+Shift+Equal".set-window-height = "+10%";

      "Mod+WheelScrollDown".focus-workspace-down = { };
      "Mod+WheelScrollUp".focus-workspace-up = { };
    }
    // (lib.mapAttrs (_: addProp "allow-when-locked" true) {
      # --- Binds that work when locked and that repeat
      # Brightness control, + CTRL for fine adjustment
      XF86MONBrightnessDown.spawn = mkBrightness "5%-";
      "Ctrl+XF86MonBrightnessDown".spawn = mkBrightness "1%-";
      XF86MONBrightnessUp.spawn = mkBrightness "5%+";
      "Ctrl+XF86MonBrightnessUp".spawn = mkBrightness "1%+";
      # Volume control
      XF86AudioLowerVolume.spawn = mkVolume "5%-";
      "Ctrl+XF86AudioLowerVolume".spawn = mkVolume "1%-";
      XF86AudioRaiseVolume.spawn = mkVolume "5%+";
      "Ctrl+XF86AudioRaiseVolume".spawn = mkVolume "1%+";
    });
}
