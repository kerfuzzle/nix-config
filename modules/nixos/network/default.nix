{ config, lib, ... }:
{
  imports = [
    ./smbClient.nix
    ./printing.nix
    ./tailscale.nix
    ./networkmanager.nix
  ];

  options.hostConfig.hostname = lib.mkOption {
    description = "hostname of system";
    type = lib.types.str;
    default = "nixos";
  };

  config.networking.hostName = config.hostConfig.hostname;
}
