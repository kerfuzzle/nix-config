{ lib, pkgs, ... }: let 
  switch-power-plan = pkgs.writeShellApplication {
    name = "switch-power-plan";
    runtimeInputs = with pkgs; [power-profiles-daemon];
    text = ''
      if [ "$(cat /sys/class/power_supply/BAT0/capacity)" -gt 50 ]
      then
        powerprofilesctl set performance
      fi
    '';
  };
in {
  services.udev = {
    enable = true;
    extraRules = ''
      SUBSYSTEM=="power_supply",ENV{POWER_SUPPLY_ONLINE}=="1",RUN+="${switch-power-plan}/bin/switch-power-plan"
    '';
  };
}
