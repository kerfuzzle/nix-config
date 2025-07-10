{ config, lib, ... }:
{
  options.tailscale.enable = lib.mkEnableOption "tailscale";

  config = lib.mkIf config.tailscale.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };
}
