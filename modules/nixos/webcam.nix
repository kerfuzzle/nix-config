{ pkgs, config, ... }: {
	services.usbmuxd.enable = true;
	environment.systemPackages = with pkgs; [
		droidcam
		libimobiledevice
	];

	boot.kernelModules = [
		"v4l2loopback"
	];
	
	boot.extraModulePackages = with config.boot.kernelPackages; [
		v4l2loopback
	];
}
