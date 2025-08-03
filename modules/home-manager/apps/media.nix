{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.homeConfig.media;
in
{
  options.homeConfig.media = {
    obs.enable = lib.mkEnableOption "obs studio";
    libreoffice.enable = lib.mkEnableOption "libreoffice";
    gimp.enable = lib.mkEnableOption "gimp";
    xournal.enable = lib.mkEnableOption "xournal";
  };
  config = {
    home.packages =
      with pkgs;
      [
        pcmanfm
        zathura
        swayimg
        mpv
      ]
      ++ (lib.optional cfg.obs.enable obs-studio)
      ++ (lib.optional cfg.libreoffice.enable libreoffice)
      ++ (lib.optional cfg.gimp.enable gimp)
      ++ (lib.optional cfg.xournal.enable xournalpp);
  };
}
