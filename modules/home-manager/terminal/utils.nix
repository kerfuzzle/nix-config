{ pkgs, ... }: {
	allowedUnfree = ["ookla-speedtest"];
	home.packages = with pkgs; [
		ookla-speedtest
		bun
		fastfetch
		yazi
		glxinfo
		ffmpeg
		toipe
		zip
		unzip
	];
}
