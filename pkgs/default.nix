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
      						mkdir "$HOME/videos"
            			wf-recorder -g "$region" -p r=30,crf=40 -f "$HOME/videos/$dateTime.mp4"
            			notify-send -r "$id" -t 5000 "Recording saved as $dateTime.mp4"
            		'';
  };
}
