{ settings, ... }: {
	services.hyprpaper = {
		enable = true;
		settings = {
			preload = [settings.wallpaper];
			wallpaper = [",${settings.wallpaper}"];
			ipc = "off";
			splash = false;
		};
	};
}
