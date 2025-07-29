{ config, lib, ... }:
{
  options.allowedUnfreePkgs = lib.mkOption {
    description = "List of names of unfree packages to whitelist";
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config.nixpkgs.config.allowUnfreePredicate =
    pkg: builtins.elem (lib.getName pkg) config.allowedUnfreePkgs;
}
