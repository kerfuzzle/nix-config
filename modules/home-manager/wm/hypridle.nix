{ pkgs, ...}: let 
  dim-screen = pkgs.writeShellApplication {
    name = "dim-screen";
    runtimeInputs = [pkgs.brightnessctl];
    text = ''
      brightnessctl -sq
      until [ "$(brightnessctl g)" -lt 1921 ]
      do
        brightnessctl -q set 1%-
        sleep 0.005
      done
    '';
  };
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock"; # Avoids starting multiple hyprlock instances
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 150;
          on-timeout = "${dim-screen}/bin/dim-screen";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 150;
          on-timeout = "brightnessctl -sd asus::kbd_backlight set 0";
          on-resume = "brightnessctl -rd asus::kbd_backlight";
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
