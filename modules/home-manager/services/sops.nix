{
  config,
  lib,
  nixosConfig,
  ...
}:
let
  cfg = config.homeConfig.sops;
in
{
  options.homeConfig.sops.enable = lib.mkEnableOption "sops secrets management";
  config = lib.mkIf cfg.enable {
    sops.age.keyFile = nixosConfig.sops.age.keyFile;
  };
}
