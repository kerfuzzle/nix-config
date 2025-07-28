{
  settings,
  config,
  inputs,
  outputs,
  lib,
  ...
}:
let
  hostConfig = config.hostConfig;
in
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
      ${hostConfig.username} =
        { ... }:
        {
          imports = [
            (import ../../hosts/${hostConfig.hostname}/home.nix)
            inputs.self.outputs.homeManagerModules.default
          ];
        };
    };
  };
}
