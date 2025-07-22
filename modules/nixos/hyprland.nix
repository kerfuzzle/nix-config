{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  options.hostConfig.hyprland.enable = lib.mkEnableOption "hyprland" // {
    default = true;
  };

  config = lib.mkIf config.hostConfig.hyprland.enable {
    programs.hyprland = {
      enable = true;
      # Set packge and portalPackage to the packages provided in the flake
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    # Enable polkit
    security.polkit.enable = true;

    # Hint electron apps to use wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
