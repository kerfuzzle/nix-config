{
  pkgs,
  config,
  lib,
  ...
}:
let
  hostConfig = config.hostConfig;
in
{
  options.hostConfig.droidcam = {
    enable = lib.mkEnableOption "droidcam";
    iosUSBSupport = lib.mkEnableOption "ios USB support for droidcam" // {
      default = true;
    };
  };

  config = lib.mkIf hostConfig.droidcam.enable {
    services.usbmuxd.enable = hostConfig.droidcam.iosUSBSupport;
    environment.systemPackages = [
      pkgs.droidcam
    ] ++ (lib.lists.optional hostConfig.droidcam.iosUSBSupport pkgs.libimobiledevice);

    boot.kernelModules = [
      "v4l2loopback"
    ];

    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
  };
}
