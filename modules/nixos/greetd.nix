{ config, settings, pkgs, lib, ... }: {
	services.greetd = {
		enable = true;
		settings = rec {
			initial_session = {
				command = lib.getExe config.programs.hyprland.package;
				user = config.users.users.${settings.username}.name;
			};
			default_session= initial_session;
		};
	};
}
