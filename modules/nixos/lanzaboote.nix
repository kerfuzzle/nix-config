{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.hostConfig.lanzaboote.enable = lib.mkEnableOption "lanzaboote secure boot";

  config = lib.mkIf config.hostConfig.lanzaboote.enable {
    environment.systemPackages = [ pkgs.sbctl ];
    # lanzaboote replaces systemd-boot so force disable just in case
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      # Secure boot keys location
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
