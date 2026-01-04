{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = lib.custom.importAll ./.;

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

    theme.indicator = with config.lib.stylix.colors.withHashtag; rec {
      current = {
        bg = base02;
        bold = true;
      };
      preview = current;
    };
  };
}
