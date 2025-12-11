{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  stylix.targets.hyprpaper.enable = lib.mkForce false;
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper;
    settings = {
      # Wallpaper is set by stylix
      # ipc = false;
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = toString config.homeConfig.theming.wallpaper;
        }
      ];
    };
  };
}
