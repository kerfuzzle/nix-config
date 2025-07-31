{ lib, ... }:
{
  imports = lib.custom.importAll ./.;

  config.hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
