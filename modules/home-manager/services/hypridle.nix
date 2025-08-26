{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homeConfig.hypridle;
in
{
  options.homeConfig.hypridle = {
    enable = lib.mkEnableOption "hypridle idle daemon";
    timeouts =
      let
        mkTimeoutOption = action: rec {
          ac = lib.mkOption {
            description = "Timeout in seconds before ${action} on AC power. Leave as null to disable.";
            type = lib.types.nullOr lib.types.ints.positive;
            example = 100;
            default = null;
          };
          bat = ac // {
            description = "Timeout in seconds before ${action} on battery power. Leave as null to disable.";
          };
        };
      in
      {
        dimScreen = mkTimeoutOption "dimming screen";
        dimKeyboard = mkTimeoutOption "dimming keyboard";
        lock = mkTimeoutOption "locking session";
        disableDisplay = mkTimeoutOption "disabling display";
        hibernate = mkTimeoutOption "hibernating system";
      };
    keyboardDeviceName = lib.mkOption {
      description = "Name of keyboard backlight, obtained with `brightnessctl -l`";
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "asus::kbd_backlight";
    };
  };

  config = {
    assertions = [
      {
        assertion =
          (cfg.timeouts.dimKeyboard.ac == null && cfg.timeouts.dimKeyboard.bat == null)
          || cfg.keyboardDeviceName != null;
        message = "Cannot enable the homeConfig.hypridle.dimKeyboard timeouts if homeconfig.hypridle.keyboardDeviceName is not specified";
      }
    ];

    services.hypridle = lib.mkIf cfg.enable (
      let
        brightnessctl = lib.getExe pkgs.brightnessctl;
        hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";
      in
      {
        enable = true;
        package = inputs.hypridle.packages.${pkgs.system}.hypridle;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || ${lib.getExe pkgs.hyprlock}"; # Avoids starting multiple hyprlock instances
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "${hyprctl} dispatch dpms on";
          };

          listener =
            let
              timeouts = cfg.timeouts;
              checkAC = lib.getExe pkgs.custom.check-ac;
              mkTimeoutPair =
                {
                  timeout,
                  on-timeout,
                  on-resume ? "",
                }:
                [ ]
                ++ (lib.optional (timeout.ac != null) {
                  inherit on-resume;
                  timeout = timeout.ac;
                  on-timeout = "${checkAC} && ${on-timeout}";
                })
                ++ (lib.optional (timeout.bat != null) {
                  inherit on-resume;
                  timeout = timeout.bat;
                  on-timeout = "${checkAC} || ${on-timeout}";
                });
            in
            [ ]
            ++ mkTimeoutPair {
              timeout = timeouts.dimScreen;
              on-timeout = lib.getExe pkgs.custom.dim-screen;
              on-resume = "${brightnessctl} -r";
            }
            ++ mkTimeoutPair {
              timeout = timeouts.dimKeyboard;
              on-timeout = "${brightnessctl} -sd ${cfg.keyboardDeviceName} set 0";
              on-resume = "${brightnessctl} -rd ${cfg.keyboardDeviceName}";
            }
            ++ mkTimeoutPair {
              timeout = timeouts.lock;
              on-timeout = "loginctl lock-session";
            }
            ++ mkTimeoutPair {
              timeout = timeouts.disableDisplay;
              on-timeout = "${hyprctl} dispatch dpms off";
              on-resume = "${hyprctl} dispatch dpms on";
            }
            ++ mkTimeoutPair {
              timeout = timeouts.hibernate;
              on-timeout = "systemctl hibernate";
            };
        };
      }
    );
  };
}
