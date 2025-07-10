{ pkgs, ... }:
{
  stylix.targets.vscode.enable = false;
  home.packages = with pkgs; [
    nixd
  ];
  allowedUnfree = [
    "vscode"
  ];
  programs.vscode = {
    enable = true;
  };
}
