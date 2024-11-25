{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    cider
    musikcube
    playerctl
  ];

  programs.cava = {
    enable = false;
    settings = {
      color = {
        foreground = "'#${config.stylix.base16Scheme.base0D}'";
      };
    };
  };
}
