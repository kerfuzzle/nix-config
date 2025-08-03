{ config, lib, ... }:
let
  hostConfig = config.hostConfig;
in
{
  options.hostConfig.restic.enable = lib.mkEnableOption "restic";

  config = lib.mkIf hostConfig.restic.enable {
    sops.secrets =
      let
        sopsFile = lib.custom.configRoot + /secrets/misc.yaml;
      in
      {
        "restic/repository".sopsFile = sopsFile;
        "restic/password".sopsFile = sopsFile;
      };

    services.restic.backups.remote = {
      # Use sops for the repo and password
      repositoryFile = config.sops.secrets."restic/repository".path;
      passwordFile = config.sops.secrets."restic/password".path;

      # Back up these home paths for the primary user
      paths = map (p: "/home/${config.users.users.${hostConfig.username}.name}" + p) [
        "/documents"
        "/downloads"
        "/media"
        "/nix-config"
      ];
      # Don't backup anything that matches these
      exclude = [
        ".git"
        "node_modules"
      ];

      # Backup at noon and midnight daily
      timerConfig = {
        OnCalendar = "*-*-* 00,12:00:00";
        # If a backup is missed then run the backup when next powered on
        Persistent = true;
      };

      # Prevents the system from sleeping whilst backing up
      inhibitsSleep = true;
    };
  };
}
