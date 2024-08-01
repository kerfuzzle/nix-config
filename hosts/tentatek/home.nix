{ config, inputs, settings, pkgs, ... }: {
	home = {
		username = settings.username;
		homeDirectory = "/home/${settings.username}";
		stateVersion = "24.05";
	};
}
