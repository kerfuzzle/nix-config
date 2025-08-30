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
        # GUI file manager
        pcmanfm
        # Image Preview
        swayimg
        # Video player
        mpv
      ]
      # Screen recording
      ++ (lib.optional cfg.obs.enable obs-studio)
      # Office productivity suite
      ++ (lib.optional cfg.libreoffice.enable libreoffice)
      # Image editor
      ++ (lib.optional cfg.gimp.enable gimp)
      # Note taking/annotation
      ++ (lib.optional cfg.xournal.enable xournalpp);
  };
}
