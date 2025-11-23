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

  config.services.hyprsunset = lib.mkIf cfg.enable {
    enable = true;
    package = inputs.hyprsunset.packages.${pkgs.stdenv.hostPlatform.system}.hyprsunset;
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
}
