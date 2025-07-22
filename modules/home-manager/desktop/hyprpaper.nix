{
  settings,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.system}.hyprpaper;
    settings = {
      preload = [ "${settings.wallpaper}" ];
      wallpaper = [ ",${settings.wallpaper}" ];
      ipc = "off";
      splash = false;
    };
  };
}
