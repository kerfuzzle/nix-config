{
  pkgs,
  config,
  lib,
  hostConfig,
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
      disabled = "󰀝";
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
      mic = " ";
      mic-muted = " ";
    };
    idle = {
      active = "";
      inactive = "";
    };

    systemd = {
      userFailed = " ";
      systemFailed = " ";
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
          "systemd-failed-units"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "group/cpu-info"
        ]
        # Only use gpu module if nvidia is enabled
        ++ (lib.optional hostConfig.nvidia.enable "custom/gpu")
        ++ [
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

        systemd-failed-units = with icons.systemd; {
          hide-on-ok = true;
          format = "${userFailed} {nr_failed_user} ${systemFailed} {nr_failed_system}";
          system = true;
          user = true;
        };

        clock = {
          interval = 15;
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

        "custom/gpu" = lib.mkIf hostConfig.nvidia.enable (
          # Change module depending on if hybrid graphics is enabled
          if hostConfig.nvidia.hybrid.enable then
            (
              let
                bdfBusId = hostConfig.nvidia.hybrid.nvidiaBdfBusId;
                gpuMonitorScript = pkgs.writeShellApplication {
                  name = "gpu-monitor";
                  text = ''
                    													# Either suspended or active
                    													power_status=$(cat /sys/bus/pci/devices/${bdfBusId}/power/runtime_status)
                    													# Only run nvidia-smi if active otherwise it'll wake GPU up
                    													if [[ $power_status = "active" ]]; then
                    														output=$(nvidia-smi --query-gpu=temperature.gpu,power.draw.average,utilization.gpu --format=csv,noheader,nounits)
                    														# Split at commas
                    														IFS=', ' read -r temp power util <<< "$output"
                    														# Single quotes escape dollar curly, prevents units from 
                    														# being interpreted as part of the env variable name
                    														echo "GPU ''${util}% ''${temp}°C ''${power}W"
                    													else
                    														# Print empty line so that module disappears
                    														echo ""
                    													fi
                  '';
                };
              in
              {
                exec = lib.getExe gpuMonitorScript;
                # Run every 30s, has to be long enough to prevent the nvidia-smi
                # calls from keeping the GPU on
                interval = 30;
                # Hide module if output is empty
                hide-empty-text = true;
                tooltip = false;
              }
            )
          else
            (
              let
                gpuMonitorScript = pkgs.writeShellApplication {
                  name = "gpu-monitor";
                  text = ''
                    			output=$(nvidia-smi --query-gpu=temperature.gpu,power.draw.average,utilization.gpu --format=csv,noheader,nounits)
                    			# Split at commas
                    			IFS=', ' read -r temp power util <<< "$output"
                    			# Single quotes escape dollar curly, prevents units from 
                    			# being interpreted as part of the env variable name
                    			echo "GPU ''${util}% ''${temp}°C ''${power}W"
                    		'';
                };
              in
              {
                exec = lib.getExe gpuMonitorScript;
                # Run more frequently as power saving is not as much of a concern
                interval = 10;
                tooltip = false;
              }
            )
        );

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
          format-disabled = "${disabled} No RF";
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
            format = "{icon} {volume}% {format_source}";
            format-muted = "{icon} — % {format_source}";
            format-source = mic;
            format-source-muted = mic-muted;
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
