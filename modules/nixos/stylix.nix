{
  inputs,
  config,
  lib,
  settings,
  pkgs,
  ...
}:
let
  themeConfig = config.hostConfig.theming;
in
{
  options.hostConfig.theming = {
    stylix.enable = lib.mkEnableOption "automatic theming using stylix" // {
      default = true;
    };
    base16Scheme = lib.mkOption {
      type = lib.types.str;
      default = "catpuccin-frappe";
      example = "catpuccin-frappe";
    };
  };

  config = lib.mkIf themeConfig.stylix.enable {
    stylix = {
      enable = true;
      base16Scheme = inputs.nix-colors.colorSchemes.${themeConfig.base16Scheme}.palette;
      image = settings.wallpaper;

      cursor = {
        package = pkgs.phinger-cursors;
        name = "phinger-cursors-light";
        size = 4;
      };

      fonts = {
        sizes = {
          terminal = 10;
          applications = 10;
          popups = 8;
        };
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
      };
    };
  };
}
