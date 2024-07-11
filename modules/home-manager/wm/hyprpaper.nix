{
	services.hyprpaper = {
		enable = true;
		settings = let
			wall = "/home/kerfuzzle/images/walls/forest-2.jpg";
		in {
			preload = [wall];
			wallpaper = [",${wall}"];
			ipc = "off";
			splash = false;
		};
	};
}
