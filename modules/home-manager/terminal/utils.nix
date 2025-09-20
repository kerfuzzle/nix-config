{ pkgs, ... }:
{
  allowedUnfreePkgs = [ "ookla-speedtest" ];
  home.packages = with pkgs; [
    # Internet speed test
    ookla-speedtest
    # typescript toolkit
    bun
    # system info tool
    microfetch
    # Provides info on GPUs
    glxinfo
    # Tool to transcode audio and video
    ffmpeg
    # Typing test
    toipe
    # PDF tools
    poppler_utils
    # CLI clock/timer/stopwatch
    peaclock
  ];

  # Basic peaclock config
  home.file.".peaclock/config".text = ''
    set seconds on
    set date off
  '';
}
