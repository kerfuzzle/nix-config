{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    cider
    musikcube
    playerctl
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
