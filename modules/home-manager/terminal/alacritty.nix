{ config, lib, ... }: {
	programs.alacritty = {
		enable = true;
		settings = {
			window = {
				opacity = lib.mkForce 0.7;
				padding = {
					x = 10;
					y = 10;
				};
			};
			
#			font = {
#				normal = {
#					family = "JetBrainsMono Nerd Font";
#					style = "Regular";
#				};
#				size = 11;
#			};
			
			scrolling = {
				history = 500;
			};
		};
	};
}
