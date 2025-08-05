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
        mkTimeoutOption =
          action:
          lib.mkOption {
            description = "Timeout in seconds before ${action}. Leave as null to disable.";
            type = lib.types.nullOr lib.types.ints.positive;
            example = 100;
            default = null;
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
        assertion = cfg.timeouts.dimKeyboard == null || cfg.keyboardDeviceName != null;
        message = "Cannot enable the homeConfig.hypridle.dimKeyboard timeout if homeconfig.hypridle.keyboardDeviceName is not specified";
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
            in
            # Only add timeouts which are not null
            [ ]
            ++ (lib.optional (timeouts.dimScreen != null) {
              timeout = timeouts.dimScreen;
              on-timeout = "${lib.getExe pkgs.custom.dim-screen}/bin/dim-screen";
              on-resume = "${brightnessctl} -r";
            })
            ++ (lib.optional (timeouts.dimKeyboard != null && cfg.keyboardDeviceName != null) {
              timeout = timeouts.dimKeyboard;
              on-timeout = "${brightnessctl} -sd ${cfg.keyboardDeviceName} set 0";
              on-resume = "${brightnessctl} -rd ${cfg.keyboardDeviceName}";
            })
            ++ (lib.optional (timeouts.lock != null) {
              timeout = timeouts.lock;
              on-timeout = "loginctl lock-session";

            })
            ++ (lib.optional (timeouts.disableDisplay != null) {
              timeout = timeouts.disableDisplay;
              on-timeout = "${hyprctl} dispatch dpms off";
              on-resume = "${hyprctl} dispatch dpms on";
            })
            ++ (lib.optional (timeouts.hibernate != null) {
              timeout = timeouts.hibernate;
              on-timeout = "systemctl hibernate";
            });
        };
      }
    );
  };
}
