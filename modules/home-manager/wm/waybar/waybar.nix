{ pkgs , ... }: 
let
	icons = { 
		cpu = "";
		mem = "";
		swap = "󰓡 ";
		backlight = ["" "" "" "" "" "" "" "" ""];
		battery = [" " " " " " " " " "];
		plugged = "󱐋";
		wifi = " ";
		wired = " ";
		shutdown = "󰐥";
		reboot = "󰜉";
		lock = "";
		hibernate = "󰒲";
		volume = ["" "" ""];
		muted = "";
		headphone = "󰋋";
		headphone-muted = "󰟎";
	};
in {
	programs.waybar = {
		enable = true;
		style = ./style.css;
		settings = {
			mainBar = {
			  reload_style_on_change = true;
				height = 25;
				margin = "0 0 0 0";
				layer = "top";
				position = "top";
				modules-left = ["hyprland/workspaces" "hyprland/window" "mpd"];
				modules-center = ["clock"];
				modules-right = ["cpu" "temperature" "memory" "backlight" "pulseaudio" "battery" "power-profiles-daemon" "network" "group/power"];

				"hyprland/workspaces" = {
					format = "{icon}";
					show-special = true;
					persistent-workspaces = {
						"*" = 5;
					};
					format-icons = {
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
				};

				"hyprland/window" = {
					rewrite = {
						"(.*)Mozilla Firefox" = "Firefox";
					};
				};

				clock = {
        	format = "{:%R}";
        	format-alt = "{:%a %b %d}";
        	tooltip-format = "<tt><small>{calendar}</small></tt>";
					calendar = {
						mode = "year";
						mode-mon-col = 3;
						format = {
							months = "{}";
							days = "{}";
							weeks = "{}";
							weekdays = "{}";
							today  = "{}";
						};
					};
				};

				cpu = with icons; {
					interval = 5;
					format = "CPU {usage}%";
				  format-alt = "CPU {usage}% {avg_frequency:0.1f}GHz";
					min-length = 6;
					max-length = 100;
				};

				memory = with icons; {
					interval = 30;
					format = "${mem} {used:0.1f}G";
					format-alt = "${mem} {used:0.1f}G ${swap} {swapUsed:0.1f}G";
					tooltip-format = "{used:0.1f}G/{total:0.1f}G used";
					min-length = 6;
					max-length = 100;
				};

				backlight = with icons; {
					device = "eDP1";
					format = "{icon} {percent}%";
					format-icons = backlight;
					tooltip = false;
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
					format-full = "{icon} {capacity}%";
					format-icons = battery;
				};

				power-profiles-daemon = {
					format = "{profile}";
					tooltip = false;
				};

				network = with icons; {
					format-ethernet = "${wired}";
					format-wifi = "${wifi}";
					tooltip-format-ethernet = "{ifname}";
					tooltip-format-wifi = "{signalStrength}% {essid}";
				};

				"group/power" = {
					orientation = "inherit";
					drawer = {
						transition-duration = 500;
						transition-left-to-right = false;
					};
					modules = ["custom/shutdown" "custom/lock" "custom/hibernate" "custom/reboot"];
				};

				"custom/lock" = with icons; {
					format = "${lock}";
					tooltip = false;
					on-click = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
				};

				"custom/hibernate" = with icons; {
					format = "${hibernate}";
					tooltip = false;
					on-click = "systemctl hibernate";
				};

				"custom/shutdown" = with icons; {
					format = "${shutdown}";
					tooltip = false;
					on-click = "poweroff";
				};

				"custom/reboot" = with icons; {
					format = "${reboot}";
					tooltip = false;
					on-click = "poweroff --reboot";
				};

				temperature = {
					thermal-zone = 7;
				};

				"temperature#gpu" = {
					thermal-zone = 1;
				};

				pulseaudio = with icons; {
					format = "{icon} {volume}%";
					format-muted = "{icon} —%";
					format-icons = {
						headphone = headphone;
						headphone-muted = headphone-muted;
						default = volume;
						default-muted = muted;
					};
					on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
					scroll-step = 0.5;
				};

				mpd = {
					format = "{title} — {artist}";
					format-stopped = "";
					format-pasued = "";
				};
			};
		};
	};
}
