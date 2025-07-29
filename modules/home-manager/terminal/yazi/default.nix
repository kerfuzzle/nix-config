{
  pkgs,
  lib,
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
  };
}
