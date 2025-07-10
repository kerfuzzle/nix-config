{ config, lib, ... }:
{
  options.printing = {
    printers = lib.mkEnableOption "printers" // {
      default = true;
    };
    scanners = lib.mkEnableOption "scanners" // {
      default = true;
    };
  };

  config = {
    services = lib.mkIf config.printing.printers {
      printing.enable = true;

      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };

    hardware.sane.enable = config.printing.scanners;
  };
}
