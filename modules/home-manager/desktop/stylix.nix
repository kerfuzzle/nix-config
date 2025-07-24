{ pkgs, ... }:
{
  stylix.icons = {
    enable = true;
    package = pkgs.colloid-icon-theme.override {
      schemeVariants = [ "catppuccin" ];
      colorVariants = [ "default" ];
    };
    light = "Colloid-Catppuccin-Light";
    dark = "Colloid-Catppuccin-Dark";
  };
}
