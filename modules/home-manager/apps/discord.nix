{ config, pkgs, ... }: {
  config.allowedUnfree = [ "discord" ];
  config.home.packages = [pkgs.discord];
}
