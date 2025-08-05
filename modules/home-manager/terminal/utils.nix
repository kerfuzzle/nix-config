{ pkgs, ... }:
{
  allowedUnfreePkgs = [ "ookla-speedtest" ];
  home.packages = with pkgs; [
    # Internet speed test
    ookla-speedtest
    # typescript toolkit
    bun
    # system info tool
    fastfetch
    # Provides info on GPUs
    glxinfo
    # Tool to transcode audio and video
    ffmpeg
    # Typing test
    toipe
    # PDF tools
    poppler_utils
  ];
}
