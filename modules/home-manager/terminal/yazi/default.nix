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

  config = {
    home.packages = with pkgs; [
      wl-clipboard
      trash-cli
      ouch
    ];

    programs.yazi = {
      enable = true;

      plugins = {
        inherit (pkgs.yaziPlugins)
          smart-enter
          smart-paste
          wl-clipboard
          restore
          ouch
          ;
      };

      theme.indicator.padding = lib.mkIf (!cfg.roundedIndicator) {
        open = "█";
        close = "█";
      };
    };
  };
}
