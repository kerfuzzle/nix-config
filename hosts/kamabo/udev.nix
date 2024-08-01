{ lib, pkgs, ... }: let 
  power-change = pkgs.writeShellApplication {
    name = "power-change";
    runtimeInputs = with pkgs; [power-profiles-daemon];
    text = ''
      while getops 'pu:' OPTION; do
        case "$OPTION" in
          p)
            if [ "$(cat /sys/class/power_supply/BAT0/capacity)" -gt 50 ]
            then
              powerprofilesctl set performance
            else 
              powerprofilesctl set balanced
            fi
            ;;
          u)
            powerprofilesctl set power-saver
            ;;
        esac
      done
    '';
  };
in {
  services.udev = {
    enable = true;
    extraRules = ''
      SUBSYSTEM=="power_supply",ENV{POWER_SUPPLY_ONLINE}=="1",RUN+="${power-change}/bin/power-change -p"
      SUBSYSTEM=="power_supply",ENV{POWER_SUPPLY_ONLINE}=="0",RUN+="${power-change}/bin/power-change -u"
    '';
  };
}
