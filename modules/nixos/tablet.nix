{ config, lib, ... }:
{
  options.graphicsTablet.enable = lib.mkEnableOption "graphics tablet support";
  config = lib.mkIf config.graphicsTablet.enable {
    hardware.opentabletdriver.enable = true;
    # TODO: Declaritively configure tablet settings
  };
}
