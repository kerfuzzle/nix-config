{ lib, config, ... }: {
  systemd.services."hyprsunset-restart" = {
    Unit = {
      Description = "Restart hyprsunset service on system resume";
      After = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
    };

    Service =
      let
        systemctl = lib.getExe' config.systemd.package "systemctl";
      in
      {
        Type = "oneshot";
        ExecStart = "${systemctl} --user --no-block restart hyprsunset.service";
        User = config.hostConfig.username;
      };

    Install.WantedBy = [
      "sleep.target"
      "multi-user.target"
    ];
  };
}
