{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.hostConfig.kernel;
in
{
  options.hostConfig.kernel = {
    useLatest = lib.mkOption {
      description = "Whether the system should use the latest kernel release, else use the latest LTS release";
      default = true;
      type = lib.types.bool;
    };
    hidAppleFnMode = lib.mkOption {
      description = ''
        Modifies how function keys act on Apple Keyboards
        0 - disabled
        1 - normally media keys, switchable to function keys by holding Fn key (=auto on Apple keyboards)
        2 - normally function keys, switchable to media keys by holding Fn key (=auto on non-Apple keyboards)
        3 - auto
      '';
      default = 2;
      type = lib.types.ints.between 0 3;
    };
  };

  config.boot = {
    kernelPackages = lib.mkIf cfg.useLatest pkgs.linuxPackages_latest;
    extraModprobeConfig = "options hid_apple fnmode=${toString cfg.hidAppleFnMode}";
  };
}
