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
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
