{
  outputs,
  hostConfig,
  nixosConfig,
  lib,
  ...
}:
{
  imports = [
    ./desktop
    ./terminal
    ./apps
    ./services
    ./nix-colors.nix
    ../nixos/allow-unfree.nix
  ];

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
}
