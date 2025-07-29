{ pkgs, ... }:
{
  allowedUnfreePkgs = [ "ookla-speedtest" ];
  home.packages = with pkgs; [
    ookla-speedtest
    bun
    fastfetch
    yazi
    glxinfo
    ffmpeg
    toipe
    poppler_utils
  ];
}
