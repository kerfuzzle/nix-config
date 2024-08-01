{ pkgs, ... }: {
  home.packages = with pkgs; [
    cider
    musikcube
    playerctl
  ];

  programs.cava = {
    enable = true;
    settings = {
      color = {
        gradient = 1;
        gradient_color_1 = "'#FF2164'";
        gradient_color_2 = "'#FF2164'";
        gradient_color_3 = "'#FF3572'";
        gradient_color_4 = "'#FF5F8F'";
        gradient_color_5 = "'#FF96B6'";
        gradient_color_6 = "'#FFB2C9'";
        gradient_color_7 = "'#FFE8EF'";
        gradient_color_8 = "'#ffffff'";
      };
    };
  };
}
