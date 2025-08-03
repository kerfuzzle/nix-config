{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.homeConfig.media.music;
in
{
  options.homeConfig.media.music = {
    cdRipping.enable = lib.mkEnableOption "tools for ripping music from CDs";
  };

  config = {
    home.packages =
      with pkgs;
      [
        # Simple CLI music player
        kew
        # Fully featured CLI music player
        musikcube
        # Tool for interating with media players
        playerctl
      ]
      ++ (lib.optionals cfg.cdRipping.enable [
        abcde
        whipper
      ]);

    # Audio visualiser, looks cool
    programs.cava = {
      enable = true;
      settings.color.foreground = "'#${config.stylix.base16Scheme.base0D}'";
    };
  };
}
