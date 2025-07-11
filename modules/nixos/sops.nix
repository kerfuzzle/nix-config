{ pkgs, config, lib, ... }: let
	hostConfig = config.hostConfig;
in {
	options.hostConfig.sops.enable = lib.mkEnableOption "sops secrets management";
	config = lib.mkIf hostConfig.sops.enable {
		sops = {
			age.keyFile = "/home/${config.users.users.${hostConfig.username}.name}/.config/sops/age/keys.txt";
		};
		
		environment.systemPackages = [ pkgs.sops ];
	};
}
