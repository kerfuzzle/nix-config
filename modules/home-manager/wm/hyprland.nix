{ config, pkgs, settings, ... }: let 
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
in {
	home.packages = with pkgs; [
		wl-clipboard
	];

	wayland.windowManager.hyprland = {
		enable = true;
		
		settings = {
			env = [
				#"WLR_DRM_DEVICES,${config.lib.file.mkOutOfStoreSymlink "/dev/dri/by-path/pci-0000:00:02.0-card"}"
			  #"LIBVA_DRIVER_NAME,nvidia"
				#"XDG_SESSION_TYPE,wayland"
				#"GBM_BACKEND,nvidia-drm"
				#"__GLX_VENDOR_LIBRARY_NAME,nvidia"
				"XCURSOR_SIZE,24"
			];
			"$mainMod" = "SUPER";
			"$terminal" = "alacritty";
			"$launcher" = "fuzzel";
			"$file" = "yazi";
			"$bctl" = "brightnessctl";
			"$browser" = "firefox";
			"$picker" = "hyprpicker -a";
			xwayland = {
				force_zero_scaling = true;
			};

			exec-once = "waybar";

			monitor = settings.monitors;
			
			general = {
				gaps_out = 7;
				gaps_in = 5;
				border_size = 2;
			};

			decoration = {
				rounding = 10;
				inactive_opacity = 0.8;
			};

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
				sensitivity = -0.8;
			};
			
			gestures = {
				workspace_swipe = true;
				workspace_swipe_distance = 100;
				workspace_swipe_create_new = false;
				workspace_swipe_min_speed_to_force = 15;
			};

			cursor = {
				inactive_timeout = 15;
			};

			misc = {
				disable_hyprland_logo = true;
			};

			bind = [
				"$mainMod, Q, exec, $terminal"
				"$mainMod, R, exec, pidof fuzzel | $launcher"
				"$mainMod, M, exit"
				"$mainMod, F, fullscreen"
				"$mainMod, C, killactive"
				"$mainMod, A, exec, ${screenshot-copy}/bin/screenshot-copy"
				"$mainMod SHIFT, A, exec, ${screenshot-swappy}/bin/screenshot-swappy"
				"$mainMod SHIFT, C, exec, $picker"
				"$mainMod, E, exec, $browser"
				"$mainMod, L, exec, pidof wlogout || wlogout -b 1 -L 500 -R 500"
				"$mainMod, F, togglefloating"
				"$mainMod, W, exec, $file"
				"$mainMod, S, togglespecialworkspace, magic"
				"$mainMod SHIFT, S, movetoworkspace, special:magic"

				",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
				",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
				",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
				",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
				",XF86MonBrightnessDown, exec, $bctl s 10%-"
				",XF86MonBrightnessUp, exec, $bctl s 10%+"
			] # Adding binds to switch/move windows between workspaces
			++ (
				builtins.concatLists (builtins.genList(
					x: let
						ws = let
							c = (x + 1) / 10;
						in
							builtins.toString(x + 1 - (c * 10));
					in [
						"$mainMod, ${ws}, workspace, ${toString (x + 1)}"
						"$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
					]
				)
				10)
			); 
			bindm = [
				"$mainMod, mouse:272, movewindow"
				"$mainMod SHIFT, mouse:272, resizewindow"
			];
		};
	};
}
