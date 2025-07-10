{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    cider
    musikcube
    playerctl
    abcde
    whipper
  ];

  programs.cava = {
    enable = true;
    settings = {
      color = {
        foreground = "'#${config.stylix.base16Scheme.base0D}'";
      };
    };
  };
}
