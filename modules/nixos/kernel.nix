{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.hostConfig.useLatestKernel = lib.mkOption {
    description = "Whether the system should use the latest kernel release, else use the latest LTS release";
    default = true;
    type = lib.types.bool;
  };

  config.boot.kernelPackages =
    if config.hostConfig.useLatestKernel then pkgs.linuxPackages_latest else pkgs.linuxPackages;
}
