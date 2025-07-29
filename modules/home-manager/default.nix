{
  outputs,
  hostConfig,
  nixosConfig,
  lib,
  ...
}:
{
  imports = (lib.custom.importAll ./.) ++ [ ../nixos/allow-unfree.nix ];

  options = {

  };

  config = {
    nixpkgs.overlays = outputs.overlays.all;

    home = rec {
      username = hostConfig.username;
      homeDirectory = "/home/${username}";
      stateVersion = nixosConfig.system.stateVersion;

      sessionVariables = rec {
        FLAKE = "${homeDirectory}/nix-config";
        NH_FLAKE = FLAKE;
      };
    };
  };
}
