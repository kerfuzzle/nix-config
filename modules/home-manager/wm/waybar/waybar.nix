{ pkgs , ... }: with builtins;
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
		power = "󰐥";
		reboot = "󰜉";
		lock = "";
		hibernate = "󰒲";
		volume = ["" "" ""];
		muted = "";
		headphone = "󰋋";
		headphone-muted = "󰟎";

		format-jp = {
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

		format-greek = {
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

		format-decimal = {
			"magic" = "*";
		};
	};
in {
	programs.waybar = {
		enable = true;
		style = ./style.css;
		settings = {
			mainBar = {
			  reload_style_on_change = true;
				height = 25;
				spacing = 0;
				margin = "5 5 0 5";
				layer = "top";
				position = "top";
				modules-left = ["hyprland/workspaces" "hyprland/window" "mpris"];
				modules-center = ["clock"];
				modules-right = ["group/cpu-info" "temperature#gpu" "memory" "backlight" "pulseaudio" "battery" "power-profiles-daemon" "network" "custom/wlogout"];

				"hyprland/workspaces" = {
					format = "{icon}";
					show-special = true;
					persistent-workspaces = {
						"*" = 5;
					};
					format-icons = icons.format-decimal;
				};

				"hyprland/window" = {
					rewrite = {
						"(.*)Mozilla Firefox" = "Firefox";
						"(.*)Discord" = "Discord";
					};
					seperate-outputs = true;
				};

				clock = {
        	format = "{:%R %D}";
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
							today  = "<span color='#e67e80'><b><u>{}</u></b></span>";
						};
					};
				};

				"group/cpu-info" = {
					orientation = "inherit";
					modules = ["cpu" "temperature#cpu"];
				};

				cpu = with icons; {
					interval = 5;
					format = "CPU {usage}% ";
				  format-alt = "CPU {usage}% {avg_frequency:0.1f}GHz ";
					min-length = 6;
					max-length = 100;
				};

				"temperature#cpu" = {
					thermal-zone = 7;
				};
				
				"temperature#gpu" = {
					thermal-zone = 1;
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
					format-plugged = "${plugged} {capacity}% {power:0.1f}W";
					format-plugged-alt = "${plugged} {capacity}% {power:0.1f}W";
					format-full = "{icon} {capacity}%";
					format-icons = battery;
				};

				power-profiles-daemon = {
					format = "{profile}";
					tooltip = false;
				};

				network = with icons; {
					format-ethernet = "${wired} {ifname}";
					format-wifi = "${wifi} {essid}";
					tooltip-format-ethernet = "{ifname}";
					tooltip-format-wifi = "{signalStrength}% {essid}";
				};

				"custom/wlogout" = with icons; {
					on-click = "pidof wlogout || wlogout -b 1 -L 500 -R 500";
					tooltip = false;
					format = power;
				};

				pulseaudio = with icons; {
					format = "{icon} {volume}%";
					format-muted = "{icon} — %";
					format-icons = {
						headphone = headphone;
						headphone-muted = headphone-muted;
						default = volume;
						default-muted = muted;
					};
					on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
					scroll-step = 0.5;
				};

				mpris = {
					dynamic-order = ["title" "artist"];
					dynamic-separator = " — ";
					dynamic-len = 40;
					format = "{dynamic}";
					tooltip-format = "{player} ({status}): {title}, {artist}, {album} {position}/{length}";
				};
			};
		};
	};
}
