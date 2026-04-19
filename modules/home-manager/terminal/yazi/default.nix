{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homeConfig.yazi;
in
{
  imports = lib.custom.importAll ./.;

  options.homeConfig.yazi = {
    roundedIndicator = lib.mkOption {
      description = "Whether to use rounded corners font on selection indicator.";
      type = lib.types.bool;
      default = true;
    };
  };

  config.programs.yazi = {
    enable = true;

    shellWrapperName = "y";

    theme = {
      indicator.padding = lib.mkIf (!cfg.roundedIndicator) {
        open = "█";
        close = "█";
      };
    };
  };
}
