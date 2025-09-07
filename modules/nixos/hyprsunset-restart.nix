{ lib, config, ... }:
{
  systemd.services."hyprsunset-restart" = {
    after = [
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];

    requires = [ "systemd-user-sessions.service" ];

    script =
      let
        inherit (config.hostConfig) username;
        systemctl = lib.getExe' config.systemd.package "systemctl";
      in
      "${systemctl} --user -M ${username}@ --no-block restart hyprsunset.service";

    wantedBy = [
      "sleep.target"
      "multi-user.target"
    ];
  };
}
