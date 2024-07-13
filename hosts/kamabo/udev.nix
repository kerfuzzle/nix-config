{ lib, pkgs, ... }: let 
  script = pkgs.writeShellApplication {
    name = "udev-test";
    text = ''
      touch /home/kerfuzzle/yay.txt
    '';
  };
in {
  services.udev = {
    enable = true;
    extraRules = ''
      SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}==1, RUN+="${script}"
    '';
  };
}
