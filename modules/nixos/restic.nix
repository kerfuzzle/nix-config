{
  pkgs,
  config,
  lib,
  ...
}:
let
  hostConfig = config.hostConfig;
  mainUser = config.users.users.${hostConfig.username};
  homeDir = "/home/${mainUser.name}";
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
      paths = map (p: homeDir + p) [
        "/documents"
        "/downloads"
        "/media"
        "/nix-config"
      ];
      # Don't backup anything that matches these
      exclude = [
        ".git"
        "node_modules"
        ".direnv"
        ".build"
        "${homeDir}/media/music"
      ];

      # Backup at noon and midnight daily
      timerConfig = {
        OnCalendar = "*-*-* 00,12:00:00";
        # If a backup is missed then run the backup when next powered on
        Persistent = true;
      };

      # Run an integrity check after the backup
      runCheck = true;

      # Clean up old snapshots
      # Keep 8 weekly, 12 monthly, 3 yearly snapshots and all snapshots within 7d of the newest
      pruneOpts = [
        # Always keep backups less than a week old
        "--keep-within=7d"
        # Keep the most recent backup from each of the last 8 weeks
        "--keep-weekly=8"
        # Keep the most recent backup from each of the last 12 months
        "--keep-monthly=12"
        # Keep the most recent backup from each of the last 3 years
        "--keep-yearly=3"
      ];

      # Prevents the system from sleeping whilst backing up
      inhibitsSleep = true;
    };

    systemd.services =
      let
        baseNotifyService = {
          enable = true;
          serviceConfig = {
            Type = "oneshot";
            User = mainUser.name;
          };
          # Set DBUS session address so that notifications can be sent
          environment.DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/${toString mainUser.uid}/bus";
          # Ensure notify-send is availible
          path = [ pkgs.libnotify ];
        };
      in
      lib.mkMerge (
        lib.mapAttrsToList (name: _: {
          # Set services to run on fail and success
          "restic-backups-${name}".unitConfig = {
            OnFailure = "restic-notify-${name}-failed.service";
            OnSuccess = "restic-notify-${name}-succeeded.service";
          };
          "restic-notify-${name}-failed" = baseNotifyService // {
            description = "Notify user of a failed restic backup";
            script = ''
               notify-send --urgency=critical \
              	"Restic Backup \"${name}\" Failed!" \
              	"See \"journalctl -u restic-backups-${name}.service\" for more details"
            '';
          };
          "restic-notify-${name}-succeeded" = baseNotifyService // {
            description = "Notify user of a successful restic backup";
            script = ''
              	# Get the line that begins with processed (contains stats about backup)
                SUMMARY=$(journalctl -u restic-backups-${name}.service --invocation=0 -o cat | sed -n "/^processed/p")
                notify-send -t 10000 "Restic Backup \"${name}\" Succeeded!" "$SUMMARY"
            '';
          };
        }) config.services.restic.backups
      );
  };
}
