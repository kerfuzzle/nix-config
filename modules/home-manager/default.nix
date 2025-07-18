{ outputs, ... }:
{
  imports = [
    ./desktop
    ./terminal
    ./apps
    ./services
    ./nix-colors.nix
    ../nixos/allow-unfree.nix
  ];

  nixpkgs.overlays = [ outputs.overlays.default ];
}
