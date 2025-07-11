{ pkgs, config, lib, ... }:
let hostConfig = config.hostConfig;
in {
	options.hostConfig.username = lib.mkOption {
		type = lib.types.str;
		example = "nix";
		default = "kerfuzzle";
		description = "Username of main user on the host";
	};

	config = {
		sops.secrets."login/${hostConfig.username}-password" = {
			neededForUsers = true;
			sopsFile = lib.custom.configRoot + /secrets/login.yaml; 
		};

		users.users.${hostConfig.username} = {
			name = hostConfig.username;
			shell = pkgs.zsh;
			isNormalUser = true;
			extraGroups = [ "wheel" ];
			hashedPasswordFile = config.sops.secrets."login/${hostConfig.username}-password".path;
		};
	};
}
