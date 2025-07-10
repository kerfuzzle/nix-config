{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.useLatestKernel = lib.mkEnableOption {
    description = "Whether the system should use the latest kernel release, else use the latest LTS release";
    default = true;
  };

  config.boot.kernelPackages = lib.mkIf config.useLatestKernel pkgs.linuxPackages_latest;
}
