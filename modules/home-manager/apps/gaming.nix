{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homeConfig.gaming;
in
{
  options.homeConfig.gaming = {
    heroic.enable = lib.mkEnableOption "heroic game launcher";
    olympus.enable = lib.mkEnableOption "olympus mod launcher for celeste";
    minecraft.enable = lib.mkEnableOption "prism minecraft launcher";
    parsec.enable = lib.mkEnableOption "parsec remote desktop";
  };

  config = {
    allowedUnfreePkgs = lib.optional cfg.parsec.enable "parsec-bin";
    home.packages =
      with pkgs;
      [
        # Performance overlay
        mangohud
      ]
      # Launcher for GOG and Epic Games
      ++ (lib.optional cfg.heroic.enable heroic)
      # Celeste mod manager
      ++ (lib.optional cfg.olympus.enable olympus)
      # Minecraft launcher and mod manager
      ++ (lib.optional cfg.minecraft.enable prismlauncher)
      # Parsec remote desktop client
      ++ (lib.optional cfg.parsec.enable parsec-bin);
  };
}
