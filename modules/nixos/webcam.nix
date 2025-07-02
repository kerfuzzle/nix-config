{ pkgs, ... }: {
	services.usbmuxd.enable = true;
	environment.systemPackages = with pkgs; [
		droidcam
		libimobiledevice
	];

	boot.kernelModules = [
		"v4l2loopback"
	];
	
	boot.extraModulePackages = [
		pkgs.linuxPackages.v4l2loopback
	];
}
