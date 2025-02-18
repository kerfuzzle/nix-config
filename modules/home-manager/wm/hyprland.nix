{ config, pkgs, settings, inputs, ... }: let 
	screenshot-swappy = pkgs.writeShellApplication {
		name = "screenshot-swappy";
		runtimeInputs = with pkgs; [grim slurp swappy];
		text = ''
			pidof slurp || grim -g "$(slurp)" - | swappy -f -
		'';
	};

	screenshot-copy = pkgs.writeShellApplication {
		name = "screenshot-copy";
		runtimeInputs = with pkgs; [grim slurp wl-clipboard];
		text = ''
			pidof slurp || grim -g "$(slurp)" - | wl-copy
		'';
	};

	screen-record = pkgs.writeShellApplication {
		name = "screen-record";
		runtimeInputs = with pkgs; [slurp wf-recorder libnotify];
		text = ''
			pgrep -x "wf-recorder" && pkill -INT -x wf-recorder && exit 0
			region=$(slurp)
			id=$(notify-send "Recording..." -p)
			dateTime=$(date +%m-%d-%Y-%H:%M:%S)
			wf-recorder -g "$region" -p r=30,crf=40 -f ${config.home.homeDirectory}/videos/"$dateTime".mp4
			notify-send -r "$id" -t 5000 "Recording saved as $dateTime.mp4"
		'';
	};
in {
	home.packages = with pkgs; [
		wl-clipboard
	];
	
	wayland.windowManager.hyprland = {
		enable = true;
		plugins = [
			pkgs.hyprlandPlugins.hyprspace
			pkgs.hyprlandPlugins.hyprsplit
		];
		
		settings = {
			env = [
				"XCURSOR_SIZE,24"
			];
			"$mainMod" = "SUPER";
			"$terminal" = "${pkgs.alacritty}/bin/alacritty";
			"$launcher" = "${pkgs.fuzzel}/bin/fuzzel";
			"$file" = "${pkgs.pcmanfm}/bin/pcmanfm";
			"$bctl" = "${pkgs.brightnessctl}/bin/brightnessctl";
			"$browser" = "${pkgs.firefox}/bin/firefox";
			"$picker" = "${pkgs.hyprpicker}/bin/hyprpicker -a -t";
			"$power_menu" = "${pkgs.wlogout}/bin/wlogout";
			"$unipicker" = "${pkgs.unipicker}/bin/unipicker";
			"$copy" = "${pkgs.wl-clipboard}/bin/wl-copy";
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

			windowrulev2 = [
				"opacity 1.0 1.0 override, title:(.*)(- YouTube)(.*)"
				"opacity 1.0 1.0 override, title:(Picture-in-Picture)"
				"opacity 1.0 1.0 override, class:^(discord)"
				"opacity 1.0 1.0 override, class:^(Code)"
			];

			animation = [
				"specialWorkspace, 1, 7, default, slidevert"	
			];

			input = {
				kb_layout  = "gb";
				scroll_method = "2fg";
				natural_scroll = false;
				sensitivity = -0.1;

				touchpad = {
					clickfinger_behavior = true;
				};
			};

			device = {
				name = "corsair-corsair-gaming-harpoon-rgb-mouse";
				sensitivity = -1.5;
			};
			
			gestures = {
				workspace_swipe = true;
				workspace_swipe_distance = 100;
				workspace_swipe_create_new = true;
				workspace_swipe_min_speed_to_force = 15;
			};

			cursor = {
				inactive_timeout = 15;
			};

			misc = {
				disable_hyprland_logo = true;
			};

			plugin = {
				hyprsplit = {
					num_workspaces = 5;
				};

				overview = {
					exitOnClick = true;
					exitOnSwitch = true;
					reverseSwipe = true;
					showEmptyWorkspace = false;
				};
			};
			
			bind = [
				"$mainMod, Q, exec, $terminal"
				"$mainMod, R, exec, pidof fuzzel | $launcher"
				"$mainMod SHIFT, F, fullscreen"
				"$mainMod, C, killactive"
				"$mainMod, A, exec, ${screenshot-copy}/bin/screenshot-copy"
				"$mainMod SHIFT, A, exec, ${screenshot-swappy}/bin/screenshot-swappy"
				"$mainMod SHIFT, P, exec, ${screen-record}/bin/screen-record"
				"$mainMod SHIFT, C, exec, $picker"
				"$mainMod, E, exec, $browser"
				"$mainMod, L, exec, pidof wlogout || $power_menu -b 1 -L 500 -R 500"
				"$mainMod, F, togglefloating"
				"$mainMod, W, exec, $file"
				"$mainMod, U, exec, $unipicker --command '$launcher --dmenu' --copy-command $copy"
				"$mainMod, S, togglespecialworkspace, magic"
				"$mainMod SHIFT, S, movetoworkspace, special:magic"
				# Code 49 is `
				"$mainMod, code:49, overview:toggle"

				",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
				",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
				",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
				",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
				",XF86MonBrightnessDown, exec, $bctl s 10%-"
				"CTRL,XF86MONBrightnessDown, exec, $bctl s 1%-"
				",XF86MonBrightnessUp, exec, $bctl s 10%+"
				"CTRL,XF86MONBrightnessUp, exec, $bctl s 1%+"
			] # Adding binds to switch/move windows between workspaces
			++ (
				builtins.concatLists (builtins.genList(
					x: let
						ws = let
							c = (x + 1) / 10;
						in
							builtins.toString(x + 1 - (c * 10));
					in [
						"$mainMod, ${ws}, split:workspace, ${toString (x + 1)}"
						"$mainMod SHIFT, ${ws}, split:movetoworkspace, ${toString (x + 1)}"
					]
				)
				5)
			); 
			bindm = [
				"$mainMod, mouse:272, movewindow"
				"$mainMod SHIFT, mouse:272, resizewindow"
			];
		};
	};
}
