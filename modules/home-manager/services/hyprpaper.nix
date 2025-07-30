{
  inputs,
  pkgs,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.system}.hyprpaper;
    settings = {
      # Wallpaper is set by stylix
      ipc = false;
      splash = false;
    };
  };
}
