{
  inputs,
  config,
  lib,
  settings,
  pkgs,
  ...
}:
let
  cfg = config.hostConfig.theming;
in
{
  options.hostConfig.theming = {
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
  };

  config = lib.mkIf cfg.enable {
    hostConfig.theming.base16.palette = inputs.nix-colors.colorSchemes.${cfg.base16.name}.palette;

    stylix = lib.mkIf cfg.stylix.enable {
      enable = true;
      base16Scheme = cfg.base16.palette;
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
