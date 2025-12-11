{
  inputs,
  pkgs,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper;
    settings = {
      # Wallpaper is set by stylix
      # ipc = false;
      splash = false;
    };
  };
}
