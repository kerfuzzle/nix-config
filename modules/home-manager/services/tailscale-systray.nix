{ config, ... }:
{
  services.tailscale-systray.enable = config.programs.waybar.enable;
}
