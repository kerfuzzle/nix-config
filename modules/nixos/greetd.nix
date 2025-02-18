{ config, settings, pkgs, ... }: {
	services.greetd = {
		enable = true;
		settings = rec {
			initial_session = {
				command = "${config.programs.hyprland.package}/bin/Hyprland";
				user = config.users.users.${settings.username}.name;
			};
			default_session= initial_session;
		};
	};
}
