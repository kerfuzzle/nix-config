{ config, settings, pkgs, ... }: {
	home = {
		username = settings.username;
		homeDirectory = "/home/${settings.username}";
		stateVersion = "24.05";
	};

	programs.bash = {
		enable = true;
		shellAliases = {
			rebuild = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nix/";
			#h = "home-manager switch --flake ${config.home.homeDirectory}/nix/";
			hyrel = "hyprctl reload";
			battery = "cat /sys/class/power_supply/BAT0/capacity";
		};
	};
}
