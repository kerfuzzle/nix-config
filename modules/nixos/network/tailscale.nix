{ config, lib, ... }:
{
  options.hostConfig.tailscale.enable = lib.mkEnableOption "tailscale";

  config = lib.mkIf config.hostConfig.tailscale.enable {
    # Imperitive intervention needed, use `tailscale up` to setup
    # SOPS doesn't help as auth keys only last for 90 days
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };
}
