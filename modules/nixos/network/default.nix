{ config, lib, ... }:
{
  imports = lib.custom.importAll ./.;

  options.hostConfig.hostname = lib.mkOption {
    description = "hostname of system";
    type = lib.types.str;
    default = "nixos";
  };

  config.networking.hostName = config.hostConfig.hostname;
}
