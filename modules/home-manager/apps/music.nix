{
  pkgs,
  config,
  lib,
  inputs,
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
        inputs.kew.packages.${pkgs.stdenv.hostPlatform.system}.default
        # Fully featured CLI music player
        musikcube
        # Tool for interating with media players
        playerctl
      ]
      ++ (lib.optionals cfg.cdRipping.enable [
        # CD ripping tool
        abcde
        # Highly accurate ripping tool, slower
        whipper
      ]);

    # Audio visualiser, looks cool
    programs.cava = {
      enable = true;
      settings.color.foreground = "'#${config.stylix.base16Scheme.base0D}'";
    };
  };
}
