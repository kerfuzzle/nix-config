{ inputs, pkgs, ... }: {
  nixpkgs.overlays = [ inputs.niri-flake.overlays.niri ];
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
}
