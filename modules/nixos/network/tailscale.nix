{ config, lib, ... }:
{
  options.hostConfig.tailscale.enable = lib.mkEnableOption "tailscale";

  config = lib.mkIf config.hostConfig.tailscale.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };
}
