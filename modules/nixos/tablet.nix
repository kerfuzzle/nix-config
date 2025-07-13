{ config, lib, ... }:
{
  options.hostConfig.graphicsTablet.enable = lib.mkEnableOption "graphics tablet support";
  config = lib.mkIf config.hostConfig.graphicsTablet.enable {
    hardware.opentabletdriver.enable = true;
    # TODO: Declaritively configure tablet settings
  };
}
