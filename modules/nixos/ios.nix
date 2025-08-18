{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.hostConfig.iosSupport;
in
{
  options.hostConfig.iosSupport.enable = lib.mkEnableOption "support for interfacing with ios devices via usb";

  config = lib.mkIf cfg.enable {
    services.usbmuxd.enable = true;
    environment.systemPackages = with pkgs; [
      # libimobiledevice needed to interface with ios devices over usb
      libimobiledevice
      # Used to mount ios document file systems
      ifuse
    ];
  };
}
