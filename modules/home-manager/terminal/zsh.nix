{
  pkgs,
  lib,
  config,
  hostConfig,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases =
      let
        flake = "${config.home.homeDirectory}/nix-config";
      in
      rec {
        ls = "${lib.getExe pkgs.eza} --icons";
        tree = "${ls} --tree";
        reb = "${lib.getExe pkgs.nh} os switch ${flake} --hostname ${hostConfig.hostname}";
        up = "${lib.getExe pkgs.nix}/bin/nix flake update --flake ${flake}";
        battery = "${lib.getExe pkgs.inxi} -B";
      };
  };
}
