{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
let
  icons = {
    cpu = "";
    mem = "";
    swap = "󰓡 ";
    backlight = [
      ""
      ""
      ""
      ""
      ""
      ""
      ""
      ""
      ""
    ];
    battery = [
      " "
      " "
      " "
      " "
      " "
    ];
    plugged = "󱐋";
    power = "󰐥";
    network = {
      wifi = " ";
      wired = " ";
    };
    audio = {
      volume = [
        ""
        ""
        ""
      ];
      muted = "";
      headphone = "󰋋";
      headphone-muted = "󰟎";
    };
    idle = {
      active = "";
      inactive = "";
    };

    formatKanji = {
      "1" = "一";
      "2" = "二";
      "3" = "三";
      "4" = "四";
      "5" = "五";
      "6" = "六";
      "7" = "七";
      "8" = "八";
      "9" = "九";
      "10" = "十";
      "magic" = "*";
    };

    formatGreek = {
      "1" = "α";
      "2" = "β";
      "3" = "γ";
      "4" = "δ";
      "5" = "ε";
      "6" = "ζ";
      "7" = "η";
      "8" = "θ";
      "9" = "ι";
      "10" = "κ";
      "magic" = "*";
    };

    mkFormatDenary =
      # Generate workspace labels so that each monitor has labels 1 through 5
      with lib;
      numMonitors: workspacesPerMonitor:
      (
        range 0 (numMonitors * workspacesPerMonitor - 1)
        |> map (x: {
          name = toString (x + 1);
          value = (mod x workspacesPerMonitor) + 1;
        })
        |> listToAttrs
      )
      // {
        "magic" = "*";
      };
  };
in
{
  stylix.targets.waybar.enable = false;
  programs.waybar = {
    enable = true;
    style = ./style_blue.css;
    # Enable waybar systemd service so that it can more easily managed
    systemd.enable = true;
    settings = {
      mainBar = {
        reload_style_on_change = true;
        height = 25;
        spacing = 0;
        margin = "5 5 0 5";
        layer = "top";
        position = "top";
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
          "mpris"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "group/cpu-info"
          "temperature#gpu"
          "memory"
          "backlight"
          "pulseaudio"
          "battery"
          "idle_inhibitor"
          "network"
          "custom/wlogout"
        ];

        "hyprland/workspaces" =
          let
            hyprlandSettings = config.wayland.windowManager.hyprland.settings;
            workspacesPerMonitor = hyprlandSettings.plugin.hyprsplit.num_workspaces;
            numMonitors = length hyprlandSettings.monitor;
          in
          {
            format = "{icon}";
            show-special = true;
            persistent-workspaces = {
              # Number of persistent workspaces on each monitor (* doesn't refer to special workspace)
              "*" = workspacesPerMonitor;
            };
            format-icons = icons.mkFormatDenary numMonitors workspacesPerMonitor;
          };

        "hyprland/window" = {
          rewrite = {
            "(.*)Mozilla Firefox" = "Firefox";
            "(.*)Discord" = "Discord";
            "(.*)org.pwmt.zathura" = "Zathura";
          };
        };

        clock = {
          format = "{:%R %d/%m/%y}";
          format-alt = "{:%T %a %b %d}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#7fbbb3'><b>W{}</b></span>";
              weekdays = "<span color='#83C092'><b>{}</b></span>";
              today = "<span color='#e67e80'><b><u>{}</u></b></span>";
            };
          };
        };

        "group/cpu-info" = {
          orientation = "inherit";
          modules = [
            "group/cpu-basic"
            "custom/platform-profile"
          ];
          drawer = {
            click-to-reveal = true;
          };
        };

        "group/cpu-basic" = {
          orientation = "inherit";
          modules = [
            "cpu"
            "temperature#cpu"
          ];
        };

        cpu = {
          interval = 5;
          format = "CPU {usage}%";
          min-length = 6;
          max-length = 100;
        };

        "temperature#cpu" = {
          thermal-zone = 7;
          tooltip = false;
        };

        "custom/platform-profile" = {
          exec = "cat /sys/firmware/acpi/platform_profile";
          tooltip = false;
          interval = 5;
        };

        "temperature#gpu" = {
          thermal-zone = 1;
          tooltip = false;
          format = "GPU {temperatureC}°C";
        };

        memory = with icons; {
          interval = 30;
          format = "${mem} {used:0.1f}G";
          format-alt = "${mem} {used:0.1f}G ${swap} {swapUsed:0.1f}G";
          tooltip-format = "{used:0.1f}G/{total:0.1f}G used";
          min-length = 6;
          max-length = 100;
        };

        backlight =
          with icons;
          let
            brightnessctl = lib.getExe pkgs.brightnessctl;
          in
          {
            device = "eDP1";
            format = "{icon} {percent}%";
            format-icons = backlight;
            tooltip = false;
            on-click = "${brightnessctl} s 100%";
          };

        battery = with icons; {
          interval = 5;
          states = {
            warning = 30;
            critical = 15;
          };

          max-length = 20;
          format = "{icon} {capacity}%";
          format-alt = "{icon} {capacity}% {power:0.1f}W";
          format-warning = "{icon} {capacity}%";
          format-critical = "{icon} {capacity}%";
          format-charging = "${plugged} {capacity}%";
          format-plugged = "${plugged} {capacity}%";
          format-plugged-alt = "${plugged} {capacity}% {power:0.1f}W";
          format-full = "{icon} {capacity}%";
          format-icons = battery;
        };

        idle_inhibitor = with icons.idle; {
          format = "{icon} ";
          format-icons = {
            activated = active;
            deactivated = inactive;
          };
        };

        network = with icons.network; {
          format-ethernet = "${wired} {ifname}";
          format-wifi = "${wifi} {essid}";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-wifi = "{signalStrength}% {essid}";
        };

        "custom/wlogout" =
          with icons;
          let
            wlogout = lib.getExe config.programs.wlogout.package;
          in
          {
            on-click = "pidof wlogout || ${wlogout} -b 1 -L 500 -R 500";
            tooltip = false;
            format = power;
          };

        pulseaudio =
          with icons.audio;
          let
            wpctl = lib.getExe' pkgs.wireplumber "wpctl";
          in
          {
            format = "{icon} {volume}%";
            format-muted = "{icon} — %";
            format-icons = {
              headphone = headphone;
              headphone-muted = headphone-muted;
              default = volume;
              default-muted = muted;
            };
            on-click = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
            scroll-step = 0.5;
          };

        mpris = {
          dynamic-order = [
            "title"
            "artist"
          ];
          dynamic-separator = " — ";
          dynamic-len = 60;
          format = "{dynamic}";
          tooltip-format = "{player} ({status}, {position}/{length}): {title} — {album} — {artist}";
        };
      };
    };
  };
}
