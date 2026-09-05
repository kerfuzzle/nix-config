{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  services.hyprpaper = {
    enable = lib.mkForce false;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper;
    settings = {
      ipc = false;
      splash = false;
    };
  };
}
