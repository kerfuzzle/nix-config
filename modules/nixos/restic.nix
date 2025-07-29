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
      repositoryFile = config.sops.secrets."restic/repository".path;
      passwordFile = config.sops.secrets."restic/password".path;

      paths = map (p: "/home/${config.users.users.${hostConfig.username}.name}" + p) [
        "/documents"
        "/downloads"
        "/media"
        "/nix-config"
      ];
      exclude = [
        ".git"
        "node_modules"
      ];

      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };

      inhibitsSleep = true;
    };
  };
}
