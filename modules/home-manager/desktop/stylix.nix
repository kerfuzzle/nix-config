{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.homeConfig.theming;
in
{
  options.homeConfig.theming = {
    enable = lib.mkEnableOption "global theming" // {
      default = true;
    };

    stylix.enable = lib.mkEnableOption "automatic home-manager theming using stylix" // {
      default = true;
    };

    base16 = {
      name = lib.mkOption {
        description = "Name of base16 scheme to use, see https://github.com/tinted-theming/base16-schemes for options";
        type = lib.types.str;
        default = "catppuccin-frappe";
        example = "catppuccin-frappe";
      };
      palette = lib.mkOption {
        description = "Attrset containing the specified base16 scheme";
        readOnly = true;
        type = lib.types.attrs;
      };
    };

    wallpaper = lib.mkOption {
      type = lib.types.path;
      description = "Wallpaper to use";
    };
  };

  config = lib.mkIf cfg.enable {
    homeConfig.theming.base16.palette = inputs.nix-colors.colorSchemes.${cfg.base16.name}.palette;

    stylix = lib.mkIf cfg.stylix.enable {
      enable = true;
      image = cfg.wallpaper;
      base16Scheme = cfg.base16.palette;
      polarity = "dark";
      icons = {
        enable = true;
        package = pkgs.colloid-icon-theme.override {
          schemeVariants = [ "catppuccin" ];
          colorVariants = [ "default" ];
        };
        light = "Colloid-Catppuccin-Light";
        dark = "Colloid-Catppuccin-Dark";
      };
    };
  };
}
