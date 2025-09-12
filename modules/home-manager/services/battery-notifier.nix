{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.homeConfig.batteryNotifier;
in
{
  options.homeConfig.batteryNotifier = {
    enable = lib.mkEnableOption "batttery notifier service";

    lowThresholds = lib.mkOption {
      default = [
        20
        15
      ];
      example = [
        20
        15
      ];
      type = lib.types.listOf (lib.types.ints.between 0 100);
      description = "Battery percentages to send low battery notification";
    };

    criticalThresholds = lib.mkOption {
      default = [
        10
        5
      ];
      example = [
        10
        5
      ];
      type = lib.types.listOf (lib.types.ints.between 0 100);
      description = "Battery percentages to send critical battery notification";
    };
  };

  config =
    let
      mkChecks = levels: levels |> map (level: "check ${toString level}") |> lib.concatStringsSep " || ";
      batteryNotifierScript = pkgs.writeShellApplication {
        name = "battery-notifier";
        runtimeInputs = with pkgs; [
          acpi
          gnugrep
          libnotify
        ];
        # From https://github.com/Julow/env with added annotations and nix modifications
        text = ''
          # Initialise a value for prev_val that all other values will be <=
          prev_val=100
          # Check if new val is <= threshold and previous val > threshold
          # i.e. check if it is the first run where val is <= threshold
          check() { [[ $1 -ge $val ]] && [[ $1 -lt $prev_val ]]; }
          # Send notification with battery percentage, -h makes the notifation background
          # match the remainning percentage
          notify() {
            notify-send -a Battery "$@" -h "int:value:$val" "Discharging" "$val%, $remaining"
          }
          while true; do
            # Trims battery name from start of output
            # Example bat0: "Discharging, 12%, 00:58:01 remaining"
            IFS=: read -r _ bat0 < <(acpi -b)
            # Splits on ", "
            # Example val: "12%", status: "Discharging", remaining: "00:58:01 remaining"
            IFS=, read -r status val remaining <<<"$bat0"
            # Trims % from val, double single quote escapes dollar curly in nix
            val=''${val%\%}
            if [[ $status = Discharging ]]; then
              if ${mkChecks cfg.lowThresholds}; then notify
              elif ${mkChecks cfg.criticalThresholds}; then notify -u critical
              fi
            fi
            # Update the prev_val to current val
            prev_val=$val
            # Wait longer between runs when at a higher battery level
            if [[ $val -gt 30 ]]; then sleep 10m; elif [[ $val -ge 20 ]]; then sleep 5m; else sleep 1m; fi
          done
        '';
      };
    in
    lib.mkIf cfg.enable {
      systemd.user.services.battery-notifier = {
        Install.WantedBy = [ "graphical-session.target" ];
        Service.ExecStart = lib.getExe batteryNotifierScript;
      };
    };
}
