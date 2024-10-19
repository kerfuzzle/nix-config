{ config, pkgs, ... }: {
	config.allowedUnfree = ["ookla-speedtest"];
	config.home.packages = with pkgs; [ookla-speedtest bun];
}
