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
  options.hostConfig.droidcam.enable = lib.mkEnableOption "droidcam";

  config = lib.mkIf hostConfig.droidcam.enable {
    environment.systemPackages = [
      pkgs.droidcam
    ];

    boot.kernelModules = [
      "v4l2loopback"
    ];

    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
  };
}
