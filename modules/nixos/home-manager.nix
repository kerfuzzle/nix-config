{
  settings,
  config,
  inputs,
  outputs,
  lib,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = {
      inherit
        inputs
        outputs
        lib
        settings
        ;
      inherit (config) hostConfig;
      nixosConfig = config;
    };
    users = {
      "${settings.username}" =
        { ... }:
        {
          imports = [
            (import ../../hosts/${settings.hostname}/home.nix)
            inputs.self.outputs.homeManagerModules.default
          ];
        };
    };
  };
}
