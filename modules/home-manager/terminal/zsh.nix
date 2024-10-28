{ pkgs, settings, ... }: {
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		syntaxHighlighting.enable = true;
		
		shellAliases = with pkgs; {
			ls = "${pkgs.eza}/bin/eza --icons";
			tree = "${pkgs.eza}/bin/eza --tree --icons";
			reb = "builtin command sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ~/nix";
			up = "${pkgs.nix}/bin/nix flake update /home/${settings.username}/nix";
			hyrel = "hyprctl reload";
			battery = "cat /sys/class/power_supply/BAT0/capacity";
		};

		profileExtra = "[[ $(tty) == /dev/tty1 ]]&&exec Hyprland";
	};
}
