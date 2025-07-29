{ pkgs, ... }:
{
  stylix.targets.vscode.enable = false;
  home.packages = with pkgs; [
    nixd
  ];
  allowedUnfreePkgs = [
    "vscode"
  ];
  programs.vscode.enable = true;
}
