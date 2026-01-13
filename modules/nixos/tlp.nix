{ config, lib, ... }:
let
  cfg = config.hostConfig.batteryControl;
in
{
  options.hostConfig.batteryControl = {
    enable = lib.mkEnableOption "tlp for powersave and battery control";
    chargeLimit = lib.mkOption {
      description = "Upper charge limit of battery";
      type = lib.types.ints.between 1 100;
    };
  };
  config.services.tlp = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      # Plugged in
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      PLATFORM_PROFILE_ON_AC = "quiet";
      # Battery
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      PLATFORM_PROFILE_ON_BAT = "quiet";

      # The command `tlp-stat -b` can be used to check the charge limits and `tlp fullcharge BAT0` can be used to force a full charge
      # Disables the start threshold
      START_CHARGE_THRESH_BAT0 = 0;
      STOP_CHARGE_THRESH_BAT0 = cfg.chargeLimit;

    };
  };
}
