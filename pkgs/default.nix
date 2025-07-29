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
                  			pgrep -x "wf-recorder" && pkill -INT -x wf-recorder && exit 0
                  			region=$(slurp)
                  			id=$(notify-send "Recording..." -p)
                  			dateTime=$(date +%m-%d-%Y-%H:%M:%S)
      									outDir="$HOME/media/videos"
      									mkdir -p "$outDir"
                  			wf-recorder -g "$region" -p r=30,crf=40 -f "$outDir/$dateTime.mp4"
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
}
