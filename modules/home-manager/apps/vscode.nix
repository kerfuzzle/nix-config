{ pkgs, config, lib, ... }: let
  cfg = config.homeConfig.vscode;
in {
  options.homeConfig.vscode.enable = lib.mkEnableOption "vscode";

  config = lib.mkIf cfg.enable {
    stylix.targets.vscode.enable = false;
    home.packages = with pkgs; [
      nixd
    ];
    allowedUnfreePkgs = [
      "vscode"
    ];
    programs.vscode.enable = true;
  };
}
