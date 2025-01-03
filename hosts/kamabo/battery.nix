{ pkgs, ... }: let
	lowThreshold = 20;
	criticalThreshold = 10;
	batteryNotifier = pkgs.writeShellApplication {
		name = "battery-notifier";
		runtimeInputs = with pkgs; [acpi gnugrep libnotify];
		text = ''
			prev_val=100
			check() { [[ $1 -ge $val ]] && [[ $1 -lt $prev_val ]]; }
			notify() {
				notify-send -a Battery "$@" -h "int:value:$val" "Discharging" "$val%, $remaining"
			}
			while true; do
				IFS=: read -r _ bat0 < <(acpi -b)
				IFS=\ , read -r status val remaining <<<"$bat0"
				val=''${val%\%}
				if [[ $status = Discharging ]]; then
					if check ${builtins.toString lowThreshold}; then notify
					elif check ${builtins.toString criticalThreshold}; then notify -u critical
					fi
				fi
				prev_val=$val
				if [[ $val -gt 30 ]]; then sleep 10m; elif [[ $val -ge 20 ]]; then sleep 5m; else sleep 1m; fi
			done
		'';
	};
in {
	systemd.user.services.battery-notifier = {
		Install.WantedBy = [ "graphical-session.target" ];
		Service.ExecStart = "${batteryNotifier}/bin/battery-notifier";
	};
}
