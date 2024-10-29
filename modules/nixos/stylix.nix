{ inputs, config, settings, pkgs, ... }: {
	stylix = {
		enable = true;
		base16Scheme = inputs.nix-colors.colorSchemes.${settings.colorScheme}.palette;
		image = settings.wallpaper;

		cursor = {
			package = pkgs.phinger-cursors;
			name = "phinger-cursors-light";
			size = 4;
		};

		fonts = {
			sizes = {
				terminal = 10;
			};
			monospace = {
				package = pkgs.nerdfonts.override { fonts = ["JetBrainsMono"]; };
				name = "JetBrainsMono Nerd Font";
			};
		};
	};
}
