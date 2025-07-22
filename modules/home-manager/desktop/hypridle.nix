{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  bctl = lib.getExe pkgs.brightnessctl;
  dim-screen = pkgs.writeShellApplication {
    name = "dim-screen";
    runtimeInputs = [ pkgs.brightnessctl ];
    text = ''
      brightnessctl -sq
      until [ "$(brightnessctl g)" -lt 1921 ]
      do
        brightnessctl -q set 1%-
        sleep 0.005
      done
    '';
  };
in
{
  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages.${pkgs.system}.hypridle;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${lib.getExe pkgs.hyprlock}"; # Avoids starting multiple hyprlock instances
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 180;
          on-timeout = "${lib.getExe dim-screen}/bin/dim-screen";
          on-resume = "${bctl} -r";
        }
        {
          timeout = 180;
          on-timeout = "${bctl} -sd asus::kbd_backlight set 0";
          on-resume = "${bctl} -rd asus::kbd_backlight";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "systemctl hibernate";
        }
      ];
    };
  };
}
