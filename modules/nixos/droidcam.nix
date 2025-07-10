{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.droidcam = {
    enable = lib.mkEnableOption "droidcam";
    iosUSBSupport = lib.mkEnableOption "ios USB support for droidcam" // {
      default = true;
    };
  };

  config = lib.mkIf config.droidcam.enable {
    services.usbmuxd.enable = true;
    environment.systemPackages = [
      pkgs.droidcam
    ] ++ (lib.lists.optional config.droidcam.iosUSBSupport pkgs.libimobiledevice);

    boot.kernelModules = [
      "v4l2loopback"
    ];

    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
  };
}
