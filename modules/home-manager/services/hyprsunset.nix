{
  pkgs,
  inputs,
  config,
  lib,
  nixosConfig,
  ...
}:
let
  cfg = config.homeConfig.hyprsunset;
in
{
  options.homeConfig.hyprsunset = {
    enable = lib.mkEnableOption "Hyprsunset, Hyprland's blue-light filter";
    sunsetTime = lib.mkOption {
      description = "Time to enable the blue light filter";
      type = lib.types.str;
      example = "21:00";
    };
    sunriseTime = lib.mkOption {
      description = "Time to disable the blue light filter";
      type = lib.types.str;
      example = "6:00";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hyprsunset = {
      enable = true;
      package = inputs.hyprsunset.packages.${pkgs.system}.hyprsunset;
      settings = {
        profile = [
          {
            time = cfg.sunriseTime;
            identity = true;
          }
          {
            time = cfg.sunsetTime;
            temperature = 3000;
          }
        ];
      };
    };

    systemd.user.services."hyprsunset-restart" = {
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
          systemctl = lib.getExe' nixosConfig.systemd.package "systemctl";
        in
        {
          Type = "oneshot";
          ExecStart = "${systemctl} --user --no-block restart hyprsunset.service";
        };

      Install.WantedBy = [ "sleep.target" ];
    };
  };
}
