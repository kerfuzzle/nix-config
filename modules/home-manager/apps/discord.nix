{ pkgs, ... }:
{
  allowedUnfreePkgs = [ "discord-canary" ];
  home.packages = [ pkgs.discord-canary ];
}
