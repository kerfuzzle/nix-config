{ config, lib, ... }:
let
  printingConfig = config.hostConfig.printing;
in
{
  options.hostConfig.printing = {
    printers.enable = lib.mkEnableOption "printers" // {
      default = true;
    };
    scanners.enable = lib.mkEnableOption "scanners" // {
      default = true;
    };
  };

  config = {
    services = lib.mkIf printingConfig.printers.enable {
      printing.enable = true;

      # Used for auto-discovery of network printers
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };

    # Support for Scanner Access Now Easy
    hardware.sane.enable = printingConfig.scanners.enable;
  };
}
