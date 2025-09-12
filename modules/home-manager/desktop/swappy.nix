{ config, ... }:
{
  programs.swappy = {
    enable = true;
    settings.Default = {
      save_dir = config.xdg.userDirs.pictures;
      show_panel = true;
      save_filename_format = "screenshot-%Y_%m_%d-%H_%M_%S.png";
      custom_color = "#${config.homeConfig.theming.base16.palette.base0E}";
    };
  };
}
