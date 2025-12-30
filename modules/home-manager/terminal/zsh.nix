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
    dotDir = "${config.xdg.configHome}/zsh";

    shellAliases =
      let
        flake = "${config.home.homeDirectory}/nix-config";
      in
      rec {
        ls = "${lib.getExe pkgs.eza} --icons";
        tree = "${ls} --tree";
        reb = "${lib.getExe pkgs.nh} os switch ${flake} --hostname ${hostConfig.hostname}";
        up = "${lib.getExe pkgs.nix} flake update";
        battery = "${lib.getExe pkgs.inxi} -B";
        backup = "systemctl start restic-backups-remote.service";
      };
  };
}
