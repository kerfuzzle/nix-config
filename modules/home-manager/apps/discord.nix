{ config, pkgs, ... }: {
  config.allowedUnfree = [ "discord-canary" ];
  config.home.packages = [pkgs.discord-canary];
}
