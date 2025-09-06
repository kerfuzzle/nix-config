{ config, lib, ... }:
{
  options.hostConfig.tailscale = {
    enable = lib.mkEnableOption "tailscale";
    devices = lib.mkOption {
      default = { };
      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            user = lib.mkOption {
              type = str;
              default = "";
              example = "user";
            };
            ipv4 = lib.mkOption {
              type = str;
              default = "";
              example = "192.168.1.1";
            };
          };
        });
    };
  };

  config = lib.mkIf config.hostConfig.tailscale.enable {
    # Imperitive intervention needed, use `tailscale up` to setup
    # SOPS doesn't help as auth keys only last for 90 days
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      # Tailscale DNS always seems to cause issues so disable
      extraSetFlags = [
        "--accept-dns=false"
        "--operator=${config.hostConfig.username}"
      ];
    };
  };
}
