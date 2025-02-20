{ pkgs, settings, ... }: {
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		syntaxHighlighting.enable = true;
		
		shellAliases = with pkgs; rec {
			ls = "${lib.getExe pkgs.eza} --icons";
			tree = "${ls} --tree";
			reb = "builtin command sudo ${lib.getExe pkgs.nixos-rebuild} switch --flake ~/nix";
			up = "${pkgs.nix}/bin/nix flake update /home/${settings.username}/nix";
			hyrel = "hyprctl reload";
			battery = "${lib.getExe pkgs.inxi} -B";
		};

		#profileExtra = "[[ $(tty) == /dev/tty1 ]]&&exec Hyprland";
	};
}
