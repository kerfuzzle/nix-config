pkgs: {
  screenshot-swappy = pkgs.writeShellApplication {
    name = "screenshot-swappy";
    runtimeInputs = with pkgs; [
      grim
      slurp
      swappy
    ];
    text = ''
      pidof slurp || grim -g "$(slurp)" - | swappy -f -
    '';
  };

  screenshot-copy = pkgs.writeShellApplication {
    name = "screenshot-copy";
    runtimeInputs = with pkgs; [
      grim
      slurp
      wl-clipboard
    ];
    text = ''
      pidof slurp || grim -g "$(slurp)" - | wl-copy
    '';
  };

  screen-record = pkgs.writeShellApplication {
    name = "screen-record";
    runtimeInputs = with pkgs; [
      slurp
      wf-recorder
      libnotify
    ];
    text = ''
      # If already recording, end the recording and exit
      pgrep -x "wf-recorder" && pkill -INT -x wf-recorder && exit 0
      # Get region with slurp
      region=$(slurp)
      # Send notification that with no timeout (e.g. will not disappear)
      id=$(notify-send -t 0 "Recording..." -p)
      dateTime=$(date +%m-%d-%Y-%H:%M:%S)
      outDir="$HOME/media/videos"
      mkdir -p "$outDir"
      wf-recorder -g "$region" -p r=30,crf=40 -f "$outDir/$dateTime.mp4"
      # Replace the previous notification
      notify-send -r "$id" -t 5000 "Recording saved as $dateTime.mp4"
    '';
  };

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

  check-ac = pkgs.writeShellScriptBin "check-ac" ''
    # Modified from https://cgit.freedesktop.org/pm-utils/tree/src/on_ac_power so that only mains power supplies are detected
    # Exit: 0 if on AC power, 1 if not on AC power
    # If there are no power supplies assume AC
    ret=0
    for ps in /sys/class/power_supply/*; do
      # Power supplies must have online file
      [ -r "$ps/online" ] || continue
      # Check power supply type is mains
      [ -r "$ps/type" ] || continue
      read -r ps_type < "$ps/type"
      [ "$ps_type" = "Mains" ] || continue
      # If we reach here we definitely have a AC power supply
      # Default return changes to not-AC
      ret=1
      read -r ps_status < "$ps/online"
      [ "$ps_status" -eq 1 ] && exit 0
    done
    exit "$ret"
  '';
}
