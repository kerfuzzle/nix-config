{ config, lib, ... }:
{
  options.hostConfig.smbClient.enable = lib.mkEnableOption {
    description = "Whether to try and connect to tailscale NAS using CIFS";
  };

  config = lib.mkIf config.hostConfig.smbClient.enable {
    fileSystems."/mnt/share" = {
      device = "//100.93.207.105/kerfuzzle-nas";
      fsType = "cifs";
      options =
        let
          # this line prevents hanging on network split
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

        in
        [ "${automount_opts},credentials=/etc/nixos/smb-secrets" ];
    };
  };
}
