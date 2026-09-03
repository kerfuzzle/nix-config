{ pkgs, ... }:
{
  allowedUnfreePkgs = [
    "discord-canary"
    "discord-canary-unwrapped"
  ];
  home.packages = [ pkgs.discord-canary ];
}
