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
  };

  config.home.packages =
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
    ++ (lib.optional cfg.minecraft.enable prismlauncher);
}
